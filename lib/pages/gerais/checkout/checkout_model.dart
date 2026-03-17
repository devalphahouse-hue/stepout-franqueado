import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'checkout_widget.dart' show CheckoutWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class CheckoutModel extends FlutterFlowModel<CheckoutWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (Criar Cliente)] action in Button widget.
  ApiCallResponse? apiCriarCliente;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<FranquiasRow>? franquiaIndicadoraPix;
  // Stores action output result for [Backend Call - API (Criar Cobranca Pix com Split )] action in Button widget.
  ApiCallResponse? apiCobPIXSplit;
  // Stores action output result for [Backend Call - API (GET QR Code)] action in Button widget.
  ApiCallResponse? gETQRcode;
  // Stores action output result for [Backend Call - API (Criar Cobranca Pix sem Split )] action in Button widget.
  ApiCallResponse? apiCobPIXSIMPLES;
  // Stores action output result for [Backend Call - API (GET QR Code)] action in Button widget.
  ApiCallResponse? gETQRcodeSIMPLES;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // Stores action output result for [Backend Call - API (GET Status Pix)] action in Button widget.
  ApiCallResponse? statusPix;
  // Stores action output result for [Backend Call - API (Criar subconta Franquia)] action in Button widget.
  ApiCallResponse? subConta;
  // State field(s) for tx_nomecart widget.
  FocusNode? txNomecartFocusNode;
  TextEditingController? txNomecartTextController;
  String? Function(BuildContext, String?)? txNomecartTextControllerValidator;
  // State field(s) for tx_numcart widget.
  FocusNode? txNumcartFocusNode;
  TextEditingController? txNumcartTextController;
  late MaskTextInputFormatter txNumcartMask;
  String? Function(BuildContext, String?)? txNumcartTextControllerValidator;
  // State field(s) for tx_mes widget.
  FocusNode? txMesFocusNode;
  TextEditingController? txMesTextController;
  late MaskTextInputFormatter txMesMask;
  String? Function(BuildContext, String?)? txMesTextControllerValidator;
  // State field(s) for tx_ano widget.
  FocusNode? txAnoFocusNode;
  TextEditingController? txAnoTextController;
  late MaskTextInputFormatter txAnoMask;
  String? Function(BuildContext, String?)? txAnoTextControllerValidator;
  // State field(s) for tx_cvv widget.
  FocusNode? txCvvFocusNode;
  TextEditingController? txCvvTextController;
  late MaskTextInputFormatter txCvvMask;
  String? Function(BuildContext, String?)? txCvvTextControllerValidator;
  // State field(s) for tx_cpf widget.
  FocusNode? txCpfFocusNode;
  TextEditingController? txCpfTextController;
  String? Function(BuildContext, String?)? txCpfTextControllerValidator;
  // Stores action output result for [Backend Call - API (Criar Cliente)] action in Button widget.
  ApiCallResponse? apiResult5t0;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<FranquiasRow>? franquiaIndicadora;
  // Stores action output result for [Backend Call - API (BuscarIP)] action in Button widget.
  ApiCallResponse? ipCliente;
  // Stores action output result for [Backend Call - API (Criar Cobranca Cartao com Split)] action in Button widget.
  ApiCallResponse? apiCobCARTSplit;
  // Stores action output result for [Backend Call - API (Criar subconta Franquia)] action in Button widget.
  ApiCallResponse? subConta1;
  // Stores action output result for [Backend Call - API (BuscarIP)] action in Button widget.
  ApiCallResponse? ipClienteSIMPL;
  // Stores action output result for [Backend Call - API (Criar Cobranca Cartao sem Split )] action in Button widget.
  ApiCallResponse? apiCobCARTSemSplit;
  // Stores action output result for [Backend Call - API (Criar subconta Franquia)] action in Button widget.
  ApiCallResponse? subConta2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController1?.dispose();

    txNomecartFocusNode?.dispose();
    txNomecartTextController?.dispose();

    txNumcartFocusNode?.dispose();
    txNumcartTextController?.dispose();

    txMesFocusNode?.dispose();
    txMesTextController?.dispose();

    txAnoFocusNode?.dispose();
    txAnoTextController?.dispose();

    txCvvFocusNode?.dispose();
    txCvvTextController?.dispose();

    txCpfFocusNode?.dispose();
    txCpfTextController?.dispose();
  }
}
