import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.112.3';

export const PAID = new Set(['CONFIRMED', 'RECEIVED', 'RECEIVED_IN_CASH']);
export class PaymentError extends Error {
  constructor(message, status = 400) { super(message); this.status = status; }
}
export function adminClient() {
  return createClient(Deno.env.get('SUPABASE_URL'), Deno.env.get('SUPABASE_SERVICE_ROLE_KEY'));
}
export function checkDb(result) {
  if (result.error) throw new PaymentError('Não foi possível atualizar o pagamento. Tente consultar novamente.', 503);
  return result.data;
}
export async function asaasFetch(method, path, body, params) {
  const base = Deno.env.get('ASAAS_BASE_URL') || 'https://api-sandbox.asaas.com/';
  const url = new URL(path.replace(/^\//, ''), base);
  if (params) for (const [key, value] of Object.entries(params)) url.searchParams.set(key, String(value));
  const response = await fetch(url, {
    method, headers: { accept: 'application/json', 'content-type': 'application/json', access_token: Deno.env.get('ASAAS_ACCESS_TOKEN') },
    body: body ? JSON.stringify(body) : undefined,
    signal: AbortSignal.timeout(60000),
  });
  const text = await response.text();
  let data;
  try { data = JSON.parse(text); } catch { throw new PaymentError('Resposta de pagamento inconclusiva. Consulte antes de tentar novamente.', 503); }
  return { statusCode: response.status, body: data };
}
export async function invoiceForUser(id, userId) {
  if (!id) throw new PaymentError('Cobrança não informada.');
  const invoice = checkDb(await adminClient().from('cobrancas').select('*').eq('id', id).maybeSingle());
  if (!invoice || invoice.user_id !== userId) throw new PaymentError('Cobrança não disponível para este usuário.', 403);
  // Published legacy clients omitted this relationship at signup. Resolve
  // only the franchise already owned by the authenticated invoice user.
  if (invoice.tipo_cobranca === 'franquia' && !invoice.if_franquia) {
    const admin = adminClient();
    const user = checkDb(await admin.from('users').select('id_franquia').eq('id', userId).maybeSingle());
    const franchise = user?.id_franquia && checkDb(await admin.from('franquias').select('*').eq('id', user.id_franquia).eq('user_responsavel', userId).maybeSingle());
    if (!franchise) throw new PaymentError('Franquia não vinculada à cobrança. Confira o cadastro.', 409);
    const relationship = { if_franquia: franchise.id };
    if (!invoice.indicacao && franchise['id-indicacao']) relationship.indicacao = franchise['id-indicacao'];
    checkDb(await admin.from('cobrancas').update(relationship).eq('id', invoice.id).eq('user_id', userId));
    invoice.if_franquia = franchise.id;
    if (relationship.indicacao) invoice.indicacao = relationship.indicacao;
  }
  return invoice;
}
export function validateTerms(invoice, variables, card) {
  const total = Number(invoice.valor);
  if (!Number.isFinite(total) || total <= 0 || !Number.isFinite(Number(variables.valortotal)) ||
      Math.abs(total - Number(variables.valortotal)) > 0.005) throw new PaymentError('Valor diferente da cobrança. Reabra o checkout.');
  const count = Number(invoice.num_parcelas ?? variables.parcelas ?? 1);
  if (!Number.isInteger(count) || count < 1 || count > 12) throw new PaymentError('Parcelas inválidas.');
  if (card) {
    if (Number(variables.parcelas ?? 1) !== count) throw new PaymentError('Parcelas diferentes da cobrança.');
    const installment = Number(variables.valorParcela ?? total / count);
    if (!Number.isFinite(installment) || installment <= 0 ||
        Math.abs(installment * count - total) > count * 0.005 + 0.005) throw new PaymentError('Parcelas não correspondem ao valor total.');
  }
  return card && count > 1 ? { installmentCount: count, totalValue: total } : { value: total };
}
export function isoBirthDate(value) {
  const raw = String(value ?? '').trim();
  const parts = /^(\d{2})\/(\d{2})\/(\d{4})$/.exec(raw);
  const iso = parts ? `${parts[3]}-${parts[2]}-${parts[1]}` : raw;
  const date = new Date(`${iso}T00:00:00Z`);
  if (!/^\d{4}-\d{2}-\d{2}$/.test(iso) || !Number.isFinite(date.valueOf()) ||
      date.toISOString().slice(0, 10) !== iso || date >= new Date()) throw new PaymentError('Data de nascimento inválida. Confira o cadastro.');
  return iso;
}
export async function saveProfile(userId, variables) {
  const invoice = await invoiceForUser(variables.idcobranca, userId);
  if (invoice.tipo_cobranca !== 'franquia' || !invoice.if_franquia) throw new PaymentError('Cadastro de franquia não vinculado à cobrança.');
  const admin = adminClient();
  const user = checkDb(await admin.from('users').select('*').eq('id', userId).maybeSingle());
  const franchise = checkDb(await admin.from('franquias').select('*').eq('id', invoice.if_franquia).maybeSingle());
  if (!user || franchise?.user_responsavel !== userId) throw new PaymentError('Cadastro não disponível.', 403);
  const document = String(variables.cpfcnpj || user.cpf || '').replace(/\D/g, '');
  if (![11, 14].includes(document.length)) throw new PaymentError('CPF/CNPJ inválido.');
  // Keep the existing configured income default; do not change plan pricing or
  // entitlement rules. Birth dates are now taken from the actual saved user.
  const income = Number(variables.renda || Deno.env.get('ASAAS_DEFAULT_INCOME') || 25000);
  if (!Number.isFinite(income) || income <= 0) throw new PaymentError('Renda/faturamento inválido.');
  const profile = {
    name: document.length === 14 ? franchise.razao_social || user.nome : user.nome,
    email: user.email, loginEmail: user.email, cpfCnpj: document, mobilePhone: user.telefone,
    incomeValue: income, address: user.endereco, addressNumber: user.numero,
    complement: user.complemento, province: user.bairro, postalCode: String(user.cep || '').replace(/\D/g, ''),
    ...(document.length === 11 ? { birthDate: isoBirthDate(user.data_nascimento) } :
      { companyType: ['MEI','LIMITED','INDIVIDUAL','ASSOCIATION'].includes(variables.tipoempresa) ? variables.tipoempresa : 'LIMITED' }),
  };
  for (const key of ['name', 'email', 'mobilePhone', 'address', 'addressNumber', 'province', 'postalCode']) {
    if (!String(profile[key] || '').trim()) throw new PaymentError('Cadastro incompleto. Confira endereço e dados pessoais.');
  }
  checkDb(await admin.from('payment_profiles').upsert({ user_id: userId, franchise_id: invoice.if_franquia, profile, updated_at: new Date().toISOString() }, { onConflict: 'user_id' }));
  return { statusCode: 200, body: { saved: true } };
}
export async function reserveOperation(invoice, kind) {
  const claim = checkDb(await adminClient().rpc('reserve_payment_operation', { p_cobranca: invoice.id, p_user: invoice.user_id, p_kind: kind }));
  if (!claim) throw new PaymentError('Pagamento indisponível. Consulte novamente.', 503);
  if (claim.action === 'busy') throw new PaymentError('Uma tentativa está em processamento. Consulte o pagamento; não é necessário pagar novamente.', 409);
  return claim;
}
export async function finishOperation(claim, state, result) {
  checkDb(await adminClient().from('payment_operations').update({ state, result, updated_at: new Date().toISOString() })
    .eq('scope_key', claim.scope).eq('operation_id', claim.operation));
}
export async function activateFranchise(invoice) {
  if (invoice.tipo_cobranca !== 'franquia') return { statusCode: 200, body: { activation: 'unchanged' } };
  if (!PAID.has(invoice.status_cobranca)) throw new PaymentError('Pagamento ainda não confirmado.', 409);
  const admin = adminClient();
  const franchise = checkDb(await admin.from('franquias').select('*').eq('id', invoice.if_franquia).maybeSingle());
  if (!franchise || franchise.user_responsavel !== invoice.user_id) throw new PaymentError('Franquia não vinculada ao pagamento.', 403);
  let walletId = franchise.wallet_id;
  if (!walletId) {
    const stored = checkDb(await admin.from('payment_profiles').select('*').eq('user_id', invoice.user_id).maybeSingle());
    if (!stored || stored.franchise_id !== franchise.id) throw new PaymentError('Pagamento aprovado; confira o cadastro para concluir a ativação.', 409);
    const claim = await reserveOperation(invoice, 'activation');
    if (claim.action === 'reuse') {
      walletId = claim.result?.walletId;
    } else {
      const response = await asaasFetch('POST', 'v3/accounts', stored.profile);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        // Only explicit validation failures are safe to retry. Auth errors,
        // conflicts, timeouts and server errors keep the reservation intact.
        if (response.statusCode === 400 || response.statusCode === 422) await finishOperation(claim, 'rejected', null);
        return response;
      }
      walletId = response.body.walletId;
      if (!walletId) throw new PaymentError('Ativação inconclusiva. Consulte o suporte antes de repetir.', 503);
      if (response.body.apiKey) checkDb(await admin.from('payment_profiles').update({ asaas_api_key: response.body.apiKey }).eq('user_id', invoice.user_id));
      await finishOperation(claim, 'succeeded', { walletId });
    }
  }
  if (!walletId) throw new PaymentError('Ativação em processamento.', 409);
  checkDb(await admin.from('franquias').update({ wallet_id: walletId, status_franquia: true }).eq('id', franchise.id).eq('user_responsavel', invoice.user_id));
  return { statusCode: 200, body: { walletId, activation: 'complete' } };
}
export async function applyPayment(invoice, payment) {
  const state = checkDb(await adminClient().rpc('apply_payment_snapshot', {
    p_cobranca: invoice.id, p_payment: payment.id, p_status: payment.status, p_method: payment.billingType,
  }));
  const updated = { ...invoice, id_cobranca_asaas: payment.id, status_cobranca: state.status };
  // Preserve the existing student validity rule. This function never changes
  // users.ativo_ate; only franchise activation belongs to this correction.
  if (updated.tipo_cobranca === 'franquia' && PAID.has(updated.status_cobranca)) {
    try {
      const activation = await activateFranchise(updated);
      return { ...payment, status: state.status, activation: activation.statusCode >= 200 && activation.statusCode < 300 ? 'complete' : 'pending' };
    } catch { return { ...payment, status: state.status, activation: 'pending' }; }
  }
  return { ...payment, status: state.status };
}
export async function splitForInvoice(invoice) {
  const admin = adminClient();
  const result = [];
  if (invoice.tipo_cobranca !== 'franquia') {
    const executor = checkDb(await admin.from('franquias').select('wallet_id').eq('id', invoice.if_franquia).maybeSingle());
    if (!executor?.wallet_id) throw new PaymentError('Franquia executora sem carteira configurada.');
    result.push({ walletId: executor.wallet_id, percentualValue: 80 });
  }
  if (invoice.indicacao) {
    const referrer = checkDb(await admin.from('franquias').select('wallet_id').eq('id', invoice.indicacao).maybeSingle());
    if (!referrer?.wallet_id) throw new PaymentError('Franquia indicadora sem carteira configurada.');
    result.push({ walletId: referrer.wallet_id, percentualValue: invoice.tipo_cobranca === 'franquia' ? 50 : 5 });
  }
  return result;
}
