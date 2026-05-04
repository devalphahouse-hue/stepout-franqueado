import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'categorias_model.dart';
export 'categorias_model.dart';

class CategoriasWidget extends StatefulWidget {
  const CategoriasWidget({
    super.key,
    required this.modulo,
    this.aula,
  });

  final String? modulo;
  final String? aula;

  static String routeName = 'Categorias';
  static String routePath = '/categorias';

  @override
  State<CategoriasWidget> createState() => _CategoriasWidgetState();
}

class _CategoriasWidgetState extends State<CategoriasWidget> {
  late CategoriasModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CategoriasModel());
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
    if (w < 1100) return 24.0;
    return 48.0;
  }

  int _crossAxis(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < 540) return 2;
    if (w < 820) return 3;
    if (w < 1100) return 4;
    return 5;
  }

  IconData _iconFor(String nome) {
    final n = nome.toLowerCase();
    if (n.contains('drill')) return Icons.fitness_center_rounded;
    if (n.contains('filme')) return Icons.movie_rounded;
    if (n.contains('game')) return Icons.sports_esports_rounded;
    if (n.contains('grammar') || n.contains('gramat')) return Icons.menu_book_rounded;
    if (n.contains('histó') || n.contains('histo') || n.contains('story')) {
      return Icons.auto_stories_rounded;
    }
    if (n.contains('imagem') || n.contains('foto')) return Icons.photo_library_rounded;
    if (n.contains('listen') || n.contains('audio') || n.contains('áudio')) {
      return Icons.headphones_rounded;
    }
    if (n.contains('música') || n.contains('musica') || n.contains('music')) {
      return Icons.music_note_rounded;
    }
    if (n.contains('teatro') || n.contains('theater')) return Icons.theater_comedy_rounded;
    if (n.contains('vídeo') || n.contains('video')) return Icons.videocam_rounded;
    return Icons.label_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isVincularContexto = widget.aula != null && widget.aula!.isNotEmpty;

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
                child: SidebarWidget(route: 'Modulos'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  primary: false,
                  child: Padding(
                    padding: EdgeInsets.all(_responsivePadding(context)),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: 1440.0),
                      child: FutureBuilder<List<ModulosDeConteudoRow>>(
                        future: ModulosDeConteudoTable().querySingleRow(
                          queryFn: (q) => q.eqOrNull('id', widget.modulo),
                        ),
                        builder: (context, modSnap) {
                          final mod = (modSnap.data?.isNotEmpty ?? false)
                              ? modSnap.data!.first
                              : null;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Header(
                                nomeModulo: mod?.nomeModulo,
                                nivelModulo: mod?.nivelModulo,
                                isVincularContexto: isVincularContexto,
                                onBack: () => Navigator.of(context).maybePop(),
                              ),
                              SizedBox(height: 24),
                              _SectionCard(
                                icon: Icons.category_rounded,
                                title: 'Explore as categorias',
                                subtitle: 'Selecione uma categoria para ver os conteúdos disponíveis.',
                                child: FutureBuilder<List<CategoriasDeConteudoRow>>(
                                  future: CategoriasDeConteudoTable().queryRows(
                                    queryFn: (q) => q
                                        .eqOrNull('status_categoria', true)
                                        .order('nome_categoria', ascending: true),
                                  ),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                        height: 280,
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: 42,
                                          height: 42,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                                          ),
                                        ),
                                      );
                                    }
                                    final cats = snapshot.data!;
                                    if (cats.isEmpty) {
                                      return _EmptyState(
                                        icon: Icons.category_rounded,
                                        title: 'Nenhuma categoria cadastrada',
                                        subtitle: 'As categorias cadastradas aparecerão aqui.',
                                      );
                                    }
                                    return GridView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: _crossAxis(context),
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 0.92,
                                      ),
                                      itemCount: cats.length,
                                      itemBuilder: (context, idx) {
                                        final c = cats[idx];
                                        return _CategoriaCard(
                                          nome: c.nomeCategoria ?? 'Categoria',
                                          imagem: c.imagemCategoria,
                                          icon: _iconFor(c.nomeCategoria ?? ''),
                                          onTap: () {
                                            context.pushNamed(
                                              ConteudosWidget.routeName,
                                              queryParameters: {
                                                'modulo': serializeParam(widget.modulo, ParamType.String),
                                                'categoria': serializeParam(c.id, ParamType.String),
                                                'aula': serializeParam(widget.aula, ParamType.String),
                                              }.withoutNulls,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
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

class _Header extends StatelessWidget {
  final String? nomeModulo;
  final String? nivelModulo;
  final bool isVincularContexto;
  final VoidCallback onBack;
  const _Header({
    required this.nomeModulo,
    required this.nivelModulo,
    required this.isVincularContexto,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final lv = (nivelModulo ?? '').toUpperCase();
    Color nivelColor;
    if (lv.startsWith('A')) {
      nivelColor = theme.success;
    } else if (lv.startsWith('B')) {
      nivelColor = theme.warning;
    } else if (lv.startsWith('C')) {
      nivelColor = theme.error;
    } else {
      nivelColor = theme.info;
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 10,
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
              Icon(Icons.menu_book_rounded, size: 16, color: theme.primary),
              SizedBox(width: 6),
              Text(
                'Módulo',
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
          nomeModulo ?? 'Módulo',
          style: GoogleFonts.interTight(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: theme.primaryText,
            height: 1.1,
          ),
        ),
        if ((nivelModulo ?? '').isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: nivelColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.signal_cellular_alt_rounded, size: 12, color: nivelColor),
                SizedBox(width: 4),
                Text(
                  'Nível $nivelModulo',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: nivelColor,
                  ),
                ),
              ],
            ),
          ),
        if (isVincularContexto)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: theme.warning.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.link_rounded, size: 14, color: theme.warning),
                SizedBox(width: 6),
                Text(
                  'Vinculando à aula',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.warning,
                  ),
                ),
              ],
            ),
          ),
      ],
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

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Color(0x14000000),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: theme.primary, size: 18),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.interTight(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: theme.primaryText,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: theme.secondaryText,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _CategoriaCard extends StatefulWidget {
  final String nome;
  final String? imagem;
  final IconData icon;
  final VoidCallback onTap;
  const _CategoriaCard({
    required this.nome,
    required this.imagem,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_CategoriaCard> createState() => _CategoriaCardState();
}

class _CategoriaCardState extends State<_CategoriaCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasImg = (widget.imagem ?? '').isNotEmpty;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: Duration(milliseconds: 120),
        scale: _hover ? 0.98 : 1.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hover ? theme.primary.withValues(alpha: 0.55) : theme.alternate,
              width: 1.2,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      blurRadius: 14,
                      color: theme.primary.withValues(alpha: 0.10),
                      offset: Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      blurRadius: 6,
                      color: Color(0x14000000),
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widget.onTap,
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        image: hasImg
                            ? DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(widget.imagem!),
                              )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: hasImg
                          ? null
                          : Icon(widget.icon, size: 36, color: theme.primary),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.interTight(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: theme.primaryText,
                      ),
                    ),
                    SizedBox(height: 8),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 160),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _hover
                            ? theme.primary
                            : theme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ver conteúdos',
                            style: GoogleFonts.interTight(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _hover ? Colors.white : theme.primary,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: _hover ? Colors.white : theme.primary,
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
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(icon, size: 26, color: theme.primary),
          ),
          SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.interTight(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
