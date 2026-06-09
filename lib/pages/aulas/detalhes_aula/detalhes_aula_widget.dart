import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/reagendar_aula/reagendar_aula_widget.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'detalhes_aula_model.dart';
export 'detalhes_aula_model.dart';

class DetalhesAulaWidget extends StatefulWidget {
  const DetalhesAulaWidget({
    super.key,
    required this.idAula,
  });

  final String? idAula;

  static String routeName = 'DetalhesAula';
  static String routePath = '/detalhesAula';

  @override
  State<DetalhesAulaWidget> createState() => _DetalhesAulaWidgetState();
}

class _DetalhesAulaWidgetState extends State<DetalhesAulaWidget> {
  late DetalhesAulaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hydrated = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhesAulaModel());
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textFieldFocusNode4 ??= FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FFAppState().AlterarProfessorVisibility = false;
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _hydrate(BuildContext context, DetalhesAulaStruct? data) {
    if (_hydrated || data == null) return;
    final loc = FFLocalizations.of(context).languageCode;
    _model.textController1 ??= TextEditingController(text: data.nomeTurma);
    _model.textController2 ??= TextEditingController(text: data.nivelInicio);
    final inicio = functions.stringToDatetime(data.datetimeinicioAula);
    final termino = functions.stringToDatetime(data.datetimeTerminoaula);
    final dataLabel = inicio == null
        ? '—'
        : '${dateTimeFormat('d/M/y', inicio, locale: loc)} | ${dateTimeFormat('Hm', inicio, locale: loc)} - ${dateTimeFormat('Hm', termino, locale: loc)}';
    _model.textController3 ??= TextEditingController(text: dataLabel);
    _model.textController4 ??=
        TextEditingController(text: data.anotacoesComentarios);
    _hydrated = true;
  }

  Future<void> _salvarProfessor() async {
    if (_model.dropDownProfessorValue == null ||
        _model.dropDownProfessorValue == '0' ||
        _model.dropDownProfessorValue!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecione um professor'),
          backgroundColor: FlutterFlowTheme.of(context).error,
          duration: const Duration(milliseconds: 3000),
        ),
      );
      return;
    }
    try {
      await AulasTable().update(
        data: {'professor_responsavel': _model.dropDownProfessorValue},
        matchingRows: (rows) => rows.eqOrNull('id', widget.idAula),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao alterar o professor. Tente novamente.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
            duration: const Duration(milliseconds: 3000),
          ),
        );
      }
      return;
    }
    // Sucesso confirmado: o update concluiu. Mostra o feedback AGORA, antes do
    // refresh de cache abaixo — os waitForApiRequestCompleted servem só pra
    // atualizar a UI e, se um deles travar, não devem impedir o feedback.
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Professor atualizado com sucesso'),
          backgroundColor: FlutterFlowTheme.of(context).primary,
          duration: const Duration(milliseconds: 2500),
        ),
      );
    }
    safeSetState(() {
      _model.clearListaProfsCache();
      _model.apiRequestCompleted2 = false;
    });
    await _model.waitForApiRequestCompleted2();
    safeSetState(() {
      _model.clearDetalhesCache();
      _model.apiRequestCompleted1 = false;
    });
    await _model.waitForApiRequestCompleted1();
    FFAppState().AlterarProfessorVisibility = false;
    safeSetState(() {});
  }

  Future<void> _removerConteudo(String? conteudoId) async {
    _model.apiRemoverConteudo =
        await SupabaseGroup.removerConteudoVinculadoCall.call(
      pAulaId: widget.idAula,
      pConteudoId: conteudoId,
      token: currentJwtToken,
    );
    if ((_model.apiRemoverConteudo?.succeeded ?? true)) {
      safeSetState(() {
        _model.clearDetalhesCache();
        _model.apiRequestCompleted1 = false;
      });
      await _model.waitForApiRequestCompleted1();
    }
    safeSetState(() {});
  }

  Future<void> _concluirPlanning(DetalhesAulaStruct data) async {
    _model.apiResulthcv = await SupabaseGroup.criarAulaNoPlanningCall.call(
      pTurmaId: data.turma,
      data: data.datetimeinicioAula,
      token: currentJwtToken,
    );
    if ((_model.apiResulthcv?.succeeded ?? true)) {
      await AulasTable().update(
        data: {
          'alunos_convidados':
              data.alunosConvidados.map((e) => e.uuid).toList(),
        },
        matchingRows: (rows) => rows.eqOrNull(
          'id',
          SupabaseGroup.criarAulaNoPlanningCall
              .idaula(_model.apiResulthcv?.jsonBody ?? ''),
        ),
      );
      if (!mounted) return;
      context.pushNamed(
        DetalhesAulaWidget.routeName,
        queryParameters: {
          'idAula': serializeParam(widget.idAula, ParamType.String),
        }.withoutNulls,
      );
    } else {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (alertCtx) => WebViewAware(
          child: AlertDialog(
            title: Text((_model.apiResulthcv?.jsonBody ?? '').toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertCtx),
                child: const Text('Ok'),
              ),
            ],
          ),
        ),
      );
    }
    await AulasTable().update(
      data: {'status_aula': 'Planning Concluído'},
      matchingRows: (rows) => rows.eqOrNull('id', widget.idAula),
    );
    safeSetState(() {});
  }

  Future<void> _abrirReagendar() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: AlignmentDirectional(0.0, 0.0)
              .resolve(Directionality.of(context)),
          child: WebViewAware(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(dialogContext).unfocus();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.4,
                width: MediaQuery.sizeOf(context).width * 0.6,
                child: ReagendarAulaWidget(idAula: widget.idAula!),
              ),
            ),
          ),
        );
      },
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
                child: const SidebarWidget(route: 'Aulas'),
              ),
              Expanded(
                child: FutureBuilder<ApiCallResponse>(
                  future: _model
                      .detalhes(
                    requestFn: () => SupabaseGroup.detalhesAulaCall.call(
                      pId: widget.idAula,
                      token: currentJwtToken,
                    ),
                  )
                      .then((res) {
                    _model.apiRequestCompleted1 = true;
                    return res;
                  }),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return _LoadingState(theme: theme);
                    }
                    final data = DetalhesAulaStruct.maybeFromMap(
                        snapshot.data!.jsonBody);
                    _hydrate(context, data);
                    final finalizada = data?.statusAula == 'Finalizada';
                    final aguardandoPlanning =
                        data?.statusAula == 'Aguardando Planning';

                    return SingleChildScrollView(
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
                            statusAula: data?.statusAula ?? '',
                            finalizada: finalizada,
                            onBack: () => context.safePop(),
                            onReagendar: _abrirReagendar,
                          ),
                          if (finalizada) ...[
                            const SizedBox(height: 16.0),
                            _ReadOnlyBanner(theme: theme),
                          ],
                          const SizedBox(height: 24.0),
                          _SectionCard(
                            theme: theme,
                            icon: Icons.info_outline_rounded,
                            chip: 'Aula',
                            title: 'Informações da aula',
                            subtitle:
                                'Detalhes da turma, professor responsável e data.',
                            child: _InfoSection(
                              theme: theme,
                              model: _model,
                              data: data,
                              isCompact: isCompact,
                              finalizada: finalizada,
                              onSalvarProfessor: _salvarProfessor,
                              onProfessorVisibilityChanged: () =>
                                  safeSetState(() {}),
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          _SectionCard(
                            theme: theme,
                            icon: Icons.groups_rounded,
                            chip: 'Alunos',
                            title: 'Alunos da aula',
                            subtitle:
                                'Escalados originalmente e alunos que estiveram presentes.',
                            child: _AlunosSection(
                              theme: theme,
                              data: data,
                              isCompact: isCompact,
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          _SectionCard(
                            theme: theme,
                            icon: Icons.menu_book_rounded,
                            chip: 'Planning',
                            title: 'Planejamento da aula',
                            subtitle:
                                'Conteúdos vinculados, anotações e finalização do planning.',
                            child: _PlanningSection(
                              theme: theme,
                              model: _model,
                              data: data,
                              idAula: widget.idAula,
                              finalizada: finalizada,
                              aguardandoPlanning: aguardandoPlanning,
                              onRemoverConteudo: _removerConteudo,
                              onConcluirPlanning: () =>
                                  _concluirPlanning(data!),
                            ),
                          ),
                          const SizedBox(height: 32.0),
                        ],
                      ),
                    );
                  },
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
// LOADING STATE
// ---------------------------------------------------------------------------

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 32.0,
        height: 32.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.6,
          valueColor: AlwaysStoppedAnimation(theme.primary),
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
    required this.statusAula,
    required this.finalizada,
    required this.onBack,
    required this.onReagendar,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final String statusAula;
  final bool finalizada;
  final VoidCallback onBack;
  final VoidCallback onReagendar;

  Color _statusColor() {
    if (statusAula == 'Aguardando Planning') return theme.warning;
    if (statusAula == 'Planning concluído' ||
        statusAula == 'Planning Concluído') {
      return theme.success;
    }
    if (statusAula == 'Finalizada') return theme.primary;
    if (statusAula == 'Cancelada') return theme.error;
    return theme.secondaryText;
  }

  Widget _titleBlock() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _IconPillButton(
          theme: theme,
          icon: Icons.arrow_back_rounded,
          tooltip: 'Voltar',
          onTap: onBack,
        ),
        const SizedBox(width: 14.0),
        Container(
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12.0),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.event_note_rounded,
              color: theme.primary, size: 22.0),
        ),
        const SizedBox(width: 14.0),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalhes da aula',
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
                'Visualize e edite as informações desta aula.',
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

  Widget _statusPill(Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            statusAula.isEmpty ? 'Sem status' : statusAula,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w700),
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();
    final reagendarBtn = !finalizada
        ? _SecondaryButton(
            theme: theme,
            icon: Icons.calendar_month_rounded,
            label: 'Reagendar aula',
            onTap: onReagendar,
          )
        : null;

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleBlock(),
          const SizedBox(height: 12.0),
          _statusPill(statusColor),
          if (reagendarBtn != null) ...[
            const SizedBox(height: 12.0),
            reagendarBtn,
          ],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _titleBlock()),
        const SizedBox(width: 12.0),
        _statusPill(statusColor),
        if (reagendarBtn != null) ...[
          const SizedBox(width: 12.0),
          reagendarBtn,
        ],
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
// READ-ONLY BANNER
// ---------------------------------------------------------------------------

class _ReadOnlyBanner extends StatelessWidget {
  const _ReadOnlyBanner({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
            color: theme.warning.withValues(alpha: 0.4), width: 1.0),
      ),
      child: Row(
        children: [
          Icon(Icons.history_edu_rounded, color: theme.warning, size: 20.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              'Esta é uma tela apenas de visualização do histórico desta aula. Não é possível realizar alterações.',
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                fontWeight: FontWeight.w500,
                fontSize: 13.0,
                color: theme.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SECTION CARD
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.theme,
    required this.icon,
    required this.chip,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String chip;
  final String title;
  final String subtitle;
  final Widget child;

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
      padding: const EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: theme.primary, size: 18.0),
              ),
              const SizedBox(width: 12.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.0),
                ),
                child: Text(
                  chip,
                  style: theme.labelSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontWeight: FontWeight.w700,
                    fontSize: 11.0,
                    letterSpacing: 0.6,
                    color: theme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            title,
            style: theme.titleMedium.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontWeight: FontWeight.w700,
              fontSize: 17.0,
              color: theme.primaryText,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            subtitle,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              fontWeight: FontWeight.w500,
              fontSize: 13.0,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 18.0),
          child,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LABELED FIELD HELPERS
// ---------------------------------------------------------------------------

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.theme,
    required this.label,
    required this.child,
  });

  final FlutterFlowTheme theme;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: theme.labelSmall.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
            letterSpacing: 0.4,
            color: theme.secondaryText,
          ),
        ),
        const SizedBox(height: 6.0),
        child,
      ],
    );
  }
}

InputDecoration _fieldDecoration(FlutterFlowTheme theme,
    {String? hint, IconData? prefix, bool readOnly = false}) {
  return InputDecoration(
    isDense: true,
    hintText: hint,
    hintStyle: theme.labelMedium.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.w400),
      fontWeight: FontWeight.w400,
      fontSize: 13.5,
      color: theme.secondaryText,
    ),
    prefixIcon: prefix == null
        ? null
        : Icon(prefix, color: theme.secondaryText, size: 18.0),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
    filled: true,
    fillColor: readOnly
        ? theme.secondaryBackground.withValues(alpha: 0.6)
        : theme.secondaryBackground,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.alternate, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(
        color: readOnly ? theme.alternate : theme.primary,
        width: readOnly ? 1.0 : 1.4,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.error, width: 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.error, width: 1.4),
    ),
  );
}

TextStyle _fieldTextStyle(FlutterFlowTheme theme) =>
    theme.bodyMedium.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      color: theme.primaryText,
    );

class _ResponsiveTwoColumns extends StatelessWidget {
  const _ResponsiveTwoColumns({
    required this.isCompact,
    required this.left,
    required this.right,
  });

  final bool isCompact;
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [left, const SizedBox(height: 14.0), right],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 14.0),
        Expanded(child: right),
      ],
    );
  }
}

class _DropDownPlaceholder extends StatelessWidget {
  const _DropDownPlaceholder({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        children: [
          SizedBox(
            width: 16.0,
            height: 16.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation(theme.secondaryText),
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            'Carregando...',
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              color: theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// INFO SECTION
// ---------------------------------------------------------------------------

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.theme,
    required this.model,
    required this.data,
    required this.isCompact,
    required this.finalizada,
    required this.onSalvarProfessor,
    required this.onProfessorVisibilityChanged,
  });

  final FlutterFlowTheme theme;
  final DetalhesAulaModel model;
  final DetalhesAulaStruct? data;
  final bool isCompact;
  final bool finalizada;
  final VoidCallback onSalvarProfessor;
  final VoidCallback onProfessorVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ResponsiveTwoColumns(
          isCompact: isCompact,
          left: _LabeledField(
            theme: theme,
            label: 'Nome da turma',
            child: TextFormField(
              controller: model.textController1,
              focusNode: model.textFieldFocusNode1,
              readOnly: true,
              style: _fieldTextStyle(theme),
              cursorColor: theme.primary,
              decoration: _fieldDecoration(
                theme,
                prefix: Icons.label_important_outline_rounded,
                readOnly: true,
              ),
            ),
          ),
          right: _LabeledField(
            theme: theme,
            label: 'Módulo',
            child: TextFormField(
              controller: model.textController2,
              focusNode: model.textFieldFocusNode2,
              readOnly: true,
              style: _fieldTextStyle(theme),
              cursorColor: theme.primary,
              decoration: _fieldDecoration(
                theme,
                prefix: Icons.tag_rounded,
                readOnly: true,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        _ProfessorBlock(
          theme: theme,
          model: model,
          data: data,
          isCompact: isCompact,
          finalizada: finalizada,
          onSalvarProfessor: onSalvarProfessor,
          onVisibilityChanged: onProfessorVisibilityChanged,
        ),
        const SizedBox(height: 16.0),
        _LabeledField(
          theme: theme,
          label: 'Data da aula',
          child: TextFormField(
            controller: model.textController3,
            focusNode: model.textFieldFocusNode3,
            readOnly: true,
            style: _fieldTextStyle(theme),
            cursorColor: theme.primary,
            decoration: _fieldDecoration(
              theme,
              prefix: Icons.calendar_today_rounded,
              readOnly: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfessorBlock extends StatelessWidget {
  const _ProfessorBlock({
    required this.theme,
    required this.model,
    required this.data,
    required this.isCompact,
    required this.finalizada,
    required this.onSalvarProfessor,
    required this.onVisibilityChanged,
  });

  final FlutterFlowTheme theme;
  final DetalhesAulaModel model;
  final DetalhesAulaStruct? data;
  final bool isCompact;
  final bool finalizada;
  final VoidCallback onSalvarProfessor;
  final VoidCallback onVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    final visible = FFAppState().AlterarProfessorVisibility;
    final nomeProf = data?.professorResponsavelNome ?? '—';
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primary.withValues(alpha: 0.14),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.school_rounded,
                    color: theme.primary, size: 18.0),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Professor responsável',
                      style: theme.labelSmall.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        fontWeight: FontWeight.w600,
                        fontSize: 11.5,
                        letterSpacing: 0.5,
                        color: theme.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      nomeProf.isEmpty ? '—' : nomeProf,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.titleSmall.override(
                        font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700),
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                        color: theme.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              if (!finalizada && !visible)
                _SecondaryButton(
                  theme: theme,
                  icon: Icons.swap_horiz_rounded,
                  label: 'Alterar',
                  onTap: () {
                    FFAppState().AlterarProfessorVisibility = true;
                    onVisibilityChanged();
                  },
                ),
            ],
          ),
          if (!finalizada && visible) ...[
            const SizedBox(height: 14.0),
            FutureBuilder<ApiCallResponse>(
              future: model.listaProfs(
                requestFn: () => SupabaseGroup.listaProfessoresCall.call(
                  pIdFranquia: FFAppState().idfranquia,
                  token: currentJwtToken,
                ),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return _DropDownPlaceholder(theme: theme);
                }
                final list = (snapshot.data!.jsonBody
                        .toList()
                        .map<ListaProfessoresStruct?>(
                            ListaProfessoresStruct.maybeFromMap)
                        .toList() as Iterable<ListaProfessoresStruct?>)
                    .withoutNulls
                    .toList();
                return Container(
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: theme.alternate, width: 1.0),
                  ),
                  child: FlutterFlowDropDown<String>(
                    controller: model.dropDownProfessorValueController ??=
                        FormFieldController<String>(
                            model.dropDownProfessorValue ??= '0'),
                    options: list.map((e) => e.userId).toList(),
                    optionLabels: list.map((e) => e.nome).toList(),
                    onChanged: (val) => model.dropDownProfessorValue = val,
                    width: double.infinity,
                    height: 48.0,
                    textStyle: _fieldTextStyle(theme),
                    hintText: 'Selecione um professor',
                    searchHintText: 'Buscar...',
                    icon: Icon(Icons.keyboard_arrow_down_rounded,
                        color: theme.secondaryText, size: 22.0),
                    fillColor: theme.primaryBackground,
                    elevation: 0.0,
                    borderColor: Colors.transparent,
                    borderWidth: 0.0,
                    borderRadius: 12.0,
                    margin: const EdgeInsetsDirectional.fromSTEB(
                        14.0, 0.0, 14.0, 0.0),
                    hidesUnderline: true,
                    isOverButton: false,
                    isSearchable: true,
                    isMultiSelect: false,
                  ),
                );
              },
            ),
            const SizedBox(height: 12.0),
            isCompact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PrimaryActionButton(
                        theme: theme,
                        icon: Icons.check_rounded,
                        label: 'Salvar novo professor',
                        onTap: onSalvarProfessor,
                      ),
                      const SizedBox(height: 8.0),
                      _SecondaryButton(
                        theme: theme,
                        icon: Icons.close_rounded,
                        label: 'Cancelar',
                        stretch: true,
                        onTap: () {
                          FFAppState().AlterarProfessorVisibility = false;
                          onVisibilityChanged();
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _PrimaryActionButton(
                          theme: theme,
                          icon: Icons.check_rounded,
                          label: 'Salvar novo professor',
                          onTap: onSalvarProfessor,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      _SecondaryButton(
                        theme: theme,
                        icon: Icons.close_rounded,
                        label: 'Cancelar',
                        onTap: () {
                          FFAppState().AlterarProfessorVisibility = false;
                          onVisibilityChanged();
                        },
                      ),
                    ],
                  ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ALUNOS SECTION
// ---------------------------------------------------------------------------

class _AlunosSection extends StatelessWidget {
  const _AlunosSection({
    required this.theme,
    required this.data,
    required this.isCompact,
  });

  final FlutterFlowTheme theme;
  final DetalhesAulaStruct? data;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final convidados = data?.alunosConvidados ?? const <AlunosAulaStruct>[];
    final presentes = data?.alunosPresentes ?? const <AlunosAulaStruct>[];

    return _ResponsiveTwoColumns(
      isCompact: isCompact,
      left: _AlunosBlock(
        theme: theme,
        title: 'Alunos escalados',
        icon: Icons.assignment_ind_rounded,
        accent: theme.primary,
        alunos: convidados,
      ),
      right: _AlunosBlock(
        theme: theme,
        title: 'Alunos presentes',
        icon: Icons.how_to_reg_rounded,
        accent: theme.success,
        alunos: presentes,
      ),
    );
  }
}

class _AlunosBlock extends StatelessWidget {
  const _AlunosBlock({
    required this.theme,
    required this.title,
    required this.icon,
    required this.accent,
    required this.alunos,
  });

  final FlutterFlowTheme theme;
  final String title;
  final IconData icon;
  final Color accent;
  final List<AlunosAulaStruct> alunos;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: accent, size: 16.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  title,
                  style: theme.titleSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: theme.primaryText,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999.0),
                ),
                child: Text(
                  alunos.length.toString(),
                  style: theme.bodySmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                    fontWeight: FontWeight.w800,
                    fontSize: 12.0,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          if (alunos.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 14.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: theme.primaryBackground.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: theme.alternate, width: 1.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.person_off_outlined,
                      color: theme.secondaryText, size: 16.0),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Nenhum aluno.',
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: theme.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(alunos.length, (i) {
                return Padding(
                  padding:
                      EdgeInsets.only(bottom: i == alunos.length - 1 ? 0.0 : 6.0),
                  child: _AlunoItem(
                    theme: theme,
                    accent: accent,
                    nome: alunos[i].nome,
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}

class _AlunoItem extends StatelessWidget {
  const _AlunoItem({
    required this.theme,
    required this.accent,
    required this.nome,
  });

  final FlutterFlowTheme theme;
  final Color accent;
  final String nome;

  String _initials(String name) {
    final t = name.trim();
    if (t.isEmpty) return '?';
    final parts = t.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.primaryBackground.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            width: 26.0,
            height: 26.0,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _initials(nome),
              style: theme.titleSmall.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                fontWeight: FontWeight.w800,
                fontSize: 11.0,
                color: accent,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              nome.isEmpty ? '—' : nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                fontWeight: FontWeight.w600,
                fontSize: 13.0,
                color: theme.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PLANNING SECTION
// ---------------------------------------------------------------------------

class _PlanningSection extends StatelessWidget {
  const _PlanningSection({
    required this.theme,
    required this.model,
    required this.data,
    required this.idAula,
    required this.finalizada,
    required this.aguardandoPlanning,
    required this.onRemoverConteudo,
    required this.onConcluirPlanning,
  });

  final FlutterFlowTheme theme;
  final DetalhesAulaModel model;
  final DetalhesAulaStruct? data;
  final String? idAula;
  final bool finalizada;
  final bool aguardandoPlanning;
  final Future<void> Function(String? conteudoId) onRemoverConteudo;
  final VoidCallback onConcluirPlanning;

  @override
  Widget build(BuildContext context) {
    final vinculados = data?.conteudosVinculados ?? const <ConteudosAulaStruct>[];
    final utilizados = data?.conteudosUtilizados ?? const <ConteudosAulaStruct>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ConteudosVinculadosBlock(
          theme: theme,
          conteudos: vinculados,
          finalizada: finalizada,
          onAdd: () => context.pushNamed(
            ModulosWidget.routeName,
            queryParameters: {
              'aula': serializeParam(idAula, ParamType.String),
            }.withoutNulls,
          ),
          onRemover: onRemoverConteudo,
        ),
        if (finalizada) ...[
          const SizedBox(height: 14.0),
          _ConteudosUtilizadosBlock(theme: theme, conteudos: utilizados),
        ],
        const SizedBox(height: 16.0),
        _LabeledField(
          theme: theme,
          label: 'Anotações e comentários',
          child: TextFormField(
            controller: model.textController4,
            focusNode: model.textFieldFocusNode4,
            readOnly: finalizada,
            onChanged: finalizada
                ? null
                : (_) => EasyDebounce.debounce(
                      '_model.textController4',
                      const Duration(milliseconds: 2000),
                      () async {
                        await AulasTable().update(
                          data: {
                            'anotacoes_comentarios': model.textController4.text,
                          },
                          matchingRows: (rows) =>
                              rows.eqOrNull('id', idAula),
                        );
                      },
                    ),
            maxLines: null,
            minLines: 5,
            style: _fieldTextStyle(theme),
            cursorColor: theme.primary,
            decoration: _fieldDecoration(
              theme,
              hint:
                  'Anote pontos importantes desta aula, observações sobre alunos, planejamento...',
              readOnly: finalizada,
            ),
          ),
        ),
        if (aguardandoPlanning) ...[
          const SizedBox(height: 18.0),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _PrimaryActionButton(
              theme: theme,
              icon: Icons.task_alt_rounded,
              label: 'Concluir planning',
              onTap: onConcluirPlanning,
            ),
          ),
        ],
      ],
    );
  }
}

class _ConteudosVinculadosBlock extends StatelessWidget {
  const _ConteudosVinculadosBlock({
    required this.theme,
    required this.conteudos,
    required this.finalizada,
    required this.onAdd,
    required this.onRemover,
  });

  final FlutterFlowTheme theme;
  final List<ConteudosAulaStruct> conteudos;
  final bool finalizada;
  final VoidCallback onAdd;
  final Future<void> Function(String? conteudoId) onRemover;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.bookmark_added_rounded,
                    color: theme.primary, size: 16.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Conteúdos vinculados',
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
                      finalizada
                          ? 'Conteúdos definidos para esta aula.'
                          : 'Acesse e vincule conteúdos para esta aula.',
                      style: theme.bodySmall.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              if (!finalizada)
                _PrimaryActionButton(
                  theme: theme,
                  icon: Icons.add_rounded,
                  label: 'Vincular conteúdo',
                  onTap: onAdd,
                ),
            ],
          ),
          const SizedBox(height: 12.0),
          if (conteudos.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 14.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: theme.primaryBackground.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: theme.alternate, width: 1.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.bookmarks_outlined,
                      color: theme.secondaryText, size: 16.0),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Nenhum conteúdo vinculado ainda.',
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: theme.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: conteudos.map((c) {
                return _ConteudoChip(
                  theme: theme,
                  nome: c.nomeConteudo,
                  removable: !finalizada,
                  onRemove: () => onRemover(c.uuid),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _ConteudosUtilizadosBlock extends StatelessWidget {
  const _ConteudosUtilizadosBlock({
    required this.theme,
    required this.conteudos,
  });

  final FlutterFlowTheme theme;
  final List<ConteudosAulaStruct> conteudos;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
            color: theme.success.withValues(alpha: 0.4), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: theme.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.task_alt_rounded,
                    color: theme.success, size: 16.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Conteúdos utilizados',
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
                      'Conteúdos efetivamente trabalhados durante a aula.',
                      style: theme.bodySmall.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          if (conteudos.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 14.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: theme.primaryBackground.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: theme.alternate, width: 1.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.assignment_late_outlined,
                      color: theme.secondaryText, size: 16.0),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Nenhum conteúdo registrado.',
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: theme.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: conteudos.map((c) {
                return _ConteudoChip(
                  theme: theme,
                  nome: c.nomeConteudo,
                  removable: false,
                  accent: theme.success,
                  onRemove: () {},
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _ConteudoChip extends StatefulWidget {
  const _ConteudoChip({
    required this.theme,
    required this.nome,
    required this.removable,
    required this.onRemove,
    this.accent,
  });

  final FlutterFlowTheme theme;
  final String nome;
  final bool removable;
  final VoidCallback onRemove;
  final Color? accent;

  @override
  State<_ConteudoChip> createState() => _ConteudoChipState();
}

class _ConteudoChipState extends State<_ConteudoChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final accent = widget.accent ?? theme.primary;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.fromLTRB(
            12.0, 8.0, widget.removable ? 8.0 : 12.0, 8.0),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: _hovered ? 0.14 : 0.10),
          borderRadius: BorderRadius.circular(999.0),
          border: Border.all(
            color: accent.withValues(alpha: _hovered ? 0.5 : 0.25),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded, color: accent, size: 14.0),
            const SizedBox(width: 8.0),
            Text(
              widget.nome.isEmpty ? '—' : widget.nome,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                fontWeight: FontWeight.w600,
                fontSize: 13.0,
                color: accent,
              ),
            ),
            if (widget.removable) ...[
              const SizedBox(width: 6.0),
              GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  width: 22.0,
                  height: 22.0,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.close_rounded, color: accent, size: 13.0),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SECONDARY BUTTON / PRIMARY ACTION
// ---------------------------------------------------------------------------

class _SecondaryButton extends StatefulWidget {
  const _SecondaryButton({
    required this.theme,
    required this.icon,
    required this.label,
    required this.onTap,
    this.stretch = false,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool stretch;

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
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
          scale: _pressed ? 0.98 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: 44.0,
            width: widget.stretch ? double.infinity : null,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: _hovered
                  ? theme.primary.withValues(alpha: 0.10)
                  : theme.primaryBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: _hovered ? theme.primary : theme.alternate,
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon,
                    color: _hovered ? theme.primary : theme.primaryText,
                    size: 18.0),
                const SizedBox(width: 8.0),
                Text(
                  widget.label,
                  style: theme.titleSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: _hovered ? theme.primary : theme.primaryText,
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

class _PrimaryActionButton extends StatefulWidget {
  const _PrimaryActionButton({
    required this.theme,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_PrimaryActionButton> createState() => _PrimaryActionButtonState();
}

class _PrimaryActionButtonState extends State<_PrimaryActionButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
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
          scale: _pressed ? 0.98 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: 44.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: Colors.white, size: 18.0),
                const SizedBox(width: 8.0),
                Text(
                  widget.label,
                  style: theme.titleSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
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
