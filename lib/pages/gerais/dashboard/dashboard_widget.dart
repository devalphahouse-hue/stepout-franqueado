import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dashboard_model.dart';
export 'dashboard_model.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  static String routeName = 'Dashboard';
  static String routePath = '/dashboard';

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  late DashboardModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bom dia';
    if (h < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  String _formattedDate() {
    final fmt = DateFormat("EEEE, d 'de' MMMM", 'pt_BR');
    final raw = fmt.format(DateTime.now());
    if (raw.isEmpty) return raw;
    return raw[0].toUpperCase() + raw.substring(1);
  }

  String _firstName(String? full) {
    final t = (full ?? '').trim();
    if (t.isEmpty) return '';
    return t.split(RegExp(r'\s+')).first;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < kBreakpointSmall;
    final hPad = responsivePadding(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.secondaryBackground,
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wrapWithModel(
                model: _model.sidebarModel,
                updateCallback: () => safeSetState(() {}),
                child: const SidebarWidget(route: 'Dashboard'),
              ),
              Expanded(
                child: isCompact
                    ? SingleChildScrollView(
                        primary: false,
                        padding: EdgeInsets.symmetric(
                          horizontal: hPad,
                          vertical: 20.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Header(
                              theme: theme,
                              isCompact: isCompact,
                              greeting: _greeting(),
                              firstNameFuture:
                                  _firstName(currentUserDisplayName),
                              dateLabel: _formattedDate(),
                            ),
                            const SizedBox(height: 18.0),
                            _MetricsSection(
                                theme: theme, isCompact: isCompact),
                            const SizedBox(height: 18.0),
                            _QuickActionsSection(
                                theme: theme, isCompact: isCompact),
                            const SizedBox(height: 18.0),
                            _BannersSection(
                              theme: theme,
                              isCompact: isCompact,
                              model: _model,
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: hPad,
                          vertical: 20.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Header(
                              theme: theme,
                              isCompact: isCompact,
                              greeting: _greeting(),
                              firstNameFuture:
                                  _firstName(currentUserDisplayName),
                              dateLabel: _formattedDate(),
                            ),
                            const SizedBox(height: 18.0),
                            _MetricsSection(
                                theme: theme, isCompact: isCompact),
                            const SizedBox(height: 18.0),
                            _QuickActionsSection(
                                theme: theme, isCompact: isCompact),
                            const SizedBox(height: 18.0),
                            Expanded(
                              child: _BannersSection(
                                theme: theme,
                                isCompact: isCompact,
                                model: _model,
                                fillHeight: true,
                              ),
                            ),
                          ],
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

class _Header extends StatelessWidget {
  const _Header({
    required this.theme,
    required this.isCompact,
    required this.greeting,
    required this.firstNameFuture,
    required this.dateLabel,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final String greeting;
  final String firstNameFuture;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FranquiasRow>>(
      future: FranquiasTable().querySingleRow(
        queryFn: (q) => q.eqOrNull('id', FFAppState().idfranquia),
      ),
      builder: (context, snapshotFranq) {
        final franquia = snapshotFranq.data?.firstOrNull;
        final razao = (franquia?.razaoSocial ?? '').trim().isEmpty
            ? 'sua franquia'
            : franquia!.razaoSocial!;

        final firstName = firstNameFuture;
        final saudacao =
            firstName.isEmpty ? '$greeting!' : '$greeting, $firstName!';

        final titleCol = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              saudacao,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.headlineMedium.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                fontSize: isCompact ? 22.0 : 28.0,
                fontWeight: FontWeight.w800,
                color: theme.primaryText,
                letterSpacing: 0.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Acompanhe os indicadores de $razao.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(),
                fontSize: 14.0,
                color: theme.secondaryText,
                letterSpacing: 0.0,
              ),
            ),
          ],
        );

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              titleCol,
              const SizedBox(height: 12.0),
              _DateChip(theme: theme, label: dateLabel),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: titleCol),
            const SizedBox(width: 16.0),
            _DateChip(theme: theme, label: dateLabel),
          ],
        );
      },
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.theme, required this.label});

  final FlutterFlowTheme theme;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded,
              color: theme.primary, size: 16.0),
          const SizedBox(width: 8.0),
          Text(
            label,
            style: theme.bodySmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: theme.primaryText,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection({required this.theme, required this.isCompact});

  final FlutterFlowTheme theme;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final alunos = _MetricCard(
      theme: theme,
      icon: Icons.people_alt_rounded,
      label: 'Alunos cadastrados',
      hint: 'Total de alunos vinculados à franquia',
      valueBuilder: () {
        return FutureBuilder<List<MetaAlunosRow>>(
          future: MetaAlunosTable().queryRows(
            queryFn: (q) => q
                .eqOrNull('franquia_id', FFAppState().idfranquia)
                .not('user_id', 'is', null)
                .filter('deleted_at', 'is', null),
          ),
          builder: (context, snap) {
            if (!snap.hasData) return _MetricSkeleton(theme: theme);
            return _MetricValueText(
                theme: theme, value: snap.data!.length.toString());
          },
        );
      },
    );

    final professores = _MetricCard(
      theme: theme,
      icon: Icons.school_rounded,
      label: 'Professores cadastrados',
      hint: 'Equipe pedagógica ativa',
      valueBuilder: () {
        return FutureBuilder<List<MetaProfessorRow>>(
          future: MetaProfessorTable().queryRows(
            queryFn: (q) => q
                .eqOrNull('franquia', FFAppState().idfranquia)
                .not('user_id', 'is', null)
                .filter('deleted_at', 'is', null),
          ),
          builder: (context, snap) {
            if (!snap.hasData) return _MetricSkeleton(theme: theme);
            return _MetricValueText(
                theme: theme, value: snap.data!.length.toString());
          },
        );
      },
    );

    final faturamento = _MetricCard(
      theme: theme,
      icon: Icons.payments_rounded,
      label: 'Faturamento',
      hint: 'Soma das cobranças da franquia',
      valueBuilder: () {
        return FutureBuilder<List<CobrancasRow>>(
          future: CobrancasTable().queryRows(
            queryFn: (q) =>
                q.eqOrNull('if_franquia', FFAppState().idfranquia),
          ),
          builder: (context, snap) {
            if (!snap.hasData) return _MetricSkeleton(theme: theme);
            return _MetricValueText(
              theme: theme,
              value: functions.retornaValorTotal(snap.data!.toList()),
            );
          },
        );
      },
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          alunos,
          const SizedBox(height: 12.0),
          professores,
          const SizedBox(height: 12.0),
          faturamento,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: alunos),
        const SizedBox(width: 16.0),
        Expanded(child: professores),
        const SizedBox(width: 16.0),
        Expanded(child: faturamento),
      ],
    );
  }
}

class _MetricCard extends StatefulWidget {
  const _MetricCard({
    required this.theme,
    required this.icon,
    required this.label,
    required this.hint,
    required this.valueBuilder,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String label;
  final String hint;
  final Widget Function() valueBuilder;

  @override
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: t.primaryBackground,
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(
            color: _hover
                ? t.primary.withValues(alpha: 0.35)
                : t.alternate,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: _hover ? 0.06 : 0.03),
              blurRadius: _hover ? 24 : 18,
              offset: Offset(0, _hover ? 10 : 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: t.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  alignment: Alignment.center,
                  child: Icon(widget.icon, color: t.primary, size: 20.0),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    widget.label,
                    style: t.titleSmall.override(
                      font: GoogleFonts.interTight(
                          fontWeight: FontWeight.w700),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: t.primaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            widget.valueBuilder(),
            const SizedBox(height: 6.0),
            Text(
              widget.hint,
              style: t.bodySmall.override(
                font: GoogleFonts.inter(),
                fontSize: 12.5,
                color: t.secondaryText,
                letterSpacing: 0.0,
                lineHeight: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricValueText extends StatelessWidget {
  const _MetricValueText({required this.theme, required this.value});

  final FlutterFlowTheme theme;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: theme.headlineMedium.override(
        font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
        fontSize: 28.0,
        fontWeight: FontWeight.w800,
        color: theme.primaryText,
        letterSpacing: -0.4,
      ),
    );
  }
}

class _MetricSkeleton extends StatelessWidget {
  const _MetricSkeleton({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 28.0,
      decoration: BoxDecoration(
        color: theme.alternate.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection({required this.theme, required this.isCompact});

  final FlutterFlowTheme theme;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final actions = <_QuickActionSpec>[
      _QuickActionSpec(
        icon: Icons.person_add_alt_1_rounded,
        title: 'Novo aluno',
        subtitle: 'Cadastrar aluno na franquia',
        onTap: () => context.pushNamed(AdicionarAlunoWidget.routeName),
      ),
      _QuickActionSpec(
        icon: Icons.group_add_rounded,
        title: 'Novo professor',
        subtitle: 'Cadastrar professor',
        onTap: () => context.pushNamed(AdicionarProfessorWidget.routeName),
      ),
      _QuickActionSpec(
        icon: Icons.calendar_month_rounded,
        title: 'Ver agenda',
        subtitle: 'Calendário de aulas',
        onTap: () => context.pushNamed(CalendarioAulasWidget.routeName),
      ),
      _QuickActionSpec(
        icon: Icons.attach_money_rounded,
        title: 'Financeiro',
        subtitle: 'Cobranças e relatórios',
        onTap: () => context.pushNamed(FinanceiroWidget.routeName),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              Icon(Icons.flash_on_rounded, color: theme.primary, size: 18.0),
              const SizedBox(width: 8.0),
              Text(
                'Atalhos rápidos',
                style: theme.titleMedium.override(
                  font:
                      GoogleFonts.interTight(fontWeight: FontWeight.w700),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        _QuickActionsGrid(theme: theme, actions: actions, isCompact: isCompact),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.theme,
    required this.actions,
    required this.isCompact,
  });

  final FlutterFlowTheme theme;
  final List<_QuickActionSpec> actions;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            _QuickActionCard(theme: theme, spec: actions[i]),
            if (i < actions.length - 1) const SizedBox(height: 10.0),
          ],
        ],
      );
    }
    final cols = width >= 1024 ? 4 : 2;
    const gap = 12.0;
    final rows = <Widget>[];
    for (var i = 0; i < actions.length; i += cols) {
      final group = <Widget>[];
      for (var j = 0; j < cols; j++) {
        if (j > 0) group.add(const SizedBox(width: gap));
        if (i + j < actions.length) {
          group.add(
            Expanded(
              child: _QuickActionCard(theme: theme, spec: actions[i + j]),
            ),
          );
        } else {
          group.add(const Expanded(child: SizedBox.shrink()));
        }
      }
      if (rows.isNotEmpty) rows.add(const SizedBox(height: gap));
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: group,
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _QuickActionSpec {
  const _QuickActionSpec({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

class _QuickActionCard extends StatefulWidget {
  const _QuickActionCard({required this.theme, required this.spec});

  final FlutterFlowTheme theme;
  final _QuickActionSpec spec;

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.spec.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: _hover
                  ? t.primary.withValues(alpha: 0.04)
                  : t.primaryBackground,
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: _hover
                    ? t.primary.withValues(alpha: 0.40)
                    : t.alternate,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: _hover ? 0.05 : 0.02),
                  blurRadius: _hover ? 18 : 12,
                  offset: Offset(0, _hover ? 6 : 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: t.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  alignment: Alignment.center,
                  child: Icon(widget.spec.icon, color: t.primary, size: 22.0),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.spec.title,
                        style: t.titleSmall.override(
                          font: GoogleFonts.interTight(
                              fontWeight: FontWeight.w700),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: t.primaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        widget.spec.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodySmall.override(
                          font: GoogleFonts.inter(),
                          fontSize: 12.0,
                          color: t.secondaryText,
                          letterSpacing: 0.0,
                          lineHeight: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Icon(Icons.arrow_forward_rounded,
                    color: t.primary, size: 18.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BannersSection extends StatelessWidget {
  const _BannersSection({
    required this.theme,
    required this.isCompact,
    required this.model,
    this.fillHeight = false,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final DashboardModel model;
  // Quando true, ocupa toda a altura disponível dividindo entre os banners.
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    final aspect = isCompact ? 16 / 9 : 3 / 1;
    final placeholderH = isCompact ? 180.0 : 240.0;

    final header = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          Icon(Icons.campaign_rounded, color: theme.primary, size: 18.0),
          const SizedBox(width: 8.0),
          Text(
            'Novidades',
            style: theme.titleMedium.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    );

    final futureBuilder = FutureBuilder<List<BannersRow>>(
      future: model.bannerFranqueado(
        requestFn: () => BannersTable().queryRows(
          queryFn: (q) => q.eqOrNull('banner_franqueado', true),
        ),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: placeholderH,
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(18.0),
              border: Border.all(color: theme.alternate, width: 1.0),
            ),
            alignment: Alignment.center,
            child: SizedBox(
              width: 28.0,
              height: 28.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor:
                    AlwaysStoppedAnimation<Color>(theme.primary),
              ),
            ),
          );
        }
        final list = snapshot.data!;
        if (list.isEmpty) {
          return _BannerEmpty(theme: theme, height: placeholderH);
        }

        if (!fillHeight) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < list.length; i++) ...[
                if (i > 0) const SizedBox(height: 14.0),
                _BannerTile(
                  theme: theme,
                  url: (list[i].imagemPc ?? '').trim(),
                  aspect: aspect,
                ),
              ],
            ],
          );
        }

        // fillHeight: divide a altura disponível entre os banners.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < list.length; i++) ...[
              if (i > 0) const SizedBox(height: 12.0),
              Expanded(
                child: _BannerTile(
                  theme: theme,
                  url: (list[i].imagemPc ?? '').trim(),
                  aspect: aspect,
                  flex: true,
                ),
              ),
            ],
          ],
        );
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        const SizedBox(height: 12.0),
        if (fillHeight)
          Expanded(child: futureBuilder)
        else
          futureBuilder,
      ],
    );
  }
}

class _BannerTile extends StatelessWidget {
  const _BannerTile({
    required this.theme,
    required this.url,
    required this.aspect,
    this.flex = false,
  });

  final FlutterFlowTheme theme;
  final String url;
  final double aspect;
  // Quando true, ocupa todo o espaço dado pelo pai (sem AspectRatio fixo).
  final bool flex;

  @override
  Widget build(BuildContext context) {
    final body = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Letterbox decorativo: gradient na cor da marca para
              // preencher espaços vazios quando a imagem não bate exato
              // com o aspect ratio do container.
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.primary.withValues(alpha: 0.92),
                      theme.primary.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),
              if (url.isEmpty)
                _BannerEmpty(theme: theme, height: 200.0, embedded: true)
              else
                Image.network(
                  url,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: SizedBox(
                        width: 26.0,
                        height: 26.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (c, e, s) => _BannerEmpty(
                    theme: theme,
                    height: 200.0,
                    embedded: true,
                  ),
                ),
            ],
          ),
        ),
      );
    if (flex) return body;
    return AspectRatio(aspectRatio: aspect, child: body);
  }
}

class _BannerEmpty extends StatelessWidget {
  const _BannerEmpty({
    required this.theme,
    required this.height,
    this.embedded = false,
  });

  final FlutterFlowTheme theme;
  final double height;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final inner = Container(
      height: height,
      decoration: embedded
          ? null
          : BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(18.0),
              border: Border.all(color: theme.alternate, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.campaign_outlined,
                color: theme.primary, size: 28.0),
          ),
          const SizedBox(height: 12.0),
          Text(
            'Sem novidades por enquanto',
            style: theme.titleSmall.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Quando o time Step Out publicar comunicados, eles aparecem aqui.',
              textAlign: TextAlign.center,
              style: theme.bodySmall.override(
                font: GoogleFonts.inter(),
                fontSize: 12.5,
                color: theme.secondaryText,
                letterSpacing: 0.0,
                lineHeight: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
    return inner;
  }
}
