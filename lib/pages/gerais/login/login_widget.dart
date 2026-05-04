import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_model.dart';
export 'login_model.dart';

const _kInProgressStatuses = {
  'PENDING',
  'AWAITING_RISK_ANALYSIS',
};
const _kPaidStatuses = {
  'CONFIRMED',
  'RECEIVED',
  'RECEIVED_IN_CASH',
};
const _kFailedStatuses = {
  'OVERDUE',
  'REFUNDED',
  'REFUND_REQUESTED',
  'CHARGEBACK_REQUESTED',
  'CHARGEBACK_DISPUTE',
  'AWAITING_CHARGEBACK_REVERSAL',
  'DUNNING_REQUESTED',
  'DUNNING_RECEIVED',
  'PAYMENT_DELETED',
};

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'Login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isSubmitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    safeSetState(() => _isSubmitting = true);
    try {
      GoRouter.of(context).prepareAuthEvent();

      final user = await authManager.signInWithEmail(
        context,
        _model.emailAddressTextController.text.trim(),
        _model.passwordTextController.text,
      );
      if (user == null) return;

      _model.userlogado = await MetaUserFranquiaTable().queryRows(
        queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
      );
      if (_model.userlogado?.length != 0) {
        FFAppState().idfranquia = _model.userlogado!.firstOrNull!.idFranquia!;
        safeSetState(() {});
        _model.fraquiaativa = await FranquiasTable().queryRows(
          queryFn: (q) =>
              q.eqOrNull('id', _model.userlogado?.firstOrNull?.idFranquia),
        );
        if (_model.fraquiaativa?.firstOrNull?.statusFranquia == true) {
          context.pushNamedAuth(
            DashboardWidget.routeName,
            context.mounted,
            extra: <String, dynamic>{
              '__transition_info__': const TransitionInfo(
                hasTransition: true,
                transitionType: PageTransitionType.fade,
                duration: Duration(milliseconds: 0),
              ),
            },
          );
        } else {
          await _routeForInactiveFranquia();
        }
      } else {
        GoRouter.of(context).prepareAuthEvent();
        await authManager.signOut();
        GoRouter.of(context).clearRedirectLocation();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem permissão de acesso.',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
            ),
            duration: const Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    } finally {
      if (mounted) safeSetState(() => _isSubmitting = false);
    }
  }

  Future<void> _routeForInactiveFranquia() async {
    final pending = await _findLastFranquiaCobranca();

    if (pending == null) {
      _goFranquiaInativa(motivo: 'inativa');
      return;
    }

    final status = (pending.statusCobranca ?? '').trim().toUpperCase();
    final hasAsaasId = (pending.idCobrancaAsaas ?? '').trim().isNotEmpty;

    if (_kPaidStatuses.contains(status)) {
      _goFranquiaInativa(motivo: 'aguardando_ativacao');
      return;
    }
    if (_kInProgressStatuses.contains(status) && hasAsaasId) {
      _goFranquiaInativa(motivo: 'em_analise');
      return;
    }
    if (_kFailedStatuses.contains(status)) {
      await _hydrateContratacaoStruct(pending);
      _goFranquiaInativa(motivo: 'pagamento_falhou', idCobranca: pending.id);
      return;
    }

    // status NULL/'' ou cartão ainda não submetido: usuário pode pagar.
    await _hydrateContratacaoStruct(pending);
    if (!mounted) return;
    context.pushNamedAuth(
      CheckoutWidget.routeName,
      context.mounted,
      queryParameters: {
        'idCobranca': serializeParam(pending.id, ParamType.String),
      }.withoutNulls,
      extra: <String, dynamic>{
        '__transition_info__': const TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
          duration: Duration(milliseconds: 0),
        ),
      },
    );
  }

  void _goFranquiaInativa({required String motivo, String? idCobranca}) {
    if (!mounted) return;
    context.pushNamedAuth(
      FranquiaInativaWidget.routeName,
      context.mounted,
      queryParameters: {
        'motivo': serializeParam(motivo, ParamType.String),
        if (idCobranca != null && idCobranca.isNotEmpty)
          'idCobranca': serializeParam(idCobranca, ParamType.String),
      }.withoutNulls,
      extra: <String, dynamic>{
        '__transition_info__': const TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
          duration: Duration(milliseconds: 0),
        ),
      },
    );
  }

  Future<CobrancasRow?> _findLastFranquiaCobranca() async {
    final rows = await CobrancasTable().queryRows(
      queryFn: (q) => q
          .eqOrNull('user_id', currentUserUid)
          .eqOrNull('tipo_cobranca', 'franquia')
          .order('created_at', ascending: false),
    );
    return rows.isEmpty ? null : rows.first;
  }

  ({int parcelas, double valorParcela}) _planFromValor(double? valor) {
    final v = valor ?? 0.0;
    if (v >= 29000) return (parcelas: 12, valorParcela: 2500.0);
    if (v >= 24000) return (parcelas: 6, valorParcela: 4167.0);
    return (parcelas: 1, valorParcela: 20000.0);
  }

  Future<void> _hydrateContratacaoStruct(CobrancasRow cob) async {
    final users = await UsersTable().queryRows(
      queryFn: (q) => q.eqOrNull('id', currentUserUid),
    );
    final user = users.firstOrNull;
    final franquia = _model.fraquiaativa?.firstOrNull;

    final plan = _planFromValor(cob.valor);
    final razao = (franquia?.razaoSocial ?? '').trim();
    // CNPJ não é persistido em DB hoje, então tratamos sempre como Pessoa
    // Física no relogin para o checkout usar user.cpf no criarClienteCall.
    // Quando a captura de CNPJ for adicionada ao schema, voltar a respeitar
    // razaoSocial pra distinguir PF/PJ.
    const tipo = 'Pessoa Física';

    FFAppState().updateContratacaoFranquadoStruct(
      (e) => e
        ..nomeResponsavel = user?.nome ?? ''
        ..emailResponsavel = user?.email ?? ''
        ..cpfResponsavel = user?.cpf ?? ''
        ..telefone = user?.telefone ?? ''
        ..cep = user?.cep ?? ''
        ..endereco = user?.endereco ?? ''
        ..numero = user?.numero ?? ''
        ..bairro = user?.bairro ?? ''
        ..cidade = user?.cidade ?? ''
        ..uf = user?.uf ?? ''
        ..complemento = user?.complemento ?? ''
        ..razaoSocial = razao
        ..tipoCadastro = tipo
        ..idFranquiaCriada = franquia?.id ?? ''
        ..valor = (cob.valor ?? 0) > 0 ? cob.valor : 20000.0
        ..parcelas = plan.parcelas
        ..valorParcela = plan.valorParcela
        ..plano = (cob.valor ?? 20000.0).toDouble(),
    );
  }

  String? _emailValidator(BuildContext _, String? value) {
    if (value == null || value.trim().isEmpty) return 'Informe seu e-mail';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'E-mail inválido';
    return null;
  }

  String? _passwordValidator(BuildContext _, String? value) {
    if (value == null || value.isEmpty) return 'Informe sua senha';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;

    if (width < kBreakpointSmall) {
      return _MobileFallback(theme: theme);
    }

    final showHero = width >= kBreakpointMedium;

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
                child: _LoginFormPanel(
                  formKey: _formKey,
                  emailController: _model.emailAddressTextController!,
                  emailFocusNode: _model.emailAddressFocusNode!,
                  passwordController: _model.passwordTextController!,
                  passwordFocusNode: _model.passwordFocusNode!,
                  passwordVisible: _model.passwordVisibility,
                  onTogglePassword: () => safeSetState(
                      () => _model.passwordVisibility = !_model.passwordVisibility),
                  loading: _isSubmitting,
                  onLogin: _handleLogin,
                  onForgot: () =>
                      context.pushNamed(EsqueceuSenhaWidget.routeName),
                  onSaibaMais: () => context.pushNamed(PlanosWidget.routeName),
                  emailValidator: _emailValidator,
                  passwordValidator: _passwordValidator,
                ),
              ),
              if (showHero)
                const Expanded(
                  flex: 1,
                  child: _LoginHeroPanel(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileFallback extends StatelessWidget {
  const _MobileFallback({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.secondaryBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32.0),
                Icon(
                  Icons.desktop_windows_outlined,
                  size: 56.0,
                  color: theme.primary,
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Acesse pelo computador',
                  textAlign: TextAlign.center,
                  style: theme.headlineSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'O Portal do Franqueado foi otimizado para uso em desktop. Abra este link no seu computador para uma melhor experiência.',
                  textAlign: TextAlign.center,
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.inter(),
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
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

class _LoginFormPanel extends StatelessWidget {
  const _LoginFormPanel({
    required this.formKey,
    required this.emailController,
    required this.emailFocusNode,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.passwordVisible,
    required this.onTogglePassword,
    required this.loading,
    required this.onLogin,
    required this.onForgot,
    required this.onSaibaMais,
    required this.emailValidator,
    required this.passwordValidator,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final bool passwordVisible;
  final VoidCallback onTogglePassword;
  final bool loading;
  final VoidCallback onLogin;
  final VoidCallback onForgot;
  final VoidCallback onSaibaMais;
  final String? Function(BuildContext, String?) emailValidator;
  final String? Function(BuildContext, String?) passwordValidator;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < kBreakpointSmall;

    return Container(
      color: theme.secondaryBackground,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 24.0 : 40.0, vertical: 32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460.0),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: Image.asset(
                        'assets/images/Logo.png',
                        width: isCompact ? 140.0 : 168.0,
                        height: isCompact ? 140.0 : 168.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'Portal do Franqueado',
                    textAlign: TextAlign.center,
                    style: theme.headlineMedium.override(
                      font:
                          GoogleFonts.interTight(fontWeight: FontWeight.w800),
                      fontSize: isCompact ? 24.0 : 28.0,
                      fontWeight: FontWeight.w800,
                      color: theme.primaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    'Faça login para acessar as informações da sua franquia.',
                    textAlign: TextAlign.center,
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(),
                      fontSize: 14.0,
                      color: theme.secondaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 18.0 : 24.0,
                      vertical: isCompact ? 20.0 : 24.0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(color: theme.alternate, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _LoginField(
                          controller: emailController,
                          focusNode: emailFocusNode,
                          label: 'E-mail',
                          hint: 'voce@exemplo.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: emailValidator,
                        ),
                        const SizedBox(height: 14.0),
                        _LoginField(
                          controller: passwordController,
                          focusNode: passwordFocusNode,
                          label: 'Senha',
                          hint: '••••••••',
                          icon: Icons.lock_outline_rounded,
                          obscureText: !passwordVisible,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => onLogin(),
                          suffixIcon: passwordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onSuffixTap: onTogglePassword,
                          validator: passwordValidator,
                        ),
                        const SizedBox(height: 6.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: onForgot,
                            style: TextButton.styleFrom(
                              foregroundColor: theme.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              minimumSize: const Size(0, 32),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Esqueceu sua senha?',
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: theme.primary,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14.0),
                        _PrimaryButton(
                          label: loading ? 'Entrando…' : 'Entrar',
                          loading: loading,
                          onTap: onLogin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28.0),
                  _DividerLabel(text: 'Ainda não é Franqueado?'),
                  const SizedBox(height: 12.0),
                  Text(
                    'Conheça os planos e descubra como abrir sua unidade Step Out.',
                    textAlign: TextAlign.center,
                    style: theme.bodySmall.override(
                      font: GoogleFonts.inter(),
                      fontSize: 13.0,
                      color: theme.secondaryText,
                      letterSpacing: 0.0,
                      lineHeight: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  _SecondaryOutlineButton(
                    label: 'Conhecer planos',
                    icon: Icons.arrow_forward_rounded,
                    onTap: onSaibaMais,
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

class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Container(height: 1, color: theme.alternate)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            text,
            style: theme.labelMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: theme.secondaryText,
              letterSpacing: 0.4,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: theme.alternate)),
      ],
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixTap,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onSubmitted;
  final String? Function(BuildContext, String?) validator;

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
          textInputAction: textInputAction,
          obscureText: obscureText,
          onFieldSubmitted: onSubmitted,
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            fontSize: 15.0,
            color: theme.primaryText,
            letterSpacing: 0.0,
          ),
          cursorColor: theme.primary,
          validator: (val) => validator(context, val),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              fontSize: 15.0,
              color: theme.secondaryText,
              letterSpacing: 0.0,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 10.0),
              child: Icon(icon, color: theme.secondaryText, size: 20.0),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: suffixIcon == null
                ? null
                : IconButton(
                    onPressed: onSuffixTap,
                    icon: Icon(
                      suffixIcon,
                      color: theme.secondaryText,
                      size: 20.0,
                    ),
                  ),
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
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: 50.0,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: base.withValues(alpha: 0.18),
                  blurRadius: 18.0,
                  offset: const Offset(0, 6.0),
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryOutlineButton extends StatefulWidget {
  const _SecondaryOutlineButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_SecondaryOutlineButton> createState() =>
      _SecondaryOutlineButtonState();
}

class _SecondaryOutlineButtonState extends State<_SecondaryOutlineButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 46.0,
        decoration: BoxDecoration(
          color: _hover
              ? theme.primary.withValues(alpha: 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: theme.primary, width: 1.4),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: widget.onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.label,
                  style: theme.titleSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: theme.primary,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 8.0),
                Icon(widget.icon, color: theme.primary, size: 18.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHeroPanel extends StatelessWidget {
  const _LoginHeroPanel();

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
                    Icons.business_center_rounded,
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
                        'Gestão completa em um lugar',
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
                        'Alunos, professores, financeiro e conteúdos centralizados.',
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
