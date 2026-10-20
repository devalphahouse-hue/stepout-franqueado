begin;

-- Older teacher apps overwrite the next lesson with meta_alunos.turma,
-- which represents only one class per student. Keep every enrolled student
-- from aluno_turmas, including students enrolled in multiple classes.
create or replace function public.preserve_class_lesson_invitations()
returns trigger language plpgsql security definer
set search_path = public, pg_temp as $$
declare
  student_id uuid;
begin
  -- Completed/past lesson invitations and attendance remain historical.
  if new.turma is null or new.datetimeinicio_aula < now() then
    return new;
  end if;
  for student_id in
    select user_id from public.aluno_turmas
    where turma_id=new.turma order by created_at,user_id
  loop
    if not (student_id = any(coalesce(new.alunos_convidados,array[]::uuid[]))) then
      new.alunos_convidados := array_append(coalesce(new.alunos_convidados,array[]::uuid[]),student_id);
    end if;
  end loop;
  return new;
end;
$$;

revoke all on function public.preserve_class_lesson_invitations() from public,anon,authenticated;
create trigger preserve_class_lesson_invitations
before insert or update of alunos_convidados,professor_responsavel on public."Aulas"
for each row execute function public.preserve_class_lesson_invitations();

-- Repair missing invitations in upcoming lessons without removing guests,
-- changing enrolments, attendance, teachers or past lessons.
update public."Aulas" a set alunos_convidados=coalesce(a.alunos_convidados,array[]::uuid[])
where a.datetimeinicio_aula >= now()
  and exists(select 1 from public.turmas t where t.id=a.turma and t.deleted_at is null)
  and exists(select 1 from public.aluno_turmas m where m.turma_id=a.turma
    and not(m.user_id=any(coalesce(a.alunos_convidados,array[]::uuid[]))));

commit;
