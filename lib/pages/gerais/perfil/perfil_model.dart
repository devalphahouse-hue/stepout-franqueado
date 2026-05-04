import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import 'perfil_widget.dart' show PerfilWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PerfilModel extends FlutterFlowModel<PerfilWidget> {
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

  late SidebarModel sidebarModel;

  FocusNode? textFieldNomeFocusNode;
  TextEditingController? textFieldNomeTextController;
  String? Function(BuildContext, String?)? textFieldNomeTextControllerValidator;

  FocusNode? textFieldEmailFocusNode;
  TextEditingController? textFieldEmailTextController;
  String? Function(BuildContext, String?)?
      textFieldEmailTextControllerValidator;

  FocusNode? textFieldTelefoneFocusNode;
  TextEditingController? textFieldTelefoneTextController;
  late MaskTextInputFormatter textFieldTelefoneMask;
  String? Function(BuildContext, String?)?
      textFieldTelefoneTextControllerValidator;

  FocusNode? textFieldCPFFocusNode;
  TextEditingController? textFieldCPFTextController;
  late MaskTextInputFormatter textFieldCPFMask;
  String? Function(BuildContext, String?)? textFieldCPFTextControllerValidator;

  FocusNode? textFieldDNascFocusNode;
  TextEditingController? textFieldDNascTextController;
  late MaskTextInputFormatter textFieldDNascMask;
  String? Function(BuildContext, String?)?
      textFieldDNascTextControllerValidator;

  FocusNode? textFieldNocionFocusNode;
  TextEditingController? textFieldNocionTextController;
  String? Function(BuildContext, String?)?
      textFieldNocionTextControllerValidator;

  bool isDataUploading_uploadSubsFotoPerfilFranquia = false;
  FFUploadedFile uploadedLocalFile_uploadSubsFotoPerfilFranquia =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadSubsFotoPerfilFranquia = '';

  FocusNode? textFieldFocusNode;
  TextEditingController? textController7;
  late MaskTextInputFormatter textFieldMask;
  String? Function(BuildContext, String?)? textController7Validator;

  ApiCallResponse? resultCEP;

  FocusNode? textFieldPaisFocusNode;
  TextEditingController? textFieldPaisTextController;
  String? Function(BuildContext, String?)? textFieldPaisTextControllerValidator;

  FocusNode? textFieldEnderecoFocusNode;
  TextEditingController? textFieldEnderecoTextController;
  String? Function(BuildContext, String?)?
      textFieldEnderecoTextControllerValidator;

  FocusNode? textFieldBairroFocusNode;
  TextEditingController? textFieldBairroTextController;
  String? Function(BuildContext, String?)?
      textFieldBairroTextControllerValidator;

  FocusNode? textFieldNumeroFocusNode;
  TextEditingController? textFieldNumeroTextController;
  String? Function(BuildContext, String?)?
      textFieldNumeroTextControllerValidator;

  FocusNode? textFieldCompleFocusNode;
  TextEditingController? textFieldCompleTextController;
  String? Function(BuildContext, String?)?
      textFieldCompleTextControllerValidator;

  FocusNode? textFieldCidadeFocusNode;
  TextEditingController? textFieldCidadeTextController;
  String? Function(BuildContext, String?)?
      textFieldCidadeTextControllerValidator;

  FocusNode? textFieldUFFocusNode;
  TextEditingController? textFieldUFTextController;
  String? Function(BuildContext, String?)? textFieldUFTextControllerValidator;

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    sidebarModel.dispose();
    textFieldNomeFocusNode?.dispose();
    textFieldNomeTextController?.dispose();
    textFieldEmailFocusNode?.dispose();
    textFieldEmailTextController?.dispose();
    textFieldTelefoneFocusNode?.dispose();
    textFieldTelefoneTextController?.dispose();
    textFieldCPFFocusNode?.dispose();
    textFieldCPFTextController?.dispose();
    textFieldDNascFocusNode?.dispose();
    textFieldDNascTextController?.dispose();
    textFieldNocionFocusNode?.dispose();
    textFieldNocionTextController?.dispose();
    textFieldFocusNode?.dispose();
    textController7?.dispose();
    textFieldPaisFocusNode?.dispose();
    textFieldPaisTextController?.dispose();
    textFieldEnderecoFocusNode?.dispose();
    textFieldEnderecoTextController?.dispose();
    textFieldBairroFocusNode?.dispose();
    textFieldBairroTextController?.dispose();
    textFieldNumeroFocusNode?.dispose();
    textFieldNumeroTextController?.dispose();
    textFieldCompleFocusNode?.dispose();
    textFieldCompleTextController?.dispose();
    textFieldCidadeFocusNode?.dispose();
    textFieldCidadeTextController?.dispose();
    textFieldUFFocusNode?.dispose();
    textFieldUFTextController?.dispose();
  }
}
