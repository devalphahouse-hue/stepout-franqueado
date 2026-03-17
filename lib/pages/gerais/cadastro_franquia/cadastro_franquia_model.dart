import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'cadastro_franquia_widget.dart' show CadastroFranquiaWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class CadastroFranquiaModel extends FlutterFlowModel<CadastroFranquiaWidget> {
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

  // State field(s) for TextFieldNome widget.
  FocusNode? textFieldNomeFocusNode1;
  TextEditingController? textFieldNomeTextController1;
  String? Function(BuildContext, String?)?
      textFieldNomeTextController1Validator;
  // State field(s) for TextFieldEmail widget.
  FocusNode? textFieldEmailFocusNode;
  TextEditingController? textFieldEmailTextController;
  String? Function(BuildContext, String?)?
      textFieldEmailTextControllerValidator;
  // State field(s) for TextFieldSenha widget.
  FocusNode? textFieldSenhaFocusNode;
  TextEditingController? textFieldSenhaTextController;
  late bool textFieldSenhaVisibility;
  String? Function(BuildContext, String?)?
      textFieldSenhaTextControllerValidator;
  // State field(s) for TextFieldSenhaConf widget.
  FocusNode? textFieldSenhaConfFocusNode;
  TextEditingController? textFieldSenhaConfTextController;
  late bool textFieldSenhaConfVisibility;
  String? Function(BuildContext, String?)?
      textFieldSenhaConfTextControllerValidator;
  // State field(s) for TextFieldTelefone widget.
  FocusNode? textFieldTelefoneFocusNode;
  TextEditingController? textFieldTelefoneTextController;
  late MaskTextInputFormatter textFieldTelefoneMask;
  String? Function(BuildContext, String?)?
      textFieldTelefoneTextControllerValidator;
  // State field(s) for TextFieldCPF widget.
  FocusNode? textFieldCPFFocusNode1;
  TextEditingController? textFieldCPFTextController1;
  late MaskTextInputFormatter textFieldCPFMask1;
  String? Function(BuildContext, String?)? textFieldCPFTextController1Validator;
  // State field(s) for TextFieldDNasc widget.
  FocusNode? textFieldDNascFocusNode;
  TextEditingController? textFieldDNascTextController;
  late MaskTextInputFormatter textFieldDNascMask;
  String? Function(BuildContext, String?)?
      textFieldDNascTextControllerValidator;
  // State field(s) for TextFieldNocion widget.
  FocusNode? textFieldNocionFocusNode;
  TextEditingController? textFieldNocionTextController;
  String? Function(BuildContext, String?)?
      textFieldNocionTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController7;
  late MaskTextInputFormatter textFieldMask;
  String? Function(BuildContext, String?)? textController7Validator;
  // Stores action output result for [Backend Call - API (BuscarCEP)] action in TextField widget.
  ApiCallResponse? resultCEP;
  // State field(s) for TextFieldPais widget.
  FocusNode? textFieldPaisFocusNode;
  TextEditingController? textFieldPaisTextController;
  String? Function(BuildContext, String?)? textFieldPaisTextControllerValidator;
  // State field(s) for TextFieldEndereco widget.
  FocusNode? textFieldEnderecoFocusNode;
  TextEditingController? textFieldEnderecoTextController;
  String? Function(BuildContext, String?)?
      textFieldEnderecoTextControllerValidator;
  // State field(s) for TextFieldBairro widget.
  FocusNode? textFieldBairroFocusNode;
  TextEditingController? textFieldBairroTextController;
  String? Function(BuildContext, String?)?
      textFieldBairroTextControllerValidator;
  // State field(s) for TextFieldNumero widget.
  FocusNode? textFieldNumeroFocusNode;
  TextEditingController? textFieldNumeroTextController;
  String? Function(BuildContext, String?)?
      textFieldNumeroTextControllerValidator;
  // State field(s) for TextFieldComple widget.
  FocusNode? textFieldCompleFocusNode;
  TextEditingController? textFieldCompleTextController;
  String? Function(BuildContext, String?)?
      textFieldCompleTextControllerValidator;
  // State field(s) for TextFieldCidade widget.
  FocusNode? textFieldCidadeFocusNode;
  TextEditingController? textFieldCidadeTextController;
  String? Function(BuildContext, String?)?
      textFieldCidadeTextControllerValidator;
  // State field(s) for TextFieldUF widget.
  FocusNode? textFieldUFFocusNode;
  TextEditingController? textFieldUFTextController;
  String? Function(BuildContext, String?)? textFieldUFTextControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for TextFieldCPF widget.
  FocusNode? textFieldCPFFocusNode2;
  TextEditingController? textFieldCPFTextController2;
  late MaskTextInputFormatter textFieldCPFMask2;
  String? Function(BuildContext, String?)? textFieldCPFTextController2Validator;
  // State field(s) for TextFieldCPF widget.
  FocusNode? textFieldCPFFocusNode3;
  TextEditingController? textFieldCPFTextController3;
  String? Function(BuildContext, String?)? textFieldCPFTextController3Validator;
  // State field(s) for TextFieldNome widget.
  FocusNode? textFieldNomeFocusNode2;
  TextEditingController? textFieldNomeTextController2;
  String? Function(BuildContext, String?)?
      textFieldNomeTextController2Validator;
  // State field(s) for TextFieldNome widget.
  FocusNode? textFieldNomeFocusNode3;
  TextEditingController? textFieldNomeTextController3;
  String? Function(BuildContext, String?)?
      textFieldNomeTextController3Validator;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  UsersRow? novoRowUser;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  FranquiasRow? novoRowFranquia;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  CobrancasRow? idCobranca;

  @override
  void initState(BuildContext context) {
    textFieldSenhaVisibility = false;
    textFieldSenhaConfVisibility = false;
  }

  @override
  void dispose() {
    textFieldNomeFocusNode1?.dispose();
    textFieldNomeTextController1?.dispose();

    textFieldEmailFocusNode?.dispose();
    textFieldEmailTextController?.dispose();

    textFieldSenhaFocusNode?.dispose();
    textFieldSenhaTextController?.dispose();

    textFieldSenhaConfFocusNode?.dispose();
    textFieldSenhaConfTextController?.dispose();

    textFieldTelefoneFocusNode?.dispose();
    textFieldTelefoneTextController?.dispose();

    textFieldCPFFocusNode1?.dispose();
    textFieldCPFTextController1?.dispose();

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

    textFieldCPFFocusNode2?.dispose();
    textFieldCPFTextController2?.dispose();

    textFieldCPFFocusNode3?.dispose();
    textFieldCPFTextController3?.dispose();

    textFieldNomeFocusNode2?.dispose();
    textFieldNomeTextController2?.dispose();

    textFieldNomeFocusNode3?.dispose();
    textFieldNomeTextController3?.dispose();
  }
}
