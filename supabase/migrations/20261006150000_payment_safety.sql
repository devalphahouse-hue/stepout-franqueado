begin;

-- Backfill only unpersisted terms and the franchise relationship. Values are
-- the existing demo/real plan amounts, not new commercial rules.
update public.cobrancas c set if_franquia=u.id_franquia
from public.users u join public.franquias f on f.id=u.id_franquia and f.user_responsavel=u.id
where c.user_id=u.id and c.tipo_cobranca='franquia' and c.if_franquia is null;
update public.cobrancas set num_parcelas=case
  when valor in (30,25000) then 6 when valor in (60,30000) then 12 else 1 end
where tipo_cobranca='franquia' and num_parcelas is null and valor>0;
update public.cobrancas set valor_parcelas=valor/num_parcelas
where tipo_cobranca='franquia' and valor_parcelas is null and num_parcelas>0;
update public.cobrancas c set indicacao=f."id-indicacao"
from public.franquias f where c.if_franquia=f.id and c.tipo_cobranca='franquia'
and c.indicacao is null and f."id-indicacao" is not null;

-- Service-only journal: reserve an external operation before sending it.
-- A network timeout remains 'processing' until reconciliation, never retried
-- blindly. No card data, passwords, or client-readable credentials here.
create table if not exists public.payment_operations (
  scope_key text primary key,
  operation_id uuid not null default gen_random_uuid(),
  cobranca_id uuid not null references public.cobrancas(id),
  state text not null check (state in ('processing', 'succeeded', 'rejected')),
  result jsonb,
  updated_at timestamptz not null default now()
);
create table if not exists public.payment_profiles (
  user_id uuid primary key references public.users(id),
  franchise_id uuid not null references public.franquias(id),
  profile jsonb not null,
  asaas_api_key text,
  updated_at timestamptz not null default now()
);
alter table public.payment_operations enable row level security;
alter table public.payment_profiles enable row level security;
revoke all on public.payment_operations, public.payment_profiles from anon, authenticated;
grant all on public.payment_operations, public.payment_profiles to service_role;

create or replace function public.reserve_payment_operation(
  p_cobranca uuid, p_user uuid, p_kind text
) returns jsonb language plpgsql security definer set search_path = public, pg_temp as $$
declare
  bill public.cobrancas%rowtype;
  operation public.payment_operations%rowtype;
  scope text;
begin
  if p_kind not in ('charge', 'activation') then raise exception 'invalid operation'; end if;
  select * into bill from public.cobrancas where id=p_cobranca for update;
  if not found or bill.user_id is distinct from p_user then raise exception 'invoice not owned'; end if;
  if p_kind='charge' and nullif(bill.id_cobranca_asaas, '') is not null then
    return jsonb_build_object('action', 'reuse', 'result', jsonb_build_object('id', bill.id_cobranca_asaas));
  end if;
  if p_kind='charge' and upper(coalesce(bill.status_cobranca,'')) in
    ('CONFIRMED','RECEIVED','RECEIVED_IN_CASH','CANCELLED','REFUNDED') then
    raise exception 'invoice cannot be charged again';
  end if;
  if p_kind='activation' then
    if bill.tipo_cobranca <> 'franquia' or bill.if_franquia is null or
       upper(coalesce(bill.status_cobranca,'')) not in ('CONFIRMED','RECEIVED','RECEIVED_IN_CASH') then
      raise exception 'franchise invoice not paid';
    end if;
    scope := 'activation:' || bill.if_franquia;
  else
    scope := 'charge:' || bill.id;
  end if;
  perform pg_advisory_xact_lock(hashtextextended(scope,0));
  select * into operation from public.payment_operations where scope_key=scope for update;
  if found and operation.state='succeeded' then
    return jsonb_build_object('action','reuse','result',operation.result);
  end if;
  if found and operation.state='processing' then
    return jsonb_build_object('action','busy');
  end if;
  insert into public.payment_operations(scope_key,cobranca_id,state)
    values(scope,p_cobranca,'processing')
    on conflict(scope_key) do update set operation_id=gen_random_uuid(),
      cobranca_id=p_cobranca,state='processing',result=null,updated_at=now()
    returning * into operation;
  return jsonb_build_object('action','create','scope',scope,'operation',operation.operation_id);
end;
$$;
revoke all on function public.reserve_payment_operation(uuid,uuid,text) from public, anon, authenticated;
grant execute on function public.reserve_payment_operation(uuid,uuid,text) to service_role;

create or replace function public.apply_payment_snapshot(
  p_cobranca uuid, p_payment text, p_status text, p_method text
) returns jsonb language plpgsql security definer set search_path = public, pg_temp as $$
declare bill public.cobrancas%rowtype; next_status text;
begin
  select * into bill from public.cobrancas where id=p_cobranca for update;
  if not found then raise exception 'invoice missing'; end if;
  if nullif(bill.id_cobranca_asaas,'') is not null and bill.id_cobranca_asaas<>p_payment then
    raise exception 'invoice already linked to another payment';
  end if;
  next_status := upper(p_status);
  if nullif(p_payment,'') is null or nullif(next_status,'') is null then raise exception 'invalid payment'; end if;
  -- Direct create responses can arrive after the webhook. Do not downgrade
  -- confirmed payments to pending; refunds/chargebacks still remain possible.
  if bill.status_cobranca in ('CONFIRMED','RECEIVED','RECEIVED_IN_CASH') and
     next_status in ('PENDING','AWAITING_RISK_ANALYSIS','OVERDUE') then
    next_status := bill.status_cobranca;
  end if;
  if bill.status_cobranca='RECEIVED' and next_status='CONFIRMED' then
    next_status := 'RECEIVED';
  end if;
  if bill.status_cobranca in ('REFUNDED','CHARGEBACK_REQUESTED','CHARGEBACK_DISPUTE') and
     next_status in ('CONFIRMED','RECEIVED','PENDING','AWAITING_RISK_ANALYSIS') then
    next_status := bill.status_cobranca;
  end if;
  update public.cobrancas set id_cobranca_asaas=p_payment,status_cobranca=next_status,
    forma_pagamento=case p_method when 'CREDIT_CARD' then 'Cartão' when 'PIX' then 'Pix'
      else coalesce(forma_pagamento,p_method) end where id=p_cobranca;
  update public.payment_operations set state='succeeded',result=jsonb_build_object('id',p_payment),
    updated_at=now() where scope_key='charge:' || p_cobranca;
  return jsonb_build_object('status',next_status,'tipo',bill.tipo_cobranca,'franchise',bill.if_franquia);
end;
$$;
revoke all on function public.apply_payment_snapshot(uuid,text,text,text) from public, anon, authenticated;
grant execute on function public.apply_payment_snapshot(uuid,text,text,text) to service_role;

commit;
