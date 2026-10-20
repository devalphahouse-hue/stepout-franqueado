begin;

-- Both operations change teacher columns only. Rosters, invitations,
-- attendance, content, dates and student metadata must remain untouched.
create or replace function public.alterar_professor_aula(
  p_aula uuid, p_professor uuid
) returns jsonb language plpgsql security definer
set search_path = public, pg_temp as $$
declare
  actor public.users%rowtype;
  class_row public.turmas%rowtype;
  lesson public."Aulas"%rowtype;
  class_id uuid;
begin
  select * into actor from public.users where id=auth.uid();
  if not found or actor.deleted_at is not null or actor.role is null or
     actor.role::text not in ('franquia','admin') then
    raise exception 'teacher change not authorized' using errcode='42501';
  end if;
  select turma into class_id from public."Aulas" where id=p_aula;
  if not found then raise exception 'lesson not found' using errcode='22023'; end if;
  -- Same locking order as the whole-class operation: class, then lessons.
  select * into class_row from public.turmas where id=class_id for update;
  if not found or class_row.deleted_at is not null then
    raise exception 'class not found' using errcode='22023';
  end if;
  if actor.role::text <> 'admin' and
     (actor.id_franquia is null or actor.id_franquia is distinct from class_row.id_franquia) then
    raise exception 'class belongs to another franchise' using errcode='42501';
  end if;
  perform 1 from public.users where id=p_professor and role::text='professor'
    and deleted_at is null and id_franquia=class_row.id_franquia;
  if not found then raise exception 'teacher not available for this class' using errcode='22023'; end if;
  select * into lesson from public."Aulas" where id=p_aula and turma=class_id for update;
  if not found then raise exception 'lesson changed; reload before retrying' using errcode='40001'; end if;
  if lesson.franquia is distinct from class_row.id_franquia then
    raise exception 'lesson and class franchise mismatch' using errcode='22023';
  end if;
  update public."Aulas" set professor_responsavel=p_professor where id=p_aula;
  return jsonb_build_object('success',true,'scope','aula','aulasAtualizadas',1);
end;
$$;

create or replace function public.alterar_professor_turma(
  p_turma uuid, p_professor uuid
) returns jsonb language plpgsql security definer
set search_path = public, pg_temp as $$
declare
  actor public.users%rowtype;
  class_row public.turmas%rowtype;
  affected integer;
begin
  select * into actor from public.users where id=auth.uid();
  if not found or actor.deleted_at is not null or actor.role is null or
     actor.role::text not in ('franquia','admin') then
    raise exception 'teacher change not authorized' using errcode='42501';
  end if;
  select * into class_row from public.turmas where id=p_turma for update;
  if not found or class_row.deleted_at is not null then
    raise exception 'class not found' using errcode='22023';
  end if;
  if actor.role::text <> 'admin' and
     (actor.id_franquia is null or actor.id_franquia is distinct from class_row.id_franquia) then
    raise exception 'class belongs to another franchise' using errcode='42501';
  end if;
  perform 1 from public.users where id=p_professor and role::text='professor'
    and deleted_at is null and id_franquia=class_row.id_franquia;
  if not found then raise exception 'teacher not available for this class' using errcode='22023'; end if;
  if exists(select 1 from public."Aulas" where turma=p_turma and franquia is distinct from class_row.id_franquia) then
    raise exception 'lesson and class franchise mismatch' using errcode='22023';
  end if;
  update public.turmas set professor_responsavel=p_professor where id=p_turma;
  update public."Aulas" set professor_responsavel=p_professor where turma=p_turma;
  get diagnostics affected=row_count;
  return jsonb_build_object('success',true,'scope','turma','aulasAtualizadas',affected);
end;
$$;

revoke all on function public.alterar_professor_aula(uuid,uuid) from public,anon,authenticated;
revoke all on function public.alterar_professor_turma(uuid,uuid) from public,anon,authenticated;
grant execute on function public.alterar_professor_aula(uuid,uuid) to authenticated,service_role;
grant execute on function public.alterar_professor_turma(uuid,uuid) to authenticated,service_role;

commit;
