# Teacher changes and lesson invitations

`alterar_professor_aula` changes the teacher of one lesson. It leaves the class default and other lessons unchanged.

`alterar_professor_turma` changes the class default and all existing lessons of that class atomically. Both functions validate the authenticated administrator/franchise, the class and the replacement teacher. Neither modifies enrolments or attendance.

`aluno_turmas` is the canonical enrolment list. `meta_alunos.turma` stores one legacy class and cannot represent students enrolled in multiple classes. Older planning clients used it to overwrite invitations after creating a lesson, excluding some enrolled students. The invitation trigger appends missing enrolled students on upcoming lesson creation, invitation writes and teacher changes. Extra guests remain invited. Past invitations are preserved. Explicit unenrolment continues to work because its RPC deletes the membership before removing invitations.

Apply both 20261020 migrations before releasing dependent franchise screens. The invitation migration also repairs upcoming lessons with missing enrolled students; it does not modify membership, attendance, teacher or schedule. Its protection also covers older installed clients without a student app release.

Run `npm test` in `supabase/tests`. Teacher regression tests cover separate scopes, legacy planning overwrites, multiple enrolments, repair without re-enrolment, guests, past lessons, explicit removal and authorization failures. Tests use isolated PostgreSQL, not customer data. Historical invitations may have already been repaired by re-enrolment, so their current state does not prove the exact original incident sequence.
