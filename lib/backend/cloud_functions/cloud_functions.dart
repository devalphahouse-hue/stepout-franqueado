import 'package:supabase_flutter/supabase_flutter.dart';

// Mantém a assinatura makeCloudCall(callName, input) por retrocompatibilidade
// com os call-sites em api_calls.dart. O parâmetro `_functionName` é ignorado:
// sempre invocamos a Edge Function `asaas-proxy` no Supabase, que substituiu
// a Firebase Cloud Function antiga.
Future<Map<String, dynamic>> makeCloudCall(
  String _functionName,
  Map<String, dynamic> input,
) async {
  try {
    final response = await Supabase.instance.client.functions.invoke(
      'asaas-proxy',
      body: input,
    );
    final data = response.data;
    return data is Map ? Map<String, dynamic>.from(data) : {};
  } on FunctionException catch (error) {
    final details = error.details;
    if (details is Map && details['statusCode'] is int) {
      return Map<String, dynamic>.from(details);
    }
    return {
      'statusCode': error.status,
      'body': {
        'errors': [
          {
            'description':
                'Não foi possível concluir. Consulte o pagamento antes de tentar novamente.',
          },
        ],
      },
    };
  } catch (_) {
    return {
      'statusCode': 503,
      'body': {
        'errors': [
          {
            'description':
                'Resultado inconclusivo. Consulte antes de tentar novamente.',
          },
        ],
      },
    };
  }
}
