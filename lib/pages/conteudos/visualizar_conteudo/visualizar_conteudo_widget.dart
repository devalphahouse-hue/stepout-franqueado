import '/componentes/sidebar_slim/sidebar_slim_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'visualizar_conteudo_model.dart';
export 'visualizar_conteudo_model.dart';

class VisualizarConteudoWidget extends StatefulWidget {
  const VisualizarConteudoWidget({super.key});

  static String routeName = 'VisualizarConteudo';
  static String routePath = '/visualizarConteudo';

  @override
  State<VisualizarConteudoWidget> createState() => _VisualizarConteudoWidgetState();
}

class _VisualizarConteudoWidgetState extends State<VisualizarConteudoWidget> {
  late VisualizarConteudoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VisualizarConteudoModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  double _responsivePadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < kBreakpointSmall) return 12.0;
    if (w < 1100) return 20.0;
    return 28.0;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);

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
                model: _model.sidebarSlimModel,
                updateCallback: () => safeSetState(() {}),
                child: SidebarSlimWidget(),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(_responsivePadding(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(onBack: () => Navigator.of(context).maybePop()),
                      SizedBox(height: 14),
                      _HintBar(
                        link: FFAppState().linkconteudo,
                        onAbrirNovaAba: () async {
                          await launchURL(FFAppState().linkconteudo);
                        },
                      ),
                      SizedBox(height: 14),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme.primaryBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.alternate),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 14,
                                color: Color(0x14000000),
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: custom_widgets.WebViewer(
                              width: double.infinity,
                              height: double.infinity,
                              url: FFAppState().linkconteudo,
                            ),
                          ),
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
  final VoidCallback onBack;
  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 8,
      spacing: 12,
      children: [
        _IconPillButton(
          icon: Icons.arrow_back_rounded,
          tooltip: 'Voltar',
          onTap: onBack,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility_rounded, size: 16, color: theme.primary),
              SizedBox(width: 6),
              Text(
                'Pré-visualização',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: theme.primary,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
        Text(
          'Visualizar conteúdo',
          style: GoogleFonts.interTight(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: theme.primaryText,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _HintBar extends StatelessWidget {
  final String link;
  final VoidCallback onAbrirNovaAba;
  const _HintBar({
    required this.link,
    required this.onAbrirNovaAba,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.info.withValues(alpha: 0.30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.info.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.info_outline_rounded, size: 16, color: theme.info),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Se o conteúdo não aparecer corretamente ou preferir abrir em outra aba, use o botão ao lado.',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: theme.primaryText,
                height: 1.35,
              ),
            ),
          ),
          SizedBox(width: 12),
          _ActionPill(
            icon: Icons.open_in_new_rounded,
            label: 'Abrir em nova aba',
            onTap: link.isEmpty ? null : onAbrirNovaAba,
          ),
        ],
      ),
    );
  }
}

class _IconPillButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _IconPillButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_IconPillButton> createState() => _IconPillButtonState();
}

class _IconPillButtonState extends State<_IconPillButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedScale(
          duration: Duration(milliseconds: 120),
          scale: _hover ? 0.97 : 1.0,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _hover
                  ? theme.primary.withValues(alpha: 0.12)
                  : theme.primaryBackground,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: theme.alternate),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: CircleBorder(),
                onTap: widget.onTap,
                child: Icon(widget.icon, size: 20, color: theme.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionPill extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _ActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ActionPill> createState() => _ActionPillState();
}

class _ActionPillState extends State<_ActionPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final disabled = widget.onTap == null;
    final bg = disabled
        ? theme.alternate
        : (_hover ? theme.primary : theme.primary.withValues(alpha: 0.12));
    final fg = disabled
        ? theme.secondaryText
        : (_hover ? Colors.white : theme.primary);
    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) {
        if (!disabled) setState(() => _hover = true);
      },
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: Duration(milliseconds: 120),
        scale: (_hover && !disabled) ? 0.97 : 1.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: widget.onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, size: 14, color: fg),
                    SizedBox(width: 6),
                    Text(
                      widget.label,
                      style: GoogleFonts.interTight(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: fg,
                      ),
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
