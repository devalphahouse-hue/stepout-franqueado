import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modulos_model.dart';
export 'modulos_model.dart';

class ModulosWidget extends StatefulWidget {
  const ModulosWidget({
    super.key,
    this.aula,
    this.vinculadosCount,
  });

  final String? aula;
  final int? vinculadosCount;

  static String routeName = 'Modulos';
  static String routePath = '/modulos';

  @override
  State<ModulosWidget> createState() => _ModulosWidgetState();
}

class _ModulosWidgetState extends State<ModulosWidget> {
  late ModulosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';
  int? _totalVinculadosAula;

  Future<void> _carregarTotalVinculados() async {
    if (widget.aula == null || widget.aula!.isEmpty) return;
    try {
      final rows = await AulasTable().queryRows(
        queryFn: (q) => q.eqOrNull('id', widget.aula),
      );
      final total = rows.firstOrNull?.conteudosVinculados.length ?? 0;
      if (!mounted) return;
      safeSetState(() => _totalVinculadosAula = total);
    } catch (_) {
      // Sem total atualizado: chip volta ao estado amarelo padrão.
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModulosModel());
    _carregarTotalVinculados();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      safeSetState(() {});
      final count = widget.vinculadosCount ?? 0;
      if (count > 0) {
        final theme = FlutterFlowTheme.of(context);
        final msg = count == 1
            ? '1 conteúdo vinculado à aula com sucesso'
            : '$count conteúdos vinculados à aula com sucesso';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    msg,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: theme.primary,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    EasyDebounce.cancel('modulos_search');
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
    if (w < 720) return 1;
    if (w < 1100) return 2;
    return 3;
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Header(
                            isVincularContexto: isVincularContexto,
                            vinculadosCount: _totalVinculadosAula,
                            onVoltarAula: isVincularContexto
                                ? () => context.pushNamed(
                                      DetalhesAulaWidget.routeName,
                                      queryParameters: {
                                        'idAula': serializeParam(
                                            widget.aula, ParamType.String),
                                      }.withoutNulls,
                                    )
                                : null,
                          ),
                          SizedBox(height: 20),
                          _SearchBar(
                            controller: _searchCtrl,
                            onChanged: (v) {
                              EasyDebounce.debounce(
                                'modulos_search',
                                Duration(milliseconds: 300),
                                () => safeSetState(() => _search = v.trim().toLowerCase()),
                              );
                            },
                            onClear: () {
                              _searchCtrl.clear();
                              EasyDebounce.cancel('modulos_search');
                              safeSetState(() => _search = '');
                            },
                          ),
                          SizedBox(height: 20),
                          FutureBuilder<List<ModulosDeConteudoRow>>(
                            future: ModulosDeConteudoTable().queryRows(
                              queryFn: (q) => q
                                  .eqOrNull('status_modulo', true)
                                  .order('nome_modulo', ascending: true),
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
                                  : all.where((m) {
                                      final n = (m.nomeModulo ?? '').toLowerCase();
                                      final lv = (m.nivelModulo ?? '').toLowerCase();
                                      return n.contains(_search) || lv.contains(_search);
                                    }).toList();

                              if (filtered.isEmpty) {
                                return _EmptyState(
                                  icon: Icons.menu_book_rounded,
                                  title: _search.isEmpty
                                      ? 'Nenhum módulo cadastrado'
                                      : 'Nenhum módulo encontrado',
                                  subtitle: _search.isEmpty
                                      ? 'Os módulos cadastrados aparecerão aqui.'
                                      : 'Tente outra busca pelo nome ou pelo nível.',
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
                                  childAspectRatio: 2.4,
                                ),
                                itemCount: filtered.length,
                                itemBuilder: (context, idx) {
                                  final m = filtered[idx];
                                  return _ModuloCard(
                                    index: idx + 1,
                                    nome: m.nomeModulo ?? 'Módulo',
                                    nivel: m.nivelModulo ?? '—',
                                    isVincularContexto: isVincularContexto,
                                    onTap: () {
                                      context.pushNamed(
                                        CategoriasWidget.routeName,
                                        queryParameters: {
                                          'modulo': serializeParam(m.id, ParamType.String),
                                          'aula': serializeParam(widget.aula, ParamType.String),
                                        }.withoutNulls,
                                        extra: <String, dynamic>{
                                          '__transition_info__': TransitionInfo(
                                            hasTransition: true,
                                            transitionType: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 0),
                                          ),
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
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
  final bool isVincularContexto;
  final int? vinculadosCount;
  final VoidCallback? onVoltarAula;
  const _Header({
    required this.isVincularContexto,
    this.vinculadosCount,
    this.onVoltarAula,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 8,
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
              Icon(Icons.menu_book_rounded, size: 16, color: theme.primary),
              SizedBox(width: 6),
              Text(
                'Conteúdos',
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
          'Módulos',
          style: GoogleFonts.interTight(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: theme.primaryText,
            height: 1.1,
          ),
        ),
        if (isVincularContexto)
          Builder(builder: (context) {
            final count = vinculadosCount ?? 0;
            final isSucesso = count > 0;
            final cor = isSucesso ? theme.primary : theme.warning;
            final icone = isSucesso
                ? Icons.check_circle_rounded
                : Icons.link_rounded;
            final texto = isSucesso
                ? (count == 1
                    ? '1 conteúdo vinculado à aula'
                    : '$count conteúdos vinculados à aula')
                : 'Selecione um conteúdo para vincular à aula';
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: cor.withValues(alpha: 0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icone, size: 14, color: cor),
                  SizedBox(width: 6),
                  Text(
                    texto,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cor,
                    ),
                  ),
                ],
              ),
            );
          }),
        if (isVincularContexto && onVoltarAula != null)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onVoltarAula,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: theme.primary.withValues(alpha: 0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_rounded, size: 14, color: theme.primary),
                    SizedBox(width: 6),
                    Text(
                      'Voltar à aula',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            'Confira o acervo de materiais disponíveis para utilizar nas aulas.',
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
                  hintText: 'Buscar módulos por nome ou nível…',
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

class _ModuloCard extends StatefulWidget {
  final int index;
  final String nome;
  final String nivel;
  final bool isVincularContexto;
  final VoidCallback onTap;
  const _ModuloCard({
    required this.index,
    required this.nome,
    required this.nivel,
    required this.isVincularContexto,
    required this.onTap,
  });

  @override
  State<_ModuloCard> createState() => _ModuloCardState();
}

class _ModuloCardState extends State<_ModuloCard> {
  bool _hover = false;

  Color _nivelColor(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final lv = widget.nivel.toUpperCase();
    if (lv.startsWith('A')) return theme.success;
    if (lv.startsWith('B')) return theme.warning;
    if (lv.startsWith('C')) return theme.error;
    return theme.info;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final cor = _nivelColor(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: Duration(milliseconds: 120),
        scale: _hover ? 0.985 : 1.0,
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
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: theme.primary,
                        size: 26,
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.interTight(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: theme.primaryText,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: cor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.signal_cellular_alt_rounded, size: 12, color: cor),
                                    SizedBox(width: 4),
                                    Text(
                                      'Nível ${widget.nivel}',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: cor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.secondaryBackground,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'Módulo ${widget.index.toString().padLeft(2, '0')}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: theme.secondaryText,
                                  ),
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _hover
                            ? theme.primary
                            : theme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: _hover ? Colors.white : theme.primary,
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
            child: Icon(icon, size: 30, color: theme.primary),
          ),
          SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.interTight(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
            ),
          ),
          SizedBox(height: 6),
          Text(
            subtitle,
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
