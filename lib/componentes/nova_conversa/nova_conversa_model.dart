import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/request_manager.dart';
import 'nova_conversa_widget.dart' show NovaConversaWidget;
import 'package:flutter/material.dart';

class NovaConversaModel extends FlutterFlowModel<NovaConversaWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (BuscarChat)] action in Button widget.
  ApiCallResponse? apiResultclt;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  ChatsRow? criarchat;

  /// Query cache managers for this widget.

  final _listarContatosManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> listarContatos({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _listarContatosManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearListarContatosCache() => _listarContatosManager.clear();
  void clearListarContatosCacheKey(String? uniqueKey) =>
      _listarContatosManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    /// Dispose query cache managers for this widget.

    clearListarContatosCache();
  }
}
