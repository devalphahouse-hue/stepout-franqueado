import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'cadastro_franquia_model.dart';
export 'cadastro_franquia_model.dart';

class CadastroFranquiaWidget extends StatefulWidget {
  const CadastroFranquiaWidget({
    super.key,
    this.indication,
  });

  final String? indication;

  static String routeName = 'CadastroFranquia';
  static String routePath = '/cadastroFranquia';

  @override
  State<CadastroFranquiaWidget> createState() => _CadastroFranquiaWidgetState();
}

class _CadastroFranquiaWidgetState extends State<CadastroFranquiaWidget> {
  late CadastroFranquiaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;
  bool _loadingCep = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CadastroFranquiaModel());

    _model.textFieldNomeTextController1 ??= TextEditingController();
    _model.textFieldNomeFocusNode1 ??= FocusNode();

    _model.textFieldEmailTextController ??= TextEditingController();
    _model.textFieldEmailFocusNode ??= FocusNode();

    _model.textFieldSenhaTextController ??= TextEditingController();
    _model.textFieldSenhaFocusNode ??= FocusNode();

    _model.textFieldSenhaConfTextController ??= TextEditingController();
    _model.textFieldSenhaConfFocusNode ??= FocusNode();

    _model.textFieldTelefoneTextController ??= TextEditingController();
    _model.textFieldTelefoneFocusNode ??= FocusNode();
    _model.textFieldTelefoneMask =
        MaskTextInputFormatter(mask: '(##) #####-####');

    _model.textFieldCPFTextController1 ??= TextEditingController();
    _model.textFieldCPFFocusNode1 ??= FocusNode();
    _model.textFieldCPFMask1 =
        MaskTextInputFormatter(mask: '###.###.###-##');

    _model.textFieldDNascTextController ??= TextEditingController();
    _model.textFieldDNascFocusNode ??= FocusNode();
    _model.textFieldDNascMask = MaskTextInputFormatter(mask: '##/##/####');

    _model.textFieldNocionTextController ??= TextEditingController();
    _model.textFieldNocionFocusNode ??= FocusNode();

    _model.textController7 ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldMask = MaskTextInputFormatter(mask: '#####-###');

    _model.textFieldPaisTextController ??= TextEditingController();
    _model.textFieldPaisFocusNode ??= FocusNode();

    _model.textFieldEnderecoTextController ??= TextEditingController();
    _model.textFieldEnderecoFocusNode ??= FocusNode();

    _model.textFieldBairroTextController ??= TextEditingController();
    _model.textFieldBairroFocusNode ??= FocusNode();

    _model.textFieldNumeroTextController ??= TextEditingController();
    _model.textFieldNumeroFocusNode ??= FocusNode();

    _model.textFieldCompleTextController ??= TextEditingController();
    _model.textFieldCompleFocusNode ??= FocusNode();

    _model.textFieldCidadeTextController ??= TextEditingController();
    _model.textFieldCidadeFocusNode ??= FocusNode();

    _model.textFieldUFTextController ??= TextEditingController();
    _model.textFieldUFFocusNode ??= FocusNode();

    _model.textFieldCPFTextController2 ??= TextEditingController();
    _model.textFieldCPFFocusNode2 ??= FocusNode();
    _model.textFieldCPFMask2 =
        MaskTextInputFormatter(mask: '###.###.###-##');

    _model.textFieldCPFTextController3 ??= TextEditingController();
    _model.textFieldCPFFocusNode3 ??= FocusNode();

    _model.textFieldNomeTextController2 ??= TextEditingController();
    _model.textFieldNomeFocusNode2 ??= FocusNode();

    _model.textFieldNomeTextController3 ??= TextEditingController();
    _model.textFieldNomeFocusNode3 ??= FocusNode();

    _model.dropDownValue ??= 'Pessoa Jurídica';

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _onCepChanged(String _) {
    EasyDebounce.debounce(
      '_model.textController7',
      const Duration(milliseconds: 700),
      () async {
        if (!mounted) return;
        if (_model.textController7.text.replaceAll(RegExp(r'[^0-9]'), '').length <
            8) {
          return;
        }
        safeSetState(() => _loadingCep = true);
        try {
          _model.resultCEP = await BuscarCEPCall.call(
            cep: _model.textController7.text,
          );
          if (!mounted) return;
          if (_model.resultCEP?.succeeded ?? false) {
            final body = _model.resultCEP?.jsonBody ?? '';
            safeSetState(() {
              _model.textFieldPaisTextController?.text = 'Brasil';
              _model.textFieldEnderecoTextController?.text =
                  BuscarCEPCall.rua(body) ?? '';
              _model.textFieldBairroTextController?.text =
                  BuscarCEPCall.bairro(body) ?? '';
              _model.textFieldCidadeTextController?.text =
                  BuscarCEPCall.cidade(body) ?? '';
              _model.textFieldUFTextController?.text =
                  BuscarCEPCall.uf(body) ?? '';
            });
          } else {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return WebViewAware(
                  child: AlertDialog(
                    content: Text((_model.resultCEP?.jsonBody ?? '').toString()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(alertDialogContext),
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        } finally {
          if (mounted) safeSetState(() => _loadingCep = false);
        }
      },
    );
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return 'Informe $label.';
    return null;
  }

  String? _emailValidator(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Informe seu e-mail.';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(v)) return 'E-mail inválido.';
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Informe sua senha.';
    if (value.length < 8) return 'Mínimo de 8 caracteres.';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Inclua uma letra maiúscula.';
    if (!value.contains(RegExp(r'[a-z]'))) return 'Inclua uma letra minúscula.';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Inclua um número.';
    if (!value.contains(RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:''\\|,.<>\/?]'))) {
      return 'Inclua um caractere especial.';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Confirme sua senha.';
    if (value != _model.textFieldSenhaTextController.text) {
      return 'As senhas não coincidem.';
    }
    return null;
  }

  int _passwordScore(String value) {
    int score = 0;
    if (value.length >= 8) score++;
    if (value.contains(RegExp(r'[A-Z]'))) score++;
    if (value.contains(RegExp(r'[a-z]'))) score++;
    if (value.contains(RegExp(r'[0-9]'))) score++;
    if (value.contains(RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:''\\|,.<>\/?]'))) {
      score++;
    }
    return score;
  }

  Future<void> _onSubmit() async {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos obrigatórios.')),
      );
      return;
    }

    safeSetState(() => _submitting = true);
    try {
      FFAppState().updateContratacaoFranquadoStruct(
        (e) => e
          ..nomeResponsavel = _model.textFieldNomeTextController1.text
          ..emailResponsavel = _model.textFieldEmailTextController.text
          ..senha = _model.textFieldSenhaTextController.text
          ..cep = _model.textController7.text
          ..endereco = _model.textFieldEnderecoTextController.text
          ..bairro = _model.textFieldBairroTextController.text
          ..cidade = _model.textFieldCidadeTextController.text
          ..cpfResponsavel = _model.textFieldCPFTextController1.text
          ..numero = _model.textFieldNumeroTextController.text
          ..complemento = _model.textFieldCompleTextController.text
          ..uf = _model.textFieldUFTextController.text
          ..telefone = _model.textFieldTelefoneTextController.text,
      );
      safeSetState(() {});
      if (_model.dropDownValue == 'Pessoa Jurídica') {
        FFAppState().updateContratacaoFranquadoStruct(
          (e) => e
            ..tipoCadastro = _model.dropDownValue
            ..nomeFantasia = _model.textFieldNomeTextController3.text
            ..razaoSocial = _model.textFieldNomeTextController2.text
            ..cnpjConta = _model.textFieldCPFTextController3.text,
        );
      } else {
        FFAppState().updateContratacaoFranquadoStruct(
          (e) => e..tipoCadastro = _model.dropDownValue,
        );
      }
      safeSetState(() {});

      GoRouter.of(context).prepareAuthEvent();

      final user = await authManager.createAccountWithEmail(
        context,
        _model.textFieldEmailTextController.text,
        _model.textFieldSenhaTextController.text,
      );
      if (user == null) return;

      _model.novoRowUser = await UsersTable().insert({
        'nome': _model.textFieldNomeTextController1.text,
        'email': _model.textFieldEmailTextController.text,
        'role': 'franquia',
        'telefone': _model.textFieldTelefoneTextController.text,
        'cpf': _model.textFieldCPFTextController1.text,
        'data_nascimento': _model.textFieldDNascTextController.text,
        'nacionalidade': _model.textFieldNocionTextController.text,
        'cep': _model.textController7.text,
        'pais': _model.textFieldPaisTextController.text,
        'endereco': _model.textFieldEnderecoTextController.text,
        'bairro': _model.textFieldBairroTextController.text,
        'numero': _model.textFieldNumeroTextController.text,
        'complemento': _model.textFieldCompleTextController.text,
        'cidade': _model.textFieldCidadeTextController.text,
        'uf': _model.textFieldUFTextController.text,
        'id': currentUserUid,
      });
      _model.novoRowFranquia = await FranquiasTable().insert({
        'razao_social': _model.textFieldNomeTextController2.text,
        'status_franquia': false,
        'user_responsavel': _model.novoRowUser?.id,
        'id-indicacao': (FFAppState().contratacaoFranquado.indication != null &&
                FFAppState().contratacaoFranquado.indication != '')
            ? FFAppState().contratacaoFranquado.indication
            : null,
      });
      await MetaUserFranquiaTable().insert({
        'level': 'ADMIN',
        'id_franquia': _model.novoRowFranquia?.id,
        'user_id': _model.novoRowUser?.id,
      });
      await UsersTable().update(
        data: {'id_franquia': _model.novoRowFranquia?.id},
        matchingRows: (rows) => rows.eqOrNull('id', _model.novoRowUser?.id),
      );
      FFAppState().updateContratacaoFranquadoStruct(
        (e) => e..idFranquiaCriada = _model.novoRowFranquia?.id,
      );
      safeSetState(() {});
      _model.idCobranca = await CobrancasTable().insert({
        'valor': FFAppState().contratacaoFranquado.valor,
        'user_id': _model.novoRowUser?.id,
        'tipo_cobranca': 'franquia',
      });

      if (!mounted) return;
      context.pushNamedAuth(
        CheckoutWidget.routeName,
        context.mounted,
        queryParameters: {
          'idCobranca':
              serializeParam(_model.idCobranca?.id, ParamType.String),
          'indication':
              serializeParam(widget.indication, ParamType.String),
        }.withoutNulls,
      );
    } finally {
      if (mounted) safeSetState(() => _submitting = false);
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
    final isCompact = width < kBreakpointSmall;
    final isMedium = width < kBreakpointLarge;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.secondaryBackground,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 16.0 : (isMedium ? 24.0 : 32.0),
                  vertical: isCompact ? 16.0 : 28.0,
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Header(onBack: _onBack),
                      const SizedBox(height: 16.0),
                      _SectionCard(
                        icon: Icons.person_outline_rounded,
                        title: 'Dados pessoais',
                        subtitle: 'Identificação do responsável pela franquia.',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _FieldRow(isCompact: isCompact, children: [
                              _Field(
                                flex: 2,
                                child: _LabeledField(
                                  label: 'Nome completo',
                                  hint: 'Seu nome',
                                  icon: Icons.badge_outlined,
                                  controller:
                                      _model.textFieldNomeTextController1!,
                                  focusNode: _model.textFieldNomeFocusNode1!,
                                  validator: (v) => _required(v, 'seu nome'),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 8.0),
                            _FieldRow(isCompact: isCompact, children: [
                              _Field(
                                flex: 2,
                                child: _LabeledField(
                                  label: 'E-mail',
                                  hint: 'voce@exemplo.com',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                      _model.textFieldEmailTextController!,
                                  focusNode: _model.textFieldEmailFocusNode!,
                                  validator: _emailValidator,
                                ),
                              ),
                            ]),
                            const SizedBox(height: 8.0),
                            _FieldRow(isCompact: isCompact, children: [
                              _Field(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _LabeledField(
                                      label: 'Senha',
                                      hint: 'Mínimo 8 caracteres',
                                      icon: Icons.lock_outline_rounded,
                                      controller:
                                          _model.textFieldSenhaTextController!,
                                      focusNode:
                                          _model.textFieldSenhaFocusNode!,
                                      validator: _passwordValidator,
                                      obscureText:
                                          !_model.textFieldSenhaVisibility,
                                      suffixIcon:
                                          _model.textFieldSenhaVisibility
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                      onSuffixTap: () => safeSetState(() =>
                                          _model.textFieldSenhaVisibility =
                                              !_model.textFieldSenhaVisibility),
                                      onChanged: (_) => safeSetState(() {}),
                                    ),
                                    const SizedBox(height: 6.0),
                                    _PasswordStrength(
                                      score: _passwordScore(_model
                                          .textFieldSenhaTextController.text),
                                    ),
                                  ],
                                ),
                              ),
                              _Field(
                                child: _LabeledField(
                                  label: 'Confirme sua senha',
                                  hint: 'Repita a senha',
                                  icon: Icons.lock_outline_rounded,
                                  controller: _model
                                      .textFieldSenhaConfTextController!,
                                  focusNode:
                                      _model.textFieldSenhaConfFocusNode!,
                                  validator: _confirmPasswordValidator,
                                  obscureText:
                                      !_model.textFieldSenhaConfVisibility,
                                  suffixIcon:
                                      _model.textFieldSenhaConfVisibility
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                  onSuffixTap: () => safeSetState(() => _model
                                          .textFieldSenhaConfVisibility =
                                      !_model.textFieldSenhaConfVisibility),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 8.0),
                            _FieldRow(isCompact: isCompact, children: [
                              _Field(
                                child: _LabeledField(
                                  label: 'Telefone',
                                  hint: '(00) 00000-0000',
                                  icon: Icons.phone_iphone_rounded,
                                  keyboardType: TextInputType.phone,
                                  controller: _model
                                      .textFieldTelefoneTextController!,
                                  focusNode:
                                      _model.textFieldTelefoneFocusNode!,
                                  inputFormatters: [_model.textFieldTelefoneMask],
                                  validator: (v) =>
                                      _required(v, 'seu telefone'),
                                ),
                              ),
                              _Field(
                                child: _LabeledField(
                                  label: 'CPF',
                                  hint: '000.000.000-00',
                                  icon: Icons.credit_card_outlined,
                                  keyboardType: TextInputType.number,
                                  controller:
                                      _model.textFieldCPFTextController1!,
                                  focusNode: _model.textFieldCPFFocusNode1!,
                                  inputFormatters: [_model.textFieldCPFMask1],
                                  validator: (v) => _required(v, 'seu CPF'),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 8.0),
                            _FieldRow(isCompact: isCompact, children: [
                              _Field(
                                child: _LabeledField(
                                  label: 'Data de nascimento',
                                  hint: 'DD/MM/AAAA',
                                  icon: Icons.calendar_today_outlined,
                                  keyboardType: TextInputType.datetime,
                                  controller:
                                      _model.textFieldDNascTextController!,
                                  focusNode: _model.textFieldDNascFocusNode!,
                                  inputFormatters: [_model.textFieldDNascMask],
                                  validator: (v) => _required(v,
                                      'sua data de nascimento'),
                                ),
                              ),
                              _Field(
                                child: _LabeledField(
                                  label: 'Nacionalidade',
                                  hint: 'Brasileira',
                                  icon: Icons.public_rounded,
                                  controller:
                                      _model.textFieldNocionTextController!,
                                  focusNode: _model.textFieldNocionFocusNode!,
                                  validator: (v) =>
                                      _required(v, 'sua nacionalidade'),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _SectionCard(
                        icon: Icons.location_on_outlined,
                        title: 'Endereço',
                        subtitle:
                            'Digite o CEP para preencher automaticamente.',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _FieldRow(isCompact: isCompact, children: [
                              _Field(
                                child: _LabeledField(
                                  label: 'CEP',
                                  hint: '00000-000',
                                  icon: Icons.search_rounded,
                                  controller: _model.textController7!,
                                  focusNode: _model.textFieldFocusNode!,
                                  inputFormatters: [_model.textFieldMask],
                                  onChanged: _onCepChanged,
                                  keyboardType: TextInputType.number,
                                  trailing: _loadingCep
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              _Field(
                                child: _LabeledField(
                                  label: 'País',
                                  hint: 'Brasil',
                                  icon: Icons.flag_outlined,
                                  controller:
                                      _model.textFieldPaisTextController!,
                                  focusNode: _model.textFieldPaisFocusNode!,
                                ),
                              ),
                            ]),
                            const SizedBox(height: 8.0),
                            _FieldRow(isCompact: isCompact, children: [
                              _Field(
                                flex: 2,
                                child: _LabeledField(
                                  label: 'Endereço',
                                  hint: 'Rua, avenida...',
                                  icon: Icons.home_outlined,
                                  controller:
                                      _model.textFieldEnderecoTextController!,
                                  focusNode: _model.textFieldEnderecoFocusNode!,
                                ),
                              ),
                              _Field(
                                child: _LabeledField(
                                  label: 'Bairro',
                                  hint: 'Bairro',
                                  icon: Icons.signpost_outlined,
                                  controller:
                                      _model.textFieldBairroTextController!,
                                  focusNode: _model.textFieldBairroFocusNode!,
                                ),
                              ),
                            ]),
                            const SizedBox(height: 8.0),
                            _FieldRow(isCompact: isCompact, children: [
                              _Field(
                                child: _LabeledField(
                                  label: 'Número',
                                  hint: 'Nº',
                                  icon: Icons.numbers_rounded,
                                  controller:
                                      _model.textFieldNumeroTextController!,
                                  focusNode: _model.textFieldNumeroFocusNode!,
                                ),
                              ),
                              _Field(
                                flex: 2,
                                child: _LabeledField(
                                  label: 'Complemento',
                                  hint: 'Sala, apto...',
                                  icon: Icons.note_alt_outlined,
                                  controller:
                                      _model.textFieldCompleTextController!,
                                  focusNode: _model.textFieldCompleFocusNode!,
                                ),
                              ),
                            ]),
                            const SizedBox(height: 8.0),
                            _FieldRow(isCompact: isCompact, children: [
                              _Field(
                                flex: 2,
                                child: _LabeledField(
                                  label: 'Cidade',
                                  hint: 'Cidade',
                                  icon: Icons.location_city_outlined,
                                  controller:
                                      _model.textFieldCidadeTextController!,
                                  focusNode: _model.textFieldCidadeFocusNode!,
                                ),
                              ),
                              _Field(
                                child: _LabeledField(
                                  label: 'UF',
                                  hint: 'UF',
                                  icon: Icons.map_outlined,
                                  controller:
                                      _model.textFieldUFTextController!,
                                  focusNode: _model.textFieldUFFocusNode!,
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _SectionCard(
                        icon: Icons.business_center_outlined,
                        title: 'Dados da empresa',
                        subtitle:
                            'Informações fiscais para emissão de cobranças.',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _PfPjToggle(
                              value: _model.dropDownValue ?? 'Pessoa Jurídica',
                              onChange: (v) =>
                                  safeSetState(() => _model.dropDownValue = v),
                            ),
                            const SizedBox(height: 8.0),
                            if (_model.dropDownValue == 'Pessoa Física')
                              _LabeledField(
                                label: 'CPF',
                                hint: '000.000.000-00',
                                icon: Icons.credit_card_outlined,
                                keyboardType: TextInputType.number,
                                controller:
                                    _model.textFieldCPFTextController2!,
                                focusNode: _model.textFieldCPFFocusNode2!,
                                inputFormatters: [_model.textFieldCPFMask2],
                                validator: (v) =>
                                    _required(v, 'o CPF'),
                              )
                            else ...[
                              _LabeledField(
                                label: 'CNPJ',
                                hint: '00.000.000/0000-00',
                                icon: Icons.business_outlined,
                                keyboardType: TextInputType.number,
                                controller:
                                    _model.textFieldCPFTextController3!,
                                focusNode: _model.textFieldCPFFocusNode3!,
                                validator: (v) => _required(v, 'o CNPJ'),
                              ),
                              const SizedBox(height: 8.0),
                              _LabeledField(
                                label: 'Razão social',
                                hint: 'Nome registrado da empresa',
                                icon: Icons.assignment_outlined,
                                controller:
                                    _model.textFieldNomeTextController2!,
                                focusNode: _model.textFieldNomeFocusNode2!,
                                validator: (v) =>
                                    _required(v, 'a razão social'),
                              ),
                              const SizedBox(height: 8.0),
                              _LabeledField(
                                label: 'Nome fantasia',
                                hint: 'Nome de exibição',
                                icon: Icons.storefront_outlined,
                                controller:
                                    _model.textFieldNomeTextController3!,
                                focusNode: _model.textFieldNomeFocusNode3!,
                                validator: (v) =>
                                    _required(v, 'o nome fantasia'),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      _PrimaryButton(
                        label: _submitting
                            ? 'Enviando…'
                            : 'Prosseguir para checkout',
                        loading: _submitting,
                        onTap: _onSubmit,
                      ),
                      const SizedBox(height: 12.0),
                      Center(
                        child: Text(
                          'Ao prosseguir você concorda com nossos termos de uso.',
                          style: theme.bodySmall.override(
                            font: GoogleFonts.inter(),
                            fontSize: 11.5,
                            color: theme.secondaryText,
                            letterSpacing: 0.0,
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
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
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
                'Preencha seus dados',
                style: theme.headlineMedium.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w800,
                  color: theme.primaryText,
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                'Cadastre o responsável e a empresa para liberar o acesso à sua franquia.',
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

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.children, required this.isCompact});

  final List<_Field> children;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i].child,
            if (i != children.length - 1) const SizedBox(height: 8.0),
          ],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          Expanded(flex: children[i].flex, child: children[i].child),
          if (i != children.length - 1) const SizedBox(width: 14.0),
        ],
      ],
    );
  }
}

class _Field {
  const _Field({this.flex = 1, required this.child});
  final int flex;
  final Widget child;
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
    this.suffixIcon,
    this.onSuffixTap,
    this.inputFormatters,
    this.onChanged,
    this.trailing,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final List<MaskTextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    Widget? builtSuffix;
    if (trailing != null) {
      builtSuffix = Padding(
        padding: const EdgeInsets.only(right: 14.0),
        child: trailing,
      );
    } else if (suffixIcon != null) {
      builtSuffix = IconButton(
        onPressed: onSuffixTap,
        icon: Icon(suffixIcon, color: theme.secondaryText, size: 20.0),
      );
    }

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
          onChanged: onChanged,
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
            suffixIcon: builtSuffix,
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

class _PasswordStrength extends StatelessWidget {
  const _PasswordStrength({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (score == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 2.0),
        child: Text(
          'Use 8+ caracteres com maiúscula, minúscula, número e símbolo.',
          style: theme.bodySmall.override(
            font: GoogleFonts.inter(),
            fontSize: 11.0,
            color: theme.secondaryText,
            letterSpacing: 0.0,
          ),
        ),
      );
    }
    final ratio = score / 5.0;
    final Color color;
    final String label;
    if (score <= 2) {
      color = const Color(0xFFDC2626);
      label = 'Senha fraca';
    } else if (score <= 4) {
      color = const Color(0xFFD97706);
      label = 'Senha média';
    } else {
      color = const Color(0xFF16A34A);
      label = 'Senha forte';
    }

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: theme.alternate,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                score >= 5
                    ? Icons.shield_rounded
                    : Icons.info_outline_rounded,
                size: 12,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.labelMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  color: color,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PfPjToggle extends StatelessWidget {
  const _PfPjToggle({required this.value, required this.onChange});

  final String value;
  final ValueChanged<String> onChange;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleOption(
              label: 'Pessoa Jurídica',
              icon: Icons.business_rounded,
              selected: value == 'Pessoa Jurídica',
              onTap: () => onChange('Pessoa Jurídica'),
            ),
          ),
          const SizedBox(width: 4.0),
          Expanded(
            child: _ToggleOption(
              label: 'Pessoa Física',
              icon: Icons.person_rounded,
              selected: value == 'Pessoa Física',
              onTap: () => onChange('Pessoa Física'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 42.0,
          decoration: BoxDecoration(
            color: selected ? theme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 16,
                  color: selected ? Colors.white : theme.secondaryText),
              const SizedBox(width: 6.0),
              Text(
                label,
                style: theme.titleSmall.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : theme.primaryText,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.label,
    required this.loading,
    required this.onTap,
  });

  final String label;
  final bool loading;
  final VoidCallback onTap;

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
      cursor:
          widget.loading ? SystemMouseCursors.basic : SystemMouseCursors.click,
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
                if (widget.loading) ...[
                  const SizedBox(
                    width: 18.0,
                    height: 18.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                ],
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
                if (!widget.loading) ...[
                  const SizedBox(width: 8.0),
                  const Icon(Icons.arrow_forward_rounded,
                      size: 18, color: Colors.white),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
