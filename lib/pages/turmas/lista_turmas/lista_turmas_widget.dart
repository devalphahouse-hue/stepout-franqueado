import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:data_table_2/data_table_2.dart' show ColumnSize;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'lista_turmas_model.dart';
export 'lista_turmas_model.dart';

class ListaTurmasWidget extends StatefulWidget {
  const ListaTurmasWidget({super.key});

  static String routeName = 'ListaTurmas';
  static String routePath = '/listaTurmas';

  @override
  State<ListaTurmasWidget> createState() => _ListaTurmasWidgetState();
}

class _ListaTurmasWidgetState extends State<ListaTurmasWidget> {
  late ListaTurmasModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaTurmasModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(ListaTurmasStruct item) async {
    final alunosCount = item.totalAlunos;
    var mensagem = 'O registro será desativado.';
    if (alunosCount > 0) {
      mensagem =
          'Esta turma possui $alunosCount aluno(s) vinculado(s). Ao excluir, os alunos serão desvinculados.';
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (alertCtx) {
        return WebViewAware(
          child: AlertDialog(
            title: const Text('Tem certeza que deseja excluir esta turma?'),
            content: Text(mensagem),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertCtx, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(alertCtx, true),
                child: const Text('Excluir'),
              ),
            ],
          ),
        );
      },
    );
    if (confirm ?? false) {
      await TurmasTable().update(
        data: {'deleted_at': DateTime.now().toUtc().toIso8601String()},
        matchingRows: (rows) => rows.eqOrNull('id', item.id),
      );
      _model.clearListaTurmasCache();
      safeSetState(() {
        _model.apiRequestCompleted = false;
      });
      await _model.waitForApiRequestCompleted();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Turma excluída'),
            backgroundColor: FlutterFlowTheme.of(context).primary,
            duration: const Duration(milliseconds: 2500),
          ),
        );
      }
    }
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
                child: const SidebarWidget(route: 'Turma'),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: isCompact ? 20.0 : 28.0,
                  ),
                  child: FutureBuilder<ApiCallResponse>(
                    future: _model
                        .listaTurmas(
                      requestFn: () => SupabaseGroup.listaTurmasCall.call(
                        pIdFranquia: FFAppState().idfranquia,
                        token: currentJwtToken,
                        pSearch: _model.textController.text,
                      ),
                    )
                        .then((result) {
                      _model.apiRequestCompleted = true;
                      return result;
                    }),
                    builder: (context, snapshot) {
                      final loading = !snapshot.hasData;
                      List<ListaTurmasStruct> turmas = [];
                      if (snapshot.hasData) {
                        turmas = (snapshot.data!.jsonBody
                                .toList()
                                .map<ListaTurmasStruct?>(
                                    ListaTurmasStruct.maybeFromMap)
                                .toList() as Iterable<ListaTurmasStruct?>)
                            .withoutNulls
                            .toList();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Header(
                            theme: theme,
                            isCompact: isCompact,
                            count: turmas.length,
                            loading: loading,
                            onAdd: () => context
                                .pushNamed(AdicionarTurmaWidget.routeName),
                          ),
                          const SizedBox(height: 20.0),
                          _SearchField(
                            theme: theme,
                            controller: _model.textController!,
                            focusNode: _model.textFieldFocusNode!,
                            onChanged: () => EasyDebounce.debounce(
                              '_model.textController',
                              const Duration(milliseconds: 400),
                              () async {
                                safeSetState(() {
                                  _model.clearListaTurmasCache();
                                  _model.apiRequestCompleted = false;
                                });
                                await _model.waitForApiRequestCompleted();
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: _TurmasCard(
                              theme: theme,
                              isCompact: isCompact,
                              loading: loading,
                              turmas: turmas,
                              controller: _model.paginatedDataTableController,
                              onTapItem: (item) => context.pushNamed(
                                DetalhesTurmaWidget.routeName,
                                queryParameters: {
                                  'idTurma': serializeParam(
                                      item.id, ParamType.String),
                                }.withoutNulls,
                              ),
                              onDelete: _confirmDelete,
                            ),
                          ),
                        ],
                      );
                    },
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

// ---------------------------------------------------------------------------
// HEADER
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.theme,
    required this.isCompact,
    required this.count,
    required this.loading,
    required this.onAdd,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final int count;
  final bool loading;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12.0),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.groups_2_rounded, color: theme.primary, size: 22.0),
        ),
        const SizedBox(width: 14.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Turmas',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.headlineSmall.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                  fontWeight: FontWeight.w800,
                  fontSize: isCompact ? 22.0 : 26.0,
                  letterSpacing: -0.4,
                  color: theme.primaryText,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                loading
                    ? 'Carregando turmas...'
                    : '$count ${count == 1 ? 'turma ativa' : 'turmas ativas'}',
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  fontWeight: FontWeight.w500,
                  fontSize: 13.0,
                  color: theme.secondaryText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12.0),
        _PrimaryButton(
          icon: Icons.add_rounded,
          label: isCompact ? 'Nova' : 'Nova turma',
          onTap: onAdd,
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
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
    final scale = _pressed ? 0.97 : 1.0;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color:
                      theme.primary.withValues(alpha: _hovered ? 0.30 : 0.18),
                  blurRadius: _hovered ? 18.0 : 12.0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: Colors.white, size: 18.0),
                const SizedBox(width: 8.0),
                Text(
                  widget.label,
                  style: theme.titleSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    letterSpacing: 0.2,
                    color: Colors.white,
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

// ---------------------------------------------------------------------------
// SEARCH
// ---------------------------------------------------------------------------

class _SearchField extends StatefulWidget {
  const _SearchField({
    required this.theme,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final FlutterFlowTheme theme;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onChanged;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final hasText = widget.controller.text.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: (_) => widget.onChanged(),
        style: theme.bodyMedium.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
          color: theme.primaryText,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Buscar por nome da turma, professor ou módulo...',
          hintStyle: theme.labelMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w400),
            fontWeight: FontWeight.w400,
            fontSize: 13.5,
            color: theme.secondaryText,
          ),
          prefixIcon: Icon(Icons.search_rounded,
              color: theme.secondaryText, size: 20.0),
          suffixIcon: hasText
              ? IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: theme.secondaryText, size: 18.0),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged();
                  },
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        cursorColor: theme.primary,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CARD WITH DATA TABLE
// ---------------------------------------------------------------------------

class _TurmasCard extends StatelessWidget {
  const _TurmasCard({
    required this.theme,
    required this.isCompact,
    required this.loading,
    required this.turmas,
    required this.controller,
    required this.onTapItem,
    required this.onDelete,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final bool loading;
  final List<ListaTurmasStruct> turmas;
  final FlutterFlowDataTableController<ListaTurmasStruct> controller;
  final void Function(ListaTurmasStruct) onTapItem;
  final Future<void> Function(ListaTurmasStruct) onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: theme.alternate, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 18.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox.expand(
        child: loading
            ? Center(
                child: SizedBox(
                  width: 28.0,
                  height: 28.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(theme.primary),
                  ),
                ),
              )
            : (turmas.isEmpty
                ? _EmptyState(theme: theme)
                : FlutterFlowDataTable<ListaTurmasStruct>(
                    controller: controller,
                    data: turmas,
                    columnsBuilder: (onSortChanged) => [
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: 'Turma'),
                        size: ColumnSize.L,
                      ),
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: 'Professor'),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: 'Módulo'),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: 'Alunos'),
                        fixedWidth: 90.0,
                      ),
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: ''),
                        fixedWidth: 64.0,
                      ),
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: ''),
                        fixedWidth: 64.0,
                      ),
                    ],
                    dataRowBuilder:
                        (item, idx, selected, onSelectChanged) => DataRow(
                      onSelectChanged: (_) => onTapItem(item),
                      color: WidgetStateProperty.all(
                        idx % 2 == 0
                            ? theme.primaryBackground
                            : theme.secondaryBackground.withValues(alpha: 0.5),
                      ),
                      cells: [
                        DataCell(_TurmaCell(theme: theme, item: item)),
                        DataCell(_ProfessorCell(theme: theme, item: item)),
                        DataCell(_ModuloChip(theme: theme, item: item)),
                        DataCell(_CountBadge(
                          theme: theme,
                          value: item.totalAlunos,
                          color: theme.primary,
                        )),
                        DataCell(
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: _IconAction(
                              theme: theme,
                              icon: Icons.delete_outline_rounded,
                              tooltip: 'Excluir turma',
                              accent: theme.error,
                              onTap: () => onDelete(item),
                            ),
                          ),
                        ),
                        DataCell(
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: _IconAction(
                              theme: theme,
                              icon: Icons.arrow_forward_rounded,
                              tooltip: 'Abrir detalhes',
                              accent: theme.primary,
                              onTap: () => onTapItem(item),
                            ),
                          ),
                        ),
                      ],
                    ),
                    emptyBuilder: () => _EmptyState(theme: theme),
                    paginated: true,
                    selectable: false,
                    hidePaginator: false,
                    showFirstLastButtons: false,
                    headingRowHeight: 52.0,
                    dataRowHeight: 64.0,
                    columnSpacing: 12.0,
                    headingRowColor: theme.secondaryBackground,
                    borderRadius: BorderRadius.zero,
                    addHorizontalDivider: true,
                    addTopAndBottomDivider: false,
                    hideDefaultHorizontalDivider: true,
                    horizontalDividerColor: theme.alternate,
                    horizontalDividerThickness: 1.0,
                    addVerticalDivider: false,
                  )),
      ),
    );
  }
}

class _ColLabel extends StatelessWidget {
  const _ColLabel({required this.theme, required this.text});

  final FlutterFlowTheme theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: theme.titleSmall.override(
          font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
          letterSpacing: 0.6,
          color: theme.secondaryText,
        ),
      ),
    );
  }
}

class _TurmaCell extends StatelessWidget {
  const _TurmaCell({required this.theme, required this.item});

  final FlutterFlowTheme theme;
  final ListaTurmasStruct item;

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFrom(item.nomeDaTurma);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: theme.primary.withValues(alpha: 0.12),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: theme.titleSmall.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                fontWeight: FontWeight.w800,
                fontSize: 13.0,
                color: theme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              item.nomeDaTurma.isEmpty ? 'Sem nome' : item.nomeDaTurma,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
                color: theme.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initialsFrom(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _ProfessorCell extends StatelessWidget {
  const _ProfessorCell({required this.theme, required this.item});

  final FlutterFlowTheme theme;
  final ListaTurmasStruct item;

  @override
  Widget build(BuildContext context) {
    final nome = item.professor.trim();
    final hasNome = nome.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasNome
                ? Icons.person_outline_rounded
                : Icons.person_off_outlined,
            size: 16.0,
            color: theme.secondaryText,
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              hasNome ? nome : 'Sem professor',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
                color: hasNome ? theme.primaryText : theme.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuloChip extends StatelessWidget {
  const _ModuloChip({required this.theme, required this.item});

  final FlutterFlowTheme theme;
  final ListaTurmasStruct item;

  @override
  Widget build(BuildContext context) {
    final modulo = item.moduloNivelTurma.trim();
    final hasModulo = modulo.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: hasModulo
              ? theme.secondaryBackground
              : theme.alternate.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: theme.alternate, width: 1.0),
        ),
        child: Text(
          hasModulo ? modulo : '—',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.bodySmall.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            fontWeight: FontWeight.w600,
            fontSize: 12.5,
            color: hasModulo ? theme.primaryText : theme.secondaryText,
          ),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.theme,
    required this.value,
    required this.color,
  });

  final FlutterFlowTheme theme;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999.0),
        ),
        child: Text(
          value.toString(),
          textAlign: TextAlign.center,
          style: theme.titleSmall.override(
            font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
            fontWeight: FontWeight.w700,
            fontSize: 13.0,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatefulWidget {
  const _IconAction({
    required this.theme,
    required this.icon,
    required this.tooltip,
    required this.accent,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String tooltip;
  final Color accent;
  final VoidCallback onTap;

  @override
  State<_IconAction> createState() => _IconActionState();
}

class _IconActionState extends State<_IconAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: _hovered
                  ? widget.accent.withValues(alpha: 0.10)
                  : theme.secondaryBackground,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: _hovered ? widget.accent : theme.alternate,
                width: 1.0,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              color: _hovered ? widget.accent : theme.secondaryText,
              size: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.0,
              height: 64.0,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.groups_2_rounded,
                color: theme.primary,
                size: 28.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Nenhuma turma encontrada',
              style: theme.titleMedium.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
                color: theme.primaryText,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              'Tente ajustar a busca ou cadastre uma nova turma.',
              textAlign: TextAlign.center,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
                color: theme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
