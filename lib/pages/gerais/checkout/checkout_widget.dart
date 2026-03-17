import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'checkout_model.dart';
export 'checkout_model.dart';

class CheckoutWidget extends StatefulWidget {
  const CheckoutWidget({
    super.key,
    this.indication,
    required this.idCobranca,
  });

  final String? indication;
  final String? idCobranca;

  static String routeName = 'Checkout';
  static String routePath = '/checkout';

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  late CheckoutModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CheckoutModel());

    _model.textController1 ??= TextEditingController(
        text: FFAppState().contratacaoFranquado.copiaecola);
    _model.textFieldFocusNode ??= FocusNode();

    _model.txNomecartTextController ??= TextEditingController();
    _model.txNomecartFocusNode ??= FocusNode();

    _model.txNumcartTextController ??= TextEditingController();
    _model.txNumcartFocusNode ??= FocusNode();

    _model.txNumcartMask = MaskTextInputFormatter(mask: '#### #### #### ####');
    _model.txMesTextController ??= TextEditingController();
    _model.txMesFocusNode ??= FocusNode();

    _model.txMesMask = MaskTextInputFormatter(mask: '##');
    _model.txAnoTextController ??= TextEditingController();
    _model.txAnoFocusNode ??= FocusNode();

    _model.txAnoMask = MaskTextInputFormatter(mask: '####');
    _model.txCvvTextController ??= TextEditingController();
    _model.txCvvFocusNode ??= FocusNode();

    _model.txCvvMask = MaskTextInputFormatter(mask: '###');
    _model.txCpfTextController ??= TextEditingController();
    _model.txCpfFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, -1.0),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 430.0,
                                ),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Escolha sua forma de pagamento',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .headlineLarge
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        'Seleciona a melhor forma de pagamento para adquirir sua franquia completa de forma vitalícia',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          if (false)
                                            Expanded(
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  FFAppState()
                                                      .updateContratacaoFranquadoStruct(
                                                    (e) => e
                                                      ..formaPagamento = 'Pix',
                                                  );
                                                  safeSetState(() {});
                                                },
                                                child: Material(
                                                  color: Colors.transparent,
                                                  elevation: 2.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(20.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          RichText(
                                                            textScaler:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .textScaler,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: 'Pix',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .interTight(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                                TextSpan(
                                                                  text: '',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10.0,
                                                                  ),
                                                                )
                                                              ],
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleSmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .interTight(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 10.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                FFAppState()
                                                    .updateContratacaoFranquadoStruct(
                                                  (e) => e
                                                    ..formaPagamento = 'Cartao',
                                                );
                                                safeSetState(() {});
                                              },
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 2.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(20.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        RichText(
                                                          textScaler:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .textScaler,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    'Cartão de Crédito',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              TextSpan(
                                                                text: '',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                ),
                                                              )
                                                            ],
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .titleSmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .interTight(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 10.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                      if (FFAppState()
                                              .contratacaoFranquado
                                              .formaPagamento ==
                                          'Pix')
                                        Material(
                                          color: Colors.transparent,
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(20.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  if (FFAppState()
                                                              .contratacaoFranquado
                                                              .imagemQr ==
                                                          null ||
                                                      FFAppState()
                                                              .contratacaoFranquado
                                                              .imagemQr ==
                                                          '')
                                                    FFButtonWidget(
                                                      onPressed: () async {
                                                        _model.apiCriarCliente =
                                                            await AsaasGroup
                                                                .criarClienteCall
                                                                .call(
                                                          nome: FFAppState()
                                                              .contratacaoFranquado
                                                              .nomeResponsavel,
                                                          cpf: FFAppState()
                                                                      .contratacaoFranquado
                                                                      .tipoCadastro ==
                                                                  'Pessoa Física'
                                                              ? FFAppState()
                                                                  .contratacaoFranquado
                                                                  .cpfResponsavel
                                                              : FFAppState()
                                                                  .contratacaoFranquado
                                                                  .cnpjConta,
                                                          email: FFAppState()
                                                              .contratacaoFranquado
                                                              .emailResponsavel,
                                                        );

                                                        if ((_model
                                                                .apiCriarCliente
                                                                ?.succeeded ??
                                                            true)) {
                                                          if (widget!.indication !=
                                                                  null &&
                                                              widget!.indication !=
                                                                  '') {
                                                            _model.franquiaIndicadoraPix =
                                                                await FranquiasTable()
                                                                    .queryRows(
                                                              queryFn: (q) =>
                                                                  q.eqOrNull(
                                                                'id',
                                                                FFAppState()
                                                                    .contratacaoFranquado
                                                                    .indication,
                                                              ),
                                                            );
                                                            _model.apiCobPIXSplit =
                                                                await AsaasGroup
                                                                    .criarCobrancaPixComSplitCall
                                                                    .call(
                                                              clienteid: AsaasGroup
                                                                  .criarClienteCall
                                                                  .idcliente(
                                                                (_model.apiCriarCliente
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              ),
                                                              valortotal:
                                                                  FFAppState()
                                                                      .contratacaoFranquado
                                                                      .valor,
                                                              datacobranca:
                                                                  dateTimeFormat(
                                                                "d-M-y",
                                                                getCurrentTimestamp,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                              valorsplit: 50.0,
                                                              walletIndicacao: _model
                                                                  .franquiaIndicadoraPix
                                                                  ?.firstOrNull
                                                                  ?.walletId,
                                                            );

                                                            if ((_model
                                                                    .apiCobPIXSplit
                                                                    ?.succeeded ??
                                                                true)) {
                                                              _model.gETQRcode =
                                                                  await AsaasGroup
                                                                      .gETQRCodeCall
                                                                      .call(
                                                                id: AsaasGroup
                                                                    .criarCobrancaPixComSplitCall
                                                                    .idpagamento(
                                                                      (_model.apiCobPIXSplit
                                                                              ?.jsonBody ??
                                                                          ''),
                                                                    )
                                                                    .toString(),
                                                              );

                                                              FFAppState()
                                                                  .updateContratacaoFranquadoStruct(
                                                                (e) => e
                                                                  ..imagemQr = AsaasGroup
                                                                      .gETQRCodeCall
                                                                      .imagemQr(
                                                                        (_model.gETQRcode?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString()
                                                                  ..copiaecola = AsaasGroup
                                                                      .gETQRCodeCall
                                                                      .copiaecola(
                                                                        (_model.gETQRcode?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString()
                                                                  ..idpagamentoAsaas = AsaasGroup
                                                                      .criarCobrancaPixComSplitCall
                                                                      .idpagamento(
                                                                        (_model.apiCobPIXSplit?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString(),
                                                              );
                                                              safeSetState(
                                                                  () {});
                                                              await CobrancasTable()
                                                                  .update(
                                                                data: {
                                                                  'id_cobranca_asaas': AsaasGroup
                                                                      .criarCobrancaPixComSplitCall
                                                                      .idpagamento(
                                                                        (_model.apiCobPIXSplit?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString(),
                                                                  'forma_pagamento':
                                                                      'Pix',
                                                                  'status_cobranca': AsaasGroup
                                                                      .criarCobrancaPixComSplitCall
                                                                      .statuspix(
                                                                        (_model.apiCobPIXSplit?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString(),
                                                                },
                                                                matchingRows:
                                                                    (rows) => rows
                                                                        .eqOrNull(
                                                                  'id',
                                                                  widget!
                                                                      .idCobranca,
                                                                ),
                                                              );
                                                            } else {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (alertDialogContext) {
                                                                  return WebViewAware(
                                                                    child:
                                                                        AlertDialog(
                                                                      content: Text((_model
                                                                              .apiCobPIXSplit
                                                                              ?.bodyText ??
                                                                          '')),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                          child:
                                                                              Text('Ok'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          } else {
                                                            _model.apiCobPIXSIMPLES =
                                                                await AsaasGroup
                                                                    .criarCobrancaPixSemSplitCall
                                                                    .call(
                                                              clienteid: AsaasGroup
                                                                  .criarClienteCall
                                                                  .idcliente(
                                                                (_model.apiCriarCliente
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              ),
                                                              valortotal:
                                                                  FFAppState()
                                                                      .contratacaoFranquado
                                                                      .valor,
                                                              datacobranca:
                                                                  dateTimeFormat(
                                                                "d-M-yyyy",
                                                                getCurrentTimestamp,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                            );

                                                            if ((_model
                                                                    .apiCobPIXSIMPLES
                                                                    ?.succeeded ??
                                                                true)) {
                                                              _model.gETQRcodeSIMPLES =
                                                                  await AsaasGroup
                                                                      .gETQRCodeCall
                                                                      .call(
                                                                id: AsaasGroup
                                                                    .criarCobrancaPixSemSplitCall
                                                                    .idpagamento(
                                                                      (_model.apiCobPIXSIMPLES
                                                                              ?.jsonBody ??
                                                                          ''),
                                                                    )
                                                                    .toString(),
                                                              );

                                                              FFAppState()
                                                                  .updateContratacaoFranquadoStruct(
                                                                (e) => e
                                                                  ..imagemQr = AsaasGroup
                                                                      .gETQRCodeCall
                                                                      .imagemQr(
                                                                        (_model.gETQRcodeSIMPLES?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString()
                                                                  ..copiaecola = AsaasGroup
                                                                      .gETQRCodeCall
                                                                      .copiaecola(
                                                                        (_model.gETQRcodeSIMPLES?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString()
                                                                  ..idpagamentoAsaas = AsaasGroup
                                                                      .criarCobrancaPixSemSplitCall
                                                                      .idpagamento(
                                                                        (_model.apiCobPIXSIMPLES?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString(),
                                                              );
                                                              safeSetState(
                                                                  () {});
                                                              await CobrancasTable()
                                                                  .update(
                                                                data: {
                                                                  'id_cobranca_asaas': AsaasGroup
                                                                      .criarCobrancaPixSemSplitCall
                                                                      .idpagamento(
                                                                        (_model.apiCobPIXSIMPLES?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString(),
                                                                  'forma_pagamento':
                                                                      'Pix',
                                                                  'status_cobranca': AsaasGroup
                                                                      .criarCobrancaPixSemSplitCall
                                                                      .statuspix(
                                                                        (_model.apiCobPIXSIMPLES?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString(),
                                                                },
                                                                matchingRows:
                                                                    (rows) => rows
                                                                        .eqOrNull(
                                                                  'id',
                                                                  widget!
                                                                      .idCobranca,
                                                                ),
                                                              );
                                                            } else {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (alertDialogContext) {
                                                                  return WebViewAware(
                                                                    child:
                                                                        AlertDialog(
                                                                      content: Text((_model
                                                                              .apiCobPIXSIMPLES
                                                                              ?.bodyText ??
                                                                          '')),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                          child:
                                                                              Text('Ok'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          }
                                                        } else {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return WebViewAware(
                                                                child:
                                                                    AlertDialog(
                                                                  content: Text((_model
                                                                          .apiCriarCliente
                                                                          ?.bodyText ??
                                                                      '')),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                      child: Text(
                                                                          'Ok'),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }

                                                        safeSetState(() {});
                                                      },
                                                      text: 'Gerar QR Code',
                                                      options: FFButtonOptions(
                                                        width: double.infinity,
                                                        height: 40.0,
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                        iconPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .interTight(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontStyle,
                                                                  ),
                                                                  color: Colors
                                                                      .white,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                        elevation: 0.0,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  if (FFAppState()
                                                              .contratacaoFranquado
                                                              .imagemQr !=
                                                          null &&
                                                      FFAppState()
                                                              .contratacaoFranquado
                                                              .imagemQr !=
                                                          '')
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Image.network(
                                                            'data:Image/png;base64,${FFAppState().contratacaoFranquado.imagemQr}',
                                                            width: 200.0,
                                                            height: 200.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                width: 200.0,
                                                                child:
                                                                    TextFormField(
                                                                  controller: _model
                                                                      .textController1,
                                                                  focusNode: _model
                                                                      .textFieldFocusNode,
                                                                  autofocus:
                                                                      false,
                                                                  enabled: true,
                                                                  readOnly:
                                                                      true,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    isDense:
                                                                        true,
                                                                    labelStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                    hintText:
                                                                        'Código Pix',
                                                                    hintStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0x00000000),
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryBackground,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                  cursorColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  enableInteractiveSelection:
                                                                      true,
                                                                  validator: _model
                                                                      .textController1Validator
                                                                      .asValidator(
                                                                          context),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                await Clipboard.setData(ClipboardData(
                                                                    text: FFAppState()
                                                                        .contratacaoFranquado
                                                                        .copiaecola));
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .content_copy,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 24.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        FFButtonWidget(
                                                          onPressed: () async {
                                                            _model.statusPix =
                                                                await AsaasGroup
                                                                    .gETStatusPixCall
                                                                    .call(
                                                              id: FFAppState()
                                                                  .contratacaoFranquado
                                                                  .idpagamentoAsaas,
                                                            );

                                                            if ((_model
                                                                    .statusPix
                                                                    ?.succeeded ??
                                                                true)) {
                                                              FFAppState()
                                                                  .updateContratacaoFranquadoStruct(
                                                                (e) => e
                                                                  ..status = AsaasGroup
                                                                      .gETStatusPixCall
                                                                      .status(
                                                                        (_model.statusPix?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString(),
                                                              );
                                                              safeSetState(
                                                                  () {});
                                                              if ((FFAppState()
                                                                          .contratacaoFranquado
                                                                          .status ==
                                                                      'CONFIRMED') ||
                                                                  (FFAppState()
                                                                          .contratacaoFranquado
                                                                          .status ==
                                                                      'RECEIVED')) {
                                                                await FranquiasTable()
                                                                    .update(
                                                                  data: {
                                                                    'status_franquia':
                                                                        true,
                                                                  },
                                                                  matchingRows:
                                                                      (rows) =>
                                                                          rows.eqOrNull(
                                                                    'id',
                                                                    FFAppState()
                                                                        .contratacaoFranquado
                                                                        .idFranquiaCriada,
                                                                  ),
                                                                );
                                                                await CobrancasTable()
                                                                    .update(
                                                                  data: {
                                                                    'status_cobranca':
                                                                        FFAppState()
                                                                            .contratacaoFranquado
                                                                            .status,
                                                                  },
                                                                  matchingRows:
                                                                      (rows) =>
                                                                          rows.eqOrNull(
                                                                    'id',
                                                                    widget!
                                                                        .idCobranca,
                                                                  ),
                                                                );
                                                                _model.subConta =
                                                                    await AsaasGroup
                                                                        .criarSubcontaFranquiaCall
                                                                        .call(
                                                                  nome: FFAppState()
                                                                              .contratacaoFranquado
                                                                              .tipoCadastro ==
                                                                          'Pessoa Física'
                                                                      ? FFAppState()
                                                                          .contratacaoFranquado
                                                                          .nomeResponsavel
                                                                      : FFAppState()
                                                                          .contratacaoFranquado
                                                                          .razaoSocial,
                                                                  email: FFAppState()
                                                                      .contratacaoFranquado
                                                                      .emailResponsavel,
                                                                  cpfcnpj: FFAppState()
                                                                              .contratacaoFranquado
                                                                              .tipoCadastro ==
                                                                          'Pessoa Física'
                                                                      ? FFAppState()
                                                                          .contratacaoFranquado
                                                                          .cpfResponsavel
                                                                      : FFAppState()
                                                                          .contratacaoFranquado
                                                                          .cnpjConta,
                                                                  telefone: FFAppState()
                                                                      .contratacaoFranquado
                                                                      .telefone,
                                                                  endereco: FFAppState()
                                                                      .contratacaoFranquado
                                                                      .endereco,
                                                                  numero: FFAppState()
                                                                      .contratacaoFranquado
                                                                      .numero,
                                                                  bairro: FFAppState()
                                                                      .contratacaoFranquado
                                                                      .bairro,
                                                                  cep: FFAppState()
                                                                      .contratacaoFranquado
                                                                      .cep,
                                                                  tipoempresa: FFAppState()
                                                                              .contratacaoFranquado
                                                                              .tipoCadastro ==
                                                                          'Pessoa Física'
                                                                      ? 'Física'
                                                                      : 'LIMITED',
                                                                );

                                                                if ((_model
                                                                        .subConta
                                                                        ?.succeeded ??
                                                                    true)) {
                                                                  await FranquiasTable()
                                                                      .update(
                                                                    data: {
                                                                      'wallet_id': AsaasGroup
                                                                          .criarSubcontaFranquiaCall
                                                                          .walletid(
                                                                        (_model.subConta?.jsonBody ??
                                                                            ''),
                                                                      ),
                                                                    },
                                                                    matchingRows:
                                                                        (rows) =>
                                                                            rows.eqOrNull(
                                                                      'id',
                                                                      FFAppState()
                                                                          .contratacaoFranquado
                                                                          .idFranquiaCriada,
                                                                    ),
                                                                  );

                                                                  context.pushNamed(
                                                                      DashboardWidget
                                                                          .routeName);
                                                                } else {
                                                                  await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (alertDialogContext) {
                                                                      return WebViewAware(
                                                                        child:
                                                                            AlertDialog(
                                                                          content:
                                                                              Text((_model.subConta?.bodyText ?? '')),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                }
                                                              } else {
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (alertDialogContext) {
                                                                    return WebViewAware(
                                                                      child:
                                                                          AlertDialog(
                                                                        title: Text(
                                                                            'Revise os dados e tente novamente'),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                            child:
                                                                                Text('Ok'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            }

                                                            safeSetState(() {});
                                                          },
                                                          text:
                                                              'Já fiz o pagamento',
                                                          options:
                                                              FFButtonOptions(
                                                            width:
                                                                double.infinity,
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        0.0,
                                                                        16.0,
                                                                        0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                            elevation: 0.0,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                ].divide(
                                                    SizedBox(height: 10.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (FFAppState()
                                              .contratacaoFranquado
                                              .formaPagamento ==
                                          'Cartao')
                                        Material(
                                          color: Colors.transparent,
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(20.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: FFAppState()
                                                              .contratacaoFranquado
                                                              .parcelas
                                                              .toString(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleSmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                        TextSpan(
                                                          text: 'x de ',
                                                          style: TextStyle(),
                                                        ),
                                                        TextSpan(
                                                          text: formatNumber(
                                                            FFAppState()
                                                                .contratacaoFranquado
                                                                .valorParcela,
                                                            formatType:
                                                                FormatType
                                                                    .decimal,
                                                            decimalType:
                                                                DecimalType
                                                                    .commaDecimal,
                                                            currency: 'R\$',
                                                          ),
                                                          style: TextStyle(),
                                                        )
                                                      ],
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ),
                                                  RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'total ',
                                                          style: TextStyle(
                                                            fontSize: 10.0,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: formatNumber(
                                                            FFAppState()
                                                                .contratacaoFranquado
                                                                .valor,
                                                            formatType:
                                                                FormatType
                                                                    .decimal,
                                                            decimalType:
                                                                DecimalType
                                                                    .commaDecimal,
                                                            currency: 'R\$',
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 10.0,
                                                          ),
                                                        )
                                                      ],
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(16.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            12.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: [
                                                            Text(
                                                              'Dados do cartão',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    fontSize:
                                                                        18.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Nome',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  TextFormField(
                                                                controller: _model
                                                                    .txNomecartTextController,
                                                                focusNode: _model
                                                                    .txNomecartFocusNode,
                                                                autofocus: true,
                                                                autofillHints: [
                                                                  AutofillHints
                                                                      .email
                                                                ],
                                                                obscureText:
                                                                    false,
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  errorBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  focusedErrorBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  filled: true,
                                                                  fillColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              22.0),
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                cursorColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                validator: _model
                                                                    .txNomecartTextControllerValidator
                                                                    .asValidator(
                                                                        context),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Número do Cartão',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  TextFormField(
                                                                controller: _model
                                                                    .txNumcartTextController,
                                                                focusNode: _model
                                                                    .txNumcartFocusNode,
                                                                autofocus: true,
                                                                autofillHints: [
                                                                  AutofillHints
                                                                      .email
                                                                ],
                                                                obscureText:
                                                                    false,
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  errorBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  focusedErrorBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  filled: true,
                                                                  fillColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              22.0),
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                cursorColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                validator: _model
                                                                    .txNumcartTextControllerValidator
                                                                    .asValidator(
                                                                        context),
                                                                inputFormatters: [
                                                                  _model
                                                                      .txNumcartMask
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.3,
                                                                    decoration:
                                                                        BoxDecoration(),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              -1.0,
                                                                              0.0),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                8.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'Mês Expira',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    font: GoogleFonts.inter(
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    ),
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                _model.txMesTextController,
                                                                            focusNode:
                                                                                _model.txMesFocusNode,
                                                                            autofocus:
                                                                                true,
                                                                            autofillHints: [
                                                                              AutofillHints.email
                                                                            ],
                                                                            obscureText:
                                                                                false,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    font: GoogleFonts.inter(
                                                                                      fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                                    ),
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                                  ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              errorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              filled: true,
                                                                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              contentPadding: EdgeInsets.all(22.0),
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  font: GoogleFonts.inter(
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                            cursorColor:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            validator:
                                                                                _model.txMesTextControllerValidator.asValidator(context),
                                                                            inputFormatters: [
                                                                              _model.txMesMask
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              -1.0,
                                                                              0.0),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                8.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'Ano Expira',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    font: GoogleFonts.inter(
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    ),
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                _model.txAnoTextController,
                                                                            focusNode:
                                                                                _model.txAnoFocusNode,
                                                                            autofocus:
                                                                                true,
                                                                            autofillHints: [
                                                                              AutofillHints.email
                                                                            ],
                                                                            obscureText:
                                                                                false,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    font: GoogleFonts.inter(
                                                                                      fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                                    ),
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                                  ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              errorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              filled: true,
                                                                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              contentPadding: EdgeInsets.all(22.0),
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  font: GoogleFonts.inter(
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                            cursorColor:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            validator:
                                                                                _model.txAnoTextControllerValidator.asValidator(context),
                                                                            inputFormatters: [
                                                                              _model.txAnoMask
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              -1.0,
                                                                              0.0),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                8.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'CVV',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    font: GoogleFonts.inter(
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    ),
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                _model.txCvvTextController,
                                                                            focusNode:
                                                                                _model.txCvvFocusNode,
                                                                            autofocus:
                                                                                true,
                                                                            obscureText:
                                                                                false,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    font: GoogleFonts.inter(
                                                                                      fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                                    ),
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                                  ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              errorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              filled: true,
                                                                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              contentPadding: EdgeInsets.all(22.0),
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  font: GoogleFonts.inter(
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                            cursorColor:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            validator:
                                                                                _model.txCvvTextControllerValidator.asValidator(context),
                                                                            inputFormatters: [
                                                                              _model.txCvvMask
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  width: 12.0)),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'CPF ou CNPJ dono do cartão',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  TextFormField(
                                                                controller: _model
                                                                    .txCpfTextController,
                                                                focusNode: _model
                                                                    .txCpfFocusNode,
                                                                autofocus: true,
                                                                obscureText:
                                                                    false,
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  errorBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  focusedErrorBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  filled: true,
                                                                  fillColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              22.0),
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                cursorColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                validator: _model
                                                                    .txCpfTextControllerValidator
                                                                    .asValidator(
                                                                        context),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  FFButtonWidget(
                                                    onPressed: () async {
                                                      _model.apiResult5t0 =
                                                          await AsaasGroup
                                                              .criarClienteCall
                                                              .call(
                                                        nome: FFAppState()
                                                            .contratacaoFranquado
                                                            .nomeResponsavel,
                                                        cpf: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .tipoCadastro ==
                                                                'Pessoa Física'
                                                            ? FFAppState()
                                                                .contratacaoFranquado
                                                                .cpfResponsavel
                                                            : FFAppState()
                                                                .contratacaoFranquado
                                                                .cnpjConta,
                                                        email: FFAppState()
                                                            .contratacaoFranquado
                                                            .emailResponsavel,
                                                      );

                                                      if ((_model.apiResult5t0
                                                              ?.succeeded ??
                                                          true)) {
                                                        if (widget!.indication !=
                                                                null &&
                                                            widget!.indication !=
                                                                '') {
                                                          _model.franquiaIndicadora =
                                                              await FranquiasTable()
                                                                  .queryRows(
                                                            queryFn: (q) =>
                                                                q.eqOrNull(
                                                              'id',
                                                              widget!
                                                                  .indication,
                                                            ),
                                                          );
                                                          _model.ipCliente =
                                                              await BuscarIPCall
                                                                  .call();

                                                          _model.apiCobCARTSplit =
                                                              await AsaasGroup
                                                                  .criarCobrancaCartaoComSplitCall
                                                                  .call(
                                                            clienteid: AsaasGroup
                                                                .criarClienteCall
                                                                .idcliente(
                                                              (_model.apiResult5t0
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            ),
                                                            valortotal: FFAppState()
                                                                .contratacaoFranquado
                                                                .valor,
                                                            datacobranca:
                                                                dateTimeFormat(
                                                              "yyyy-M-dd",
                                                              getCurrentTimestamp,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ),
                                                            valorsplit: 50.0,
                                                            walletIndicacao: _model
                                                                .franquiaIndicadora
                                                                ?.firstOrNull
                                                                ?.walletId,
                                                            nomecartao: _model
                                                                .txNomecartTextController
                                                                .text,
                                                            numerocartao: _model
                                                                .txNumcartTextController
                                                                .text,
                                                            mesexpiracao: _model
                                                                .txMesTextController
                                                                .text,
                                                            anoexpira:
                                                                '20${_model.txAnoTextController.text}',
                                                            cvv: _model
                                                                .txCvvTextController
                                                                .text,
                                                            ip: BuscarIPCall.ip(
                                                              (_model.ipCliente
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            ).toString(),
                                                            nome: FFAppState()
                                                                .contratacaoFranquado
                                                                .nomeResponsavel,
                                                            email: FFAppState()
                                                                .contratacaoFranquado
                                                                .emailResponsavel,
                                                            cpf: _model
                                                                .txCpfTextController
                                                                .text,
                                                            telefone: FFAppState()
                                                                .contratacaoFranquado
                                                                .telefone,
                                                            cep: FFAppState()
                                                                .contratacaoFranquado
                                                                .cep,
                                                            endereco: FFAppState()
                                                                .contratacaoFranquado
                                                                .endereco,
                                                            numero: FFAppState()
                                                                .contratacaoFranquado
                                                                .numero,
                                                            bairro: FFAppState()
                                                                .contratacaoFranquado
                                                                .bairro,
                                                            parcelas: FFAppState()
                                                                .contratacaoFranquado
                                                                .parcelas,
                                                            valorParcela: FFAppState()
                                                                .contratacaoFranquado
                                                                .valorParcela,
                                                          );

                                                          if ((_model
                                                                  .apiCobCARTSplit
                                                                  ?.succeeded ??
                                                              true)) {
                                                            FFAppState()
                                                                .updateContratacaoFranquadoStruct(
                                                              (e) => e
                                                                ..status = AsaasGroup
                                                                    .criarCobrancaCartaoComSplitCall
                                                                    .statuspix(
                                                                      (_model.apiCobCARTSplit
                                                                              ?.jsonBody ??
                                                                          ''),
                                                                    )
                                                                    .toString(),
                                                            );
                                                            safeSetState(() {});
                                                            if ((FFAppState()
                                                                        .contratacaoFranquado
                                                                        .status ==
                                                                    'CONFIRMED') ||
                                                                (FFAppState()
                                                                        .contratacaoFranquado
                                                                        .status ==
                                                                    'RECEIVED')) {
                                                              await FranquiasTable()
                                                                  .update(
                                                                data: {
                                                                  'status_franquia':
                                                                      true,
                                                                },
                                                                matchingRows:
                                                                    (rows) => rows
                                                                        .eqOrNull(
                                                                  'id',
                                                                  FFAppState()
                                                                      .contratacaoFranquado
                                                                      .idFranquiaCriada,
                                                                ),
                                                              );
                                                              await CobrancasTable()
                                                                  .update(
                                                                data: {
                                                                  'forma_pagamento':
                                                                      'Cartão',
                                                                  'status_cobranca': AsaasGroup
                                                                      .criarCobrancaCartaoComSplitCall
                                                                      .statuspix(
                                                                        (_model.apiCobCARTSplit?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString(),
                                                                  'id_cobranca_asaas': AsaasGroup
                                                                      .criarCobrancaCartaoComSplitCall
                                                                      .idpagamento(
                                                                        (_model.apiCobCARTSplit?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString(),
                                                                },
                                                                matchingRows:
                                                                    (rows) => rows
                                                                        .eqOrNull(
                                                                  'id',
                                                                  widget!
                                                                      .idCobranca,
                                                                ),
                                                              );
                                                              _model.subConta1 =
                                                                  await AsaasGroup
                                                                      .criarSubcontaFranquiaCall
                                                                      .call(
                                                                nome: FFAppState()
                                                                            .contratacaoFranquado
                                                                            .tipoCadastro ==
                                                                        'Pessoa Física'
                                                                    ? FFAppState()
                                                                        .contratacaoFranquado
                                                                        .nomeResponsavel
                                                                    : FFAppState()
                                                                        .contratacaoFranquado
                                                                        .razaoSocial,
                                                                email: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .emailResponsavel,
                                                                cpfcnpj: FFAppState()
                                                                            .contratacaoFranquado
                                                                            .tipoCadastro ==
                                                                        'Pessoa Física'
                                                                    ? FFAppState()
                                                                        .contratacaoFranquado
                                                                        .cpfResponsavel
                                                                    : FFAppState()
                                                                        .contratacaoFranquado
                                                                        .cnpjConta,
                                                                telefone: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .telefone,
                                                                endereco: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .endereco,
                                                                numero: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .numero,
                                                                bairro: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .bairro,
                                                                cep: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .cep,
                                                                tipoempresa: FFAppState()
                                                                            .contratacaoFranquado
                                                                            .tipoCadastro ==
                                                                        'Pessoa Física'
                                                                    ? 'Física'
                                                                    : 'LIMITED',
                                                              );

                                                              if ((_model
                                                                      .subConta1
                                                                      ?.succeeded ??
                                                                  true)) {
                                                                await FranquiasTable()
                                                                    .update(
                                                                  data: {
                                                                    'wallet_id':
                                                                        AsaasGroup
                                                                            .criarSubcontaFranquiaCall
                                                                            .walletid(
                                                                      (_model.subConta1
                                                                              ?.jsonBody ??
                                                                          ''),
                                                                    ),
                                                                  },
                                                                  matchingRows:
                                                                      (rows) =>
                                                                          rows.eqOrNull(
                                                                    'id',
                                                                    FFAppState()
                                                                        .contratacaoFranquado
                                                                        .idFranquiaCriada,
                                                                  ),
                                                                );
                                                                FFAppState()
                                                                        .idfranquia =
                                                                    FFAppState()
                                                                        .contratacaoFranquado
                                                                        .idFranquiaCriada;
                                                                safeSetState(
                                                                    () {});

                                                                context.pushNamed(
                                                                    DashboardWidget
                                                                        .routeName);
                                                              } else {
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (alertDialogContext) {
                                                                    return WebViewAware(
                                                                      child:
                                                                          AlertDialog(
                                                                        content:
                                                                            Text((_model.subConta1?.bodyText ??
                                                                                '')),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                            child:
                                                                                Text('Ok'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            } else {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (alertDialogContext) {
                                                                  return WebViewAware(
                                                                    child:
                                                                        AlertDialog(
                                                                      title: Text(
                                                                          'Revise os dados e tente novamente'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                          child:
                                                                              Text('Ok'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          } else {
                                                            await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return WebViewAware(
                                                                  child:
                                                                      AlertDialog(
                                                                    title: Text(
                                                                        'Criar cobranca'),
                                                                    content: Text((_model
                                                                            .apiCobCARTSplit
                                                                            ?.bodyText ??
                                                                        '')),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                        child: Text(
                                                                            'Ok'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          }
                                                        } else {
                                                          _model.ipClienteSIMPL =
                                                              await BuscarIPCall
                                                                  .call();

                                                          _model.apiCobCARTSemSplit =
                                                              await AsaasGroup
                                                                  .criarCobrancaCartaoSemSplitCall
                                                                  .call(
                                                            clienteid: AsaasGroup
                                                                .criarClienteCall
                                                                .idcliente(
                                                              (_model.apiResult5t0
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            ),
                                                            valortotal: FFAppState()
                                                                .contratacaoFranquado
                                                                .valor,
                                                            datacobranca:
                                                                dateTimeFormat(
                                                              "yyyy-M-dd",
                                                              getCurrentTimestamp,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ),
                                                            nomecartao: _model
                                                                .txNomecartTextController
                                                                .text,
                                                            numerocartao: _model
                                                                .txNumcartTextController
                                                                .text,
                                                            mesexpiracao: _model
                                                                .txMesTextController
                                                                .text,
                                                            anoexpira: _model
                                                                .txAnoTextController
                                                                .text,
                                                            cvv: _model
                                                                .txCvvTextController
                                                                .text,
                                                            ip: BuscarIPCall.ip(
                                                              (_model.ipClienteSIMPL
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            ).toString(),
                                                            nome: FFAppState()
                                                                .contratacaoFranquado
                                                                .nomeResponsavel,
                                                            email: FFAppState()
                                                                .contratacaoFranquado
                                                                .emailResponsavel,
                                                            cpf: _model
                                                                .txCpfTextController
                                                                .text,
                                                            telefone: FFAppState()
                                                                .contratacaoFranquado
                                                                .telefone,
                                                            cep: FFAppState()
                                                                .contratacaoFranquado
                                                                .cep,
                                                            endereco: FFAppState()
                                                                .contratacaoFranquado
                                                                .endereco,
                                                            numero: FFAppState()
                                                                .contratacaoFranquado
                                                                .numero,
                                                            bairro: FFAppState()
                                                                .contratacaoFranquado
                                                                .bairro,
                                                            parcelas: FFAppState()
                                                                .contratacaoFranquado
                                                                .parcelas,
                                                            valorParcela: FFAppState()
                                                                .contratacaoFranquado
                                                                .valorParcela,
                                                          );

                                                          if ((_model
                                                                  .apiCobCARTSemSplit
                                                                  ?.succeeded ??
                                                              true)) {
                                                            FFAppState()
                                                                .updateContratacaoFranquadoStruct(
                                                              (e) => e
                                                                ..status = AsaasGroup
                                                                    .criarCobrancaCartaoSemSplitCall
                                                                    .statuspix(
                                                                      (_model.apiCobCARTSemSplit
                                                                              ?.jsonBody ??
                                                                          ''),
                                                                    )
                                                                    .toString(),
                                                            );
                                                            safeSetState(() {});
                                                            if ((FFAppState()
                                                                        .contratacaoFranquado
                                                                        .status ==
                                                                    'CONFIRMED') ||
                                                                (FFAppState()
                                                                        .contratacaoFranquado
                                                                        .status ==
                                                                    'RECEIVED')) {
                                                              await FranquiasTable()
                                                                  .update(
                                                                data: {
                                                                  'status_franquia':
                                                                      true,
                                                                },
                                                                matchingRows:
                                                                    (rows) => rows
                                                                        .eqOrNull(
                                                                  'id',
                                                                  FFAppState()
                                                                      .contratacaoFranquado
                                                                      .idFranquiaCriada,
                                                                ),
                                                              );
                                                              await CobrancasTable()
                                                                  .update(
                                                                data: {
                                                                  'forma_pagamento':
                                                                      'Cartão',
                                                                  'status_cobranca': AsaasGroup
                                                                      .criarCobrancaCartaoSemSplitCall
                                                                      .statuspix(
                                                                        (_model.apiCobCARTSemSplit?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString(),
                                                                  'id_cobranca_asaas': AsaasGroup
                                                                      .criarCobrancaCartaoSemSplitCall
                                                                      .idpagamento(
                                                                        (_model.apiCobCARTSemSplit?.jsonBody ??
                                                                            ''),
                                                                      )
                                                                      .toString(),
                                                                },
                                                                matchingRows:
                                                                    (rows) => rows
                                                                        .eqOrNull(
                                                                  'id',
                                                                  widget!
                                                                      .idCobranca,
                                                                ),
                                                              );
                                                              _model.subConta2 =
                                                                  await AsaasGroup
                                                                      .criarSubcontaFranquiaCall
                                                                      .call(
                                                                nome: FFAppState()
                                                                            .contratacaoFranquado
                                                                            .tipoCadastro ==
                                                                        'Pessoa Física'
                                                                    ? FFAppState()
                                                                        .contratacaoFranquado
                                                                        .nomeResponsavel
                                                                    : FFAppState()
                                                                        .contratacaoFranquado
                                                                        .razaoSocial,
                                                                email: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .emailResponsavel,
                                                                cpfcnpj: FFAppState()
                                                                            .contratacaoFranquado
                                                                            .tipoCadastro ==
                                                                        'Pessoa Física'
                                                                    ? FFAppState()
                                                                        .contratacaoFranquado
                                                                        .cpfResponsavel
                                                                    : FFAppState()
                                                                        .contratacaoFranquado
                                                                        .cnpjConta,
                                                                telefone: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .telefone,
                                                                endereco: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .endereco,
                                                                numero: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .numero,
                                                                bairro: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .bairro,
                                                                cep: FFAppState()
                                                                    .contratacaoFranquado
                                                                    .cep,
                                                                tipoempresa: FFAppState()
                                                                            .contratacaoFranquado
                                                                            .tipoCadastro ==
                                                                        'Pessoa Física'
                                                                    ? 'Física'
                                                                    : 'LIMITED',
                                                              );

                                                              if ((_model
                                                                      .subConta2
                                                                      ?.succeeded ??
                                                                  true)) {
                                                                await FranquiasTable()
                                                                    .update(
                                                                  data: {
                                                                    'wallet_id':
                                                                        AsaasGroup
                                                                            .criarSubcontaFranquiaCall
                                                                            .walletid(
                                                                      (_model.subConta2
                                                                              ?.jsonBody ??
                                                                          ''),
                                                                    ),
                                                                  },
                                                                  matchingRows:
                                                                      (rows) =>
                                                                          rows.eqOrNull(
                                                                    'id',
                                                                    FFAppState()
                                                                        .contratacaoFranquado
                                                                        .idFranquiaCriada,
                                                                  ),
                                                                );
                                                                FFAppState()
                                                                        .idfranquia =
                                                                    FFAppState()
                                                                        .contratacaoFranquado
                                                                        .idFranquiaCriada;
                                                                safeSetState(
                                                                    () {});

                                                                context.pushNamed(
                                                                    DashboardWidget
                                                                        .routeName);
                                                              } else {
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (alertDialogContext) {
                                                                    return WebViewAware(
                                                                      child:
                                                                          AlertDialog(
                                                                        content:
                                                                            Text((_model.subConta2?.bodyText ??
                                                                                '')),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                            child:
                                                                                Text('Ok'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            } else {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (alertDialogContext) {
                                                                  return WebViewAware(
                                                                    child:
                                                                        AlertDialog(
                                                                      title: Text(
                                                                          'Revise os dados e tente novamente'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                          child:
                                                                              Text('Ok'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          } else {
                                                            await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return WebViewAware(
                                                                  child:
                                                                      AlertDialog(
                                                                    content: Text((_model
                                                                            .apiCobCARTSemSplit
                                                                            ?.bodyText ??
                                                                        '')),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                        child: Text(
                                                                            'Ok'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          }
                                                        }
                                                      } else {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return WebViewAware(
                                                              child:
                                                                  AlertDialog(
                                                                title: Text(
                                                                    'Criar cliente'),
                                                                content: Text((_model
                                                                        .apiResult5t0
                                                                        ?.bodyText ??
                                                                    '')),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext),
                                                                    child: Text(
                                                                        'Ok'),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }

                                                      safeSetState(() {});
                                                    },
                                                    text: 'Pagar',
                                                    options: FFButtonOptions(
                                                      width: double.infinity,
                                                      height: 40.0,
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                      iconPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                      elevation: 0.0,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ].divide(
                                                    SizedBox(height: 10.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 40.0, 0.0, 0.0),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 12.0)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (responsiveVisibility(
                context: context,
                phone: false,
                tablet: false,
              ))
                Expanded(
                  flex: 8,
                  child: Container(
                    width: 100.0,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset(
                          'assets/images/bannerlogin.png',
                        ).image,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
