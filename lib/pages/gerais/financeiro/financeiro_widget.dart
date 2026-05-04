import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/components/modal_pagamento_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'financeiro_model.dart';
export 'financeiro_model.dart';

class FinanceiroWidget extends StatefulWidget {
  const FinanceiroWidget({super.key});

  static String routeName = 'Financeiro';
  static String routePath = '/financeiro';

  @override
  State<FinanceiroWidget> createState() => _FinanceiroWidgetState();
}

class _FinanceiroWidgetState extends State<FinanceiroWidget> {
  late FinanceiroModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentPage = 1;
  int _perPage = 10;

  Future<void> _refreshPage() async {
    safeSetState(() {
      _model.clearCobranacaCache();
      _model.apiRequestCompleted = false;
    });
    await _model.waitForApiRequestCompleted();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FinanceiroModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    EasyDebounce.cancel('financeiro_search');
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
                model: _model.sidebarModel,
                updateCallback: () => safeSetState(() {}),
                child: SidebarWidget(route: 'Financeiro'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  primary: false,
                  child: Padding(
                    padding: EdgeInsets.all(_responsivePadding(context)),
                    child: FutureBuilder<ApiCallResponse>(
                      future: _model
                          .cobranaca(
                        requestFn: () => SupabaseGroup.filtroCobrancaCall.call(
                          pSearch: _model.textController.text,
                          pTipoCobranca: 'aluno',
                          pUserId: '',
                          pIfFranquia: FFAppState().idfranquia,
                          pPage: _currentPage,
                          pPerPage: _perPage,
                          token: currentJwtToken,
                        ),
                      )
                          .then((result) {
                        _model.apiRequestCompleted = true;
                        return result;
                      }),
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
                        final response = snapshot.data!;
                        final body = response.jsonBody;
                        final cobrancasData = (body is Map && body['data'] is List)
                            ? (body['data'] as List<dynamic>)
                            : <dynamic>[];
                        final cobrancasCount =
                            (body is Map ? (body['total'] as num?) : null)?.toInt() ??
                                0;
                        final cobrancasTotalPages = (body is Map
                                    ? (body['totalPages'] as num?)
                                    : null)
                                ?.toInt() ??
                            0;
                        final cobrancasTotalLabel = functions.formatCurrencyBr(
                            body is Map ? body['totalValor'] : 0);

                        return Container(
                          width: double.infinity,
                          constraints: BoxConstraints(maxWidth: 1440),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Header(
                                count: cobrancasCount,
                                totalLabel: cobrancasTotalLabel,
                              ),
                              SizedBox(height: 24),
                              _MainCard(
                                searchController: _model.textController!,
                                searchFocus: _model.textFieldFocusNode!,
                                onSearchChanged: (v) {
                                  EasyDebounce.debounce(
                                    'financeiro_search',
                                    Duration(milliseconds: 400),
                                    () async {
                                      safeSetState(() {
                                        _currentPage = 1;
                                        _model.clearCobranacaCache();
                                        _model.apiRequestCompleted = false;
                                      });
                                      await _model.waitForApiRequestCompleted();
                                    },
                                  );
                                  safeSetState(() {});
                                },
                                onSearchClear: () async {
                                  EasyDebounce.cancel('financeiro_search');
                                  _model.textController?.clear();
                                  safeSetState(() {
                                    _currentPage = 1;
                                    _model.clearCobranacaCache();
                                    _model.apiRequestCompleted = false;
                                  });
                                  await _model.waitForApiRequestCompleted();
                                },
                                cobrancas: cobrancasData,
                                onTapVisualizar: (item) async {
                                  await showDialog(
                                    context: context,
                                    builder: (dialogContext) {
                                      return Dialog(
                                        elevation: 0,
                                        insetPadding: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        alignment: Alignment.center,
                                        child: WebViewAware(
                                          child: GestureDetector(
                                            onTap: () {
                                              FocusScope.of(dialogContext).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: ModalPagamentoWidget(items: item),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                currentPage: _currentPage,
                                totalPages:
                                    cobrancasTotalPages == 0 ? 1 : cobrancasTotalPages,
                                perPage: _perPage,
                                onPrev: _currentPage > 1
                                    ? () async {
                                        safeSetState(() => _currentPage--);
                                        await _refreshPage();
                                      }
                                    : null,
                                onNext: _currentPage < cobrancasTotalPages
                                    ? () async {
                                        safeSetState(() => _currentPage++);
                                        await _refreshPage();
                                      }
                                    : null,
                                onChangePerPage: (v) async {
                                  if (v == null) return;
                                  safeSetState(() {
                                    _perPage = v;
                                    _currentPage = 1;
                                  });
                                  await _refreshPage();
                                },
                              ),
                            ],
                          ),
                        );
                      },
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
  final String totalLabel;
  const _Header({required this.count, required this.totalLabel});

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
              Icon(Icons.account_balance_wallet_rounded,
                  size: 16, color: theme.primary),
              SizedBox(width: 6),
              Text(
                'Financeiro',
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
          'Financeiro Franquia',
          style: GoogleFonts.interTight(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: theme.primaryText,
            height: 1.1,
          ),
        ),
        _StatChip(
          icon: Icons.receipt_long_rounded,
          label: '$count ${count == 1 ? "cobrança" : "cobranças"}',
          color: theme.info,
        ),
        _StatChip(
          icon: Icons.savings_rounded,
          label: totalLabel,
          color: theme.primary,
          strong: true,
        ),
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            'Acompanhe e visualize as cobranças geradas para os alunos da franquia.',
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

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool strong;
  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: strong ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// MAIN CARD
// ============================================================================
class _MainCard extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final List<dynamic> cobrancas;
  final ValueChanged<dynamic> onTapVisualizar;
  final int currentPage;
  final int totalPages;
  final int perPage;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final ValueChanged<int?> onChangePerPage;

  const _MainCard({
    required this.searchController,
    required this.searchFocus,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.cobrancas,
    required this.onTapVisualizar,
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
    required this.onPrev,
    required this.onNext,
    required this.onChangePerPage,
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
            _SearchField(
              controller: searchController,
              focusNode: searchFocus,
              onChanged: onSearchChanged,
              onClear: onSearchClear,
            ),
            SizedBox(height: 18),
            _Table(
              cobrancas: cobrancas,
              onTapVisualizar: onTapVisualizar,
            ),
            SizedBox(height: 16),
            _PaginationFooter(
              currentPage: currentPage,
              totalPages: totalPages,
              perPage: perPage,
              onPrev: onPrev,
              onNext: onNext,
              onChangePerPage: onChangePerPage,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SEARCH
// ============================================================================
class _SearchField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  bool _hover = false;
  bool _focus = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _focus = widget.focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasText = widget.controller.text.isNotEmpty;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        constraints: BoxConstraints(maxWidth: 520),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _focus
                ? theme.primary.withValues(alpha: 0.55)
                : (_hover
                    ? theme.primary.withValues(alpha: 0.4)
                    : theme.alternate),
            width: 1.4,
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
                focusNode: widget.focusNode,
                onChanged: widget.onChanged,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: theme.primaryText,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar por ID da cobrança ou aluno…',
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
// TABLE
// ============================================================================
class _Table extends StatelessWidget {
  final List<dynamic> cobrancas;
  final ValueChanged<dynamic> onTapVisualizar;

  const _Table({required this.cobrancas, required this.onTapVisualizar});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
              border: Border(
                bottom: BorderSide(color: theme.alternate),
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Row(
              children: [
                _HeaderCell(label: 'ID da cobrança', flex: 3),
                _HeaderCell(label: 'Valor', flex: 2),
                _HeaderCell(label: 'Aluno', flex: 3),
                _HeaderCell(label: 'Data', flex: 2),
                _HeaderCell(label: 'Status', flex: 2),
                SizedBox(width: 124),
              ],
            ),
          ),
          // Rows
          if (cobrancas.isEmpty)
            _EmptyState()
          else
            ...List.generate(
              cobrancas.length,
              (idx) => _RowItem(
                item: cobrancas[idx],
                isLast: idx == cobrancas.length - 1,
                onTap: () => onTapVisualizar(cobrancas[idx]),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  const _HeaderCell({required this.label, required this.flex});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: theme.secondaryText,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _RowItem extends StatefulWidget {
  final dynamic item;
  final bool isLast;
  final VoidCallback onTap;
  const _RowItem({
    required this.item,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<_RowItem> createState() => _RowItemState();
}

class _RowItemState extends State<_RowItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final id = functions.shortIdFallback(
      getJsonField(widget.item, r'''$.id_cobranca_asaas''')?.toString(),
      getJsonField(widget.item, r'''$.id''')?.toString(),
    );
    final valor = functions.formatCurrencyBr(
      getJsonField(widget.item, r'''$.valor'''),
    );
    final aluno =
        getJsonField(widget.item, r'''$.user_nome''')?.toString() ?? '-';
    final dataRaw =
        getJsonField(widget.item, r'''$.created_at''')?.toString() ?? '';
    final dataFmt = dataRaw.isEmpty
        ? '—'
        : (dateTimeFormat(
              "dd/MM/yyyy",
              functions.stringToDatetime(dataRaw),
              locale: FFLocalizations.of(context).languageCode,
            ) ??
            '—');
    final statusRaw =
        getJsonField(widget.item, r'''$.status_cobranca''')?.toString();
    final statusLabel = functions.cobrancaStatusLabel(statusRaw);
    final statusBg = functions.cobrancaStatusColorBg(statusRaw);
    final statusFg = functions.cobrancaStatusColorFg(statusRaw);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 140),
        decoration: BoxDecoration(
          color: _hover
              ? theme.primary.withValues(alpha: 0.05)
              : Colors.transparent,
          borderRadius: widget.isLast
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                )
              : null,
          border: widget.isLast
              ? null
              : Border(bottom: BorderSide(color: theme.alternate)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: SelectionArea(
                      child: Text(
                        id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.robotoMono(
                          fontSize: 12.5,
                          color: theme.secondaryText,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SelectionArea(
                      child: Text(
                        valor,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: theme.primaryText,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.primary.withValues(alpha: 0.12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _initials(aluno),
                            style: GoogleFonts.interTight(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: theme.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            aluno,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      dataFmt,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: theme.secondaryText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: statusFg.withValues(alpha: 0.45),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: statusFg,
                            ),
                          ),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              statusLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: statusFg,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  _VisualizarButton(
                    hover: _hover,
                    onTap: widget.onTap,
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

class _VisualizarButton extends StatefulWidget {
  final bool hover;
  final VoidCallback onTap;
  const _VisualizarButton({required this.hover, required this.onTap});

  @override
  State<_VisualizarButton> createState() => _VisualizarButtonState();
}

class _VisualizarButtonState extends State<_VisualizarButton> {
  bool _hoverSelf = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final highlight = widget.hover || _hoverSelf;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoverSelf = true),
      onExit: (_) => setState(() => _hoverSelf = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color:
              highlight ? theme.primary : theme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          boxShadow: highlight
              ? [
                  BoxShadow(
                    blurRadius: 8,
                    color: theme.primary.withValues(alpha: 0.30),
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
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
                  Icon(
                    Icons.visibility_rounded,
                    size: 14,
                    color: highlight ? Colors.white : theme.primary,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Visualizar',
                    style: GoogleFonts.interTight(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: highlight ? Colors.white : theme.primary,
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primary.withValues(alpha: 0.08),
            ),
            child: Icon(Icons.receipt_long_rounded,
                size: 30, color: theme.primary),
          ),
          SizedBox(height: 14),
          Text(
            'Nenhuma cobrança encontrada',
            textAlign: TextAlign.center,
            style: GoogleFonts.interTight(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: theme.primaryText,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Ajuste o termo de busca ou aguarde novas cobranças serem geradas.',
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

// ============================================================================
// PAGINATION
// ============================================================================
class _PaginationFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int perPage;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final ValueChanged<int?> onChangePerPage;
  const _PaginationFooter({
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
    required this.onPrev,
    required this.onNext,
    required this.onChangePerPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        _PageNavButton(
          icon: Icons.chevron_left_rounded,
          enabled: onPrev != null,
          onTap: onPrev,
          tooltip: 'Página anterior',
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: theme.alternate),
          ),
          child: Text(
            'Página $currentPage de $totalPages',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
            ),
          ),
        ),
        _PageNavButton(
          icon: Icons.chevron_right_rounded,
          enabled: onNext != null,
          onTap: onNext,
          tooltip: 'Próxima página',
        ),
        SizedBox(width: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Itens por página:',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: theme.secondaryText,
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.alternate),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: perPage,
                  isDense: true,
                  borderRadius: BorderRadius.circular(8),
                  items: const [5, 10, 20, 50]
                      .map((v) => DropdownMenuItem<int>(
                            value: v,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                v.toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: theme.primaryText,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: onChangePerPage,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PageNavButton extends StatefulWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;
  final String tooltip;
  const _PageNavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.tooltip,
  });

  @override
  State<_PageNavButton> createState() => _PageNavButtonState();
}

class _PageNavButtonState extends State<_PageNavButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hover = widget.enabled && _hover;
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) {
          if (widget.enabled) setState(() => _hover = true);
        },
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedScale(
          duration: Duration(milliseconds: 120),
          scale: hover ? 0.96 : 1.0,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: !widget.enabled
                  ? theme.alternate.withValues(alpha: 0.5)
                  : (hover
                      ? theme.primary
                      : theme.primary.withValues(alpha: 0.12)),
              boxShadow: hover
                  ? [
                      BoxShadow(
                        blurRadius: 8,
                        color: theme.primary.withValues(alpha: 0.25),
                        offset: Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: CircleBorder(),
                onTap: widget.enabled ? widget.onTap : null,
                child: Icon(
                  widget.icon,
                  size: 22,
                  color: !widget.enabled
                      ? theme.secondaryText
                      : (hover ? Colors.white : theme.primary),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Helpers
// ============================================================================
String _initials(String? nome) {
  if (nome == null || nome.trim().isEmpty || nome.trim() == '-') return '?';
  final partes = nome.trim().split(RegExp(r'\s+'));
  if (partes.length == 1) {
    return partes.first.characters.take(2).toString().toUpperCase();
  }
  return (partes.first.characters.take(1).toString() +
          partes.last.characters.take(1).toString())
      .toUpperCase();
}
