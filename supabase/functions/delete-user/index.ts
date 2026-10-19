import { createClient } from "https://esm.sh/@supabase/supabase-js@2.108.2";
// ============================================================================
// delete-user — exclusão de aluno ou professor, autorizada no servidor.
// Aluno: remove Auth primeiro e desativa cadastro/metadados em transação,
// preservando o histórico. Professor: mantém o fluxo definitivo existente.
// ----------------------------------------------------------------------------
// Usado nas telas de aluno da franquia/admin e de professor da franquia.
// Diferente do soft-delete antigo (que só setava `deleted_at`), esta função:
//   1. desvincula turmas/aulas (professor_responsavel = null) — preserva
//      matrículas de alunos e histórico de aulas;
//   2. apaga os chats em que o professor participa + suas mensagens;
//   3. apaga as linhas próprias do professor (meta_user_franquia, meta_professor, users);
//   4. apaga o login em auth.users (via service_role — impossível pelo client).
//
// Segurança: exige sessão e responsável ativo. A franquia só exclui alunos
// da própria unidade; o admin conserva seu alcance global para alunos.
// A exclusão de professor mantém o vínculo obrigatório com a mesma franquia.
// ============================================================================
const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
const SUPABASE_ANON = Deno.env.get("SUPABASE_ANON_KEY");
const SUPABASE_SERVICE_ROLE = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
const ALLOW_LOCALHOST = Deno.env.get("ALLOW_LOCALHOST") === "true";
// Origens verificadas dos aplicativos que usam esta função.
const ALLOWED_ORIGINS = new Set([
  "https://franqueado.stepout.com.br",
  "https://stepout-franqueado.flutterflow.app",
  "https://stepoutadministrador.vercel.app"
]);
const LOCALHOST_RE = /^http:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/;
function isOriginAllowed(origin) {
  if (ALLOWED_ORIGINS.has(origin)) return true;
  if (ALLOW_LOCALHOST && LOCALHOST_RE.test(origin)) return true;
  return false;
}
function corsHeaders(req) {
  const origin = req.headers.get("origin") || "";
  const allowed = isOriginAllowed(origin);
  const acrh = req.headers.get("access-control-request-headers") || "authorization, content-type, x-client-info, apikey";
  const headers = {
    "Vary": "Origin",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": acrh,
    "Content-Type": "application/json"
  };
  if (allowed) {
    headers["Access-Control-Allow-Origin"] = origin;
    headers["Access-Control-Allow-Credentials"] = "true";
  }
  return headers;
}
function jsonResponse(req, data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: corsHeaders(req)
  });
}
async function requireUser(req) {
  const auth = req.headers.get("authorization") || "";
  if (!auth.toLowerCase().startsWith("bearer ")) throw new Error("no token");
  const token = auth.slice(7);
  const supabase = createClient(SUPABASE_URL, SUPABASE_ANON, {
    global: {
      headers: {
        Authorization: `Bearer ${token}`
      }
    }
  });
  const { data, error } = await supabase.auth.getUser();
  if (error || !data?.user) throw new Error("invalid session");
  return data.user;
}
function adminClient() {
  return createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE);
}
class AuthzError extends Error {
}
class DeletionError extends Error {
  constructor(message, status = 503) { super(message); this.status = status; }
}
async function deleteAuthentication(admin, targetId) {
  const { error } = await admin.auth.admin.deleteUser(targetId, false);
  // A retry after Auth succeeded but database finalization failed is safe.
  if (error && error.status !== 404 && error.code !== 'user_not_found') {
    throw new DeletionError('Não foi possível remover o acesso do aluno. Tente novamente.');
  }
}
Deno.serve(async (req)=>{
  const origin = req.headers.get("origin") || "";
  if (origin && !isOriginAllowed(origin)) {
    return new Response(JSON.stringify({
      error: "origin not allowed"
    }), {
      status: 403,
      headers: {
        "Content-Type": "application/json",
        "Vary": "Origin"
      }
    });
  }
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 204,
      headers: corsHeaders(req)
    });
  }
  if (req.method !== "POST") {
    return jsonResponse(req, {
      error: "method not allowed"
    }, 405);
  }
  try {
    const caller = await requireUser(req);
    const body = await req.json().catch(()=>({}));
    const targetId = String(body.userId || "").trim();
    if (!/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(targetId)) {
      return jsonResponse(req, {
        error: "missing userId"
      }, 400);
    }
    if (targetId === caller.id) {
      return jsonResponse(req, {
        error: "cannot delete your own account"
      }, 400);
    }
    const admin = adminClient();
    // Franquia do caller (do banco, não do body — não confiável).
    const { data: callerRow, error: callerErr } = await admin.from("users").select("id_franquia, role, deleted_at").eq("id", caller.id).maybeSingle();
    if (callerErr) throw new DeletionError('Não foi possível conferir a permissão. Tente novamente.');
    if (!callerRow || callerRow.deleted_at || !['franquia','admin'].includes(callerRow.role)) {
      throw new AuthzError("caller cannot delete accounts");
    }
    // Alvo precisa existir, ser professor, e estar na MESMA franquia do caller.
    const { data: targetRow, error: targetErr } = await admin.from("users").select("id_franquia, role").eq("id", targetId).maybeSingle();
    if (targetErr) throw new DeletionError('Não foi possível consultar o cadastro. Tente novamente.');
    if (!targetRow) {
      return jsonResponse(req, {
        error: "target not found"
      }, 404);
    }
    const targetRole = String(targetRow.role || "").toLowerCase();
    if (body.expectedRole && body.expectedRole !== targetRole) {
      throw new AuthzError('target role does not match request');
    }
    if (targetRole === 'aluno') {
      if (callerRow.role !== 'admin' &&
          (!callerRow.id_franquia || targetRow.id_franquia !== callerRow.id_franquia)) {
        throw new AuthzError('target belongs to another franquia');
      }
      await deleteAuthentication(admin, targetId);
      const finalized = await admin.rpc('finalize_student_deletion', { p_actor: caller.id, p_target: targetId });
      if (finalized.error || finalized.data?.success !== true) {
        throw new DeletionError('A exclusão não foi concluída. Tente novamente para finalizar.');
      }
      return jsonResponse(req, { success: true, authDeleted: true });
    }
    if (!targetRole.includes("professor")) {
      throw new AuthzError("target is not a professor");
    }
    if (!callerRow.id_franquia || targetRow.id_franquia !== callerRow.id_franquia) {
      throw new AuthzError("target belongs to another franquia");
    }
    // ------------------------------------------------------------------
    // Cascade (service_role ignora RLS). Ordem: filhos → pais → auth.
    // Cada passo loga, mas só o delete de auth.users é fatal (o resto é
    // best-effort: se uma linha não existe, segue).
    // ------------------------------------------------------------------
    // 1) Desvincula turmas e aulas (preserva alunos/histórico).
    await admin.from("turmas").update({
      professor_responsavel: null
    }).eq("professor_responsavel", targetId);
    await admin.from("aulas").update({
      professor_responsavel: null
    }).eq("professor_responsavel", targetId);
    // 2) Chats em que o professor participa (user1 OU user2) + mensagens.
    const { data: chats } = await admin.from("chats").select("id").or(`user1.eq.${targetId},user2.eq.${targetId}`);
    const chatIds = (chats || []).map((c)=>c.id);
    if (chatIds.length > 0) {
      await admin.from("mensagens_chats").delete().in("chat_id", chatIds);
      await admin.from("chats").delete().in("id", chatIds);
    }
    // Mensagens enviadas pelo professor em chats que sobraram (defensivo).
    await admin.from("mensagens_chats").delete().eq("sender_id", targetId);
    // 3) Linhas próprias do professor.
    await admin.from("meta_user_franquia").delete().eq("user_id", targetId);
    await admin.from("meta_professor").delete().eq("user_id", targetId);
    await admin.from("users").delete().eq("id", targetId);
    // 4) Login em auth.users — passo crítico.
    const { error: authErr } = await admin.auth.admin.deleteUser(targetId);
    if (authErr) {
      // `User not found` é tolerável (conta já sem login). Outros erros sobem.
      const msg = String(authErr.message || "").toLowerCase();
      if (!msg.includes("not found")) {
        throw new Error(`auth delete failed: ${authErr.message}`);
      }
    }
    return jsonResponse(req, {
      success: true,
      deletedChats: chatIds.length
    });
  } catch (e) {
    if (e instanceof DeletionError) return jsonResponse(req, { error: e.message }, e.status);
    if (e instanceof AuthzError) {
      return jsonResponse(req, {
        error: e.message
      }, 403);
    }
    const message = e instanceof Error ? e.message : String(e);
    return jsonResponse(req, {
      error: message
    }, 401);
  }
});
