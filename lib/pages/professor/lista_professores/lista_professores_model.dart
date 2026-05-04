import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/request_manager.dart';
import 'lista_professores_widget.dart' show ListaProfessoresWidget;
import 'package:flutter/material.dart';

class ListaProfessoresModel extends FlutterFlowModel<ListaProfessoresWidget> {
  // Model for Sidebar component.
  late SidebarModel sidebarModel;

  // Search field.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  bool apiRequestCompleted = false;

  // PaginatedDataTable controller.
  final paginatedDataTableController =
      FlutterFlowDataTableController<ListaProfessoresStruct>();

  /// Cache manager for the professors list query.
  final _listaProfessoresManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> listaProfessores({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _listaProfessoresManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearListaProfessoresCache() => _listaProfessoresManager.clear();
  void clearListaProfessoresCacheKey(String? uniqueKey) =>
      _listaProfessoresManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    sidebarModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
    paginatedDataTableController.dispose();
    clearListaProfessoresCache();
  }

  Future<void> waitForApiRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(const Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleted;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
