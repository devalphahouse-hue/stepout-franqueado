import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'franquia_inativa_model.dart';
export 'franquia_inativa_model.dart';

enum _Motivo { emAnalise, aguardandoAtivacao, pagamentoFalhou, inativa }

_Motivo _parseMotivo(String? raw) {
  switch (raw) {
    case 'em_analise':
      return _Motivo.emAnalise;
    case 'aguardando_ativacao':
      return _Motivo.aguardandoAtivacao;
    case 'pagamento_falhou':
      return _Motivo.pagamentoFalhou;
    default:
      return _Motivo.inativa;
  }
}

class FranquiaInativaWidget extends StatefulWidget {
  const FranquiaInativaWidget({
    super.key,
    this.motivo,
    this.idCobranca,
  });

  final String? motivo;
  final String? idCobranca;

  static String routeName = 'FranquiaInativa';
  static String routePath = '/franquiaInativa';

  @override
  State<FranquiaInativaWidget> createState() => _FranquiaInativaWidgetState();
}

class _FranquiaInativaWidgetState extends State<FranquiaInativaWidget> {
  late FranquiaInativaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _signingOut = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FranquiaInativaModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    if (_signingOut) return;
    safeSetState(() => _signingOut = true);
    try {
      GoRouter.of(context).prepareAuthEvent();
      await authManager.signOut();
      GoRouter.of(context).clearRedirectLocation();
      if (!mounted) return;
      context.goNamedAuth(LoginWidget.routeName, context.mounted);
    } finally {
      if (mounted) safeSetState(() => _signingOut = false);
    }
  }

  void _retryCheckout() {
    final id = widget.idCobranca;
    if (id == null || id.isEmpty) return;
    context.pushNamed(
      CheckoutWidget.routeName,
      queryParameters: {
        'idCobranca': serializeParam(id, ParamType.String),
      }.withoutNulls,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < kBreakpointSmall;
    final motivo = _parseMotivo(widget.motivo);
    final v = _variantFor(motivo, theme);
    final canRetry = motivo == _Motivo.pagamentoFalhou &&
        (widget.idCobranca?.isNotEmpty ?? false);

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
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 16.0 : 32.0, vertical: 32.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 88.0,
                        height: 88.0,
                        decoration: BoxDecoration(
                          color: v.heroColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          v.heroIcon,
                          color: v.heroColor,
                          size: 44.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    Text(
                      v.title,
                      textAlign: TextAlign.center,
                      style: theme.headlineMedium.override(
                        font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w800),
                        fontSize: isCompact ? 22.0 : 26.0,
                        fontWeight: FontWeight.w800,
                        color: theme.primaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      v.subtitle,
                      textAlign: TextAlign.center,
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(),
                        fontSize: 14.0,
                        color: theme.secondaryText,
                        letterSpacing: 0.0,
                        lineHeight: 1.45,
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: theme.primaryBackground,
                        borderRadius: BorderRadius.circular(18.0),
                        border:
                            Border.all(color: theme.alternate, width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < v.reasons.length; i++) ...[
                            if (i > 0) _Divider(theme: theme),
                            _Reason(
                              icon: v.reasons[i].icon,
                              title: v.reasons[i].title,
                              description: v.reasons[i].description,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    _SupportCard(theme: theme),
                    const SizedBox(height: 22.0),
                    if (canRetry) ...[
                      _PrimaryButton(
                        label: 'Tentar pagamento novamente',
                        loading: false,
                        icon: Icons.refresh_rounded,
                        onTap: _retryCheckout,
                      ),
                      const SizedBox(height: 10.0),
                      _SecondaryGhostButton(
                        label: _signingOut ? 'Saindo…' : 'Voltar ao login',
                        loading: _signingOut,
                        icon: Icons.arrow_back_rounded,
                        onTap: _signOut,
                      ),
                    ] else
                      _PrimaryButton(
                        label: _signingOut ? 'Saindo…' : 'Voltar ao login',
                        loading: _signingOut,
                        icon: Icons.arrow_back_rounded,
                        onTap: _signOut,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Variant {
  const _Variant({
    required this.heroIcon,
    required this.heroColor,
    required this.title,
    required this.subtitle,
    required this.reasons,
  });

  final IconData heroIcon;
  final Color heroColor;
  final String title;
  final String subtitle;
  final List<_ReasonSpec> reasons;
}

class _ReasonSpec {
  const _ReasonSpec({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

_Variant _variantFor(_Motivo motivo, FlutterFlowTheme theme) {
  switch (motivo) {
    case _Motivo.emAnalise:
      return _Variant(
        heroIcon: Icons.hourglass_top_rounded,
        heroColor: theme.primary,
        title: 'Pagamento em análise',
        subtitle:
            'Estamos confirmando o recebimento do seu pagamento. Isso costuma levar alguns minutos.',
        reasons: const [
          _ReasonSpec(
            icon: Icons.payments_outlined,
            title: 'Cobrança em processamento',
            description:
                'O Asaas está validando o pagamento. Não é necessário pagar novamente — você seria cobrado em duplicidade.',
          ),
          _ReasonSpec(
            icon: Icons.notifications_active_outlined,
            title: 'Você será avisado por e-mail',
            description:
                'Assim que confirmado, sua franquia é ativada automaticamente. Tente entrar novamente em alguns minutos.',
          ),
        ],
      );
    case _Motivo.aguardandoAtivacao:
      return _Variant(
        heroIcon: Icons.verified_rounded,
        heroColor: theme.primary,
        title: 'Pagamento confirmado',
        subtitle:
            'Recebemos seu pagamento. A liberação da franquia está sendo finalizada pela equipe Step Out.',
        reasons: const [
          _ReasonSpec(
            icon: Icons.check_circle_outline_rounded,
            title: 'Pagamento aprovado pelo Asaas',
            description:
                'Seu plano foi quitado. Falta apenas a etapa final de configuração da sua conta.',
          ),
          _ReasonSpec(
            icon: Icons.support_agent_rounded,
            title: 'Levou mais de 1 hora?',
            description:
                'Em casos raros a ativação não acontece automaticamente. Fale com o suporte para agilizarmos.',
          ),
        ],
      );
    case _Motivo.pagamentoFalhou:
      return _Variant(
        heroIcon: Icons.error_outline_rounded,
        heroColor: theme.error,
        title: 'Pagamento não concluído',
        subtitle:
            'Sua tentativa anterior não foi finalizada. Você pode tentar novamente abaixo.',
        reasons: const [
          _ReasonSpec(
            icon: Icons.credit_card_off_rounded,
            title: 'Cartão recusado, vencido ou estornado',
            description:
                'Reveja os dados do cartão, verifique o limite disponível ou use outro cartão.',
          ),
          _ReasonSpec(
            icon: Icons.shield_outlined,
            title: 'Pagamento seguro',
            description:
                'Você só será cobrado se a tentativa for aprovada. Nada é debitado por tentativas recusadas.',
          ),
        ],
      );
    case _Motivo.inativa:
      return _Variant(
        heroIcon: Icons.lock_clock_rounded,
        heroColor: theme.warning,
        title: 'Sua franquia está inativa',
        subtitle:
            'Identificamos que sua conta ainda não está liberada. Verifique os pontos abaixo para ativar o acesso.',
        reasons: const [
          _ReasonSpec(
            icon: Icons.payments_outlined,
            title: 'Pagamento pendente',
            description:
                'Se a contratação ainda não foi quitada, conclua o pagamento para liberar o acesso.',
          ),
          _ReasonSpec(
            icon: Icons.fact_check_outlined,
            title: 'Em análise pela equipe Step Out',
            description:
                'Após o pagamento, sua franquia passa por uma validação rápida antes de ficar ativa.',
          ),
          _ReasonSpec(
            icon: Icons.warning_amber_rounded,
            title: 'Inadimplência ou bloqueio temporário',
            description:
                'Cobranças vencidas podem suspender o acesso. Regularize as pendências para reativar.',
          ),
        ],
      );
  }
}

class _Reason extends StatelessWidget {
  const _Reason({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10.0),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: theme.primary, size: 18.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.titleSmall.override(
                    font:
                        GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  description,
                  style: theme.bodySmall.override(
                    font: GoogleFonts.inter(),
                    fontSize: 12.5,
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                    lineHeight: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(height: 1, color: theme.alternate),
    );
  }
}

class _SupportCard extends StatefulWidget {
  const _SupportCard({required this.theme});

  final FlutterFlowTheme theme;

  @override
  State<_SupportCard> createState() => _SupportCardState();
}

class _SupportCardState extends State<_SupportCard> {
  bool _hover = false;

  Future<void> _openSupport() async {
    final uri = Uri.parse(
      'https://wa.me/5511999999999?text=Ol%C3%A1%2C%20preciso%20de%20ajuda%20para%20ativar%20minha%20franquia%20Step%20Out.',
    );
    await launchURL(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _hover
              ? theme.primary.withValues(alpha: 0.06)
              : theme.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: theme.primary.withValues(alpha: _hover ? 0.45 : 0.25),
            width: 1.2,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14.0),
            onTap: _openSupport,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: Colors.white,
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
                          'Falar com o suporte',
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
                          'Atendimento via WhatsApp para regularizar sua conta.',
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
                  Icon(Icons.arrow_forward_rounded,
                      color: theme.primary, size: 18.0),
                ],
              ),
            ),
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

class _SecondaryGhostButton extends StatefulWidget {
  const _SecondaryGhostButton({
    required this.label,
    required this.loading,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool loading;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_SecondaryGhostButton> createState() => _SecondaryGhostButtonState();
}

class _SecondaryGhostButtonState extends State<_SecondaryGhostButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return MouseRegion(
      cursor: widget.loading
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
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
            onTap: widget.loading ? null : widget.onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.loading)
                  SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(theme.primary),
                    ),
                  )
                else
                  Icon(widget.icon, color: theme.primary, size: 18.0),
                const SizedBox(width: 8.0),
                Text(
                  widget.label,
                  style: theme.titleSmall.override(
                    font: GoogleFonts.interTight(
                        fontWeight: FontWeight.w600),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: theme.primary,
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
