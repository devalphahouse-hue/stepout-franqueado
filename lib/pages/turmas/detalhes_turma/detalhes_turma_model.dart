import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'dart:async';
import 'detalhes_turma_widget.dart' show DetalhesTurmaWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class DetalhesTurmaModel extends FlutterFlowModel<DetalhesTurmaWidget> {
  ///  Local state fields for this page.

  List<VinculacaoTurmasStruct> vincularTurmas = [];
  void addToVincularTurmas(VinculacaoTurmasStruct item) =>
      vincularTurmas.add(item);
  void removeFromVincularTurmas(VinculacaoTurmasStruct item) =>
      vincularTurmas.remove(item);
  void removeAtIndexFromVincularTurmas(int index) =>
      vincularTurmas.removeAt(index);
  void insertAtIndexInVincularTurmas(int index, VinculacaoTurmasStruct item) =>
      vincularTurmas.insert(index, item);
  void updateVincularTurmasAtIndex(
          int index, Function(VinculacaoTurmasStruct) updateFn) =>
      vincularTurmas[index] = updateFn(vincularTurmas[index]);

  ///  State fields for stateful widgets in this page.

  // Model for Sidebar component.
  late SidebarModel sidebarModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for DropDownProfessor widget.
  String? dropDownProfessorValue;
  FormFieldController<String>? dropDownProfessorValueController;
  bool requestCompleted1 = false;
  String? requestLastUniqueKey1;
  bool requestCompleted2 = false;
  String? requestLastUniqueKey2;
  // State field(s) for DropDownDia widget.
  String? dropDownDiaValue;
  FormFieldController<String>? dropDownDiaValueController;
  // State field(s) for TextFieldhoraini widget.
  FocusNode? textFieldhorainiFocusNode;
  TextEditingController? textFieldhorainiTextController;
  late MaskTextInputFormatter textFieldhorainiMask;
  String? Function(BuildContext, String?)?
      textFieldhorainiTextControllerValidator;
  // State field(s) for TextFieldhorafim widget.
  FocusNode? textFieldhorafimFocusNode;
  TextEditingController? textFieldhorafimTextController;
  late MaskTextInputFormatter textFieldhorafimMask;
  String? Function(BuildContext, String?)?
      textFieldhorafimTextControllerValidator;
  // State field(s) for DropDownAluno widget.
  String? dropDownAlunoValue;
  FormFieldController<String>? dropDownAlunoValueController;
  bool apiRequestCompleted = false;
  String? apiRequestLastUniqueKey;

  /// Query cache managers for this widget.

  final _profRespManager = FutureRequestManager<List<UsersRow>>();
  Future<List<UsersRow>> profResp({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<UsersRow>> Function() requestFn,
  }) =>
      _profRespManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearProfRespCache() => _profRespManager.clear();
  void clearProfRespCacheKey(String? uniqueKey) =>
      _profRespManager.clearRequest(uniqueKey);

  final _turmaManager = FutureRequestManager<List<TurmasRow>>();
  Future<List<TurmasRow>> turma({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<TurmasRow>> Function() requestFn,
  }) =>
      _turmaManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearTurmaCache() => _turmaManager.clear();
  void clearTurmaCacheKey(String? uniqueKey) =>
      _turmaManager.clearRequest(uniqueKey);

  final _listaprofManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> listaprof({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _listaprofManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearListaprofCache() => _listaprofManager.clear();
  void clearListaprofCacheKey(String? uniqueKey) =>
      _listaprofManager.clearRequest(uniqueKey);

  final _lsialunoturmaManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> lsialunoturma({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _lsialunoturmaManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearLsialunoturmaCache() => _lsialunoturmaManager.clear();
  void clearLsialunoturmaCacheKey(String? uniqueKey) =>
      _lsialunoturmaManager.clearRequest(uniqueKey);

  final _lsitaalunoManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> lsitaaluno({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _lsitaalunoManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearLsitaalunoCache() => _lsitaalunoManager.clear();
  void clearLsitaalunoCacheKey(String? uniqueKey) =>
      _lsitaalunoManager.clearRequest(uniqueKey);

  final _aulasManager = FutureRequestManager<List<AulasRow>>();
  Future<List<AulasRow>> aulas({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<AulasRow>> Function() requestFn,
  }) =>
      _aulasManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearAulasCache() => _aulasManager.clear();
  void clearAulasCacheKey(String? uniqueKey) =>
      _aulasManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    sidebarModel.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldhorainiFocusNode?.dispose();
    textFieldhorainiTextController?.dispose();

    textFieldhorafimFocusNode?.dispose();
    textFieldhorafimTextController?.dispose();

    /// Dispose query cache managers for this widget.

    clearProfRespCache();

    clearTurmaCache();

    clearListaprofCache();

    clearLsialunoturmaCache();

    clearLsitaalunoCache();

    clearAulasCache();
  }

  /// Additional helper methods.
  Future waitForRequestCompleted1({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleted1;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  Future waitForRequestCompleted2({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleted2;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

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
