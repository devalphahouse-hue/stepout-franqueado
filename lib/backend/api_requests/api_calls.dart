import 'dart:convert';
import 'dart:typed_data';
import '../cloud_functions/cloud_functions.dart';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffprivateapicallfranqueadov2';

/// Start Supabase Group Code

class SupabaseGroup {
  static String getBaseUrl({
    String? token = '',
  }) =>
      'https://qmfitknztvxvzpgjyvxf.supabase.co';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
    'Authorization': 'Bearer [token]',
    'Content-Type': 'application/json',
  };
  static SignupCall signupCall = SignupCall();
  static ListaProfessoresCall listaProfessoresCall = ListaProfessoresCall();
  static ListaProfessoresFiltroCall listaProfessoresFiltroCall =
      ListaProfessoresFiltroCall();
  static ListaAlunosFiltroCall listaAlunosFiltroCall = ListaAlunosFiltroCall();
  static ListaAlunosCall listaAlunosCall = ListaAlunosCall();
  static DetalhesAulaCall detalhesAulaCall = DetalhesAulaCall();
  static ListaAlunosPorTurmaCall listaAlunosPorTurmaCall =
      ListaAlunosPorTurmaCall();
  static ListaTurmasCall listaTurmasCall = ListaTurmasCall();
  static ListaAulasDoDiaCall listaAulasDoDiaCall = ListaAulasDoDiaCall();
  static ListaChatsAbertosCall listaChatsAbertosCall = ListaChatsAbertosCall();
  static CriarAulaCall criarAulaCall = CriarAulaCall();
  static CriarAulaNoPlanningCall criarAulaNoPlanningCall =
      CriarAulaNoPlanningCall();
  static BuscarChatCall buscarChatCall = BuscarChatCall();
  static FiltroCobrancaCall filtroCobrancaCall = FiltroCobrancaCall();
  static RemoverConteudoVinculadoCall removerConteudoVinculadoCall =
      RemoverConteudoVinculadoCall();
  static ListarContatosChatCall listarContatosChatCall =
      ListarContatosChatCall();
  static VincularAlunoTurmaEAulasCall vincularAlunoTurmaEAulasCall =
      VincularAlunoTurmaEAulasCall();
  static DesvincularAlunoTurmaEAulasCall desvincularAlunoTurmaEAulasCall =
      DesvincularAlunoTurmaEAulasCall();
}

class SignupCall {
  Future<ApiCallResponse> call({
    String? email = '',
    String? senha = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    final ffApiRequestBody = '''
{
  "email": "${escapeStringForJson(email)}",
  "password": "123456"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Signup',
      apiUrl: '${baseUrl}/auth/v1/signup',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? idUserCriado(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.user.id''',
      ));
}

class ListaProfessoresCall {
  Future<ApiCallResponse> call({
    String? pIdFranquia = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ListaProfessores',
      apiUrl: '${baseUrl}/rest/v1/rpc/list_professores_json',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {
        'p_id_franquia': pIdFranquia,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListaProfessoresFiltroCall {
  Future<ApiCallResponse> call({
    String? pIdFranquia = '',
    String? pSearch = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ListaProfessoresFiltro',
      apiUrl: '${baseUrl}/rest/v1/rpc/list_professores_json_by_search',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {
        'p_id_franquia': pIdFranquia,
        'p_search': pSearch,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListaAlunosFiltroCall {
  Future<ApiCallResponse> call({
    String? pIdFranquia = '',
    String? pSearch = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ListaAlunosFiltro',
      apiUrl: '${baseUrl}/rest/v1/rpc/get_students_by_franquia_and_search',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {
        'p_franquia_id': pIdFranquia,
        'p_search': pSearch,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListaAlunosCall {
  Future<ApiCallResponse> call({
    String? pFranquiaId = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ListaAlunos',
      apiUrl: '${baseUrl}/rest/v1/rpc/get_students_by_franquia',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {
        'p_franquia_id': pFranquiaId,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DetalhesAulaCall {
  Future<ApiCallResponse> call({
    String? pId = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'DetalhesAula',
      apiUrl: '${baseUrl}/rest/v1/rpc/get_aula_details',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {
        'p_id': pId,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListaAlunosPorTurmaCall {
  Future<ApiCallResponse> call({
    String? pTurmaId = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ListaAlunosPorTurma',
      apiUrl: '${baseUrl}/rest/v1/rpc/meta_alunos_by_turma',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {
        'p_turma_id': pTurmaId,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListaTurmasCall {
  Future<ApiCallResponse> call({
    String? pIdFranquia = '',
    String? pSearch = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ListaTurmas',
      apiUrl: '${baseUrl}/rest/v1/rpc/get_turmas_by_franquia',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {
        'p_id_franquia': pIdFranquia,
        'p_search': pSearch,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListaAulasDoDiaCall {
  Future<ApiCallResponse> call({
    String? pIdFranquia = '',
    String? pDataInicio = '',
    String? pDataTermino = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ListaAulasDoDia',
      apiUrl: '${baseUrl}/rest/v1/rpc/get_aulas_by_franquia',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {
        'p_id_franquia': pIdFranquia,
        'p_data_inicio': pDataInicio,
        'p_data_termino': pDataTermino,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListaChatsAbertosCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ListaChatsAbertos',
      apiUrl: '${baseUrl}/rest/v1/rpc/get_user_chats',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {
        'p_user_id': pUserId,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CriarAulaCall {
  Future<ApiCallResponse> call({
    String? pTurmaId = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    final ffApiRequestBody = '''
{
  "p_turma_id": "${escapeStringForJson(pTurmaId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CriarAula',
      apiUrl: '${baseUrl}/rest/v1/rpc/cria_aula',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? uuidAula(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].id''',
      ));
}

class CriarAulaNoPlanningCall {
  Future<ApiCallResponse> call({
    String? pTurmaId = '',
    String? data = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    final ffApiRequestBody = '''
{
  "turma_uuid": "${escapeStringForJson(pTurmaId)}",
  "data_str": "${escapeStringForJson(data)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CriarAulaNoPlanning',
      apiUrl: '${baseUrl}/rest/v1/rpc/cria_aula_com_data',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? idaula(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].id''',
      ));
}

class BuscarChatCall {
  Future<ApiCallResponse> call({
    String? pUserA = '',
    String? pUserB = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'BuscarChat',
      apiUrl: '${baseUrl}/rest/v1/rpc/get_chat_id_between2',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {
        'p_user_a': pUserA,
        'p_user_b': pUserB,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? chatid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.chat_id''',
      ));
}

class FiltroCobrancaCall {
  Future<ApiCallResponse> call({
    String? pSearch = '',
    String? pTipoCobranca = '',
    String? pUserId = '',
    String? pIfFranquia = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Filtro cobranca',
      apiUrl: '${baseUrl}/rest/v1/rpc/get_cobrancas_search',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {
        'p_search': pSearch,
        'p_tipo_cobranca': pTipoCobranca,
        'p_user_id': pUserId,
        'p_if_franquia': pIfFranquia,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class RemoverConteudoVinculadoCall {
  Future<ApiCallResponse> call({
    String? pAulaId = '',
    String? pConteudoId = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    final ffApiRequestBody = '''
{
  "p_aula_id": "${escapeStringForJson(pAulaId)}",
  "p_conteudo_id": "${escapeStringForJson(pConteudoId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'remover conteudo vinculado',
      apiUrl: '${baseUrl}/rest/v1/rpc/remover_conteudo_vinculado',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListarContatosChatCall {
  Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'listar contatos chat',
      apiUrl: '${baseUrl}/rest/v1/rpc/listar_contatos_chat',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class VincularAlunoTurmaEAulasCall {
  Future<ApiCallResponse> call({
    String? pTurmaId = '',
    String? pUserId = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    final ffApiRequestBody = '''
{
  "p_turma_id": "${escapeStringForJson(pTurmaId)}",
  "p_user_id": "${escapeStringForJson(pUserId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'vincular aluno turma e aulas',
      apiUrl: '${baseUrl}/rest/v1/rpc/vincular_aluno_turma_e_aulas',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DesvincularAlunoTurmaEAulasCall {
  Future<ApiCallResponse> call({
    String? pTurmaId = '',
    String? pUserId = '',
    String? token = '',
  }) async {
    final baseUrl = SupabaseGroup.getBaseUrl(
      token: token,
    );

    final ffApiRequestBody = '''
{
  "p_turma_id": "${escapeStringForJson(pTurmaId)}",
  "p_user_id": "${escapeStringForJson(pUserId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'desvincular aluno turma e aulas ',
      apiUrl: '${baseUrl}/rest/v1/rpc/desvincular_aluno_turma_e_aulas',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtZml0a256dHZ4dnpwZ2p5dnhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzMjYzNTEsImV4cCI6MjA2NDkwMjM1MX0.IcGtCLKkPmULcM85Kl19C_-4P5-w0MWQriseRB3mGTI',
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Supabase Group Code

/// Start Asaas Group Code

class AsaasGroup {
  static CriarSubcontaFranquiaCall criarSubcontaFranquiaCall =
      CriarSubcontaFranquiaCall();
  static CriarCobrancaCartaoComSplitCall criarCobrancaCartaoComSplitCall =
      CriarCobrancaCartaoComSplitCall();
  static CriarCobrancaCartaoSemSplitCall criarCobrancaCartaoSemSplitCall =
      CriarCobrancaCartaoSemSplitCall();
  static CriarCobrancaPixComSplitCall criarCobrancaPixComSplitCall =
      CriarCobrancaPixComSplitCall();
  static CriarCobrancaPixSemSplitCall criarCobrancaPixSemSplitCall =
      CriarCobrancaPixSemSplitCall();
  static CriarClienteCall criarClienteCall = CriarClienteCall();
  static GETQRCodeCall gETQRCodeCall = GETQRCodeCall();
  static GETStatusPixCall gETStatusPixCall = GETStatusPixCall();
}

class CriarSubcontaFranquiaCall {
  Future<ApiCallResponse> call({
    String? nome = '',
    String? email = '',
    String? cpfcnpj = '',
    String? telefone = '',
    String? renda = '',
    String? endereco = '',
    String? numero = '',
    String? bairro = '',
    String? cep = '',
    String? tipoempresa = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'CriarSubcontaFranquiaCall',
        'variables': {
          'nome': nome,
          'email': email,
          'cpfcnpj': cpfcnpj,
          'telefone': telefone,
          'renda': renda,
          'endereco': endereco,
          'numero': numero,
          'bairro': bairro,
          'cep': cep,
          'tipoempresa': tipoempresa,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  String? walletid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.walletId''',
      ));
  String? apikey(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.apiKey''',
      ));
}

class CriarCobrancaCartaoComSplitCall {
  Future<ApiCallResponse> call({
    String? clienteid = '',
    double? valortotal,
    String? datacobranca = '',
    double? valorsplit,
    String? descricao = '',
    String? walletIndicacao = '',
    String? nomecartao = '',
    String? numerocartao = '',
    String? mesexpiracao = '',
    String? anoexpira = '',
    String? cvv = '',
    String? ip = '',
    String? nome = '',
    String? email = '',
    String? cpf = '',
    String? telefone = '',
    String? cep = '',
    String? endereco = '',
    String? numero = '',
    String? bairro = '',
    int? parcelas,
    double? valorParcela,
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'CriarCobrancaCartaoComSplitCall',
        'variables': {
          'clienteid': clienteid,
          'valortotal': valortotal,
          'datacobranca': datacobranca,
          'valorsplit': valorsplit,
          'descricao': descricao,
          'walletIndicacao': walletIndicacao,
          'nomecartao': nomecartao,
          'numerocartao': numerocartao,
          'mesexpiracao': mesexpiracao,
          'anoexpira': anoexpira,
          'cvv': cvv,
          'ip': ip,
          'nome': nome,
          'email': email,
          'cpf': cpf,
          'telefone': telefone,
          'cep': cep,
          'endereco': endereco,
          'numero': numero,
          'bairro': bairro,
          'parcelas': parcelas,
          'valorParcela': valorParcela,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  dynamic statuspix(dynamic response) => getJsonField(
        response,
        r'''$.status''',
      );
  dynamic idpagamento(dynamic response) => getJsonField(
        response,
        r'''$.id''',
      );
  dynamic formapagamento(dynamic response) => getJsonField(
        response,
        r'''$.billingType''',
      );
  dynamic dataliberacao(dynamic response) => getJsonField(
        response,
        r'''$.creditDate''',
      );
}

class CriarCobrancaCartaoSemSplitCall {
  Future<ApiCallResponse> call({
    String? clienteid = '',
    double? valortotal,
    String? datacobranca = '',
    double? valorsplit,
    String? descricao = '',
    String? walletsplit = '',
    String? nomecartao = '',
    String? numerocartao = '',
    String? mesexpiracao = '',
    String? anoexpira = '',
    String? cvv = '',
    String? ip = '',
    String? nome = '',
    String? email = '',
    String? cpf = '',
    String? telefone = '',
    String? cep = '',
    String? endereco = '',
    String? numero = '',
    String? bairro = '',
    int? parcelas,
    double? valorParcela,
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'CriarCobrancaCartaoSemSplitCall',
        'variables': {
          'clienteid': clienteid,
          'valortotal': valortotal,
          'datacobranca': datacobranca,
          'valorsplit': valorsplit,
          'descricao': descricao,
          'walletsplit': walletsplit,
          'nomecartao': nomecartao,
          'numerocartao': numerocartao,
          'mesexpiracao': mesexpiracao,
          'anoexpira': anoexpira,
          'cvv': cvv,
          'ip': ip,
          'nome': nome,
          'email': email,
          'cpf': cpf,
          'telefone': telefone,
          'cep': cep,
          'endereco': endereco,
          'numero': numero,
          'bairro': bairro,
          'parcelas': parcelas,
          'valorParcela': valorParcela,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  dynamic statuspix(dynamic response) => getJsonField(
        response,
        r'''$.status''',
      );
  dynamic idpagamento(dynamic response) => getJsonField(
        response,
        r'''$.id''',
      );
  dynamic formapagamento(dynamic response) => getJsonField(
        response,
        r'''$.billingType''',
      );
  dynamic dataliberacao(dynamic response) => getJsonField(
        response,
        r'''$.creditDate''',
      );
}

class CriarCobrancaPixComSplitCall {
  Future<ApiCallResponse> call({
    String? clienteid = '',
    double? valortotal,
    String? datacobranca = '',
    double? valorsplit,
    String? descricao = '',
    String? walletIndicacao = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'CriarCobrancaPixComSplitCall',
        'variables': {
          'clienteid': clienteid,
          'valortotal': valortotal,
          'datacobranca': datacobranca,
          'valorsplit': valorsplit,
          'descricao': descricao,
          'walletIndicacao': walletIndicacao,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  dynamic statuspix(dynamic response) => getJsonField(
        response,
        r'''$.status''',
      );
  dynamic idpagamento(dynamic response) => getJsonField(
        response,
        r'''$.id''',
      );
  dynamic formapagamento(dynamic response) => getJsonField(
        response,
        r'''$.billingType''',
      );
}

class CriarCobrancaPixSemSplitCall {
  Future<ApiCallResponse> call({
    String? clienteid = '',
    double? valortotal,
    String? datacobranca = '',
    double? valorsplit,
    String? descricao = '',
    String? walletsplit = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'CriarCobrancaPixSemSplitCall',
        'variables': {
          'clienteid': clienteid,
          'valortotal': valortotal,
          'datacobranca': datacobranca,
          'valorsplit': valorsplit,
          'descricao': descricao,
          'walletsplit': walletsplit,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  dynamic statuspix(dynamic response) => getJsonField(
        response,
        r'''$.status''',
      );
  dynamic idpagamento(dynamic response) => getJsonField(
        response,
        r'''$.id''',
      );
  dynamic formapagamento(dynamic response) => getJsonField(
        response,
        r'''$.billingType''',
      );
}

class CriarClienteCall {
  Future<ApiCallResponse> call({
    String? nome = '',
    String? cpf = '',
    String? email = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'CriarClienteCall',
        'variables': {
          'nome': nome,
          'cpf': cpf,
          'email': email,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  String? idcliente(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.id''',
      ));
}

class GETQRCodeCall {
  Future<ApiCallResponse> call({
    String? id = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'GETQRCodeCall',
        'variables': {
          'id': id,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  dynamic imagemQr(dynamic response) => getJsonField(
        response,
        r'''$.encodedImage''',
      );
  dynamic copiaecola(dynamic response) => getJsonField(
        response,
        r'''$.payload''',
      );
}

class GETStatusPixCall {
  Future<ApiCallResponse> call({
    String? id = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'GETStatusPixCall',
        'variables': {
          'id': id,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  dynamic status(dynamic response) => getJsonField(
        response,
        r'''$.status''',
      );
}

/// End Asaas Group Code

class BuscarCEPCall {
  static Future<ApiCallResponse> call({
    String? cep = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'BuscarCEP',
      apiUrl: 'https://viacep.com.br/ws/${cep}/json/',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? rua(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.logradouro''',
      ));
  static String? bairro(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.bairro''',
      ));
  static String? cidade(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.localidade''',
      ));
  static String? uf(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.uf''',
      ));
}

class BuscarIPCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'BuscarIP',
      apiUrl: 'https://api.ipify.org?format=json',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic ip(dynamic response) => getJsonField(
        response,
        r'''$.ip''',
      );
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
