const {test,before,beforeEach,after}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const path=require('node:path');
const {PGlite}=require('@electric-sql/pglite');
const id=n=>`00000000-0000-0000-0000-${String(n).padStart(12,'0')}`;
let db;
before(async()=>{
  db=new PGlite();
  await db.exec(`create role anon;create role authenticated;create role service_role;
    create schema auth;
    create function auth.uid() returns uuid language sql as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
    create table users(id uuid primary key,role text,id_franquia uuid,deleted_at timestamptz);
    create table turmas(id uuid primary key,id_franquia uuid,professor_responsavel uuid,deleted_at timestamptz);
    create table aluno_turmas(user_id uuid,turma_id uuid,created_at timestamptz default now(),primary key(user_id,turma_id));
    create table meta_alunos(user_id uuid,turma uuid);
    create table "Aulas"(id uuid primary key,turma uuid,franquia uuid,professor_responsavel uuid,
      datetimeinicio_aula timestamptz,alunos_convidados uuid[],alunos_presentes uuid[],notes text);
  `);
  for(const file of ['20261020190000_teacher_change_scopes.sql','20261020210000_preserve_class_invitations.sql']){
    await db.exec(fs.readFileSync(path.join(__dirname,'../migrations',file),'utf8'));
  }
});
beforeEach(async()=>{
  await db.exec('truncate users,turmas,aluno_turmas,meta_alunos,"Aulas";');
  await db.query(`select set_config('request.jwt.claim.sub',$1,false)`,[id(1)]);
  await db.query(`insert into users values($1,'franquia',$5,null),($2,'professor',$5,null),
    ($3,'professor',$5,null),($4,'aluno',$5,null),($6,'professor',$7,null)`,[id(1),id(2),id(3),id(4),id(10),id(8),id(11)]);
  await db.query('insert into turmas values($1,$3,$4,null),($2,$3,$4,null)',[id(20),id(21),id(10),id(2)]);
  await db.query('insert into aluno_turmas(user_id,turma_id) values($1,$2),($1,$3),($4,$2)',[id(4),id(20),id(21),id(5)]);
  // The single-class legacy metadata deliberately points to the other class.
  await db.query('insert into meta_alunos values($1,$2)',[id(4),id(21)]);
  await db.query(`insert into "Aulas" values
    ($1,$4,$6,$7,now()+interval '1 day',array[$8]::uuid[],array[$9]::uuid[],'planning'),
    ($2,$4,$6,$7,now()+interval '2 days',null,null,'next'),
    ($3,$5,$6,$7,now()+interval '3 days',null,null,'other'),
    ($10,$4,$6,$7,now()-interval '1 day',array[$9]::uuid[],array[$9]::uuid[],'history')`,
    [id(30),id(31),id(32),id(20),id(21),id(10),id(2),id(6),id(4),id(33)]);
});
after(async()=>db.close());
async function state(){return (await db.query(`select jsonb_build_object('lessons',(select jsonb_agg(a order by id) from "Aulas" a),
 'classes',(select jsonb_agg(t order by id) from turmas t),'members',(select jsonb_agg(m order by turma_id,user_id) from aluno_turmas m),
 'metadata',(select jsonb_agg(m) from meta_alunos m)) s`)).rows[0].s;}
async function change(scope,target,teacher=id(3)){
  return (await db.query(`select alterar_professor_${scope}($1,$2) result`,[target,teacher])).rows[0].result;
}
function omitTeacher(s){return {...s,lessons:s.lessons.map(({professor_responsavel,...a})=>a),classes:s.classes.map(({professor_responsavel,...t})=>t)};}
test('Calendar changes one teacher only, preserving students, attendance, dates and planning',async()=>{
  const old=await state();assert.equal((await change('aula',id(30))).scope,'aula');const next=await state();
  assert.deepEqual(omitTeacher(next),omitTeacher(old));
  assert.equal(next.lessons.find(a=>a.id===id(30)).professor_responsavel,id(3));
  assert.equal(next.lessons.find(a=>a.id===id(31)).professor_responsavel,id(2));
  assert.equal(next.classes[0].professor_responsavel,id(2));
});
test('Class change updates all its lessons and default, preserving full roster and other class',async()=>{
  const old=await state();assert.equal((await change('turma',id(20))).aulasAtualizadas,3);const next=await state();
  assert.deepEqual(omitTeacher(next),omitTeacher(old));
  assert(next.lessons.filter(a=>a.turma===id(20)).every(a=>a.professor_responsavel===id(3)));
  assert.equal(next.lessons.find(a=>a.id===id(32)).professor_responsavel,id(2));
});
test('Legacy planning overwrite cannot drop a student enrolled in multiple classes',async()=>{
  await change('aula',id(30));
  await db.query('update "Aulas" set alunos_convidados=array[$1]::uuid[] where id=$2',[id(5),id(31)]);
  const lesson=(await state()).lessons.find(a=>a.id===id(31));
  assert.deepEqual([...lesson.alunos_convidados].sort(),[id(4),id(5)].sort());
});
test('Reproduces the old disappearance and repairs upcoming lessons without re-enrolment',async()=>{
  const old=await state();
  await db.exec('alter table "Aulas" disable trigger preserve_class_lesson_invitations;');
  await db.query('update "Aulas" set alunos_convidados=array[$1]::uuid[] where id=$2',[id(5),id(31)]);
  assert(!(await state()).lessons.find(a=>a.id===id(31)).alunos_convidados.includes(id(4)));
  await db.exec('alter table "Aulas" enable trigger preserve_class_lesson_invitations;');
  await db.exec('update "Aulas" set alunos_convidados=alunos_convidados where datetimeinicio_aula>=now();');
  const repaired=await state();assert.deepEqual(repaired.members,old.members);
  assert.deepEqual(repaired.metadata,old.metadata);
  assert.deepEqual(repaired.lessons.find(a=>a.id===id(31)).alunos_convidados.sort(),[id(4),id(5)]);
  assert.deepEqual(repaired.lessons.find(a=>a.id===id(33)),old.lessons.find(a=>a.id===id(33)));
});
test('New lessons receive canonical students even when client sends no invitations',async()=>{
  assert.deepEqual((await state()).lessons.find(a=>a.id===id(31)).alunos_convidados.sort(),[id(4),id(5)]);
});
test('Extra guests remain invited and attendance is untouched',async()=>{
  const lesson=(await state()).lessons.find(a=>a.id===id(30));
  assert(lesson.alunos_convidados.includes(id(6)));assert.deepEqual(lesson.alunos_presentes,[id(4)]);
});
test('Explicit unenrolment still removes invitation after deleting membership',async()=>{
  await db.query('delete from aluno_turmas where user_id=$1 and turma_id=$2',[id(4),id(20)]);
  await db.query('update "Aulas" set alunos_convidados=array_remove(alunos_convidados,$1) where turma=$2',[id(4),id(20)]);
  assert(!(await state()).lessons.find(a=>a.id===id(30)).alunos_convidados.includes(id(4)));
  assert((await state()).members.some(m=>m.user_id===id(4)&&m.turma_id===id(21)));
});
test('Past invitations are not reconstructed when changing teacher',async()=>{
  await change('aula',id(33));assert.deepEqual((await state()).lessons.find(a=>a.id===id(33)).alunos_convidados,[id(4)]);
});
for(const scope of ['aula','turma']){
  const target=scope==='aula'?id(30):id(20);
  test(`${scope}: teacher from another franchise is rejected atomically`,async()=>{
    const old=await state();await assert.rejects(change(scope,target,id(8)));assert.deepEqual(await state(),old);
  });
  test(`${scope}: student cannot change teacher`,async()=>{
    await db.query(`select set_config('request.jwt.claim.sub',$1,false)`,[id(4)]);
    await assert.rejects(change(scope,target),/not authorized/);
  });
  test(`${scope}: missing target cannot broaden update`,async()=>{
    const old=await state();await assert.rejects(change(scope,null));assert.deepEqual(await state(),old);
  });
  test(`${scope}: another franchise owner cannot change teacher`,async()=>{
    await db.query('update users set id_franquia=$1 where id=$2',[id(11),id(1)]);
    await assert.rejects(change(scope,target),/another franchise/);
  });
}
