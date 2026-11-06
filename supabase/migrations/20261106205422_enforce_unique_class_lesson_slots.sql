create index if not exists aulas_turma_inicio_idx
    on public."Aulas" (turma, datetimeinicio_aula);

create or replace function public.prevent_duplicate_class_lesson_slot()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
begin
    if new.turma is null or new.datetimeinicio_aula is null then
        return new;
    end if;

    if tg_op = 'UPDATE' then
        if (new.turma, new.datetimeinicio_aula)
            is not distinct from (old.turma, old.datetimeinicio_aula) then
            return new;
        end if;
    end if;

    -- The lookup after waiting for the lock needs a fresh snapshot.
    if pg_catalog.current_setting('transaction_isolation') not in ('read committed', 'read uncommitted') then
        raise exception using errcode = '0A000',
            message = 'Class scheduling requires read committed isolation';
    end if;

    perform pg_catalog.pg_advisory_xact_lock(
        pg_catalog.hashtextextended('stepout:scheduled-lesson:' || new.turma::text, 0)
    );

    if exists (
        select 1
        from public."Aulas" a
        where a.turma = new.turma
          and a.datetimeinicio_aula = new.datetimeinicio_aula
    ) then
        raise unique_violation using message = 'Já existe uma aula desta turma neste horário';
    end if;

    return new;
end;
$function$;

create trigger prevent_duplicate_class_lesson_slot
before insert or update of turma, datetimeinicio_aula on public."Aulas"
for each row execute function public.prevent_duplicate_class_lesson_slot();
