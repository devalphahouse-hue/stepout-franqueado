import { adminClient, checkDb, asaasFetch, applyPayment } from '../_shared/payments.ts';

Deno.serve(async (req) => {
  if (req.method !== 'POST') return new Response('method not allowed', { status: 405 });
  const expected = Deno.env.get('ASAAS_WEBHOOK_TOKEN');
  if (!expected || req.headers.get('asaas-access-token') !== expected) return new Response('unauthorized', { status: 401 });
  let event;
  try { event = await req.json(); } catch { return new Response('invalid body', { status: 400 }); }
  const incoming = event?.payment;
  if (!incoming?.id || !incoming?.status) return new Response('invalid payment', { status: 400 });
  try {
    // Fetch current authoritative status. Duplicate or reordered notifications
    // never revert a settled payment based on an older event payload.
    const current = await asaasFetch('GET', `v3/payments/${incoming.id}`);
    if (current.statusCode < 200 || current.statusCode >= 300 || !current.body?.status) return new Response('payment lookup failed', { status: 503 });
    const payment = current.body;
    const admin = adminClient();
    let invoice = checkDb(await admin.from('cobrancas').select('*').eq('id_cobranca_asaas', payment.id).maybeSingle());
    if (!invoice && /^[0-9a-f]{8}-[0-9a-f-]{27}$/i.test(payment.externalReference || '')) {
      invoice = checkDb(await admin.from('cobrancas').select('*').eq('id', payment.externalReference).maybeSingle());
    }
    if (!invoice) return new Response('invoice not linked yet', { status: 503 });
    // Additional installments share externalReference but are separate Asaas
    // payments. Preserve the original checkout invoice/first-payment binding.
    if (invoice.id_cobranca_asaas && invoice.id_cobranca_asaas !== payment.id) {
      return new Response('non-primary installment', { status: 200 });
    }
    const applied = await applyPayment(invoice, payment);
    if (applied.activation === 'pending') return new Response('activation pending; payment recorded', { status: 503 });
    console.log(JSON.stringify({ tag: 'WEBHOOK_PROCESSED', invoice: invoice.id, payment: payment.id, status: applied.status }));
    return new Response('ok', { status: 200 });
  } catch {
    return new Response('transient reconciliation failure', { status: 503 });
  }
});
