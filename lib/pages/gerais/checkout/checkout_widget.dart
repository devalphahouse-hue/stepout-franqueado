import 'dart:convert';

import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _processing = false;

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
    _model.txNumcartMask =
        MaskTextInputFormatter(mask: '#### #### #### ####');

    _model.txMesTextController ??= TextEditingController();
    _model.txMesFocusNode ??= FocusNode();
    _model.txMesMask = MaskTextInputFormatter(mask: '##');

    _model.txAnoTextController ??= TextEditingController();
    _model.txAnoFocusNode ??= FocusNode();
    _model.txAnoMask = MaskTextInputFormatter(mask: '####');

    _model.txCvvTextController ??= TextEditingController();
    _model.txCvvFocusNode ??= FocusNode();
    _model.txCvvMask = MaskTextInputFormatter(mask: '####');

    _model.txCpfTextController ??= TextEditingController();
    _model.txCpfFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _formatBRL(double? valor) {
    if (valor == null) return 'R\$ 0,00';
    final s = valor.toStringAsFixed(2).replaceAll('.', ',');
    final parts = s.split(',');
    final integer = parts[0]
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return 'R\$ $integer,${parts[1]}';
  }

  List<String> _parseAsaasErrors(String? body) {
    final fallback = [
      'Não foi possível processar o pagamento. Verifique os dados do cartão e tente novamente.'
    ];
    if (body == null || body.trim().isEmpty) return fallback;
    try {
      final parsed = jsonDecode(body);
      if (parsed is Map && parsed['errors'] is List) {
        final list = (parsed['errors'] as List)
            .map((e) {
              if (e is Map && e['description'] is String) {
                return (e['description'] as String).trim();
              }
              return '';
            })
            .where((s) => s.isNotEmpty)
            .toList();
        if (list.isNotEmpty) return list;
      }
      if (parsed is Map && parsed['message'] is String) {
        return [parsed['message'] as String];
      }
    } catch (_) {}
    return fallback;
  }

  Future<void> _showErrorsDialog({
    required String title,
    required List<String> errors,
  }) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (dialogCtx) => _ErrorDialog(title: title, errors: errors),
    );
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return 'Informe $label.';
    return null;
  }

  Future<void> _onPay() async {
    if (_processing) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    safeSetState(() => _processing = true);
    try {
      _model.apiResult5t0 = await AsaasGroup.criarClienteCall.call(
        nome: FFAppState().contratacaoFranquado.nomeResponsavel,
        cpf: FFAppState().contratacaoFranquado.tipoCadastro == 'Pessoa Física'
            ? FFAppState().contratacaoFranquado.cpfResponsavel
            : FFAppState().contratacaoFranquado.cnpjConta,
        email: FFAppState().contratacaoFranquado.emailResponsavel,
      );

      if (!(_model.apiResult5t0?.succeeded ?? false)) {
        await _showErrorsDialog(
          title: 'Não conseguimos criar o cadastro',
          errors: _parseAsaasErrors(_model.apiResult5t0?.bodyText),
        );
        return;
      }

      final hasIndication =
          widget.indication != null && widget.indication!.isNotEmpty;

      ApiCallResponse? cobResp;

      if (hasIndication) {
        _model.franquiaIndicadora = await FranquiasTable().queryRows(
          queryFn: (q) => q.eqOrNull('id', widget.indication),
        );
        _model.ipCliente = await BuscarIPCall.call();

        _model.apiCobCARTSplit =
            await AsaasGroup.criarCobrancaCartaoComSplitCall.call(
          clienteid: AsaasGroup.criarClienteCall
              .idcliente(_model.apiResult5t0?.jsonBody ?? ''),
          valortotal: FFAppState().contratacaoFranquado.valor,
          datacobranca: dateTimeFormat(
            'yyyy-M-dd',
            getCurrentTimestamp,
            locale: FFLocalizations.of(context).languageCode,
          ),
          valorsplit: 50.0,
          walletIndicacao:
              _model.franquiaIndicadora?.firstOrNull?.walletId,
          nomecartao: _model.txNomecartTextController.text,
          numerocartao: _model.txNumcartTextController.text,
          mesexpiracao: _model.txMesTextController.text,
          anoexpira: _model.txAnoTextController.text,
          cvv: _model.txCvvTextController.text,
          ip: BuscarIPCall.ip(_model.ipCliente?.jsonBody ?? '').toString(),
          nome: FFAppState().contratacaoFranquado.nomeResponsavel,
          email: FFAppState().contratacaoFranquado.emailResponsavel,
          cpf: _model.txCpfTextController.text,
          telefone: FFAppState().contratacaoFranquado.telefone,
          cep: FFAppState().contratacaoFranquado.cep,
          endereco: FFAppState().contratacaoFranquado.endereco,
          numero: FFAppState().contratacaoFranquado.numero,
          bairro: FFAppState().contratacaoFranquado.bairro,
          parcelas: FFAppState().contratacaoFranquado.parcelas,
          valorParcela: FFAppState().contratacaoFranquado.valorParcela,
          idcobranca: widget.idCobranca,
        );
        cobResp = _model.apiCobCARTSplit;
      } else {
        _model.ipClienteSIMPL = await BuscarIPCall.call();

        _model.apiCobCARTSemSplit =
            await AsaasGroup.criarCobrancaCartaoSemSplitCall.call(
          clienteid: AsaasGroup.criarClienteCall
              .idcliente(_model.apiResult5t0?.jsonBody ?? ''),
          valortotal: FFAppState().contratacaoFranquado.valor,
          datacobranca: dateTimeFormat(
            'yyyy-M-dd',
            getCurrentTimestamp,
            locale: FFLocalizations.of(context).languageCode,
          ),
          nomecartao: _model.txNomecartTextController.text,
          numerocartao: _model.txNumcartTextController.text,
          mesexpiracao: _model.txMesTextController.text,
          anoexpira: _model.txAnoTextController.text,
          cvv: _model.txCvvTextController.text,
          ip: BuscarIPCall.ip(_model.ipClienteSIMPL?.jsonBody ?? '')
              .toString(),
          nome: FFAppState().contratacaoFranquado.nomeResponsavel,
          email: FFAppState().contratacaoFranquado.emailResponsavel,
          cpf: _model.txCpfTextController.text,
          telefone: FFAppState().contratacaoFranquado.telefone,
          cep: FFAppState().contratacaoFranquado.cep,
          endereco: FFAppState().contratacaoFranquado.endereco,
          numero: FFAppState().contratacaoFranquado.numero,
          bairro: FFAppState().contratacaoFranquado.bairro,
          parcelas: FFAppState().contratacaoFranquado.parcelas,
          valorParcela: FFAppState().contratacaoFranquado.valorParcela,
          idcobranca: widget.idCobranca,
        );
        cobResp = _model.apiCobCARTSemSplit;
      }

      if (!(cobResp?.succeeded ?? false)) {
        await _showErrorsDialog(
          title: 'Não conseguimos processar o pagamento',
          errors: _parseAsaasErrors(cobResp?.bodyText),
        );
        return;
      }

      final body = cobResp?.jsonBody ?? '';
      final status = hasIndication
          ? AsaasGroup.criarCobrancaCartaoComSplitCall.statuspix(body)
          : AsaasGroup.criarCobrancaCartaoSemSplitCall.statuspix(body);
      final idPagamento = hasIndication
          ? AsaasGroup.criarCobrancaCartaoComSplitCall.idpagamento(body)
          : AsaasGroup.criarCobrancaCartaoSemSplitCall.idpagamento(body);

      FFAppState().updateContratacaoFranquadoStruct(
        (e) => e..status = status?.toString() ?? '',
      );
      safeSetState(() {});

      final isApproved = FFAppState().contratacaoFranquado.status ==
              'CONFIRMED' ||
          FFAppState().contratacaoFranquado.status == 'RECEIVED';

      if (!isApproved) {
        await _showErrorsDialog(
          title: 'Pagamento não aprovado',
          errors: const [
            'Revise os dados do cartão e tente novamente. Se o problema persistir, entre em contato com a sua operadora.'
          ],
        );
        return;
      }

      await FranquiasTable().update(
        data: {'status_franquia': true},
        matchingRows: (rows) => rows.eqOrNull(
          'id',
          FFAppState().contratacaoFranquado.idFranquiaCriada,
        ),
      );
      await CobrancasTable().update(
        data: {
          'forma_pagamento': 'Cartão',
          'status_cobranca': status?.toString() ?? '',
          'id_cobranca_asaas': idPagamento?.toString() ?? '',
        },
        matchingRows: (rows) => rows.eqOrNull('id', widget.idCobranca),
      );

      final subResp = await AsaasGroup.criarSubcontaFranquiaCall.call(
        nome: FFAppState().contratacaoFranquado.tipoCadastro == 'Pessoa Física'
            ? FFAppState().contratacaoFranquado.nomeResponsavel
            : FFAppState().contratacaoFranquado.razaoSocial,
        email: FFAppState().contratacaoFranquado.emailResponsavel,
        cpfcnpj: FFAppState().contratacaoFranquado.tipoCadastro ==
                'Pessoa Física'
            ? FFAppState().contratacaoFranquado.cpfResponsavel
            : FFAppState().contratacaoFranquado.cnpjConta,
        telefone: FFAppState().contratacaoFranquado.telefone,
        endereco: FFAppState().contratacaoFranquado.endereco,
        numero: FFAppState().contratacaoFranquado.numero,
        bairro: FFAppState().contratacaoFranquado.bairro,
        cep: FFAppState().contratacaoFranquado.cep,
        tipoempresa:
            FFAppState().contratacaoFranquado.tipoCadastro == 'Pessoa Física'
                ? 'Física'
                : 'LIMITED',
      );
      if (hasIndication) {
        _model.subConta1 = subResp;
      } else {
        _model.subConta2 = subResp;
      }

      if (!(subResp.succeeded)) {
        await _showErrorsDialog(
          title: 'Pagamento aprovado, ativação pendente',
          errors: _parseAsaasErrors(subResp.bodyText),
        );
        return;
      }

      await FranquiasTable().update(
        data: {
          'wallet_id': AsaasGroup.criarSubcontaFranquiaCall
              .walletid(subResp.jsonBody ?? ''),
        },
        matchingRows: (rows) => rows.eqOrNull(
          'id',
          FFAppState().contratacaoFranquado.idFranquiaCriada,
        ),
      );
      FFAppState().idfranquia =
          FFAppState().contratacaoFranquado.idFranquiaCriada;
      safeSetState(() {});

      if (!mounted) return;
      context.pushNamed(CompraConfirmadaWidget.routeName);
    } finally {
      if (mounted) safeSetState(() => _processing = false);
    }
  }

  void _onBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.goNamed(PlanosWidget.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final showHero = width >= kBreakpointMedium;
    final isCompact = width < kBreakpointSmall;

    final valor = FFAppState().contratacaoFranquado.valor;
    final parcelas = FFAppState().contratacaoFranquado.parcelas;
    final valorParcela = FFAppState().contratacaoFranquado.valorParcela;
    final tipoCadastro = FFAppState().contratacaoFranquado.tipoCadastro;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.secondaryBackground,
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: _CheckoutFormPanel(
                  isCompact: isCompact,
                  formKey: _formKey,
                  onBack: _onBack,
                  onPay: _onPay,
                  processing: _processing,
                  valor: valor,
                  parcelas: parcelas,
                  valorParcela: valorParcela,
                  tipoCadastro: tipoCadastro,
                  formatBRL: _formatBRL,
                  required: _required,
                  model: _model,
                ),
              ),
              if (showHero)
                const Expanded(
                  flex: 1,
                  child: _CheckoutHeroPanel(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutFormPanel extends StatelessWidget {
  const _CheckoutFormPanel({
    required this.isCompact,
    required this.formKey,
    required this.onBack,
    required this.onPay,
    required this.processing,
    required this.valor,
    required this.parcelas,
    required this.valorParcela,
    required this.tipoCadastro,
    required this.formatBRL,
    required this.required,
    required this.model,
  });

  final bool isCompact;
  final GlobalKey<FormState> formKey;
  final VoidCallback onBack;
  final VoidCallback onPay;
  final bool processing;
  final double? valor;
  final int? parcelas;
  final double? valorParcela;
  final String? tipoCadastro;
  final String Function(double?) formatBRL;
  final String? Function(String?, String) required;
  final CheckoutModel model;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      color: theme.secondaryBackground,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16.0 : 32.0,
            vertical: isCompact ? 16.0 : 32.0,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480.0),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _BackPill(onTap: onBack),
                      const SizedBox(width: 14.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Pagamento',
                              style: theme.headlineMedium.override(
                                font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w800),
                                fontSize: 24.0,
                                fontWeight: FontWeight.w800,
                                color: theme.primaryText,
                                letterSpacing: 0.0,
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              'Conclua a contratação da sua franquia.',
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(),
                                fontSize: 13.5,
                                color: theme.secondaryText,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  _ResumoCard(
                    valor: valor,
                    parcelas: parcelas,
                    valorParcela: valorParcela,
                    tipoCadastro: tipoCadastro,
                    formatBRL: formatBRL,
                  ),
                  const SizedBox(height: 16.0),
                  _SectionCard(
                    icon: Icons.credit_card_rounded,
                    title: 'Forma de pagamento',
                    subtitle: 'Pagamento seguro processado pela Asaas.',
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12.0),
                        border:
                            Border.all(color: theme.primary, width: 1.4),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: theme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.credit_card_rounded,
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cartão de crédito',
                                  style: theme.titleSmall.override(
                                    font: GoogleFonts.interTight(
                                        fontWeight: FontWeight.w700),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: theme.primaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Visa, Mastercard, Elo, Amex e mais.',
                                  style: theme.bodySmall.override(
                                    font: GoogleFonts.inter(),
                                    fontSize: 12,
                                    color: theme.secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle_rounded,
                              color: theme.primary, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _SectionCard(
                    icon: Icons.lock_outline_rounded,
                    title: 'Dados do cartão',
                    subtitle: 'Seus dados são criptografados e seguros.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _LabeledField(
                          label: 'Nome impresso no cartão',
                          hint: 'Como aparece no cartão',
                          icon: Icons.badge_outlined,
                          controller: model.txNomecartTextController!,
                          focusNode: model.txNomecartFocusNode!,
                          textCapitalization: TextCapitalization.characters,
                          validator: (v) => required(v, 'o nome do titular'),
                        ),
                        const SizedBox(height: 8.0),
                        _LabeledField(
                          label: 'Número do cartão',
                          hint: '0000 0000 0000 0000',
                          icon: Icons.credit_card_outlined,
                          controller: model.txNumcartTextController!,
                          focusNode: model.txNumcartFocusNode!,
                          keyboardType: TextInputType.number,
                          inputFormatters: [model.txNumcartMask],
                          validator: (v) {
                            final clean = (v ?? '').replaceAll(' ', '');
                            if (clean.isEmpty) {
                              return 'Informe o número do cartão.';
                            }
                            if (clean.length < 13) {
                              return 'Número do cartão incompleto.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _LabeledField(
                                label: 'Mês',
                                hint: 'MM',
                                icon: Icons.calendar_month_outlined,
                                controller: model.txMesTextController!,
                                focusNode: model.txMesFocusNode!,
                                keyboardType: TextInputType.number,
                                inputFormatters: [model.txMesMask],
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Mês.';
                                  final n = int.tryParse(v);
                                  if (n == null || n < 1 || n > 12) {
                                    return 'Mês inválido.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: _LabeledField(
                                label: 'Ano',
                                hint: 'AAAA',
                                icon: Icons.event_outlined,
                                controller: model.txAnoTextController!,
                                focusNode: model.txAnoFocusNode!,
                                keyboardType: TextInputType.number,
                                inputFormatters: [model.txAnoMask],
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Ano.';
                                  if (v.length < 4) return 'Ano inválido.';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: _LabeledField(
                                label: 'CVV',
                                hint: '000',
                                icon: Icons.shield_outlined,
                                controller: model.txCvvTextController!,
                                focusNode: model.txCvvFocusNode!,
                                keyboardType: TextInputType.number,
                                inputFormatters: [model.txCvvMask],
                                validator: (v) {
                                  if (v == null || v.length < 3) {
                                    return 'CVV.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        _LabeledField(
                          label: tipoCadastro == 'Pessoa Jurídica'
                              ? 'CNPJ do titular'
                              : 'CPF do titular',
                          hint: tipoCadastro == 'Pessoa Jurídica'
                              ? '00.000.000/0000-00'
                              : '000.000.000-00',
                          icon: Icons.credit_card_outlined,
                          controller: model.txCpfTextController!,
                          focusNode: model.txCpfFocusNode!,
                          keyboardType: TextInputType.number,
                          validator: (v) => required(v,
                              tipoCadastro == 'Pessoa Jurídica'
                                  ? 'o CNPJ'
                                  : 'o CPF'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  _PrimaryButton(
                    label: processing
                        ? 'Processando…'
                        : 'Pagar ${formatBRL(valor)}',
                    loading: processing,
                    onTap: onPay,
                    icon: Icons.lock_rounded,
                  ),
                  const SizedBox(height: 12.0),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_user_outlined,
                            size: 14, color: theme.secondaryText),
                        const SizedBox(width: 6),
                        Text(
                          'Pagamento processado com criptografia ponta a ponta.',
                          style: theme.bodySmall.override(
                            font: GoogleFonts.inter(),
                            fontSize: 11.5,
                            color: theme.secondaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResumoCard extends StatelessWidget {
  const _ResumoCard({
    required this.valor,
    required this.parcelas,
    required this.valorParcela,
    required this.tipoCadastro,
    required this.formatBRL,
  });

  final double? valor;
  final int? parcelas;
  final double? valorParcela;
  final String? tipoCadastro;
  final String Function(double?) formatBRL;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isInstallment = (parcelas ?? 1) > 1;
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primary,
            theme.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha: 0.20),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium_rounded,
                        size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'CONTRATAÇÃO DE FRANQUIA',
                      style: theme.labelMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            isInstallment
                ? '${parcelas}x de ${formatBRL(valorParcela)}'
                : formatBRL(valor),
            style: theme.headlineLarge.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
              fontSize: 30.0,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            isInstallment
                ? 'Valor total: ${formatBRL(valor)}'
                : 'Pagamento à vista',
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              fontSize: 13.0,
              color: Colors.white.withValues(alpha: 0.92),
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 14.0),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.18)),
          const SizedBox(height: 12.0),
          Row(
            children: [
              const Icon(Icons.account_balance_outlined,
                  color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tipoCadastro == 'Pessoa Jurídica'
                      ? 'Cobrança como Pessoa Jurídica'
                      : 'Cobrança como Pessoa Física',
                  style: theme.bodySmall.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackPill extends StatefulWidget {
  const _BackPill({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_BackPill> createState() => _BackPillState();
}

class _BackPillState extends State<_BackPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            color: _hover
                ? theme.primary.withValues(alpha: 0.08)
                : theme.primaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: theme.alternate, width: 1.0),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.arrow_back_rounded,
              color: theme.primaryText, size: 20.0),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: theme.alternate, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: theme.primary, size: 20.0),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.titleMedium.override(
                        font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: theme.primaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle,
                      style: theme.bodySmall.override(
                        font: GoogleFonts.inter(),
                        fontSize: 12.5,
                        color: theme.secondaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          child,
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.focusNode,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final List<MaskTextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
          child: Text(
            label,
            style: theme.labelMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: theme.secondaryText,
              letterSpacing: 0.2,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          validator: validator,
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            fontSize: 14.5,
            color: theme.primaryText,
            letterSpacing: 0.0,
          ),
          cursorColor: theme.primary,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              fontSize: 14.5,
              color: theme.secondaryText,
              letterSpacing: 0.0,
            ),
            errorStyle: theme.bodySmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
              color: theme.error,
              letterSpacing: 0.0,
              lineHeight: 1.1,
            ),
            errorMaxLines: 1,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 10.0),
              child: Icon(icon, color: theme.secondaryText, size: 20.0),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: theme.secondaryBackground,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14.0, vertical: 14.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.alternate, width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primary, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.error, width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.error, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.label,
    required this.loading,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool loading;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final base = theme.primary;
    final bg = (_hovered || _pressed)
        ? base.withValues(alpha: 0.88)
        : base;

    return MouseRegion(
      cursor: widget.loading
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) =>
            widget.loading ? null : setState(() => _pressed = true),
        onTapUp: (_) =>
            widget.loading ? null : setState(() => _pressed = false),
        onTapCancel: () =>
            widget.loading ? null : setState(() => _pressed = false),
        onTap: widget.loading ? null : widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: 52.0,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14.0),
              boxShadow: [
                BoxShadow(
                  color: base.withValues(alpha: 0.20),
                  blurRadius: 20.0,
                  offset: const Offset(0, 8.0),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.loading)
                  const SizedBox(
                    width: 18.0,
                    height: 18.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else if (widget.icon != null)
                  Icon(widget.icon, size: 18, color: Colors.white),
                if (widget.loading || widget.icon != null)
                  const SizedBox(width: 10.0),
                Text(
                  widget.label,
                  style: theme.titleSmall.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorDialog extends StatelessWidget {
  const _ErrorDialog({required this.title, required this.errors});

  final String title;
  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(color: theme.alternate, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.error_outline_rounded,
                        color: theme.error, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.titleMedium.override(
                        font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: theme.primaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: theme.alternate, width: 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < errors.length; i++) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: theme.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              errors[i],
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(),
                                fontSize: 13.5,
                                color: theme.primaryText,
                                letterSpacing: 0.0,
                                lineHeight: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (i != errors.length - 1)
                        const SizedBox(height: 8.0),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18.0),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Entendi',
                    style: theme.titleSmall.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.2,
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

class _CheckoutHeroPanel extends StatelessWidget {
  const _CheckoutHeroPanel();

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/bannerlogin.png', fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                theme.primary.withValues(alpha: 0.55),
                theme.primary.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
        Positioned(
          left: 32.0,
          right: 32.0,
          bottom: 32.0,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 18.0, vertical: 14.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: [
                Container(
                  width: 38.0,
                  height: 38.0,
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.shield_rounded,
                    color: theme.primary,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pagamento 100% seguro',
                        style: theme.titleSmall.override(
                          font: GoogleFonts.interTight(
                              fontWeight: FontWeight.w700),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: theme.primaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Processado pela Asaas com criptografia ponta a ponta.',
                        style: theme.bodySmall.override(
                          font: GoogleFonts.inter(),
                          fontSize: 12.0,
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
