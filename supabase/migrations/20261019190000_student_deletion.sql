begin;

-- Authentication is removed through the Admin API before this transaction.
-- Keep student and financial history; finalize both soft-delete markers
-- atomically so a retry never reports success after only one table changed.
create or replace function public.finalize_student_deletion(
  p_actor uuid, p_target uuid
) returns jsonb language plpgsql security definer
set search_path = public, pg_temp as $$
declare
  actor public.users%rowtype;
  student public.users%rowtype;
  removed_at timestamptz;
begin
  select * into actor from public.users where id=p_actor;
  if not found or actor.deleted_at is not null or actor.role is null or
     actor.role::text not in ('franquia','admin') or p_actor=p_target then
    raise exception 'student deletion not authorized' using errcode='42501';
  end if;
  select * into student from public.users where id=p_target for update;
  if not found or student.role::text is distinct from 'aluno' then
    raise exception 'student not found' using errcode='22023';
  end if;
  if actor.role::text <> 'admin' and
     (actor.id_franquia is null or student.id_franquia is distinct from actor.id_franquia) then
    raise exception 'student belongs to another franchise' using errcode='42501';
  end if;
  if exists(select 1 from auth.users where id=p_target) then
    raise exception 'authentication must be deleted first' using errcode='55000';
  end if;
  removed_at := coalesce(student.deleted_at,now());
  update public.meta_alunos set deleted_at=coalesce(deleted_at,removed_at)
    where user_id=p_target;
  update public.users set deleted_at=removed_at where id=p_target;
  return jsonb_build_object('success',true,'authDeleted',true);
end;
$$;
revoke all on function public.finalize_student_deletion(uuid,uuid) from public,anon,authenticated;
grant execute on function public.finalize_student_deletion(uuid,uuid) to service_role;

commit;
