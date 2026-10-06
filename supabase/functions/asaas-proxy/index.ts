import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.112.3';
import { PaymentError, PAID, adminClient, checkDb, asaasFetch, invoiceForUser, validateTerms, saveProfile, reserveOperation, finishOperation, activateFranchise, applyPayment, splitForInvoice } from '../_shared/payments.ts';

const ORIGINS = new Set(['https://aluno.stepout.com.br', 'https://stepout-aluno.flutterflow.app', 'https://franqueado.stepout.com.br', 'https://stepout-franqueado.flutterflow.app']);
function allowedOrigin(origin) {
  return !origin || ORIGINS.has(origin) || (Deno.env.get('ALLOW_LOCALHOST') === 'true' && /^http:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin));
}
function response(req, result, status = 200) {
  const headers = { 'content-type': 'application/json', Vary: 'Origin', 'Access-Control-Allow-Methods': 'POST, OPTIONS', 'Access-Control-Allow-Headers': req.headers.get('access-control-request-headers') || 'authorization, content-type, x-client-info, apikey' };
  if (allowedOrigin(req.headers.get('origin') || '') && req.headers.get('origin')) headers['Access-Control-Allow-Origin'] = req.headers.get('origin');
  return new Response(status === 204 ? null : JSON.stringify(result), { status, headers });
}
async function requireUser(req) {
  const auth = req.headers.get('authorization') || '';
  if (!/^bearer /i.test(auth)) throw new PaymentError('Sessão expirada. Entre novamente.', 401);
  const client = createClient(Deno.env.get('SUPABASE_URL'), Deno.env.get('SUPABASE_ANON_KEY'), { global: { headers: { Authorization: auth } } });
  const result = await client.auth.getUser();
  if (result.error || !result.data?.user) throw new PaymentError('Sessão expirada. Entre novamente.', 401);
  return result.data.user;
}
async function paymentForUser(userId, id) {
  if (!id) throw new PaymentError('Pagamento não informado.');
  const invoice = checkDb(await adminClient().from('cobrancas').select('*').eq('id_cobranca_asaas', id).maybeSingle());
  if (!invoice || invoice.user_id !== userId) throw new PaymentError('Pagamento não disponível para este usuário.', 403);
  return invoice;
}
async function createPayment(userId, variables, card) {
  const invoice = await invoiceForUser(variables.idcobranca, userId);
  const terms = validateTerms(invoice, variables, card);
  const split = await splitForInvoice(invoice);
  const claim = await reserveOperation(invoice, 'charge');
  if (claim.action === 'reuse') {
    const current = await asaasFetch('GET', `v3/payments/${claim.result.id}`);
    if (current.statusCode >= 200 && current.statusCode < 300) current.body = await applyPayment(invoice, current.body);
    return current;
  }
  const payload = {
    customer: variables.clienteid, billingType: card ? 'CREDIT_CARD' : 'PIX', ...terms,
    dueDate: variables.datacobranca || new Date().toISOString().slice(0, 10),
    externalReference: invoice.id,
    description: invoice.tipo_cobranca === 'franquia' ? 'Step Out - Contratação de franquia' : 'Step Out - Pagamento do aluno',
    ...(split.length ? { split } : {}),
  };
  if (card) {
    payload.creditCard = { holderName: variables.nomecartao, number: String(variables.numerocartao || '').replace(/\D/g, ''), expiryMonth: variables.mesexpiracartao || variables.mesexpiracao, expiryYear: variables.anoexpira, ccv: variables.cvv };
    payload.creditCardHolderInfo = { name: variables.nomecartao, email: variables.email, cpfCnpj: String(variables.cpf || '').replace(/\D/g, ''), postalCode: String(variables.cep || '').replace(/\D/g, ''), addressNumber: variables.numero, phone: String(variables.telefone || '').replace(/\D/g, '') };
    payload.remoteIp = variables.ip;
  }
  const result = await asaasFetch('POST', 'v3/payments', payload);
  if (result.statusCode < 200 || result.statusCode >= 300) {
    if (result.statusCode === 400 || result.statusCode === 422) await finishOperation(claim, 'rejected', null);
    return result;
  }
  if (!result.body?.id || !result.body?.status) throw new PaymentError('Pagamento inconclusivo. Consulte antes de tentar novamente.', 503);
  // Keep the reservation on failure after Asaas has accepted the payment.
  // The webhook can reconcile it using externalReference even with no browser.
  result.body = await applyPayment(invoice, result.body);
  return result;
}
async function handle(userId, call, variables) {
  if (call === 'SalvarContextoPagamentoCall') return saveProfile(userId, variables);
  if (call === 'ConsultarContextoPagamentoCall') {
    const invoice = await invoiceForUser(variables.idcobranca, userId);
    const stored = checkDb(await adminClient().from('payment_profiles').select('profile,franchise_id').eq('user_id', userId).maybeSingle());
    if (stored && stored.franchise_id !== invoice.if_franquia) throw new PaymentError('Confira o cadastro para concluir o pagamento.', 409);
    return { statusCode: 200, body: { profile: stored?.profile || null } };
  }
  if (call === 'CriarSubcontaFranquiaCall') {
    let id = variables.idcobranca;
    if (!id) {
      // Old published clients send registration fields without an invoice ID.
      // Use only their most recent confirmed franchise invoice; never create
      // a subaccount merely because the caller supplied registration fields.
      const invoices = checkDb(await adminClient().from('cobrancas').select('*')
        .eq('user_id', userId).eq('tipo_cobranca', 'franquia').order('created_at', { ascending: false }));
      id = invoices.find(invoice => PAID.has(invoice.status_cobranca))?.id;
      if (!id) throw new PaymentError('Pagamento ainda não confirmado.', 409);
    }
    const invoice = await invoiceForUser(id, userId);
    const stored = checkDb(await adminClient().from('payment_profiles').select('franchise_id').eq('user_id', userId).maybeSingle());
    if (!stored) await saveProfile(userId, { ...variables, idcobranca: id });
    return activateFranchise(invoice);
  }
  if (/^CriarCobranca(Cartao|Pix)(Com|Sem)SplitCall$/.test(call)) return createPayment(userId, variables, call.includes('Cartao'));
  if (call === 'CriarClienteCall') {
    const stored = checkDb(await adminClient().from('payment_profiles').select('profile').eq('user_id', userId).maybeSingle());
    if (stored?.profile) variables = { ...variables, nome: stored.profile.name, cpf: stored.profile.cpfCnpj, email: stored.profile.email };
    // Reuse the same customer on retries, instead of creating duplicates.
    const list = await asaasFetch('GET', 'v3/customers', undefined, { email: variables.email, cpfCnpj: String(variables.cpf || '').replace(/\D/g, '') });
    if (list.statusCode < 200 || list.statusCode >= 300) return list;
    if (list.body.data?.length) return { statusCode: 200, body: list.body.data[0] };
    return asaasFetch('POST', 'v3/customers', { name: variables.nome, cpfCnpj: String(variables.cpf || '').replace(/\D/g, ''), email: variables.email });
  }
  if (call === 'GETClienteCall') {
    const user = checkDb(await adminClient().from('users').select('email').eq('id', userId).maybeSingle());
    if (!user || variables.email !== user.email) throw new PaymentError('Cliente não disponível.', 403);
    return asaasFetch('GET', 'v3/customers', undefined, { email: user.email });
  }
  if (call === 'GETQRCodeCall' || call === 'GETStatusPixCall') {
    const invoice = await paymentForUser(userId, variables.id);
    if (call === 'GETQRCodeCall') return asaasFetch('GET', `v3/payments/${variables.id}/pixQrCode`);
    const current = await asaasFetch('GET', `v3/payments/${variables.id}`);
    if (current.statusCode >= 200 && current.statusCode < 300) current.body = await applyPayment(invoice, current.body);
    return current;
  }
  if (call === 'ConsultarPagamentoCall') {
    const invoice = await invoiceForUser(variables.idcobranca, userId);
    if (!invoice.id_cobranca_asaas) {
      const operation = checkDb(await adminClient().from('payment_operations').select('state').eq('scope_key', `charge:${invoice.id}`).maybeSingle());
      if (operation?.state === 'processing') throw new PaymentError('Pagamento em processamento. Não pague novamente.', 409);
      return { statusCode: 200, body: { status: invoice.status_cobranca || '', id: null } };
    }
    const current = await asaasFetch('GET', `v3/payments/${invoice.id_cobranca_asaas}`);
    if (current.statusCode >= 200 && current.statusCode < 300) current.body = await applyPayment(invoice, current.body);
    return current;
  }
  if (call === 'CancelarCobrancaCall') {
    const invoice = checkDb(await adminClient().from('cobrancas').select('*').eq('id_cobranca_asaas', variables.id).maybeSingle());
    if (!invoice) throw new PaymentError('Cobrança não encontrada.', 404);
    if (invoice.user_id !== userId) {
      const franchise = checkDb(await adminClient().from('franquias').select('id').eq('id', invoice.if_franquia).eq('user_responsavel', userId).maybeSingle());
      if (!franchise) throw new PaymentError('Sem permissão para cancelar esta cobrança.', 403);
    }
    if (PAID.has(invoice.status_cobranca)) throw new PaymentError('Pagamento confirmado. Solicite estorno pelo procedimento existente.');
    return asaasFetch('DELETE', `v3/payments/${variables.id}`);
  }
  throw new PaymentError('Operação não disponível.');
}
Deno.serve(async (req) => {
  if (!allowedOrigin(req.headers.get('origin') || '')) return response(req, { error: 'origin not allowed' }, 403);
  if (req.method === 'OPTIONS') return response(req, null, 204);
  if (req.method !== 'POST') return response(req, { error: 'method not allowed' }, 405);
  try {
    const user = await requireUser(req);
    const body = await req.json();
    return response(req, await handle(user.id, String(body.callName || ''), body.variables || {}));
  } catch (error) {
    const status = error instanceof PaymentError ? error.status : 503;
    const message = error instanceof PaymentError ? error.message : 'Resultado inconclusivo. Consulte o pagamento antes de tentar novamente.';
    return response(req, { statusCode: status, body: { errors: [{ description: message }] } }, status);
  }
});
