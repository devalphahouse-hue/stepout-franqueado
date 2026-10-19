# Exclusão de contas

`delete-user` atende a exclusão de alunos no franqueado e no administrador, preservando o contrato existente de exclusão de professores.

Para alunos, a função valida a sessão e a permissão, remove o login pela Auth Admin API e chama `finalize_student_deletion`. Essa transação marca `users.deleted_at` e `meta_alunos.deleted_at` juntas. Histórico e cobranças permanecem preservados; o e-mail fica disponível para novo cadastro.

A franquia só exclui alunos da própria unidade. O administrador mantém a exclusão de alunos de qualquer unidade. Clientes não podem chamar a transação de finalização diretamente.

Se Auth falhar, o cadastro não é desativado. Se Auth for removido e a transação falhar, a tela informa falha e permite repetir a operação. Uma autenticação já ausente é aceita na retomada.

Aplicar `20261019190000_student_deletion.sql` antes de publicar a função, mantendo `verify_jwt = true`. Depois, publicar as telas que enviam `{userId, expectedRole: "aluno"}` e só confirmam a exclusão quando `success` e `authDeleted` são verdadeiros.

Testes: `npm test` em `supabase/tests/`. A suíte usa PostgreSQL isolado e autenticação simulada, sem excluir usuários reais.
