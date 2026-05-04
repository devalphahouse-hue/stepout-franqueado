import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'treinamentos_model.dart';
export 'treinamentos_model.dart';

class TreinamentosWidget extends StatefulWidget {
  const TreinamentosWidget({super.key});

  static String routeName = 'Treinamentos';
  static String routePath = '/treinamentos';

  @override
  State<TreinamentosWidget> createState() => _TreinamentosWidgetState();
}

class _TreinamentosWidgetState extends State<TreinamentosWidget> {
  late TreinamentosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinamentosModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    EasyDebounce.cancel('treinamentos_search');
    _model.dispose();
    super.dispose();
  }

  double _responsivePadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < kBreakpointSmall) return 12.0;
    if (w < 1100) return 24.0;
    return 48.0;
  }

  @override
  Widget build(BuildContext context) {
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
                model: _model.sidebarModel,
                updateCallback: () => safeSetState(() {}),
                child: SidebarWidget(route: 'Treinamentos'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  primary: false,
                  child: Padding(
                    padding: EdgeInsets.all(_responsivePadding(context)),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: 1440),
                      child: FutureBuilder<List<TreinamentosRow>>(
                        future: TreinamentosTable().queryRows(
                          queryFn: (q) => q
                              .eqOrNull('status_treinamento', true)
                              .eqOrNull('treinamento_franqueado', true),
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              height: 320,
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
                              : all.where((t) =>
                                  (t.tituloTreinamento ?? '')
                                      .toLowerCase()
                                      .contains(_search))
                                  .toList();

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Header(count: all.length),
                              SizedBox(height: 20),
                              _SearchField(
                                controller: _searchCtrl,
                                onChanged: (v) {
                                  EasyDebounce.debounce(
                                    'treinamentos_search',
                                    Duration(milliseconds: 250),
                                    () => safeSetState(
                                        () => _search = v.trim().toLowerCase()),
                                  );
                                  safeSetState(() {});
                                },
                                onClear: () {
                                  _searchCtrl.clear();
                                  EasyDebounce.cancel('treinamentos_search');
                                  safeSetState(() => _search = '');
                                },
                              ),
                              SizedBox(height: 20),
                              if (filtered.isEmpty)
                                _EmptyState(
                                  hasSearch: _search.isNotEmpty,
                                )
                              else
                                _List(
                                  treinamentos: filtered,
                                  onTap: (t) async {
                                    final link = t.linkTreinamento;
                                    if (link == null || link.isEmpty) return;
                                    await launchURL(link);
                                  },
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

// ============================================================================
// HEADER
// ============================================================================
class _Header extends StatelessWidget {
  final int count;
  const _Header({required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 10,
      spacing: 12,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cast_for_education_rounded,
                  size: 16, color: theme.primary),
              SizedBox(width: 6),
              Text(
                'Capacitação',
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
          'Treinamentos',
          style: GoogleFonts.interTight(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: theme.primaryText,
            height: 1.1,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: theme.primary.withValues(alpha: 0.40)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_lesson_rounded, size: 13, color: theme.primary),
              SizedBox(width: 5),
              Text(
                '$count ${count == 1 ? "treinamento" : "treinamentos"}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: theme.primary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            'Acesse os conteúdos de capacitação disponíveis para a franquia.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: theme.secondaryText,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SEARCH
// ============================================================================
class _SearchField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
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
            color: _hover
                ? theme.primary.withValues(alpha: 0.4)
                : theme.alternate,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.search_rounded,
                  size: 20, color: theme.secondaryText),
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: theme.primaryText,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar treinamento pelo título…',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: theme.secondaryText,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            if (hasText)
              IconButton(
                onPressed: widget.onClear,
                icon: Icon(Icons.close_rounded,
                    size: 18, color: theme.secondaryText),
                splashRadius: 20,
                tooltip: 'Limpar',
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// LIST
// ============================================================================
class _List extends StatelessWidget {
  final List<TreinamentosRow> treinamentos;
  final ValueChanged<TreinamentosRow> onTap;
  const _List({required this.treinamentos, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
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
                  child: Icon(Icons.play_lesson_rounded,
                      color: theme.primary, size: 18),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conteúdos disponíveis',
                        style: GoogleFonts.interTight(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: theme.primaryText,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Clique em um treinamento para abrir em nova aba.',
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
            Column(
              children: [
                for (int i = 0; i < treinamentos.length; i++) ...[
                  if (i > 0) SizedBox(height: 10),
                  _TreinamentoTile(
                    index: i + 1,
                    row: treinamentos[i],
                    onTap: () => onTap(treinamentos[i]),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TreinamentoTile extends StatefulWidget {
  final int index;
  final TreinamentosRow row;
  final VoidCallback onTap;
  const _TreinamentoTile({
    required this.index,
    required this.row,
    required this.onTap,
  });

  @override
  State<_TreinamentoTile> createState() => _TreinamentoTileState();
}

class _TreinamentoTileState extends State<_TreinamentoTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final titulo = widget.row.tituloTreinamento ?? 'Treinamento';
    final hasLink = (widget.row.linkTreinamento ?? '').isNotEmpty;

    return MouseRegion(
      cursor: hasLink
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        if (hasLink) setState(() => _hover = true);
      },
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hover
                ? theme.primary.withValues(alpha: 0.55)
                : theme.alternate,
            width: 1.2,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    blurRadius: 12,
                    color: theme.primary.withValues(alpha: 0.10),
                    offset: Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: hasLink ? widget.onTap : null,
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar com play icon e número
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              theme.primary,
                              theme.primary.withValues(alpha: 0.75),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: theme.primary.withValues(alpha: 0.25),
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.primaryBackground,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: theme.alternate),
                          ),
                          child: Text(
                            widget.index.toString().padLeft(2, '0'),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: theme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.interTight(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: theme.primaryText,
                            height: 1.25,
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              hasLink
                                  ? Icons.open_in_new_rounded
                                  : Icons.link_off_rounded,
                              size: 12,
                              color: hasLink
                                  ? theme.primary
                                  : theme.secondaryText,
                            ),
                            SizedBox(width: 4),
                            Text(
                              hasLink
                                  ? 'Abrir em nova aba'
                                  : 'Link indisponível',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: hasLink
                                    ? theme.primary
                                    : theme.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 160),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: !hasLink
                          ? theme.alternate
                          : (_hover
                              ? theme.primary
                              : theme.primary.withValues(alpha: 0.12)),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: (_hover && hasLink)
                          ? [
                              BoxShadow(
                                blurRadius: 8,
                                color: theme.primary.withValues(alpha: 0.30),
                                offset: Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility_rounded,
                          size: 14,
                          color: !hasLink
                              ? theme.secondaryText
                              : (_hover ? Colors.white : theme.primary),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Visualizar',
                          style: GoogleFonts.interTight(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: !hasLink
                                ? theme.secondaryText
                                : (_hover ? Colors.white : theme.primary),
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

// ============================================================================
// EMPTY
// ============================================================================
class _EmptyState extends StatelessWidget {
  final bool hasSearch;
  const _EmptyState({required this.hasSearch});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 56),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(
              hasSearch
                  ? Icons.search_off_rounded
                  : Icons.cast_for_education_rounded,
              size: 30,
              color: theme.primary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            hasSearch
                ? 'Nenhum treinamento encontrado'
                : 'Nenhum treinamento disponível',
            textAlign: TextAlign.center,
            style: GoogleFonts.interTight(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: theme.primaryText,
            ),
          ),
          SizedBox(height: 6),
          Text(
            hasSearch
                ? 'Tente outro termo de busca.'
                : 'Os treinamentos cadastrados para a franquia aparecerão aqui.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: theme.secondaryText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
