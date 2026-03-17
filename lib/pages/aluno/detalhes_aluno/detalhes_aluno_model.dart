import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/cobranca_criada/cobranca_criada_widget.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/flutter_flow/request_manager.dart';

import 'dart:async';
import 'detalhes_aluno_widget.dart' show DetalhesAlunoWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class DetalhesAlunoModel extends FlutterFlowModel<DetalhesAlunoWidget> {
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

  // Stores action output result for [Backend Call - Query Rows] action in DetalhesAluno widget.
  List<UsersRow>? dadosAluno;
  // Stores action output result for [Backend Call - Query Rows] action in DetalhesAluno widget.
  List<MetaAlunosRow>? dadosMetaAluno;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  late MaskTextInputFormatter textFieldMask3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  late MaskTextInputFormatter textFieldMask4;
  String? Function(BuildContext, String?)? textController4Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode5;
  TextEditingController? textController5;
  late MaskTextInputFormatter textFieldMask5;
  String? Function(BuildContext, String?)? textController5Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode6;
  TextEditingController? textController6;
  String? Function(BuildContext, String?)? textController6Validator;
  bool isDataUploading_uploadFotoPerfil = false;
  FFUploadedFile uploadedLocalFile_uploadFotoPerfil =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadFotoPerfil = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode7;
  TextEditingController? textController7;
  late MaskTextInputFormatter textFieldMask7;
  String? Function(BuildContext, String?)? textController7Validator;
  // Stores action output result for [Backend Call - API (BuscarCEP)] action in TextField widget.
  ApiCallResponse? apiCEP;
  // State field(s) for TxtPais widget.
  FocusNode? txtPaisFocusNode;
  TextEditingController? txtPaisTextController;
  String? Function(BuildContext, String?)? txtPaisTextControllerValidator;
  // State field(s) for TxtRua widget.
  FocusNode? txtRuaFocusNode;
  TextEditingController? txtRuaTextController;
  String? Function(BuildContext, String?)? txtRuaTextControllerValidator;
  // State field(s) for TextBairro widget.
  FocusNode? textBairroFocusNode;
  TextEditingController? textBairroTextController;
  String? Function(BuildContext, String?)? textBairroTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode8;
  TextEditingController? textController11;
  String? Function(BuildContext, String?)? textController11Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode9;
  TextEditingController? textController12;
  String? Function(BuildContext, String?)? textController12Validator;
  // State field(s) for TextCidade widget.
  FocusNode? textCidadeFocusNode;
  TextEditingController? textCidadeTextController;
  String? Function(BuildContext, String?)? textCidadeTextControllerValidator;
  // State field(s) for UF widget.
  FocusNode? ufFocusNode;
  TextEditingController? ufTextController;
  String? Function(BuildContext, String?)? ufTextControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  bool requestCompleted1 = false;
  String? requestLastUniqueKey1;
  bool requestCompleted3 = false;
  String? requestLastUniqueKey3;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  DateTime? datePicked;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode10;
  TextEditingController? textController15;
  String? Function(BuildContext, String?)? textController15Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode11;
  TextEditingController? textController16;
  String? Function(BuildContext, String?)? textController16Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode12;
  TextEditingController? textController17;
  String? Function(BuildContext, String?)? textController17Validator;
  // State field(s) for DropDownPlano widget.
  String? dropDownPlanoValue;
  FormFieldController<String>? dropDownPlanoValueController;
  // State field(s) for DropDownDesconto widget.
  int? dropDownDescontoValue;
  FormFieldController<int>? dropDownDescontoValueController;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<FranquiasRow>? dadosfranquia;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<PlanosRow>? planoDeta;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  CobrancasRow? cobrancaCriadaSupa;
  // State field(s) for DropDownPlano123 widget.
  String? dropDownPlano123Value;
  FormFieldController<String>? dropDownPlano123ValueController;
  // State field(s) for DropDownDesconto123 widget.
  int? dropDownDesconto123Value;
  FormFieldController<int>? dropDownDesconto123ValueController;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<FranquiasRow>? dadosfranquia2;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<PlanosRow>? planoDetalhe;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  CobrancasRow? cobrancaCriadaSupa2;
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<CobrancasRow>();
  bool requestCompleted2 = false;
  String? requestLastUniqueKey2;

  /// Query cache managers for this widget.

  final _usersManager = FutureRequestManager<List<UsersRow>>();
  Future<List<UsersRow>> users({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<UsersRow>> Function() requestFn,
  }) =>
      _usersManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearUsersCache() => _usersManager.clear();
  void clearUsersCacheKey(String? uniqueKey) =>
      _usersManager.clearRequest(uniqueKey);

  final _metaAulaManager = FutureRequestManager<List<MetaAlunosRow>>();
  Future<List<MetaAlunosRow>> metaAula({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<MetaAlunosRow>> Function() requestFn,
  }) =>
      _metaAulaManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearMetaAulaCache() => _metaAulaManager.clear();
  void clearMetaAulaCacheKey(String? uniqueKey) =>
      _metaAulaManager.clearRequest(uniqueKey);

  final _listaturmaManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> listaturma({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _listaturmaManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearListaturmaCache() => _listaturmaManager.clear();
  void clearListaturmaCacheKey(String? uniqueKey) =>
      _listaturmaManager.clearRequest(uniqueKey);

  final _cobrancaManager = FutureRequestManager<List<CobrancasRow>>();
  Future<List<CobrancasRow>> cobranca({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<CobrancasRow>> Function() requestFn,
  }) =>
      _cobrancaManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearCobrancaCache() => _cobrancaManager.clear();
  void clearCobrancaCacheKey(String? uniqueKey) =>
      _cobrancaManager.clearRequest(uniqueKey);

  final _planosManager = FutureRequestManager<List<PlanosRow>>();
  Future<List<PlanosRow>> planos({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<PlanosRow>> Function() requestFn,
  }) =>
      _planosManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearPlanosCache() => _planosManager.clear();
  void clearPlanosCacheKey(String? uniqueKey) =>
      _planosManager.clearRequest(uniqueKey);

  final _descontosManager = FutureRequestManager<List<DescontosRow>>();
  Future<List<DescontosRow>> descontos({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<DescontosRow>> Function() requestFn,
  }) =>
      _descontosManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearDescontosCache() => _descontosManager.clear();
  void clearDescontosCacheKey(String? uniqueKey) =>
      _descontosManager.clearRequest(uniqueKey);

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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();

    textFieldFocusNode5?.dispose();
    textController5?.dispose();

    textFieldFocusNode6?.dispose();
    textController6?.dispose();

    textFieldFocusNode7?.dispose();
    textController7?.dispose();

    txtPaisFocusNode?.dispose();
    txtPaisTextController?.dispose();

    txtRuaFocusNode?.dispose();
    txtRuaTextController?.dispose();

    textBairroFocusNode?.dispose();
    textBairroTextController?.dispose();

    textFieldFocusNode8?.dispose();
    textController11?.dispose();

    textFieldFocusNode9?.dispose();
    textController12?.dispose();

    textCidadeFocusNode?.dispose();
    textCidadeTextController?.dispose();

    ufFocusNode?.dispose();
    ufTextController?.dispose();

    textFieldFocusNode10?.dispose();
    textController15?.dispose();

    textFieldFocusNode11?.dispose();
    textController16?.dispose();

    textFieldFocusNode12?.dispose();
    textController17?.dispose();

    paginatedDataTableController.dispose();

    /// Dispose query cache managers for this widget.

    clearUsersCache();

    clearMetaAulaCache();

    clearListaturmaCache();

    clearCobrancaCache();

    clearPlanosCache();

    clearDescontosCache();

    clearTurmaCache();
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

  Future waitForRequestCompleted3({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleted3;
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
}
