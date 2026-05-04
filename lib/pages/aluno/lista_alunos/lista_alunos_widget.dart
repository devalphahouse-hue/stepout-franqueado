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
import 'lista_alunos_model.dart';
export 'lista_alunos_model.dart';

class ListaAlunosWidget extends StatefulWidget {
  const ListaAlunosWidget({super.key});

  static String routeName = 'ListaAlunos';
  static String routePath = '/listaAlunos';

  @override
  State<ListaAlunosWidget> createState() => _ListaAlunosWidgetState();
}

class _ListaAlunosWidgetState extends State<ListaAlunosWidget> {
  late ListaAlunosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaAlunosModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
                child: const SidebarWidget(route: 'Aluno'),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: isCompact ? 20.0 : 28.0,
                  ),
                  child: FutureBuilder<ApiCallResponse>(
                    future: _model
                        .listaAlunos(
                      requestFn: () =>
                          SupabaseGroup.listaAlunosFiltroCall.call(
                        pIdFranquia: FFAppState().idfranquia,
                        pSearch: _model.textController.text,
                        token: currentJwtToken,
                      ),
                    )
                        .then((result) {
                      _model.apiRequestCompleted = true;
                      return result;
                    }),
                    builder: (context, snapshot) {
                      final loading = !snapshot.hasData;
                      List<ListaAlunosStruct> alunos = [];
                      if (snapshot.hasData) {
                        alunos = (snapshot.data!.jsonBody
                                    .toList()
                                    .map<ListaAlunosStruct?>(
                                        ListaAlunosStruct.maybeFromMap)
                                    .toList()
                                as Iterable<ListaAlunosStruct?>)
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
                            count: alunos.length,
                            loading: loading,
                            onAdd: () => context
                                .pushNamed(AdicionarAlunoWidget.routeName),
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
                                  _model.clearListaAlunosCache();
                                  _model.apiRequestCompleted = false;
                                });
                                await _model.waitForApiRequestCompleted();
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: _AlunosCard(
                              theme: theme,
                              isCompact: isCompact,
                              loading: loading,
                              alunos: alunos,
                              controller:
                                  _model.paginatedDataTableController,
                              onTapItem: (item) => context.pushNamed(
                                DetalhesAlunoWidget.routeName,
                                queryParameters: {
                                  'idaluno': serializeParam(
                                      item.userId, ParamType.String),
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
    final titleCol = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10.0),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.people_alt_rounded,
                  color: theme.primary, size: 22.0),
            ),
            const SizedBox(width: 12.0),
            Text(
              'Alunos',
              style: theme.headlineMedium.override(
                font:
                    GoogleFonts.interTight(fontWeight: FontWeight.w800),
                fontSize: isCompact ? 22.0 : 26.0,
                fontWeight: FontWeight.w800,
                color: theme.primaryText,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Padding(
          padding: const EdgeInsets.only(left: 52.0),
          child: Text(
            loading
                ? 'Carregando alunos…'
                : (count == 0
                    ? 'Nenhum aluno cadastrado ainda'
                    : '$count ${count == 1 ? 'aluno cadastrado' : 'alunos cadastrados'}'),
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              fontSize: 13.0,
              color: theme.secondaryText,
              letterSpacing: 0.0,
            ),
          ),
        ),
      ],
    );

    final addButton = _PrimaryButton(
      label: 'Novo aluno',
      icon: Icons.add_rounded,
      onTap: onAdd,
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleCol,
          const SizedBox(height: 12.0),
          addButton,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: titleCol),
        const SizedBox(width: 16.0),
        addButton,
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: (_) => onChanged(),
      style: theme.bodyMedium.override(
        font: GoogleFonts.inter(),
        fontSize: 14.5,
        color: theme.primaryText,
        letterSpacing: 0.0,
      ),
      cursorColor: theme.primary,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Buscar por nome, e-mail, CPF…',
        hintStyle: theme.bodyMedium.override(
          font: GoogleFonts.inter(),
          fontSize: 14.5,
          color: theme.secondaryText,
          letterSpacing: 0.0,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 10.0),
          child:
              Icon(Icons.search_rounded, color: theme.secondaryText, size: 20.0),
        ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: Icon(Icons.close_rounded,
                    color: theme.secondaryText, size: 18.0),
                onPressed: () {
                  controller.clear();
                  onChanged();
                },
              ),
        filled: true,
        fillColor: theme.primaryBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.alternate, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primary, width: 1.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}

class _AlunosCard extends StatelessWidget {
  const _AlunosCard({
    required this.theme,
    required this.isCompact,
    required this.loading,
    required this.alunos,
    required this.controller,
    required this.onTapItem,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final bool loading;
  final List<ListaAlunosStruct> alunos;
  final FlutterFlowDataTableController<ListaAlunosStruct> controller;
  final void Function(ListaAlunosStruct) onTapItem;

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
            blurRadius: 18,
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
                    valueColor:
                        AlwaysStoppedAnimation<Color>(theme.primary),
                  ),
                ),
              )
            : (alunos.isEmpty
                ? _EmptyState(theme: theme)
                : FlutterFlowDataTable<ListaAlunosStruct>(
                    controller: controller,
                    data: alunos,
                    columnsBuilder: (onSortChanged) => [
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: 'Aluno'),
                        size: ColumnSize.L,
                      ),
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: 'Contato'),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: _ColLabel(theme: theme, text: 'Turma'),
                        size: ColumnSize.M,
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
                        DataCell(_AlunoCell(theme: theme, item: item)),
                        DataCell(_ContatoCell(theme: theme, item: item)),
                        DataCell(_TurmaCell(theme: theme, item: item)),
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
                    columnSpacing: 24.0,
                    headingRowColor: theme.secondaryBackground
                        .withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(0.0),
                    addHorizontalDivider: true,
                    addTopAndBottomDivider: false,
                    hideDefaultHorizontalDivider: false,
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
    return Text(
      text,
      style: theme.titleSmall.override(
        font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        color: theme.secondaryText,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _AlunoCell extends StatelessWidget {
  const _AlunoCell({required this.theme, required this.item});
  final FlutterFlowTheme theme;
  final ListaAlunosStruct item;

  String _initials() {
    final n = item.nome.trim();
    if (n.isEmpty) return '?';
    final parts = n.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            _initials(),
            style: theme.titleSmall.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontSize: 13.0,
              fontWeight: FontWeight.w700,
              color: theme.primary,
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.titleSmall.override(
                  font:
                      GoogleFonts.interTight(fontWeight: FontWeight.w700),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryText,
                  letterSpacing: 0.0,
                ),
              ),
              if (item.email.isNotEmpty)
                Text(
                  item.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
    );
  }
}

class _ContatoCell extends StatelessWidget {
  const _ContatoCell({required this.theme, required this.item});
  final FlutterFlowTheme theme;
  final ListaAlunosStruct item;

  @override
  Widget build(BuildContext context) {
    return Text(
      item.telefone.isEmpty ? '—' : item.telefone,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.bodyMedium.override(
        font: GoogleFonts.inter(),
        fontSize: 13.5,
        color: theme.primaryText,
        letterSpacing: 0.0,
      ),
    );
  }
}

class _TurmaCell extends StatelessWidget {
  const _TurmaCell({required this.theme, required this.item});
  final FlutterFlowTheme theme;
  final ListaAlunosStruct item;

  @override
  Widget build(BuildContext context) {
    final turma = item.alunosTurma.trim();
    if (turma.isEmpty) {
      return Text(
        'Sem turma',
        style: theme.bodySmall.override(
          font: GoogleFonts.inter(fontStyle: FontStyle.italic),
          fontSize: 12.5,
          color: theme.secondaryText,
          letterSpacing: 0.0,
        ),
      );
    }
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Text(
        turma,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.bodySmall.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: theme.primary,
          letterSpacing: 0.2,
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
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            color: _hover
                ? t.primary.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: _hover ? t.primary.withValues(alpha: 0.40) : t.alternate,
              width: 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_forward_rounded,
            color: _hover ? t.primary : t.secondaryText,
            size: 18.0,
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
            child: Icon(Icons.person_search_rounded,
                color: theme.primary, size: 28.0),
          ),
          const SizedBox(height: 12.0),
          Text(
            'Nenhum aluno encontrado',
            style: theme.titleSmall.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Tente ajustar os filtros ou cadastre um novo aluno.',
            textAlign: TextAlign.center,
            style: theme.bodySmall.override(
              font: GoogleFonts.inter(),
              fontSize: 13.0,
              color: theme.secondaryText,
              letterSpacing: 0.0,
              lineHeight: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
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
    final base = theme.primary;
    final bg = (_hovered || _pressed) ? base.withValues(alpha: 0.88) : base;

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
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: 46.0,
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: base.withValues(alpha: 0.20),
                  blurRadius: 18.0,
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
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
