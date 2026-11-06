CREATE OR REPLACE FUNCTION public.cria_aula(p_turma_id uuid)
 RETURNS SETOF "Aulas"
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
    /* Dados da turma */
    v_modulo_nivel   text;
    v_professor      uuid;
    v_franquia       uuid;
    v_data_inicio    date;
    v_agenda         jsonb[];

    /* Variáveis de data/hora da aula */
    v_next_date      date;
    v_horario_inicio time;
    v_horario_fim    time;
    v_dia_int        int;
    v_found          boolean := false;
    rec              jsonb;      -- registro da agenda
    i                int;
    v_aula_id        uuid;       -- id da aula inserida
    v_convidados     uuid[];     -- roster atual da turma (aluno_turmas)
BEGIN
    ------------------------------------------------------------------
    -- 1️⃣  Busca os dados da turma
    ------------------------------------------------------------------
    SELECT
        modulo_nivel_turma,
        professor_responsavel,
        id_franquia,
        data_inicio,
        agenda_aulas
    INTO
        v_modulo_nivel,
        v_professor,
        v_franquia,
        v_data_inicio,
        v_agenda
    FROM public.turmas
    WHERE id = p_turma_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Turma % não encontrada', p_turma_id;
    END IF;

    ------------------------------------------------------------------
    -- 2️⃣  Procura a primeira combinação (data + horário) que coincida
    --     com a agenda da turma (até 7 dias depois da data de início)
    ------------------------------------------------------------------
    FOR i IN 1..7 LOOP
        v_next_date := v_data_inicio + i;                     -- próximo dia
        v_dia_int   := EXTRACT(DOW FROM v_next_date)::int;   -- 0 = domingo

        FOREACH rec IN ARRAY v_agenda LOOP
            IF (
                CASE rec->>'dia'
                    WHEN 'Domingo' THEN 0
                    WHEN 'Segunda' THEN 1
                    WHEN 'Terça'   THEN 2
                    WHEN 'Quarta'  THEN 3
                    WHEN 'Quinta'  THEN 4
                    WHEN 'Sexta'   THEN 5
                    WHEN 'Sábado'  THEN 6
                    ELSE -1
                END
            ) = v_dia_int THEN

                v_horario_inicio := (rec->>'horarioInicio')::time;
                v_horario_fim    := (rec->>'horarioFinal')::time;
                v_found := true;
                EXIT;                 -- sai do FOREACH
            END IF;
        END LOOP;

        IF v_found THEN
            EXIT;                     -- sai do FOR i
        END IF;
    END LOOP;

    IF NOT v_found THEN
        RAISE EXCEPTION 'Agenda não contém dia compatível para a turma %', p_turma_id;
    END IF;

    ------------------------------------------------------------------
    -- 3️⃣  Roster atual da turma (fonte canônica: aluno_turmas)
    ------------------------------------------------------------------
    SELECT COALESCE(array_agg(user_id ORDER BY created_at), ARRAY[]::uuid[])
    INTO v_convidados
    FROM public.aluno_turmas
    WHERE turma_id = p_turma_id;

    ------------------------------------------------------------------
    -- 4️⃣  Insere a aula (fuso "America/Sao_Paulo") e captura o id gerado
    ------------------------------------------------------------------
    -- Serialize generation for the same class across both scheduling RPCs.
    PERFORM pg_catalog.pg_advisory_xact_lock(
        pg_catalog.hashtextextended('stepout:scheduled-lesson:' || p_turma_id::text, 0)
    );

    SELECT a.id INTO v_aula_id
    FROM public."Aulas" a
    WHERE a.turma = p_turma_id
      AND a.datetimeinicio_aula = ((v_next_date + v_horario_inicio) AT TIME ZONE 'America/Sao_Paulo')
    ORDER BY a.created_at ASC NULLS LAST, a.id
    LIMIT 1;

    IF FOUND THEN
        RETURN QUERY SELECT a.* FROM public."Aulas" a WHERE a.id = v_aula_id;
        RETURN;
    END IF;

    INSERT INTO public."Aulas" (
        nivel_inicio,
        status_aula,
        professor_responsavel,
        turma,
        franquia,
        datetimeinicio_aula,
        datetime_terminoaula,
        alunos_convidados
    )
    VALUES (
        v_modulo_nivel,
        'Aguardando Planning',
        v_professor,
        p_turma_id,
        v_franquia,
        (v_next_date + v_horario_inicio) AT TIME ZONE 'America/Sao_Paulo',
        (v_next_date + v_horario_fim)    AT TIME ZONE 'America/Sao_Paulo',
        v_convidados
    )
    RETURNING id INTO v_aula_id;

    ------------------------------------------------------------------
    -- 5️⃣  Devolve o registro completo da aula recém-criada
    ------------------------------------------------------------------
    RETURN QUERY
    SELECT a.*
    FROM public."Aulas" a
    WHERE a.id = v_aula_id;
END;$function$;

CREATE OR REPLACE FUNCTION public.cria_aula_com_data(turma_uuid uuid, data_str text)
 RETURNS SETOF "Aulas"
 LANGUAGE plpgsql
AS $function$DECLARE
    /* Dados da turma */
    v_modulo_nivel   text;
    v_professor      uuid;
    v_franquia       uuid;
    v_agenda         jsonb[];

    /* Âncora em horário local (America/Sao_Paulo) */
    v_anchor_local       timestamp;

    /* Candidatos */
    v_candidate_date     date;
    v_dow                int;

    /* Melhor slot encontrado */
    v_best_start_local   timestamp;
    v_best_end_local     timestamp;
    v_best_found         boolean := false;

    /* Iteradores */
    rec                  jsonb;
    i                    int;

    /* Auxiliares agenda */
    t_ini                time;
    t_fim                time;
    start_local          timestamp;
    end_local            timestamp;

    /* Aula criada */
    v_aula_id            uuid;

    /* Roster atual da turma (aluno_turmas) */
    v_convidados         uuid[];
BEGIN
    ------------------------------------------------------------------
    -- 1) Converte a data_str (ISO) para horário local (America/Sao_Paulo)
    ------------------------------------------------------------------
    v_anchor_local := (data_str::timestamptz AT TIME ZONE 'America/Sao_Paulo');

    ------------------------------------------------------------------
    -- 2) Busca dados da turma
    ------------------------------------------------------------------
    SELECT
        modulo_nivel_turma,
        professor_responsavel,
        id_franquia,
        agenda_aulas
    INTO
        v_modulo_nivel,
        v_professor,
        v_franquia,
        v_agenda
    FROM public.turmas
    WHERE id = turma_uuid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Turma % não encontrada', turma_uuid;
    END IF;

    ------------------------------------------------------------------
    -- 3) Procura o PRÓXIMO slot da agenda
    --    Sempre começa a partir do dia seguinte (i = 1)
    ------------------------------------------------------------------
    FOR i IN 1..28 LOOP
        v_candidate_date := (v_anchor_local::date) + i;
        v_dow            := EXTRACT(DOW FROM v_candidate_date)::int;

        v_best_start_local := NULL;
        v_best_end_local   := NULL;

        FOREACH rec IN ARRAY v_agenda LOOP
            IF (
                CASE rec->>'dia'
                    WHEN 'Domingo' THEN 0
                    WHEN 'Segunda' THEN 1
                    WHEN 'Terça'   THEN 2
                    WHEN 'Quarta'  THEN 3
                    WHEN 'Quinta'  THEN 4
                    WHEN 'Sexta'   THEN 5
                    WHEN 'Sábado'  THEN 6
                    ELSE -1
                END
            ) = v_dow THEN
                t_ini := (rec->>'horarioInicio')::time;
                t_fim := (rec->>'horarioFinal')::time;

                start_local := v_candidate_date + t_ini;
                end_local   := v_candidate_date + t_fim;

                IF v_best_start_local IS NULL OR start_local < v_best_start_local THEN
                    v_best_start_local := start_local;
                    v_best_end_local   := end_local;
                END IF;
            END IF;
        END LOOP;

        IF v_best_start_local IS NOT NULL THEN
            v_best_found := true;
            EXIT;
        END IF;
    END LOOP;

    IF NOT v_best_found THEN
        RAISE EXCEPTION 'Não há horário na agenda após % (America/Sao_Paulo) para a turma %',
            v_anchor_local, turma_uuid;
    END IF;

    ------------------------------------------------------------------
    -- 4) Roster atual da turma (fonte canônica: aluno_turmas)
    ------------------------------------------------------------------
    SELECT COALESCE(array_agg(user_id ORDER BY created_at), ARRAY[]::uuid[])
    INTO v_convidados
    FROM public.aluno_turmas
    WHERE turma_id = turma_uuid;

    ------------------------------------------------------------------
    -- 5) Insere a aula no banco
    ------------------------------------------------------------------
    -- Serialize generation for the same class across both scheduling RPCs.
    PERFORM pg_catalog.pg_advisory_xact_lock(
        pg_catalog.hashtextextended('stepout:scheduled-lesson:' || turma_uuid::text, 0)
    );

    SELECT a.id INTO v_aula_id
    FROM public."Aulas" a
    WHERE a.turma = turma_uuid
      AND a.datetimeinicio_aula = (v_best_start_local AT TIME ZONE 'America/Sao_Paulo')
    ORDER BY a.created_at ASC NULLS LAST, a.id
    LIMIT 1;

    IF FOUND THEN
        RETURN QUERY SELECT a.* FROM public."Aulas" a WHERE a.id = v_aula_id;
        RETURN;
    END IF;

    INSERT INTO public."Aulas" (
        nivel_inicio,
        status_aula,
        professor_responsavel,
        turma,
        franquia,
        datetimeinicio_aula,
        datetime_terminoaula,
        alunos_convidados
    )
    VALUES (
        v_modulo_nivel,
        'Aguardando Planning',
        v_professor,
        turma_uuid,
        v_franquia,
        (v_best_start_local AT TIME ZONE 'America/Sao_Paulo'),
        (v_best_end_local   AT TIME ZONE 'America/Sao_Paulo'),
        v_convidados
    )
    RETURNING id INTO v_aula_id;

    ------------------------------------------------------------------
    -- 6) Retorna a aula criada
    ------------------------------------------------------------------
    RETURN QUERY
    SELECT a.* FROM public."Aulas" a WHERE a.id = v_aula_id;
END;$function$;
