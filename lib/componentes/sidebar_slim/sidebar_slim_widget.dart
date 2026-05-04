import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sidebar_slim_model.dart';
export 'sidebar_slim_model.dart';

class SidebarSlimWidget extends StatefulWidget {
  const SidebarSlimWidget({
    super.key,
    this.route = 'Modulos',
  });

  final String route;

  @override
  State<SidebarSlimWidget> createState() => _SidebarSlimWidgetState();
}

class _SidebarSlimWidgetState extends State<SidebarSlimWidget> {
  late SidebarSlimModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SidebarSlimModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: 76,
      height: MediaQuery.sizeOf(context).height,
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        border: Border(
          right: BorderSide(color: theme.alternate, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primary.withValues(alpha: 0.06),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: theme.primary.withValues(alpha: 0.10),
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Image.asset(
                'assets/images/Logo.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 12),
          Container(
            width: 28,
            height: 1,
            color: theme.alternate,
          ),
          SizedBox(height: 6),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
                overscroll: false,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _NavItem(
                      icon: Icons.dashboard_rounded,
                      label: 'Dashboard',
                      active: widget.route == 'Dashboard',
                      onTap: () => _push(DashboardWidget.routeName),
                    ),
                    _NavItem(
                      icon: Icons.person_rounded,
                      label: 'Alunos',
                      active: widget.route == 'ListaAlunos',
                      onTap: () => _push(ListaAlunosWidget.routeName),
                    ),
                    _NavItem(
                      icon: Icons.school_rounded,
                      label: 'Professores',
                      active: widget.route == 'ListaProfessores',
                      onTap: () => _push(ListaProfessoresWidget.routeName),
                    ),
                    _NavItem(
                      icon: Icons.groups_rounded,
                      label: 'Turmas',
                      active: widget.route == 'ListaTurmas',
                      onTap: () => _push(ListaTurmasWidget.routeName),
                    ),
                    _NavItem(
                      icon: Icons.calendar_month_rounded,
                      label: 'Calendário de Aulas',
                      active: widget.route == 'CalendarioAulas',
                      onTap: () => _push(CalendarioAulasWidget.routeName),
                    ),
                    _NavItem(
                      icon: Icons.menu_book_rounded,
                      label: 'Módulos',
                      active: widget.route == 'Modulos',
                      onTap: () => _push(ModulosWidget.routeName),
                    ),
                    _NavItem(
                      icon: Icons.chat_rounded,
                      label: 'Chat',
                      active: widget.route == 'Chat',
                      onTap: () => _push(ChatWidget.routeName),
                    ),
                    _NavItem(
                      icon: Icons.attach_money_rounded,
                      label: 'Financeiro',
                      active: widget.route == 'Financeiro',
                      disabled: true,
                      onTap: () {},
                    ),
                    _NavItem(
                      icon: Icons.cast_for_education_rounded,
                      label: 'Treinamentos',
                      active: widget.route == 'Treinamentos',
                      onTap: () => _push(TreinamentosWidget.routeName),
                    ),
                    _NavItem(
                      icon: Icons.share_rounded,
                      label: 'Indicação',
                      active: widget.route == 'Indicacoes',
                      onTap: () => _push(IndicacoesWidget.routeName),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 36,
            height: 1,
            color: theme.alternate,
          ),
          SizedBox(height: 6),
          _NavItem(
            icon: Icons.account_circle_rounded,
            label: 'Perfil',
            active: widget.route == 'Perfil',
            onTap: () => _push(PerfilWidget.routeName),
          ),
          _NavItem(
            icon: Icons.logout_rounded,
            label: 'Sair',
            active: false,
            destructive: true,
            onTap: () async {
              GoRouter.of(context).prepareAuthEvent();
              await authManager.signOut();
              GoRouter.of(context).clearRedirectLocation();
              if (!context.mounted) return;
              context.goNamedAuth(LoginWidget.routeName, context.mounted);
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  void _push(String name) {
    context.pushNamed(
      name,
      extra: <String, dynamic>{
        '__transition_info__': TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
          duration: Duration(milliseconds: 0),
        ),
      },
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool active;
  final bool destructive;
  final bool disabled;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.destructive = false,
    this.disabled = false,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final base = widget.destructive ? theme.error : theme.primary;
    Color iconColor;
    Color bg;
    if (widget.disabled) {
      iconColor = theme.secondaryText.withValues(alpha: 0.45);
      bg = Colors.transparent;
    } else if (widget.active) {
      iconColor = Colors.white;
      bg = base;
    } else if (_hover) {
      iconColor = base;
      bg = base.withValues(alpha: 0.10);
    } else {
      iconColor = theme.secondaryText;
      bg = Colors.transparent;
    }

    final tile = Padding(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 180),
            width: widget.active ? 4 : 0,
            height: 20,
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: AnimatedScale(
                duration: Duration(milliseconds: 120),
                scale: (_hover && !widget.disabled) ? 0.96 : 1.0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 180),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: widget.active
                        ? [
                            BoxShadow(
                              blurRadius: 10,
                              color: base.withValues(alpha: 0.30),
                              offset: Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Icon(widget.icon, color: iconColor, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.disabled) {
      return Tooltip(
        message: '${widget.label} (em breve)',
        waitDuration: Duration(milliseconds: 250),
        textStyle: GoogleFonts.inter(fontSize: 12, color: Colors.white),
        decoration: BoxDecoration(
          color: theme.primaryText.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(8),
        ),
        child: tile,
      );
    }

    return Tooltip(
      message: widget.label,
      waitDuration: Duration(milliseconds: 250),
      textStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: theme.primaryText.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
      ),
      preferBelow: false,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: tile,
          ),
        ),
      ),
    );
  }
}
