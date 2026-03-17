import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'adicionar_aluno_widget.dart' show AdicionarAlunoWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class AdicionarAlunoModel extends FlutterFlowModel<AdicionarAlunoWidget> {
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
  bool isDataUploading_uploadFotoPerfilAlunio = false;
  FFUploadedFile uploadedLocalFile_uploadFotoPerfilAlunio =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadFotoPerfilAlunio = '';

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
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Backend Call - API (Signup)] action in Button widget.
  ApiCallResponse? criarAluno;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  UsersRow? criarUser;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  MetaAlunosRow? criarMetaUser;

  /// Query cache managers for this widget.

  final _turmasManager = FutureRequestManager<List<TurmasRow>>();
  Future<List<TurmasRow>> turmas({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<TurmasRow>> Function() requestFn,
  }) =>
      _turmasManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearTurmasCache() => _turmasManager.clear();
  void clearTurmasCacheKey(String? uniqueKey) =>
      _turmasManager.clearRequest(uniqueKey);

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

    /// Dispose query cache managers for this widget.

    clearTurmasCache();
  }
}
