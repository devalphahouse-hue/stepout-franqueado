const { test, before, beforeEach, after } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const { PGlite } = require('@electric-sql/pglite');
const USER = '00000000-0000-0000-0000-000000000001';
const OTHER = '00000000-0000-0000-0000-000000000002';
const BILL = '00000000-0000-0000-0000-000000000010';
const FRANCHISE = '00000000-0000-0000-0000-000000000020';
const EXECUTOR = '00000000-0000-0000-0000-000000000021';
const REFERRER = '00000000-0000-0000-0000-000000000022';
let db;
before(async () => {
  db = new PGlite();
  await db.exec(`
    create role anon; create role authenticated; create role service_role;
    create table users (id uuid primary key,nome text,email text,cpf text,telefone text,
      data_nascimento text,endereco text,numero text,bairro text,cep text,complemento text,
      id_franquia uuid,ativo_ate date);
    create table franquias (id uuid primary key,razao_social text,user_responsavel uuid,
      wallet_id text,status_franquia boolean,"id-indicacao" uuid);
    create table cobrancas (id uuid primary key,created_at timestamptz default now(),
      user_id uuid,valor double precision,tipo_cobranca text,if_franquia uuid,indicacao uuid,
      num_parcelas bigint,valor_parcelas double precision,id_cobranca_asaas text,
      status_cobranca text,forma_pagamento text);
  `);
  await db.exec(fs.readFileSync(path.join(__dirname, '../migrations/20261006150000_payment_safety.sql'), 'utf8'));
});
beforeEach(async () => {
  await db.exec('truncate payment_operations,payment_profiles,cobrancas,franquias,users cascade;');
  await db.query(`insert into users values ($1,'Teste','teste@example.invalid','00000000000','11999999999',
    '04/05/1990','Rua Teste','123','Centro','01001000','', $2, '2027-01-01')`, [USER, FRANCHISE]);
  await db.query(`insert into franquias(id,razao_social,user_responsavel,status_franquia) values ($1,'Teste',$2,false)`, [FRANCHISE, USER]);
  await db.query(`insert into franquias(id,wallet_id,user_responsavel,status_franquia) values ($1,'executor',$3,true),($2,'referrer',$3,true)`, [EXECUTOR, REFERRER, OTHER]);
  await db.query(`insert into cobrancas(id,user_id,valor,tipo_cobranca,if_franquia,num_parcelas,valor_parcelas)
    values ($1,$2,10,'franquia',$3,1,10)`, [BILL, USER, FRANCHISE]);
  await db.query(`insert into payment_profiles(user_id,franchise_id,profile) values ($1,$2,$3)`, [USER, FRANCHISE, {
    name: 'Teste', email: 'teste@example.invalid', cpfCnpj: '00000000000', mobilePhone: '11999999999',
    incomeValue: 25000, address: 'Rua Teste', addressNumber: '123', province: 'Centro', postalCode: '01001000', birthDate: '1990-05-04',
  }]);
});
after(async () => { await db.close(); });

// Real SQL transaction/row-lock logic, real function sources, simulated Asaas.
// Every external HTTP request is intercepted here; never accesses real data.
function runtime(options = {}) {
  const calls = [], payments = new Map();
  let nextId = 1;
  const quote = s => '"' + s.replaceAll('"', '""') + '"';
  class Query {
    constructor(table) { this.table = table; this.filters = []; this.mode = 'select'; }
    select() { this.returning = true; return this; }
    eq(key, value) { this.filters.push([key, value]); return this; }
    order(key, config) { this.sort = [key, config.ascending]; return this; }
    update(data) { this.mode = 'update'; this.data = data; return this; }
    upsert(data, config) { this.mode = 'upsert'; this.data = data; this.conflict = config.onConflict; return this; }
    async execute(single = false) {
      try {
        const values = [], push = x => { values.push(x); return '$' + values.length; };
        let sql;
        if (this.mode === 'select') sql = `select * from ${quote(this.table)}`;
        else if (this.mode === 'update') sql = `update ${quote(this.table)} set ` + Object.entries(this.data).map(([k,v]) => quote(k) + '=' + push(v)).join(',');
        else {
          const keys = Object.keys(this.data);
          sql = `insert into ${quote(this.table)} (${keys.map(quote).join(',')}) values (${keys.map(k => push(this.data[k])).join(',')}) on conflict (${quote(this.conflict)}) do update set ` + keys.filter(k => k !== this.conflict).map(k => `${quote(k)}=excluded.${quote(k)}`).join(',');
        }
        if (this.filters.length) sql += ' where ' + this.filters.map(([k,v]) => `${quote(k)}=${push(v)}`).join(' and ');
        if (this.sort && this.mode === 'select') sql += ` order by ${quote(this.sort[0])} ${this.sort[1] ? 'asc' : 'desc'}`;
        if (this.mode !== 'select' && this.returning) sql += ' returning *';
        const result = await db.query(sql, values);
        return { data: single ? result.rows[0] ?? null : result.rows, error: null };
      } catch (error) { return { data: null, error: { message: error.message } }; }
    }
    maybeSingle() { return this.execute(true); }
    then(resolve, reject) { return this.execute().then(resolve,reject); }
  }
  const client = {
    auth: { getUser: async () => ({ data: { user: options.invalidSession ? null : { id: options.userId || USER } }, error: null }) },
    from: table => new Query(table),
    rpc: async (name, args) => {
      if (name === 'apply_payment_snapshot' && options.failApply) return { data: null, error: { message: 'simulated database failure' } };
      try {
        const keys = Object.keys(args);
        const response = await db.query(`select public.${quote(name)}(${keys.map((k,i) => `${quote(k)}=>$${i+1}`).join(',')}) as result`, keys.map(k => args[k]));
        return { data: response.rows[0].result, error: null };
      } catch (error) { return { data: null, error: { message: error.message } }; }
    },
  };
  const served = [];
  const context = vm.createContext({
    URL, Request, Response, Date, AbortSignal, console: { log() {} },
    createClient: () => client,
    Deno: { env: { get: key => ({ SUPABASE_URL: 'https://offline.invalid', SUPABASE_ANON_KEY: 'fake', SUPABASE_SERVICE_ROLE_KEY: 'fake', ASAAS_ACCESS_TOKEN: 'fake', ASAAS_BASE_URL: 'https://offline.invalid/', ASAAS_WEBHOOK_TOKEN: 'fake-webhook' })[key] }, serve: fn => served.push(fn) },
    fetch: async (url, config) => {
      const uri = new URL(url), body = config.body ? JSON.parse(config.body) : null;
      calls.push({ method: config.method, path: uri.pathname, body });
      if (uri.pathname === '/v3/payments' && config.method === 'POST') {
        if (options.paymentError) return new Response(JSON.stringify({ errors: [{ description: 'Cartão recusado' }] }), { status: 400 });
        const payment = { id: 'pay_test_' + nextId++, status: options.paymentStatus || 'CONFIRMED', billingType: body.billingType, externalReference: body.externalReference, value: body.value ?? body.totalValue / body.installmentCount };
        payments.set(payment.id, payment);
        if (options.networkTimeout) throw new Error('simulated timeout after acceptance');
        return new Response(JSON.stringify(payment));
      }
      if (uri.pathname === '/v3/accounts') {
        if (options.activationError) return new Response(JSON.stringify({ errors: [{ description: 'Dados cadastrais inválidos' }] }), { status: 400 });
        return new Response(JSON.stringify({ id: 'account_test', walletId: 'new-wallet', apiKey: 'fake-private-key' }));
      }
      if (uri.pathname === '/v3/customers') return new Response(JSON.stringify(config.method === 'POST' ? { id: 'cus_test' } : { data: [] }));
      const id = uri.pathname.split('/')[3];
      if (config.method === 'DELETE') return new Response(JSON.stringify({ deleted: true }));
      if (uri.pathname.endsWith('/pixQrCode')) return new Response(JSON.stringify({ payload: 'fake-pix', encodedImage: 'fake-image' }));
      return new Response(JSON.stringify(payments.get(id) || { id, status: 'CONFIRMED', externalReference: BILL, billingType: 'CREDIT_CARD' }));
    },
  });
  for (const source of ['_shared/payments.ts','asaas-proxy/index.ts','asaas-webhook/index.ts']) {
    const text = fs.readFileSync(path.join(__dirname, '../functions', source), 'utf8').replace(/^import .*;\r?\n/gm, '').replace(/^export /gm, '');
    vm.runInContext(text, context, { filename: source });
  }
  return { calls, payments, options, context,
    async invoke(callName, variables = {}, headers = {}) {
      const result = await served[0](new Request('https://offline.invalid', { method: 'POST', headers: { authorization: 'Bearer fake', origin: 'https://franqueado.stepout.com.br', ...headers }, body: JSON.stringify({ callName, variables }) }));
      return { http: result.status, ...(await result.json()) };
    },
    async webhook(payment, headers = {}) {
      return served[1](new Request('https://offline.invalid', { method: 'POST', headers: { 'asaas-access-token': 'fake-webhook', ...headers }, body: JSON.stringify({ event: 'PAYMENT_' + payment.status, payment }) }));
    },
  };
}
const base = { idcobranca: BILL, clienteid: 'cus_test', valortotal: 10, parcelas: 1, valorParcela: 10, nomecartao: 'Teste', numerocartao: '4111 1111 1111 1111', mesexpiracao: '12', anoexpira: '2030', cvv: '123', email: 'teste@example.invalid', cpf: '000.000.000-00', cep: '01001-000', endereco: 'Rua Teste', numero: '123', telefone: '(11) 99999-9999' };
const creations = rt => rt.calls.filter(c => c.path === '/v3/payments' && c.method === 'POST');
for (const [total,count] of [[10,1],[30,6],[60,12],[20000,1],[25000,6],[30000,12]]) {
  for (const referral of [false,true]) test(`Plano ${total}, ${count} parcelas, indicação ${referral}: total e split preservados`, async () => {
    await db.query('update cobrancas set valor=$1,num_parcelas=$2,valor_parcelas=$3,indicacao=$4 where id=$5', [total,count,total/count,referral ? REFERRER : null,BILL]);
    const rt = runtime();
    const result = await rt.invoke(referral ? 'CriarCobrancaCartaoComSplitCall' : 'CriarCobrancaCartaoSemSplitCall', { ...base,valortotal: total,parcelas: count,valorParcela: total/count });
    assert.equal(result.statusCode,200);
    const body = creations(rt)[0].body;
    assert.equal(body.externalReference,BILL);
    if (count === 1) { assert.equal(body.value,total); assert.equal(body.installmentCount,undefined); }
    else { assert.equal(body.totalValue,total); assert.equal(body.installmentCount,count); assert.equal(body.installmentValue,undefined); }
    if (referral) assert.deepEqual(body.split,[{walletId:'referrer',percentualValue:50}]);
    else assert.equal(body.split,undefined);
    const invoice = (await db.query('select * from cobrancas where id=$1',[BILL])).rows[0];
    assert.equal(invoice.id_cobranca_asaas,'pay_test_1');
    assert.equal((await db.query('select status_franquia from franquias where id=$1',[FRANCHISE])).rows[0].status_franquia,true);
  });
}
test('A mesma cobrança repetida cria somente um pagamento e uma subconta', async () => {
  const rt=runtime(); await rt.invoke('CriarCobrancaCartaoSemSplitCall',base); await rt.invoke('CriarCobrancaCartaoSemSplitCall',base);
  assert.equal(creations(rt).length,1); assert.equal(rt.calls.filter(c=>c.path==='/v3/accounts').length,1);
});
test('Cliques concorrentes reservam somente uma cobrança', async () => {
  const rt=runtime(); await Promise.all([rt.invoke('CriarCobrancaCartaoSemSplitCall',base),rt.invoke('CriarCobrancaCartaoSemSplitCall',base)]);
  assert.equal(creations(rt).length,1);
});
test('Timeout após aceitação impede novo débito e permite recuperação por webhook', async () => {
  const rt=runtime({networkTimeout:true}); assert.equal((await rt.invoke('CriarCobrancaCartaoSemSplitCall',base)).statusCode,503);
  assert.equal((await rt.invoke('CriarCobrancaCartaoSemSplitCall',base)).statusCode,409); assert.equal(creations(rt).length,1);
  rt.options.networkTimeout=false;
  assert.equal((await rt.webhook(rt.payments.get('pay_test_1'))).status,200);
  assert.equal((await db.query('select id_cobranca_asaas from cobrancas where id=$1',[BILL])).rows[0].id_cobranca_asaas,'pay_test_1');
});
test('Falha de banco após pagamento não permite pagar novamente', async () => {
  const rt=runtime({failApply:true}); assert.equal((await rt.invoke('CriarCobrancaCartaoSemSplitCall',base)).statusCode,503);
  assert.equal((await rt.invoke('CriarCobrancaCartaoSemSplitCall',base)).statusCode,409); assert.equal(creations(rt).length,1);
  rt.options.failApply=false; assert.equal((await rt.webhook(rt.payments.get('pay_test_1'))).status,200);
});
test('Recusa explícita de cartão permite corrigir dados e tentar novamente', async () => {
  const rt=runtime({paymentError:true}); assert.equal((await rt.invoke('CriarCobrancaCartaoSemSplitCall',base)).statusCode,400);
  rt.options.paymentError=false; assert.equal((await rt.invoke('CriarCobrancaCartaoSemSplitCall',base)).statusCode,200);
  assert.equal(creations(rt).length,2);
});
test('Falha na ativação mantém pagamento e permite retomar somente a ativação', async () => {
  const rt=runtime({activationError:true}); const first=await rt.invoke('CriarCobrancaCartaoSemSplitCall',base);
  assert.equal(first.body.status,'CONFIRMED'); assert.equal(first.body.activation,'pending');
  assert.equal((await db.query('select status_franquia from franquias where id=$1',[FRANCHISE])).rows[0].status_franquia,false);
  rt.options.activationError=false; assert.equal((await rt.invoke('CriarSubcontaFranquiaCall',{idcobranca:BILL})).statusCode,200);
  assert.equal(creations(rt).length,1);
});
test('Pagamento em análise permanece registrado e é ativado depois pelo webhook', async () => {
  const rt=runtime({paymentStatus:'AWAITING_RISK_ANALYSIS'}); await rt.invoke('CriarCobrancaCartaoSemSplitCall',base);
  assert.equal((await db.query('select status_franquia from franquias where id=$1',[FRANCHISE])).rows[0].status_franquia,false);
  rt.payments.get('pay_test_1').status='CONFIRMED'; assert.equal((await rt.webhook({id:'pay_test_1',status:'CONFIRMED'})).status,200);
  assert.equal((await db.query('select status_franquia from franquias where id=$1',[FRANCHISE])).rows[0].status_franquia,true);
});
test('Webhook antigo PENDING não rebaixa pagamento recebido', async () => {
  const rt=runtime({paymentStatus:'RECEIVED'}); await rt.invoke('CriarCobrancaCartaoSemSplitCall',base);
  assert.equal((await rt.webhook({id:'pay_test_1',status:'PENDING'})).status,200);
  assert.equal((await db.query('select status_cobranca from cobrancas where id=$1',[BILL])).rows[0].status_cobranca,'RECEIVED');
});
test('Pix fica vinculado antes de consultar QR e webhook', async () => {
  await db.query('update cobrancas set tipo_cobranca=$1,if_franquia=$2 where id=$3',['aluno',EXECUTOR,BILL]);
  const rt=runtime({paymentStatus:'PENDING'}); const result=await rt.invoke('CriarCobrancaPixSemSplitCall',base);
  assert.equal(result.statusCode,200); assert.equal((await db.query('select id_cobranca_asaas from cobrancas where id=$1',[BILL])).rows[0].id_cobranca_asaas,'pay_test_1');
  assert.equal((await rt.invoke('GETQRCodeCall',{id:'pay_test_1'})).statusCode,200);
});
test('Confirmação de aluno preserva a validade atual, sem inventar prazo', async () => {
  await db.query('update cobrancas set tipo_cobranca=$1,if_franquia=$2 where id=$3',['aluno',EXECUTOR,BILL]);
  const rt=runtime(); await rt.invoke('CriarCobrancaCartaoSemSplitCall',base);
  assert.equal((await db.query('select ativo_ate::text as date from users where id=$1',[USER])).rows[0].date,'2027-01-01');
});
test('Endereço do cartão usa o número, nunca a rua', async () => {
  const rt=runtime(); await rt.invoke('CriarCobrancaCartaoSemSplitCall',base);
  assert.equal(creations(rt)[0].body.creditCardHolderInfo.addressNumber,'123');
  assert.equal(creations(rt)[0].body.creditCard.number,'4111111111111111');
});
test('CPF salva nascimento real em ISO e não envia companyType', async () => {
  const rt=runtime(); assert.equal((await rt.invoke('SalvarContextoPagamentoCall',{idcobranca:BILL,cpfcnpj:'00000000000',tipoempresa:'Física'})).statusCode,200);
  await rt.invoke('CriarCobrancaCartaoSemSplitCall',base); const profile=rt.calls.find(c=>c.path==='/v3/accounts').body;
  assert.equal(profile.birthDate,'1990-05-04'); assert.equal(profile.companyType,undefined);
});
test('CNPJ permanece CNPJ na retomada e não envia nascimento PF', async () => {
  const rt=runtime(); await rt.invoke('SalvarContextoPagamentoCall',{idcobranca:BILL,cpfcnpj:'00000000000000',tipoempresa:'LIMITED'});
  const context=await rt.invoke('ConsultarContextoPagamentoCall',{idcobranca:BILL});
  assert.equal(context.body.profile.cpfCnpj.length,14); assert.equal(context.body.profile.birthDate,undefined);
});
test('Nascimentos inválidos não são substituídos por uma data inventada', async () => {
  await db.query('update users set data_nascimento=$1 where id=$2',['31/02/1990',USER]);
  const rt=runtime(); assert.equal((await rt.invoke('SalvarContextoPagamentoCall',{idcobranca:BILL,cpfcnpj:'00000000000'})).statusCode,400);
});
for (const changes of [{valortotal:1},{parcelas:12,valorParcela:50},{valortotal:NaN}]) test(`Parâmetros inconsistentes bloqueados: ${JSON.stringify(changes)}`,async()=>{
  const rt=runtime(); assert.equal((await rt.invoke('CriarCobrancaCartaoSemSplitCall',{...base,...changes})).statusCode,400); assert.equal(creations(rt).length,0);
});
test('Usuário diferente não cria pagamento de terceiro',async()=>{const rt=runtime({userId:OTHER}); assert.equal((await rt.invoke('CriarCobrancaCartaoSemSplitCall',base)).statusCode,403); assert.equal(creations(rt).length,0);});
test('Token e origem inválidos não alcançam o Asaas',async()=>{
  const badSession=runtime({invalidSession:true}); assert.equal((await badSession.invoke('CriarCobrancaCartaoSemSplitCall',base)).http,401); assert.equal(badSession.calls.length,0);
  const rt=runtime(); assert.equal((await rt.invoke('CriarCobrancaCartaoSemSplitCall',base,{origin:'https://untrusted.invalid'})).http,403); assert.equal(rt.calls.length,0);
});
test('Webhook sem token é bloqueado',async()=>{const rt=runtime(); assert.equal((await rt.webhook({id:'pay_test',status:'CONFIRMED'},{'asaas-access-token':''})).status,401); assert.equal(rt.calls.length,0);});
test('Webhook sem vínculo retorna erro transitório para não perder evento',async()=>{
  await db.query('delete from payment_profiles'); await db.query('delete from cobrancas');
  const rt=runtime(); assert.equal((await rt.webhook({id:'pay_missing',status:'CONFIRMED'})).status,503);
});
test('Estorno atualiza financeiro sem mudar a regra de acesso existente',async()=>{
  const rt=runtime(); await rt.invoke('CriarCobrancaCartaoSemSplitCall',base); rt.payments.get('pay_test_1').status='REFUNDED';
  assert.equal((await rt.webhook({id:'pay_test_1',status:'REFUNDED'})).status,200);
  assert.equal((await db.query('select status_cobranca from cobrancas where id=$1',[BILL])).rows[0].status_cobranca,'REFUNDED');
});
test('Chave privada da subconta não é devolvida ao aplicativo',async()=>{
  const rt=runtime(); const result=await rt.invoke('CriarCobrancaCartaoSemSplitCall',base);
  assert.ok(!JSON.stringify(result).includes('fake-private-key'));
  assert.equal((await db.query('select asaas_api_key from payment_profiles where user_id=$1',[USER])).rows[0].asaas_api_key,'fake-private-key');
});
test('Cliente não pode ler o journal privado nem executar a reserva SQL',async()=>{
  await db.exec('set role authenticated');
  try {
    await assert.rejects(db.query('select * from payment_profiles'),/permission denied/);
    await assert.rejects(db.query('select reserve_payment_operation($1,$2,$3)',[BILL,USER,'charge']),/permission denied/);
  } finally { await db.exec('reset role'); }
});
test('Cobrança antiga recupera os dados existentes antes de salvar o contexto',async()=>{
  await db.query('delete from payment_profiles where user_id=$1',[USER]);
  const rt=runtime();
  const missing=await rt.invoke('ConsultarContextoPagamentoCall',{idcobranca:BILL});
  assert.equal(missing.statusCode,200);
  assert.equal(missing.body.profile,null);
  assert.equal((await rt.invoke('SalvarContextoPagamentoCall',{idcobranca:BILL})).statusCode,200);
  const restored=await rt.invoke('ConsultarContextoPagamentoCall',{idcobranca:BILL});
  assert.equal(restored.body.profile.birthDate,'1990-05-04');
});
test('Cliente publicado sem ID retoma a subconta da sua cobrança confirmada',async()=>{
  const rt=runtime();
  await rt.invoke('CriarCobrancaCartaoSemSplitCall',base);
  const result=await rt.invoke('CriarSubcontaFranquiaCall',{});
  assert.equal(result.statusCode,200);
  assert.equal(result.body.walletId,'new-wallet');
  assert.equal(rt.calls.filter(c=>c.path==='/v3/accounts').length,1);
});
test('Cliente publicado não cria subconta sem pagamento confirmado',async()=>{
  const rt=runtime();
  assert.equal((await rt.invoke('CriarSubcontaFranquiaCall',{})).statusCode,409);
  assert.equal(rt.calls.length,0);
});
test('Cliente antigo retoma cadastro salvo usando nascimento real',async()=>{
  await db.query('delete from payment_profiles where user_id=$1',[USER]);
  const rt=runtime();
  await rt.invoke('CriarCobrancaCartaoSemSplitCall',base);
  const result=await rt.invoke('CriarSubcontaFranquiaCall',{cpfcnpj:'00000000000',tipoempresa:'Física'});
  assert.equal(result.statusCode,200);
  assert.equal(rt.calls.find(c=>c.path==='/v3/accounts').body.birthDate,'1990-05-04');
});
test('Cobrança de cliente antigo recupera somente a franquia do próprio usuário',async()=>{
  await db.query('update cobrancas set if_franquia=null where id=$1',[BILL]);
  const rt=runtime();
  assert.equal((await rt.invoke('CriarCobrancaCartaoSemSplitCall',base)).statusCode,200);
  assert.equal((await db.query('select if_franquia from cobrancas where id=$1',[BILL])).rows[0].if_franquia,FRANCHISE);
});
test('Cliente antigo preserva indicação e split ao recuperar vínculo da franquia',async()=>{
  await db.query('update cobrancas set if_franquia=null,indicacao=null where id=$1',[BILL]);
  await db.query('update franquias set "id-indicacao"=$1 where id=$2',[REFERRER,FRANCHISE]);
  const rt=runtime();
  const result=await rt.invoke('CriarCobrancaCartaoComSplitCall',base);
  assert.equal(result.statusCode,200);
  assert.equal(rt.calls.find(c=>c.path==='/v3/payments'&&c.method==='POST').body.split[0].percentualValue,50);
  assert.equal((await db.query('select indicacao from cobrancas where id=$1',[BILL])).rows[0].indicacao,REFERRER);
});
