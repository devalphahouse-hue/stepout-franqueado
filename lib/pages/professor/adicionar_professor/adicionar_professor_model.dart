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
import '/index.dart';
import 'adicionar_professor_widget.dart' show AdicionarProfessorWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class AdicionarProfessorModel
    extends FlutterFlowModel<AdicionarProfessorWidget> {
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
  bool isDataUploading_uploadFotoPerfilAluno = false;
  FFUploadedFile uploadedLocalFile_uploadFotoPerfilAluno =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadFotoPerfilAluno = '';

  // State field(s) for TextCEP widget.
  FocusNode? textCEPFocusNode;
  TextEditingController? textCEPTextController;
  late MaskTextInputFormatter textCEPMask;
  String? Function(BuildContext, String?)? textCEPTextControllerValidator;
  // Stores action output result for [Backend Call - API (BuscarCEP)] action in TextCEP widget.
  ApiCallResponse? apiResultCEP;
  // State field(s) for TextPais widget.
  FocusNode? textPaisFocusNode;
  TextEditingController? textPaisTextController;
  String? Function(BuildContext, String?)? textPaisTextControllerValidator;
  // State field(s) for TextRua widget.
  FocusNode? textRuaFocusNode;
  TextEditingController? textRuaTextController;
  String? Function(BuildContext, String?)? textRuaTextControllerValidator;
  // State field(s) for TextBairro widget.
  FocusNode? textBairroFocusNode;
  TextEditingController? textBairroTextController;
  String? Function(BuildContext, String?)? textBairroTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode7;
  TextEditingController? textController11;
  String? Function(BuildContext, String?)? textController11Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode8;
  TextEditingController? textController12;
  String? Function(BuildContext, String?)? textController12Validator;
  // State field(s) for TextCidade widget.
  FocusNode? textCidadeFocusNode;
  TextEditingController? textCidadeTextController;
  String? Function(BuildContext, String?)? textCidadeTextControllerValidator;
  // State field(s) for TextUF widget.
  FocusNode? textUFFocusNode;
  TextEditingController? textUFTextController;
  String? Function(BuildContext, String?)? textUFTextControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  Stream<List<TurmasRow>>? dropDownSupabaseStream;
  // Stores action output result for [Backend Call - API (Signup)] action in Button widget.
  ApiCallResponse? criarProfessor;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  UsersRow? criarUser;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  MetaProfessorRow? criarMetaUser;

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

    textCEPFocusNode?.dispose();
    textCEPTextController?.dispose();

    textPaisFocusNode?.dispose();
    textPaisTextController?.dispose();

    textRuaFocusNode?.dispose();
    textRuaTextController?.dispose();

    textBairroFocusNode?.dispose();
    textBairroTextController?.dispose();

    textFieldFocusNode7?.dispose();
    textController11?.dispose();

    textFieldFocusNode8?.dispose();
    textController12?.dispose();

    textCidadeFocusNode?.dispose();
    textCidadeTextController?.dispose();

    textUFFocusNode?.dispose();
    textUFTextController?.dispose();
  }
}
