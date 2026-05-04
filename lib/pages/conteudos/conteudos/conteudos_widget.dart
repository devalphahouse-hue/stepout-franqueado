import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'conteudos_model.dart';
export 'conteudos_model.dart';

class ConteudosWidget extends StatefulWidget {
  const ConteudosWidget({
    super.key,
    required this.modulo,
    required this.categoria,
    this.aula,
  });

  final String? modulo;
  final String? categoria;
  final String? aula;

  static String routeName = 'Conteudos';
  static String routePath = '/conteudos';

  @override
  State<ConteudosWidget> createState() => _ConteudosWidgetState();
}

class _ConteudosWidgetState extends State<ConteudosWidget> {
  late ConteudosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConteudosModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    EasyDebounce.cancel('conteudos_search');
    _model.dispose();
    super.dispose();
  }

  double _responsivePadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < kBreakpointSmall) return 12.0;
    if (w < 1100) return 24.0;
    return 48.0;
  }

  IconData _iconForCategoria(String nome) {
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
    return Icons.description_rounded;
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
                      child: FutureBuilder<List<CategoriasDeConteudoRow>>(
                        future: CategoriasDeConteudoTable().querySingleRow(
                          queryFn: (q) => q.eqOrNull('id', widget.categoria),
                        ),
                        builder: (context, catSnap) {
                          final cat = (catSnap.data?.isNotEmpty ?? false)
                              ? catSnap.data!.first
                              : null;
                          return FutureBuilder<List<ModulosDeConteudoRow>>(
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
                                    nomeCategoria: cat?.nomeCategoria,
                                    iconCategoria: _iconForCategoria(cat?.nomeCategoria ?? ''),
                                    isVincularContexto: isVincularContexto,
                                    onBack: () => Navigator.of(context).maybePop(),
                                  ),
                                  SizedBox(height: 20),
                                  _SearchBar(
                                    controller: _searchCtrl,
                                    onChanged: (v) {
                                      EasyDebounce.debounce(
                                        'conteudos_search',
                                        Duration(milliseconds: 300),
                                        () => safeSetState(() => _search = v.trim().toLowerCase()),
                                      );
                                    },
                                    onClear: () {
                                      _searchCtrl.clear();
                                      EasyDebounce.cancel('conteudos_search');
                                      safeSetState(() => _search = '');
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  _SectionCard(
                                    icon: Icons.library_books_rounded,
                                    title: 'Conteúdos disponíveis',
                                    subtitle: isVincularContexto
                                        ? 'Visualize ou clique em "Vincular na aula" para anexar à aula em planejamento.'
                                        : 'Visualize os conteúdos cadastrados nesta categoria.',
                                    child: FutureBuilder<List<ConteudosRow>>(
                                      future: ConteudosTable().queryRows(
                                        queryFn: (q) => q
                                            .eqOrNull('modulo_conteudo', widget.modulo)
                                            .eqOrNull('categoria_conteudo', widget.categoria)
                                            .order('nome_conteudo', ascending: true),
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
                                        final all = snapshot.data!;
                                        final filtered = _search.isEmpty
                                            ? all
                                            : all.where((c) => (c.nomeConteudo ?? '')
                                                .toLowerCase()
                                                .contains(_search))
                                                .toList();

                                        if (filtered.isEmpty) {
                                          return _EmptyState(
                                            icon: Icons.library_books_rounded,
                                            title: _search.isEmpty
                                                ? 'Nenhum conteúdo cadastrado'
                                                : 'Nenhum conteúdo encontrado',
                                            subtitle: _search.isEmpty
                                                ? 'Os conteúdos cadastrados nesta categoria aparecerão aqui.'
                                                : 'Tente outra busca pelo nome.',
                                          );
                                        }

                                        return Column(
                                          children: [
                                            for (int i = 0; i < filtered.length; i++) ...[
                                              if (i > 0) SizedBox(height: 10),
                                              _ConteudoTile(
                                                nome: filtered[i].nomeConteudo ?? 'Conteúdo',
                                                icon: _iconForCategoria(cat?.nomeCategoria ?? ''),
                                                onVisualizar: () async {
                                                  FFAppState().linkconteudo =
                                                      filtered[i].linkConteudo ?? '';
                                                  safeSetState(() {});
                                                  context.pushNamed(
                                                    VisualizarConteudoWidget.routeName,
                                                    extra: <String, dynamic>{
                                                      '__transition_info__': TransitionInfo(
                                                        hasTransition: true,
                                                        transitionType: PageTransitionType.fade,
                                                        duration: Duration(milliseconds: 0),
                                                      ),
                                                    },
                                                  );
                                                },
                                                onVincular: isVincularContexto
                                                    ? () async {
                                                        _model.aula = await AulasTable().queryRows(
                                                          queryFn: (q) =>
                                                              q.eqOrNull('id', widget.aula),
                                                        );
                                                        await AulasTable().update(
                                                          data: {
                                                            'conteudos_vinculados':
                                                                functions.addItemToList(
                                                              _model.aula?.firstOrNull
                                                                  ?.conteudosVinculados
                                                                  .toList(),
                                                              filtered[i].id,
                                                            ),
                                                          },
                                                          matchingRows: (rows) =>
                                                              rows.eqOrNull('id', widget.aula),
                                                        );
                                                        if (!context.mounted) return;
                                                        context.pushNamed(
                                                          DetalhesAulaWidget.routeName,
                                                          queryParameters: {
                                                            'idAula': serializeParam(
                                                              widget.aula,
                                                              ParamType.String,
                                                            ),
                                                          }.withoutNulls,
                                                        );
                                                        safeSetState(() {});
                                                      }
                                                    : null,
                                              ),
                                            ],
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
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
  final String? nomeCategoria;
  final IconData iconCategoria;
  final bool isVincularContexto;
  final VoidCallback onBack;
  const _Header({
    required this.nomeModulo,
    required this.nomeCategoria,
    required this.iconCategoria,
    required this.isVincularContexto,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 10,
      spacing: 10,
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
              Icon(iconCategoria, size: 16, color: theme.primary),
              SizedBox(width: 6),
              Text(
                'Categoria',
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
          nomeCategoria ?? 'Categoria',
          style: GoogleFonts.interTight(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: theme.primaryText,
            height: 1.1,
          ),
        ),
        if ((nomeModulo ?? '').isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.menu_book_rounded, size: 12, color: theme.secondaryText),
                SizedBox(width: 4),
                Text(
                  nomeModulo!,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
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

class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasText = widget.controller.text.isNotEmpty;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        constraints: BoxConstraints(maxWidth: 480),
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hover ? theme.primary.withValues(alpha: 0.4) : theme.alternate,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.search_rounded, size: 20, color: theme.secondaryText),
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                onChanged: (v) {
                  setState(() {});
                  widget.onChanged(v);
                },
                style: GoogleFonts.inter(fontSize: 14, color: theme.primaryText),
                decoration: InputDecoration(
                  hintText: 'Buscar conteúdo pelo nome…',
                  hintStyle: GoogleFonts.inter(fontSize: 14, color: theme.secondaryText),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            if (hasText)
              IconButton(
                onPressed: widget.onClear,
                icon: Icon(Icons.close_rounded, size: 18, color: theme.secondaryText),
                splashRadius: 20,
                tooltip: 'Limpar',
              ),
          ],
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

class _ConteudoTile extends StatefulWidget {
  final String nome;
  final IconData icon;
  final VoidCallback onVisualizar;
  final VoidCallback? onVincular;
  const _ConteudoTile({
    required this.nome,
    required this.icon,
    required this.onVisualizar,
    required this.onVincular,
  });

  @override
  State<_ConteudoTile> createState() => _ConteudoTileState();
}

class _ConteudoTileState extends State<_ConteudoTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 720;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hover ? theme.primary.withValues(alpha: 0.40) : theme.alternate,
            width: 1.2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: isMobile ? _buildMobile(theme) : _buildDesktop(theme),
        ),
      ),
    );
  }

  Widget _buildDesktop(FlutterFlowTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _icon(theme),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            widget.nome,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.interTight(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              height: 1.25,
            ),
          ),
        ),
        SizedBox(width: 12),
        _actions(),
      ],
    );
  }

  Widget _buildMobile(FlutterFlowTheme theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _icon(theme),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.nome,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.interTight(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryText,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        _actions(),
      ],
    );
  }

  Widget _icon(FlutterFlowTheme theme) => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(widget.icon, size: 18, color: theme.primary),
      );

  Widget _actions() => Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.end,
        children: [
          _ActionPill(
            icon: Icons.visibility_rounded,
            label: 'Visualizar',
            onTap: widget.onVisualizar,
            primary: false,
          ),
          if (widget.onVincular != null)
            _ActionPill(
              icon: Icons.link_rounded,
              label: 'Vincular na aula',
              onTap: widget.onVincular!,
              primary: true,
            ),
        ],
      );
}

class _ActionPill extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;
  const _ActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.primary,
  });

  @override
  State<_ActionPill> createState() => _ActionPillState();
}

class _ActionPillState extends State<_ActionPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bg = widget.primary
        ? (_hover ? theme.primary : theme.primary.withValues(alpha: 0.12))
        : (_hover ? theme.alternate : theme.primaryBackground);
    final fg = widget.primary
        ? (_hover ? Colors.white : theme.primary)
        : theme.primaryText;
    final border = widget.primary
        ? Colors.transparent
        : theme.alternate;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: Duration(milliseconds: 120),
        scale: _hover ? 0.97 : 1.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: border),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: widget.onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
