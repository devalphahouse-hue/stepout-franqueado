# Correções do pagamento

Fontes das funções `asaas-proxy` e `asaas-webhook`. Em 06/10/2026, a migração `20261006150000_payment_safety` foi aplicada e registrada no projeto `qmfitknztvxvzpgjyvxf`. As versões finais publicadas conjuntamente são `asaas-proxy` v14 e `asaas-webhook` v8, preservando suas configurações de JWT e a indicação/split dos clientes antigos.

As telas corrigidas estão incluídas nesta revisão. Confirmar a publicação dos aplicativos antes do teste com o cliente. Nenhuma cobrança real foi realizada nesta validação; o teste completo com o provedor continua pendente.

## Regras preservadas

- Demo da franquia: R$ 10, 6 × R$ 5 e 12 × R$ 5.
- Preços reais: R$ 20.000, R$ 25.000 e R$ 30.000. O total de R$ 25.000 é enviado sem arredondar para R$ 25.002.
- Splits existentes e validade de alunos permanecem como construídos.
- O modo demo reduz valores, mas não seleciona sandbox. Conferir o ambiente antes da validação do cliente.

## Validação local

Em `supabase/tests/`, executar `npm install` e `npm test`. A suíte executa a migração em PostgreSQL isolado e testa as funções reais com respostas Asaas simuladas. Não efetua cobranças nem comprova o funcionamento real do provedor.

Passaram 42 testes de servidor, 11 de retomada de planos e 5 da tela demo em cópia isolada. As duas aplicações web compilaram. Foram conferidos no projeto remoto o histórico da migração, as funções ativas, as permissões privadas e o bloqueio de acessos sem autorização. Os totais de usuários, franquias e cobranças permaneceram iguais após a publicação.

## Publicação coordenada

1. Migração aplicada em transação e registrada no histórico; cópias dos campos anteriores e das funções foram salvas localmente em `.payment-audit/deployment/` (não versionar).
2. Funções publicadas conjuntamente. Em futuras atualizações, manter proxy com JWT e webhook sem JWT, protegido pelo token próprio.
3. Preservar segredos existentes: `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `SUPABASE_ANON_KEY`, `ASAAS_ACCESS_TOKEN`, `ASAAS_BASE_URL` e `ASAAS_WEBHOOK_TOKEN`.
4. Publicar os aplicativos do franqueado e aluno compatíveis e atualizar as sessões antigas antes de testar.
5. Validar uma cobrança demo com conta de teste autorizada, confirmação/webhook e retomada após recarregar; conferir que existe somente um pagamento.

Não apagar reservas `processing` nem repetir cobranças após timeout. Primeiro reconciliar o pagamento pelo `externalReference` da cobrança no Asaas. Liberar a reserva sem conferir o resultado pode duplicar débito.

Perfis e chaves de subcontas ficam em tabelas exclusivas do serviço. Cadastros antigos reutilizam dados existentes; informações ausentes devem ser corrigidas, nunca inventadas.
