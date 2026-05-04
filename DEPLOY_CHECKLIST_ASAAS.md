# Checklist de deploy — migração Asaas (stepout-franqueado)

Documento de ação para Renan. As mudanças de **código e Edge Functions** já estão prontas. Falta executar os passos abaixo, na ordem indicada.

> ⚠️ Em produção hoje, o franqueado **continua funcionando exatamente como antes** — chamando Firebase Cloud Function antiga (`ffprivateapicallfranqueadov2`). Os passos aqui é que ativam a nova arquitetura.
>
> **Pré-requisito:** o passo 1 (webhook do Asaas) já foi feito durante o deploy do aluno e **vale para os dois apps** — o webhook não distingue origem da cobrança. Se você ainda não fez o webhook (deploy aluno), faz primeiro.

---

## Estado do código (referência)

| Item | Status |
|---|---|
| `supabase/functions/asaas-proxy/index.ts` agora suporta franqueado (origin allowlist + handler `CriarSubcontaFranquiaCall`) | ✅ deployada |
| `supabase/functions/asaas-webhook/index.ts` (mesma do aluno — atende os dois apps) | ✅ deployada |
| `lib/backend/cloud_functions/cloud_functions.dart` (chama Supabase em vez de Firebase) | ✅ no disco, falta deploy |
| `lib/backend/api_requests/api_calls.dart` (parâmetro `idcobranca` adicionado nas 4 classes de cobrança) | ✅ no disco, falta deploy |
| `lib/pages/gerais/checkout/checkout_widget.dart` (passa `idCobranca` nos 2 calls de cartão) | ✅ no disco, falta deploy |
| `pubspec.yaml` Firebase deps removidas (10 packages) | ✅ no disco, falta deploy |
| `android/app/build.gradle` plugin GMS comentado (preventivo) | ✅ no disco, falta deploy |
| Secrets no Supabase (`ASAAS_ACCESS_TOKEN`, `ASAAS_BASE_URL`, `ASAAS_WEBHOOK_TOKEN`) | ✅ todos setados (mesmos do aluno) |

---

## Passo 1 — Confirmar que o webhook do Asaas já está configurado

> Esse passo só vale a primeira vez. Se você fez o deploy do aluno seguindo o `stepout-aluno/DEPLOY_CHECKLIST_ASAAS.md`, **pular pra Passo 2**.

Se ainda não fez:

1. Acessar **Asaas Sandbox Dashboard**: https://sandbox.asaas.com/
2. Configurações → Integrações → Webhooks → Adicionar webhook
3. URL: `https://qmfitknztvxvzpgjyvxf.supabase.co/functions/v1/asaas-webhook`
4. Token de autenticação: `d660e7c4ddc5db903b8fc5dd51a133c101e6479684f7e6112b0743e95e0a9c29`
5. Marcar todos os eventos `PAYMENT_*`
6. Salvar.

---

## Passo 2 — Subir o app franqueado no Vercel

1. Verificar:
   ```bash
   cd stepout-franqueado
   git status
   git diff --stat
   ```

2. Esperado em `git diff --stat`:
   - `lib/backend/cloud_functions/cloud_functions.dart` (~15 linhas)
   - `lib/backend/api_requests/api_calls.dart` (~5 linhas — 4 classes × 1 linha cada + 4 vars)
   - `lib/pages/gerais/checkout/checkout_widget.dart` (~2 linhas)
   - `lib/main.dart` (-2 linhas)
   - `pubspec.yaml` (-9 deps)
   - `pubspec.lock` (atualizado)
   - `android/app/build.gradle` (1 linha alterada — plugin GMS comentado)
   - `lib/backend/firebase/firebase_config.dart` (deletado)

3. Commit + push:
   ```bash
   git add lib/backend/cloud_functions lib/backend/api_requests \
           lib/pages/gerais/checkout lib/main.dart \
           pubspec.yaml pubspec.lock \
           android/app/build.gradle
   git rm lib/backend/firebase/firebase_config.dart
   git commit -m "Migrar Asaas de Firebase Cloud Function para Supabase Edge Function (franqueado)

   - cloud_functions.dart agora chama supabase.functions.invoke('asaas-proxy')
   - 4 classes de cobrança recebem idcobranca para validação server-side
   - Removidas 10 deps Firebase (cloud_functions, firebase_core, firebase_performance)
   - Plugin Gradle GMS comentado (preventivo — app web-only)
   - main.dart sem initFirebase (Performance Monitoring desativado)"
   git push
   ```

4. Vercel detecta e deploy automaticamente. Acompanhe em https://vercel.com/<seu-time>/stepout-franqueado/deployments.

5. Quando ficar verde, confirmar visitando https://franqueado.stepout.com.br.

---

## Passo 3 — Validação em produção (15 min)

> Use uma conta de franqueado **sua, de teste**. Não use a de um franqueado real.

1. Acessar https://franqueado.stepout.com.br, logar.
2. Testar fluxo de **criação de uma cobrança / contratação** (depende do fluxo que você usa pra testar; pode ser cadastro de franquia ou criação de cobrança via "Detalhes do Aluno").
3. Confirmar:
   - ✅ A cobrança foi criada no Asaas Sandbox
   - ✅ Apareceu registro na tabela `cobrancas` no Supabase
4. Pagar a cobrança via simulador do Asaas Sandbox.
5. Confirmar que `cobrancas.status_cobranca` virou `"CONFIRMED"` (escrito pelo webhook).
6. Conferir logs do webhook em https://supabase.com/dashboard/project/qmfitknztvxvzpgjyvxf/functions/asaas-webhook/logs (procurar `WEBHOOK_PROCESSED` com `rowsUpdated: 1`).

**Se algo der errado:** abra https://supabase.com/dashboard/project/qmfitknztvxvzpgjyvxf/functions/asaas-proxy/logs e me mostre as últimas linhas. Não corrija sozinho — me chame.

---

## Passo 4 — (Conjunto com o aluno) Desativar Firebase Cloud Function antiga

Depois que **aluno e franqueado** estiverem 1 semana cada em prod sem incidentes:

1. Firebase Console: https://console.firebase.google.com/project/stepout-franqueado-3zcule/functions
2. Deletar **`ffprivateapicallalunov2`** (do aluno) e **`ffprivateapicallfranqueadov2`** (do franqueado)
3. Não apagar outras funções

> Cuidado: o `stepout-professor` pode ainda estar usando alguma função do mesmo projeto Firebase. Se sim, isolar o que apagar.

---

## Passo 5 — Pós-cleanup adicional (opcional, baixa prioridade)

- Apagar `stepout-franqueado/firebase/` (código antigo da Cloud Function — só referência histórica).
- Apagar `stepout-franqueado/android/app/google-services.json` (sem efeito, mas ocupa espaço no repo).
- Comentar `pod 'FirebaseFirestore'` em `stepout-franqueado/ios/Podfile` (leftover inofensivo).

---

## Como reverter se algo der errado

```bash
cd stepout-franqueado
git revert HEAD     # Vercel re-deploya
git push
```

A Edge Function `asaas-proxy` continua deployada no Supabase mas fica inerte para o franqueado se o app antigo (chamando Firebase) voltar.

---

## Tokens e URLs importantes (compartilhados com o aluno)

| Item | Valor |
|---|---|
| Supabase project ref | `qmfitknztvxvzpgjyvxf` |
| Edge Function asaas-proxy | `https://qmfitknztvxvzpgjyvxf.supabase.co/functions/v1/asaas-proxy` |
| Edge Function asaas-webhook | `https://qmfitknztvxvzpgjyvxf.supabase.co/functions/v1/asaas-webhook` |
| ASAAS_WEBHOOK_TOKEN | `d660e7c4ddc5db903b8fc5dd51a133c101e6479684f7e6112b0743e95e0a9c29` |
| Domínio prod franqueado | `https://franqueado.stepout.com.br` |

---

## ⚠️ Item separado (não é desta migração) — INSERT em `cobrancas` sem validação

3 lugares no franqueado fazem `INSERT` direto em `cobrancas` via Supabase REST, aceitando `user_id` arbitrário:
- `lib/pages/aluno/detalhes_aluno/detalhes_aluno_widget.dart:4584` e `:5249`
- `lib/pages/gerais/cadastro_franquia/cadastro_franquia_widget.dart:294`

**Resolução:** RLS na tabela `cobrancas`. Não pode ser feito sem alteração de policies (banco em produção). Próxima sessão dedicada.

---

## Checklist resumido

- [ ] **Passo 1** — Webhook do Asaas configurado (provavelmente já feito no deploy do aluno)
- [ ] **Passo 2** — Commit + push para Vercel; deploy verde
- [ ] **Passo 3** — Cobrança de teste do franqueado, pagamento, status atualizado via webhook
- [ ] **Passo 4** — (após 1 semana de aluno + 1 semana de franqueado em prod) — desativar Firebase Cloud Functions antigas
- [ ] **Passo 5** — Cleanup adicional opcional (firebase/, google-services.json, Podfile)

**Quando estiver tudo verde:** a migração Asaas está 100% finalizada nos dois apps. Próxima fronteira é a **RLS** na tabela `cobrancas` (e no resto do banco) para fechar de vez o vetor de `user_id` arbitrário.
