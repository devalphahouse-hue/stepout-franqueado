import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/request_manager.dart';
import 'chat_widget.dart' show ChatWidget;
import 'package:flutter/material.dart';

class ChatModel extends FlutterFlowModel<ChatWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Sidebar component.
  late SidebarModel sidebarModel;
  Stream<List<MensagensChatsRow>>? columnSupabaseStream;
  // State field(s) for tfMobile widget.
  FocusNode? tfMobileFocusNode;
  TextEditingController? tfMobileTextController;
  String? Function(BuildContext, String?)? tfMobileTextControllerValidator;
  // Stores action output result for [Backend Call - Insert Row] action in tfMobile widget.
  MensagensChatsRow? insertMessageCopy;
  bool apiRequestCompleted = false;
  String? apiRequestLastUniqueKey;
  // Stores action output result for [Backend Call - Insert Row] action in IconButton widget.
  MensagensChatsRow? insertMessage;

  /// Query cache managers for this widget.

  final _listaChatsManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> listaChats({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _listaChatsManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearListaChatsCache() => _listaChatsManager.clear();
  void clearListaChatsCacheKey(String? uniqueKey) =>
      _listaChatsManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    sidebarModel.dispose();
    tfMobileFocusNode?.dispose();
    tfMobileTextController?.dispose();

    /// Dispose query cache managers for this widget.

    clearListaChatsCache();
  }

  /// Additional helper methods.
  Future waitForApiRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleted;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
