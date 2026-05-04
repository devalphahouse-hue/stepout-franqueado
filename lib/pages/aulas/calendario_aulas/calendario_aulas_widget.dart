import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'calendario_aulas_model.dart';
export 'calendario_aulas_model.dart';

class CalendarioAulasWidget extends StatefulWidget {
  const CalendarioAulasWidget({super.key});

  static String routeName = 'CalendarioAulas';
  static String routePath = '/calendarioAulas';

  @override
  State<CalendarioAulasWidget> createState() => _CalendarioAulasWidgetState();
}

class _CalendarioAulasWidgetState extends State<CalendarioAulasWidget> {
  late CalendarioAulasModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalendarioAulasModel());

    if (FFAppState().ListaDiasCalendarioAulas.isEmpty ||
        FFAppState().dataParamentroCalendario == null) {
      FFAppState().dataParamentroCalendario = getCurrentTimestamp;
      FFAppState().ListaDiasCalendarioAulas = functions
          .gerarLista7Dias(getCurrentTimestamp)!
          .toList()
          .cast<DiaCalendarioAulasStruct>();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _shift(bool forward) async {
    FFAppState().dataParamentroCalendario = forward
        ? functions.calcula7diasFrente(FFAppState().dataParamentroCalendario)
        : functions.calcula7diasTras(FFAppState().dataParamentroCalendario);
    FFAppState().ListaDiasCalendarioAulas = functions
        .gerarLista7Dias(FFAppState().dataParamentroCalendario)!
        .toList()
        .cast<DiaCalendarioAulasStruct>();
    safeSetState(() {
      _model.clearAulastodasCache();
      _model.apiRequestCompleted = false;
    });
    await _model.waitForApiRequestCompleted();
  }

  Future<void> _today() async {
    FFAppState().dataParamentroCalendario = getCurrentTimestamp;
    FFAppState().ListaDiasCalendarioAulas = functions
        .gerarLista7Dias(getCurrentTimestamp)!
        .toList()
        .cast<DiaCalendarioAulasStruct>();
    safeSetState(() {
      _model.clearAulastodasCache();
      _model.apiRequestCompleted = false;
    });
    await _model.waitForApiRequestCompleted();
  }

  String _rangeLabel(BuildContext context) {
    final list = FFAppState().ListaDiasCalendarioAulas;
    if (list.isEmpty) return '';
    final first = list.first.diaHoraInicio;
    final last = list.last.diaHoraInicio;
    final loc = FFLocalizations.of(context).languageCode;
    if (first == null || last == null) return '';
    return '${dateTimeFormat('d MMM', first, locale: loc)} – ${dateTimeFormat('d MMM yyyy', last, locale: loc)}';
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
                child: const SidebarWidget(route: 'Aulas'),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: isCompact ? 20.0 : 28.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(
                        theme: theme,
                        isCompact: isCompact,
                        rangeLabel: _rangeLabel(context),
                        onPrev: () => _shift(false),
                        onNext: () => _shift(true),
                        onToday: _today,
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: _CalendarBoard(
                          theme: theme,
                          model: _model,
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

// ---------------------------------------------------------------------------
// HEADER
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.theme,
    required this.isCompact,
    required this.rangeLabel,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final String rangeLabel;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;

  Widget _titleBlock() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12.0),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.calendar_month_rounded,
              color: theme.primary, size: 22.0),
        ),
        const SizedBox(width: 14.0),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calendário de Aulas',
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
                'Acompanhe as próximas aulas programadas.',
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
      ],
    );
  }

  Widget _rangePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.date_range_rounded,
              color: theme.secondaryText, size: 16.0),
          const SizedBox(width: 8.0),
          Text(
            rangeLabel.isEmpty ? '—' : rangeLabel,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontWeight: FontWeight.w600,
              fontSize: 13.0,
              color: theme.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _IconPillButton(
          theme: theme,
          icon: Icons.chevron_left_rounded,
          tooltip: 'Semana anterior',
          onTap: onPrev,
        ),
        const SizedBox(width: 8.0),
        _IconPillButton(
          theme: theme,
          icon: Icons.today_rounded,
          tooltip: 'Hoje',
          onTap: onToday,
        ),
        const SizedBox(width: 8.0),
        _IconPillButton(
          theme: theme,
          icon: Icons.chevron_right_rounded,
          tooltip: 'Próxima semana',
          onTap: onNext,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleBlock(),
          const SizedBox(height: 12.0),
          _rangePill(),
          const SizedBox(height: 12.0),
          _navButtons(),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _titleBlock()),
        const SizedBox(width: 12.0),
        _rangePill(),
        const SizedBox(width: 12.0),
        _navButtons(),
      ],
    );
  }
}

class _IconPillButton extends StatefulWidget {
  const _IconPillButton({
    required this.theme,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_IconPillButton> createState() => _IconPillButtonState();
}

class _IconPillButtonState extends State<_IconPillButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final accent = theme.primary;
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
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: _hovered
                  ? accent.withValues(alpha: 0.10)
                  : theme.primaryBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: _hovered ? accent : theme.alternate,
                width: 1.0,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              color: _hovered ? accent : theme.secondaryText,
              size: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CALENDAR BOARD
// ---------------------------------------------------------------------------

class _CalendarBoard extends StatelessWidget {
  const _CalendarBoard({required this.theme, required this.model});

  final FlutterFlowTheme theme;
  final CalendarioAulasModel model;

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
      child: FutureBuilder<ApiCallResponse>(
        future: model
            .aulastodas(
          requestFn: () => SupabaseGroup.listaAulasDoDiaCall.call(
            pIdFranquia: FFAppState().idfranquia,
            pDataInicio: functions
                .stringToDatetime(FFAppState()
                    .ListaDiasCalendarioAulas
                    .firstOrNull
                    ?.diaHoraInicio
                    ?.toString())
                ?.toString(),
            pDataTermino: functions
                .stringToDatetime(FFAppState()
                    .ListaDiasCalendarioAulas
                    .lastOrNull
                    ?.diaHoraTermino
                    ?.toString())
                ?.toString(),
            token: currentJwtToken,
          ),
        )
            .then((res) {
          model.apiRequestCompleted = true;
          return res;
        }),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 28.0,
                height: 28.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(theme.primary),
                ),
              ),
            );
          }
          final aulas = (snapshot.data!.jsonBody
                      .toList()
                      .map<ItemCalendarioAulasStruct?>(
                          ItemCalendarioAulasStruct.maybeFromMap)
                      .toList()
                  as Iterable<ItemCalendarioAulasStruct?>)
              .withoutNulls
              .toList();

          final dias = FFAppState().ListaDiasCalendarioAulas;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(dias.length, (i) {
                final dia = dias[i];
                final aulasDoDia = aulas.where((e) {
                  if (dia.diaHoraInicio == null) return false;
                  return functions.verificaDatasIguais(
                      dia.diaHoraInicio!.toString(), e.datetimeInicioAula);
                }).toList();

                return Padding(
                  padding: EdgeInsets.only(
                    right: i == dias.length - 1 ? 0.0 : 12.0,
                  ),
                  child: _DayColumn(
                    theme: theme,
                    dia: dia,
                    aulas: aulasDoDia,
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DAY COLUMN
// ---------------------------------------------------------------------------

class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.theme,
    required this.dia,
    required this.aulas,
  });

  final FlutterFlowTheme theme;
  final DiaCalendarioAulasStruct dia;
  final List<ItemCalendarioAulasStruct> aulas;

  bool _isToday() {
    final d = dia.diaHoraInicio;
    if (d == null) return false;
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday();
    final loc = FFLocalizations.of(context).languageCode;
    final dateLabel = dia.diaHoraInicio == null
        ? '—'
        : dateTimeFormat('d/M', dia.diaHoraInicio!, locale: loc);
    final weekLabel =
        functions.datetimeToDiaSemana(dia.diaHoraInicio) ?? 'Dia';
    return Container(
      width: 232.0,
      constraints: const BoxConstraints(minHeight: 480.0),
      decoration: BoxDecoration(
        color: isToday
            ? theme.primary.withValues(alpha: 0.04)
            : theme.secondaryBackground.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: isToday ? theme.primary : theme.alternate,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: isToday
                      ? theme.primary
                      : theme.primaryBackground,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: isToday ? theme.primary : theme.alternate,
                    width: 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  dateLabel,
                  style: theme.titleSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                    fontWeight: FontWeight.w800,
                    fontSize: 13.0,
                    color: isToday ? Colors.white : theme.primaryText,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weekLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.titleSmall.override(
                        font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700),
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      aulas.isEmpty
                          ? 'Sem aulas'
                          : '${aulas.length} ${aulas.length == 1 ? 'aula' : 'aulas'}',
                      style: theme.bodySmall.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        fontWeight: FontWeight.w500,
                        fontSize: 11.5,
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Expanded(
            child: aulas.isEmpty
                ? _EmptyDay(theme: theme)
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(aulas.length, (i) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: i == aulas.length - 1 ? 0.0 : 8.0),
                          child: _AulaCard(
                            theme: theme,
                            aula: aulas[i],
                          ),
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: theme.primaryBackground.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy_outlined,
              color: theme.secondaryText, size: 22.0),
          const SizedBox(height: 8.0),
          Text(
            'Sem aulas',
            textAlign: TextAlign.center,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              fontWeight: FontWeight.w500,
              fontSize: 12.5,
              color: theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AULA CARD
// ---------------------------------------------------------------------------

class _AulaCard extends StatefulWidget {
  const _AulaCard({required this.theme, required this.aula});

  final FlutterFlowTheme theme;
  final ItemCalendarioAulasStruct aula;

  @override
  State<_AulaCard> createState() => _AulaCardState();
}

class _AulaCardState extends State<_AulaCard> {
  bool _hovered = false;

  Color _statusColor() {
    final s = widget.aula.statusAula;
    final t = widget.theme;
    if (s == 'Aguardando Planning') return t.warning;
    if (s == 'Planning concluído') return t.success;
    if (s == 'Finalizada') return t.primary;
    if (s == 'Cancelada') return t.error;
    return t.secondaryText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final aula = widget.aula;
    final loc = FFLocalizations.of(context).languageCode;
    final inicio = functions.stringToDatetime(aula.datetimeInicioAula);
    final termino = functions.stringToDatetime(aula.datetimeTerminoAula);
    final timeLabel = inicio == null || termino == null
        ? '—'
        : '${dateTimeFormat('Hm', inicio, locale: loc)} – ${dateTimeFormat('Hm', termino, locale: loc)}';
    final statusColor = _statusColor();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.pushNamed(
          DetalhesAulaWidget.routeName,
          queryParameters: {
            'idAula': serializeParam(aula.uuidAula, ParamType.String),
          }.withoutNulls,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: _hovered
                ? theme.primary.withValues(alpha: 0.05)
                : theme.primaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: _hovered ? theme.primary : theme.alternate,
              width: 1.0,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: theme.primary.withValues(alpha: 0.10),
                      blurRadius: 12.0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : const [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time_rounded,
                            color: theme.primary, size: 12.0),
                        const SizedBox(width: 4.0),
                        Text(
                          timeLabel,
                          style: theme.bodySmall.override(
                            font: GoogleFonts.inter(
                                fontWeight: FontWeight.w700),
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5,
                            color: theme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                aula.nomeTurma.isEmpty ? 'Sem turma' : aula.nomeTurma,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.titleSmall.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  color: theme.primaryText,
                ),
              ),
              const SizedBox(height: 8.0),
              _InfoLine(
                theme: theme,
                icon: Icons.school_rounded,
                text: aula.nomeProfessor.isEmpty
                    ? 'Sem professor'
                    : aula.nomeProfessor,
              ),
              const SizedBox(height: 4.0),
              _InfoLine(
                theme: theme,
                icon: Icons.people_alt_rounded,
                text:
                    '${aula.quantidadeAlunosConvidados} ${aula.quantidadeAlunosConvidados == 1 ? 'aluno' : 'alunos'}',
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999.0),
                ),
                child: Text(
                  aula.statusAula.isEmpty ? 'Sem status' : aula.statusAula,
                  style: theme.bodySmall.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.0,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Ver detalhes',
                    style: theme.bodySmall.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.0,
                      color: theme.primary,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Icon(Icons.arrow_forward_rounded,
                      color: theme.primary, size: 14.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.theme,
    required this.icon,
    required this.text,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: theme.secondaryText, size: 13.0),
        const SizedBox(width: 6.0),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.bodySmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
              color: theme.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}
