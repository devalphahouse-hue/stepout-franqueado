const {test,before,beforeEach,after}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const path=require('node:path');
const vm=require('node:vm');
const {PGlite}=require('@electric-sql/pglite');
const ACTOR='00000000-0000-0000-0000-000000000001';
const STUDENT='00000000-0000-0000-0000-000000000002';
const ADMIN='00000000-0000-0000-0000-000000000003';
const FRANCHISE='00000000-0000-0000-0000-000000000010';
const OTHER_FRANCHISE='00000000-0000-0000-0000-000000000011';
let db;
before(async()=>{
  db=new PGlite();
  await db.exec(`create role anon;create role authenticated;create role service_role;
    create schema auth;create table auth.users(id uuid primary key,email text unique);
    create table users(id uuid primary key,role text,id_franquia uuid,deleted_at timestamptz,email text);
    create table meta_alunos(id uuid primary key,user_id uuid,deleted_at timestamptz);
    create table cobrancas(id uuid primary key,user_id uuid,valor numeric);
  `);
  await db.exec(fs.readFileSync(path.join(__dirname,'../migrations/20261019190000_student_deletion.sql'),'utf8'));
});
beforeEach(async()=>{
  await db.exec('truncate auth.users,users,meta_alunos,cobrancas;');
  await db.query(`insert into users(id,role,id_franquia,email) values
    ($1,'franquia',$4,'owner@example.invalid'),($2,'aluno',$4,'student@example.invalid'),
    ($3,'admin',null,'admin@example.invalid')`,[ACTOR,STUDENT,ADMIN,FRANCHISE]);
  await db.query(`insert into auth.users values($1,'student@example.invalid');
    `,[STUDENT]);
  await db.query('insert into meta_alunos values($1,$1,null)',[STUDENT]);
  await db.query('insert into cobrancas values($1,$1,10)',[STUDENT]);
});
after(async()=>db.close());
function runtime(options={}){
  const events=[];
  class Query{
    constructor(table){this.table=table;this.filters=[];this.mode='select';}
    select(){return this;}
    eq(key,value){this.filters.push([key,value]);return this;}
    update(data){this.mode='update';this.data=data;return this;}
    delete(){this.mode='delete';return this;}
    in(){return this;}
    or(){return this;}
    async execute(single=false){
      try{
        if(this.mode!=='select') {events.push(`legacy:${this.table}`);return {data:[],error:null};}
        const args=this.filters.map(x=>x[1]);
        const conditions=this.filters.map(([key],i)=>`"${key}"=$${i+1}`).join(' and ');
        const result=await db.query(`select * from "${this.table}"${conditions?' where '+conditions:''}`,args);
        return {data:single?result.rows[0]??null:result.rows,error:null};
      }catch(error){return {data:null,error:{message:error.message}};}
    }
    maybeSingle(){return this.execute(true);}
    then(resolve,reject){return this.execute().then(resolve,reject);}
  }
  const client={
    from:table=>new Query(table),
    rpc:async(name,args)=>{
      events.push('finalize');
      if(options.failFinalize)return {data:null,error:{message:'simulated failure'}};
      try{return {data:(await db.query(`select public.${name}($1,$2) as result`,[args.p_actor,args.p_target])).rows[0].result,error:null};}
      catch(error){return {data:null,error:{message:error.message}};}
    },
    auth:{
      getUser:async()=>({data:{user:options.invalidSession?null:{id:options.actor||ACTOR}},error:null}),
      admin:{deleteUser:async(id,soft)=>{
        assert.equal(soft ?? false,false);
        events.push('auth-delete');
        if(options.failAuth)return {error:{status:500,message:'provider unavailable'}};
        const result=await db.query('delete from auth.users where id=$1 returning id',[id]);
        return {error:result.rows.length?null:{status:404,code:'user_not_found'}};
      }},
    },
  };
  let handler;
  const context=vm.createContext({Request,Response,console,
    createClient:()=>client,
    Deno:{env:{get:()=> 'offline-test'},serve:fn=>{handler=fn;}},
  });
  const source=fs.readFileSync(path.join(__dirname,'../functions/delete-user/index.ts'),'utf8').replace(/^import .*;\r?\n/gm,'');
  vm.runInContext(source,context);
  return {events,async invoke(body={userId:STUDENT,expectedRole:'aluno'},overrides={}){
    const response=await handler(new Request('https://offline.invalid',{method:overrides.method||'POST',headers:{authorization:'Bearer fake',origin:overrides.origin||'https://franqueado.stepout.com.br'},body:overrides.method==='OPTIONS'?undefined:JSON.stringify(body)}));
    return {status:response.status,body:response.status===204?null:await response.json()};
  }};
}
async function state(){return (await db.query(`select
  (select count(*)::int from auth.users) auth_count,
  (select deleted_at is not null from users where id=$1) profile_deleted,
  (select deleted_at is not null from meta_alunos where user_id=$1) meta_deleted,
  (select count(*)::int from cobrancas) bills`,[STUDENT])).rows[0];}
test('Exclusão remove Auth antes de desativar cadastro e mantém histórico financeiro',async()=>{
  const rt=runtime();assert.equal((await rt.invoke()).status,200);
  assert.deepEqual(rt.events,['auth-delete','finalize']);
  assert.deepEqual(await state(),{auth_count:0,profile_deleted:true,meta_deleted:true,bills:1});
});
test('Mesmo email pode ser cadastrado novamente após a exclusão',async()=>{
  await runtime().invoke();
  const newId='00000000-0000-0000-0000-000000000099';
  await db.query(`insert into auth.users values($1,'student@example.invalid')`,[newId]);
  await db.query(`insert into users(id,role,email) values($1,'aluno','student@example.invalid')`,[newId]);
  assert.equal((await db.query(`select count(*)::int count from users where email='student@example.invalid' and deleted_at is null`)).rows[0].count,1);
});
test('Falha na autenticação não desativa perfil nem informa sucesso',async()=>{
  const rt=runtime({failAuth:true});assert.equal((await rt.invoke()).status,503);
  assert.deepEqual(rt.events,['auth-delete']);
  assert.equal((await state()).profile_deleted,false);
});
test('Falha na finalização permite retomar sem falhar por Auth já removido',async()=>{
  assert.equal((await runtime({failFinalize:true}).invoke()).status,503);
  assert.deepEqual(await state(),{auth_count:0,profile_deleted:false,meta_deleted:false,bills:1});
  assert.equal((await runtime().invoke()).status,200);
  assert.equal((await state()).profile_deleted,true);
});
test('Transação desfaz as duas marcações se uma atualização falhar',async()=>{
  await db.exec(`create function test_fail_profile_update() returns trigger language plpgsql as $$ begin raise exception 'test failure';end;$$;
    create trigger test_fail before update on users for each row execute function test_fail_profile_update();`);
  try{
    assert.equal((await runtime().invoke()).status,503);
    assert.equal((await state()).meta_deleted,false);
    assert.equal((await state()).profile_deleted,false);
  }finally{await db.exec('drop trigger test_fail on users;drop function test_fail_profile_update();');}
  assert.equal((await runtime().invoke()).status,200);
});
test('Repetição após exclusão completa é idempotente',async()=>{
  const rt=runtime();assert.equal((await rt.invoke()).status,200);
  assert.equal((await rt.invoke()).status,200);
});
test('Aluno anteriormente desativado pode ter Auth remanescente removido',async()=>{
  await db.query(`update users set deleted_at='2026-06-15' where id=$1`,[STUDENT]);
  assert.equal((await runtime().invoke()).status,200);
  assert.equal((await state()).auth_count,0);
});
test('Franquia diferente não pode excluir o aluno',async()=>{
  await db.query('update users set id_franquia=$1 where id=$2',[OTHER_FRANCHISE,STUDENT]);
  const rt=runtime();assert.equal((await rt.invoke()).status,403);assert.deepEqual(rt.events,[]);
});
test('Administrador sem franquia mantém permissão para excluir aluno',async()=>{
  assert.equal((await runtime({actor:ADMIN}).invoke(undefined,{origin:'https://stepoutadministrador.vercel.app'})).status,200);
});
for(const role of ['aluno','professor'])test(`${role} não pode excluir outro aluno`,async()=>{
  await db.query('update users set role=$1 where id=$2',[role,ACTOR]);
  const rt=runtime();assert.equal((await rt.invoke()).status,403);assert.deepEqual(rt.events,[]);
});
test('Responsável desativado não pode excluir contas',async()=>{
  await db.query('update users set deleted_at=now() where id=$1',[ACTOR]);
  assert.equal((await runtime().invoke()).status,403);
});
test('Alvo professor não é excluído pela ação de aluno',async()=>{
  await db.query("update users set role='professor' where id=$1",[STUDENT]);
  const rt=runtime();assert.equal((await rt.invoke()).status,403);assert.deepEqual(rt.events,[]);
});
test('Fluxo de professor existente permanece disponível com seu contrato original',async()=>{
  await db.query("update users set role='professor' where id=$1",[STUDENT]);
  assert.equal((await runtime().invoke({userId:STUDENT})).status,200);
});
test('Não permite excluir a própria conta',async()=>{
  assert.equal((await runtime().invoke({userId:ACTOR})).status,400);
});
test('Sessão inválida não executa exclusão',async()=>{
  const rt=runtime({invalidSession:true});assert.equal((await rt.invoke()).status,401);assert.deepEqual(rt.events,[]);
});
test('Origem inválida é bloqueada',async()=>{
  assert.equal((await runtime().invoke(undefined,{origin:'https://other.invalid'})).status,403);
});
test('ID inválido é bloqueado antes de consultar ou excluir',async()=>{
  const rt=runtime();assert.equal((await rt.invoke({userId:'invalid'})).status,400);assert.deepEqual(rt.events,[]);
});
test('SQL recusa finalizar enquanto a autenticação ainda existir',async()=>{
  await assert.rejects(db.query('select finalize_student_deletion($1,$2)',[ACTOR,STUDENT]),/authentication must be deleted first/);
  assert.equal((await state()).profile_deleted,false);
});
test('Clientes não podem chamar a finalização administrativa diretamente',async()=>{
  await db.exec('set role authenticated');
  try{await assert.rejects(db.query('select finalize_student_deletion($1,$2)',[ACTOR,STUDENT]),/permission denied/);}
  finally{await db.exec('reset role');}
});
