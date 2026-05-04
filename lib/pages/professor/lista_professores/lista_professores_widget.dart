import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:data_table_2/data_table_2.dart' show ColumnSize;
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'lista_professores_model.dart';
export 'lista_professores_model.dart';

class ListaProfessoresWidget extends StatefulWidget {
  const ListaProfessoresWidget({super.key});

  static String routeName = 'ListaProfessores';
  static String routePath = '/listaProfessores';

  @override
  State<ListaProfessoresWidget> createState() => _ListaProfessoresWidgetState();
}

class _ListaProfessoresWidgetState extends State<ListaProfessoresWidget> {
  late ListaProfessoresModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaProfessoresModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<ApiCallResponse> _fetchProfessores() {
    final search = _model.textController.text.trim();
    if (search.isEmpty) {
      return SupabaseGroup.listaProfessoresCall.call(
        pIdFranquia: FFAppState().idfranquia,
        token: currentJwtToken,
      );
    }
    return SupabaseGroup.listaProfessoresFiltroCall.call(
      pIdFranquia: FFAppState().idfranquia,
      pSearch: search,
      token: currentJwtToken,
    );
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
                child: const SidebarWidget(route: 'Professor'),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: isCompact ? 20.0 : 28.0,
                  ),
                  child: FutureBuilder<ApiCallResponse>(
                    future: _model
                        .listaProfessores(requestFn: _fetchProfessores)
                        .then((result) {
                      _model.apiRequestCompleted = true;
                      return result;
                    }),
                    builder: (context, snapshot) {
                      final loading = !snapshot.hasData;
                      List<ListaProfessoresStruct> professores = [];
                      if (snapshot.hasData) {
                        professores = (snapshot.data!.jsonBody
                                    .toList()
                                    .map<ListaProfessoresStruct?>(
                                        ListaProfessoresStruct.maybeFromMap)
                                    .toList()
                                as Iterable<ListaProfessoresStruct?>)
                            .withoutNulls
                            ?.toList() ??
                            [];
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Header(
                            theme: theme,
                            isCompact: isCompact,
                            count: professores.length,
                            loading: loading,
                            onAdd: () => context.pushNamed(
                                AdicionarProfessorWidget.routeName),
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
                                  _model.clearListaProfessoresCache();
                                  _model.apiRequestCompleted = false;
                                });
                                await _model.waitForApiRequestCompleted();
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: _ProfessoresCard(
                              theme: theme,
                              isCompact: isCompact,
                              loading: loading,
                              professores: professores,
                              controller: _model.paginatedDataTableController,
                              onTapItem: (item) => context.pushNamed(
                                DetalhesProfessorWidget.routeName,
                                queryParameters: {
                                  'profId': serializeParam(
                                      item.userId, ParamType.String),
                                  'metaProfId': serializeParam(
                                      item.professorMetaId, ParamType.String),
                                }.withoutNulls,
                              ),
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
          child: Icon(Icons.school_rounded, color: theme.primary, size: 22.0),
        ),
        const SizedBox(width: 14.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Professores',
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
                    ? 'Carregando professores...'
                    : '$count ${count == 1 ? 'professor' : 'professores'} cadastrados',
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
          label: isCompact ? 'Novo' : 'Novo professor',
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
                  color: theme.primary
                      .withValues(alpha: _hovered ? 0.30 : 0.18),
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
          hintText: 'Buscar por nome, e-mail, telefone...',
          hintStyle: theme.labelMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w400),
            fontWeight: FontWeight.w400,
            fontSize: 13.5,
            color: theme.secondaryText,
          ),
          prefixIcon:
              Icon(Icons.search_rounded, color: theme.secondaryText, size: 20.0),
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

class _ProfessoresCard extends StatelessWidget {
  const _ProfessoresCard({
    required this.theme,
    required this.isCompact,
    required this.loading,
    required this.professores,
    required this.controller,
    required this.onTapItem,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final bool loading;
  final List<ListaProfessoresStruct> professores;
  final FlutterFlowDataTableController<ListaProfessoresStruct> controller;
  final void Function(ListaProfessoresStruct) onTapItem;

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
            : (professores.isEmpty
                ? _EmptyState(theme: theme)
                : FlutterFlowDataTable<ListaProfessoresStruct>(
                    controller: controller,
                    data: professores,
                    columnsBuilder: (onSortChanged) => [
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: 'Professor'),
                        size: ColumnSize.L,
                      ),
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: 'Contato'),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: 'Turmas'),
                        fixedWidth: 90.0,
                      ),
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: 'Alunos'),
                        fixedWidth: 90.0,
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
                        DataCell(_ProfessorCell(theme: theme, item: item)),
                        DataCell(_ContatoCell(theme: theme, item: item)),
                        DataCell(_CountBadge(
                          theme: theme,
                          value: item.turmaCount,
                          color: theme.primary,
                        )),
                        DataCell(_CountBadge(
                          theme: theme,
                          value: item.alunoCount.toInt(),
                          color: theme.secondaryText,
                        )),
                        DataCell(
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: _RowActionButton(
                              theme: theme,
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

class _ProfessorCell extends StatelessWidget {
  const _ProfessorCell({required this.theme, required this.item});

  final FlutterFlowTheme theme;
  final ListaProfessoresStruct item;

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFrom(item.nome);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.nome.isEmpty ? 'Sem nome' : item.nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  item.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.bodySmall.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    fontWeight: FontWeight.w500,
                    fontSize: 12.5,
                    color: theme.secondaryText,
                  ),
                ),
              ],
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

class _ContatoCell extends StatelessWidget {
  const _ContatoCell({required this.theme, required this.item});

  final FlutterFlowTheme theme;
  final ListaProfessoresStruct item;

  @override
  Widget build(BuildContext context) {
    final tel = item.telefone;
    final hasTel = tel.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasTel ? Icons.phone_rounded : Icons.phone_disabled_rounded,
            size: 16.0,
            color: theme.secondaryText,
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              hasTel ? tel : '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
                color: hasTel ? theme.primaryText : theme.secondaryText,
              ),
            ),
          ),
        ],
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
        padding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
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

class _RowActionButton extends StatefulWidget {
  const _RowActionButton({required this.theme, required this.onTap});

  final FlutterFlowTheme theme;
  final VoidCallback onTap;

  @override
  State<_RowActionButton> createState() => _RowActionButtonState();
}

class _RowActionButtonState extends State<_RowActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
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
                ? theme.primary.withValues(alpha: 0.10)
                : theme.secondaryBackground,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: _hovered ? theme.primary : theme.alternate,
              width: 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_forward_rounded,
            color: _hovered ? theme.primary : theme.secondaryText,
            size: 16.0,
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
                Icons.school_rounded,
                color: theme.primary,
                size: 28.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Nenhum professor encontrado',
              style: theme.titleMedium.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
                color: theme.primaryText,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              'Tente ajustar a busca ou cadastre um novo professor.',
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
