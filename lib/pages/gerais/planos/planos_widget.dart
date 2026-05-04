import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'planos_model.dart';
export 'planos_model.dart';

class PlanosWidget extends StatefulWidget {
  const PlanosWidget({
    super.key,
    this.indication,
  });

  final String? indication;

  static String routeName = 'Planos';
  static String routePath = '/planos';

  @override
  State<PlanosWidget> createState() => _PlanosWidgetState();
}

class _PlanosWidgetState extends State<PlanosWidget> {
  late PlanosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlanosModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _selectPlan(_PlanSpec plan) {
    FFAppState().updateContratacaoFranquadoStruct(
      (e) => e
        ..plano = plan.planoIdx
        ..valor = plan.totalValor
        ..parcelas = plan.parcelas
        ..valorParcela = plan.valorParcela,
    );
    safeSetState(() {});
    final indication = widget.indication;
    if (indication != null && indication.isNotEmpty) {
      FFAppState().updateContratacaoFranquadoStruct(
        (e) => e..indication = indication,
      );
      safeSetState(() {});
    }
    context.pushNamed(
      CadastroFranquiaWidget.routeName,
      queryParameters: {
        'indication': serializeParam(indication, ParamType.String),
      }.withoutNulls,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final showHero = width >= kBreakpointMedium;

    final plans = <_PlanSpec>[
      const _PlanSpec(
        planoIdx: 1.0,
        title: 'À vista',
        subtitle: 'Pagamento único, melhor preço.',
        priceLabel: 'R\$ 20.000,00',
        installmentsLabel: 'Pagamento único',
        totalValor: 20000.0,
        parcelas: 1,
        valorParcela: 20000.0,
        savings: 'Economize até R\$ 10.000',
        recommended: true,
      ),
      const _PlanSpec(
        planoIdx: 2.0,
        title: '6 parcelas',
        subtitle: 'Sem juros, no boleto ou cartão.',
        priceLabel: '6x de R\$ 4.167',
        installmentsLabel: 'Total R\$ 25.000,00',
        totalValor: 25000.0,
        parcelas: 6,
        valorParcela: 4167.0,
      ),
      const _PlanSpec(
        planoIdx: 3.0,
        title: '12 parcelas',
        subtitle: 'Parcelas menores ao longo do ano.',
        priceLabel: '12x de R\$ 2.500',
        installmentsLabel: 'Total R\$ 30.000,00',
        totalValor: 30000.0,
        parcelas: 12,
        valorParcela: 2500.0,
      ),
    ];

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
                child: _PlanosFormPanel(
                  plans: plans,
                  onSelect: _selectPlan,
                  onLogin: () => context.pushNamed(LoginWidget.routeName),
                ),
              ),
              if (showHero)
                const Expanded(
                  flex: 1,
                  child: _PlanosHeroPanel(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanSpec {
  const _PlanSpec({
    required this.planoIdx,
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.installmentsLabel,
    required this.totalValor,
    required this.parcelas,
    required this.valorParcela,
    this.savings,
    this.recommended = false,
  });

  final double planoIdx;
  final String title;
  final String subtitle;
  final String priceLabel;
  final String installmentsLabel;
  final double totalValor;
  final int parcelas;
  final double valorParcela;
  final String? savings;
  final bool recommended;
}

class _PlanosFormPanel extends StatelessWidget {
  const _PlanosFormPanel({
    required this.plans,
    required this.onSelect,
    required this.onLogin,
  });

  final List<_PlanSpec> plans;
  final ValueChanged<_PlanSpec> onSelect;
  final VoidCallback onLogin;

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
            constraints: const BoxConstraints(maxWidth: 480.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium_rounded,
                            size: 14, color: theme.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Torne-se franqueado',
                          style: theme.labelMedium.override(
                            font:
                                GoogleFonts.inter(fontWeight: FontWeight.w700),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: theme.primary,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14.0),
                Text(
                  'Adquira sua Franquia',
                  textAlign: TextAlign.center,
                  style: theme.headlineMedium.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                    fontSize: isCompact ? 26.0 : 30.0,
                    fontWeight: FontWeight.w800,
                    color: theme.primaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Escolha a melhor forma de pagamento e tenha acesso vitalício à plataforma Step Out.',
                  textAlign: TextAlign.center,
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.inter(),
                    fontSize: 14.0,
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                    lineHeight: 1.45,
                  ),
                ),
                const SizedBox(height: 24.0),
                ...plans.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _PlanCard(
                      plan: p,
                      onContratar: () => onSelect(p),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                _DividerLabel(text: 'Já é franqueado?'),
                const SizedBox(height: 12.0),
                _SecondaryOutlineButton(
                  label: 'Acessar Portal do Franqueado',
                  icon: Icons.login_rounded,
                  onTap: onLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatefulWidget {
  const _PlanCard({required this.plan, required this.onContratar});

  final _PlanSpec plan;
  final VoidCallback onContratar;

  @override
  State<_PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<_PlanCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final highlighted = widget.plan.recommended;
    final borderColor = highlighted
        ? theme.primary
        : (_hover ? theme.primary.withValues(alpha: 0.4) : theme.alternate);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(
            color: borderColor,
            width: highlighted ? 1.6 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: highlighted
                  ? theme.primary.withValues(alpha: 0.10)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: highlighted ? 24 : 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.plan.title,
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
                if (highlighted) _RecommendedTag(theme: theme),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              widget.plan.subtitle,
              style: theme.bodySmall.override(
                font: GoogleFonts.inter(),
                fontSize: 12.5,
                color: theme.secondaryText,
                letterSpacing: 0.0,
              ),
            ),
            const SizedBox(height: 14.0),
            Text(
              widget.plan.priceLabel,
              style: theme.headlineLarge.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                fontSize: 26.0,
                fontWeight: FontWeight.w800,
                color: theme.primaryText,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                Icon(Icons.payments_outlined,
                    size: 14, color: theme.secondaryText),
                const SizedBox(width: 6),
                Text(
                  widget.plan.installmentsLabel,
                  style: theme.bodySmall.override(
                    font: GoogleFonts.inter(),
                    fontSize: 12.5,
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                  ),
                ),
              ],
            ),
            if (widget.plan.savings != null) ...[
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.savings_rounded,
                        size: 13, color: theme.primary),
                    const SizedBox(width: 4),
                    Text(
                      widget.plan.savings!,
                      style: theme.labelMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: theme.primary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16.0),
            _ContratarButton(
              onTap: widget.onContratar,
              filled: highlighted,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendedTag extends StatelessWidget {
  const _RecommendedTag({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            'RECOMENDADO',
            style: theme.labelMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w800),
              fontSize: 10.0,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContratarButton extends StatefulWidget {
  const _ContratarButton({required this.onTap, required this.filled});

  final VoidCallback onTap;
  final bool filled;

  @override
  State<_ContratarButton> createState() => _ContratarButtonState();
}

class _ContratarButtonState extends State<_ContratarButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final base = theme.primary;
    final filled = widget.filled;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 46.0,
        decoration: BoxDecoration(
          color: filled
              ? (_hover ? base.withValues(alpha: 0.88) : base)
              : (_hover ? base.withValues(alpha: 0.06) : Colors.transparent),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: base, width: filled ? 0.0 : 1.4),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: base.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [],
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
                  'Contratar',
                  style: theme.titleSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: filled ? Colors.white : base,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: filled ? Colors.white : base,
                ),
              ],
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
                Icon(widget.icon, color: theme.primary, size: 18.0),
                const SizedBox(width: 8),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanosHeroPanel extends StatelessWidget {
  const _PlanosHeroPanel();

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
                    Icons.rocket_launch_rounded,
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
                        'Comece sua jornada Step Out',
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
                        'Suporte completo, materiais e plataforma 100% prontos.',
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
