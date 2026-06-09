import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'detalhes_turma_model.dart';
export 'detalhes_turma_model.dart';

class DetalhesTurmaWidget extends StatefulWidget {
  const DetalhesTurmaWidget({
    super.key,
    required this.idTurma,
  });

  final String? idTurma;

  static String routeName = 'DetalhesTurma';
  static String routePath = '/detalhesTurma';

  @override
  State<DetalhesTurmaWidget> createState() => _DetalhesTurmaWidgetState();
}

class _DetalhesTurmaWidgetState extends State<DetalhesTurmaWidget> {
  late DetalhesTurmaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _controllersHydrated = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhesTurmaModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().AlterarProfessorVisibility = false;
      safeSetState(() {});
    });

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textFieldhorainiTextController ??= TextEditingController();
    _model.textFieldhorainiFocusNode ??= FocusNode();
    _model.textFieldhorainiMask = MaskTextInputFormatter(mask: '##:##');

    _model.textFieldhorafimTextController ??= TextEditingController();
    _model.textFieldhorafimFocusNode ??= FocusNode();
    _model.textFieldhorafimMask = MaskTextInputFormatter(mask: '##:##');

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _hydrate(TurmasRow? row) {
    if (_controllersHydrated || row == null) return;
    _model.textController1!.text = row.nomeDaTurma ?? '';
    _model.textController2!.text = row.moduloNivelTurma ?? '';
    _controllersHydrated = true;
  }

  Future<void> _showAlert(String title) async {
    await showDialog(
      context: context,
      builder: (alertCtx) => WebViewAware(
        child: AlertDialog(
          title: Text(title),
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

  Future<bool> _confirm(String title) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (alertCtx) => WebViewAware(
        child: AlertDialog(
          title: Text(title),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertCtx, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(alertCtx, true),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
    return res ?? false;
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
    await TurmasTable().update(
      data: {'professor_responsavel': _model.dropDownProfessorValue},
      matchingRows: (rows) => rows.eqOrNull('id', widget.idTurma),
    );
    safeSetState(() {
      _model.clearTurmaCache();
      _model.requestCompleted1 = false;
    });
    await _model.waitForRequestCompleted1();
    safeSetState(() {
      _model.clearProfRespCache();
      _model.requestCompleted2 = false;
    });
    await _model.waitForRequestCompleted2();
    FFAppState().AlterarProfessorVisibility = false;
    safeSetState(() {});
  }

  Future<void> _inserirAgenda(TurmasRow turma) async {
    final dia = _model.dropDownDiaValue;
    final ini = _model.textFieldhorainiTextController!.text.trim();
    final fim = _model.textFieldhorafimTextController!.text.trim();
    if (dia == null || dia.isEmpty || dia == '0') {
      await _showAlert('Selecione um dia da semana');
      return;
    }
    if (ini.isEmpty) {
      await _showAlert('Selecione um horário de início');
      return;
    }
    if (fim.isEmpty) {
      await _showAlert('Selecione um horário de término');
      return;
    }
    await TurmasTable().update(
      data: {
        'agenda_aulas': functions.addJsonItem(
          dia,
          ini,
          fim,
          turma.agendaAulas.toList(),
        ),
      },
      matchingRows: (rows) => rows.eqOrNull('id', widget.idTurma),
    );
    safeSetState(() {
      _model.textFieldhorafimTextController?.clear();
      _model.textFieldhorainiTextController?.clear();
      _model.dropDownDiaValueController?.value = '0';
      _model.dropDownDiaValue = '0';
      _model.clearTurmaCache();
      _model.requestCompleted1 = false;
    });
    await _model.waitForRequestCompleted1();
  }

  Future<void> _removerAgenda(TurmasRow turma, int index) async {
    if (!await _confirm('Desvincular essa agenda?')) return;
    await TurmasTable().update(
      data: {
        'agenda_aulas': functions.removeJsonItem(
          turma.agendaAulas.toList(),
          index,
        ),
      },
      matchingRows: (rows) => rows.eqOrNull('id', widget.idTurma),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Agenda desvinculada'),
          backgroundColor: FlutterFlowTheme.of(context).primary,
          duration: const Duration(milliseconds: 2500),
        ),
      );
    }
    safeSetState(() {
      _model.clearTurmaCache();
      _model.requestCompleted1 = false;
    });
    await _model.waitForRequestCompleted1();
  }

  Future<void> _vincularAluno() async {
    final id = _model.dropDownAlunoValue;
    if (id == null || id.isEmpty || id == '0') {
      await _showAlert('Selecione um aluno');
      return;
    }
    // O RPC é a fonte única: insere o vínculo N:N em aluno_turmas, mantém
    // meta_alunos.turma como turma mais recente e adiciona o aluno nas aulas.
    // Um aluno pode estar vinculado a várias turmas ao mesmo tempo.
    final resp = await SupabaseGroup.vincularAlunoTurmaEAulasCall.call(
      pTurmaId: widget.idTurma,
      pUserId: id,
      token: currentJwtToken,
    );
    if (!resp.succeeded) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao vincular o aluno. Tente novamente.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
            duration: const Duration(milliseconds: 3000),
          ),
        );
      }
      return;
    }
    safeSetState(() {
      _model.clearLsialunoturmaCache();
      _model.apiRequestCompleted = false;
    });
    await _model.waitForApiRequestCompleted();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Aluno vinculado'),
          backgroundColor: FlutterFlowTheme.of(context).primary,
          duration: const Duration(milliseconds: 2500),
        ),
      );
    }
  }

  Future<void> _desvincularAluno(String userId) async {
    if (!await _confirm('Desvincular esse aluno?')) return;
    // O RPC é a fonte única: remove o vínculo N:N desta turma, repõe
    // meta_alunos.turma com outra turma do aluno (ou null) e tira o aluno das
    // aulas desta turma — sem afetar as outras turmas em que ele está.
    final resp = await SupabaseGroup.desvincularAlunoTurmaEAulasCall.call(
      pTurmaId: widget.idTurma,
      pUserId: userId,
      token: currentJwtToken,
    );
    if (!resp.succeeded) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao desvincular o aluno. Tente novamente.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
            duration: const Duration(milliseconds: 3000),
          ),
        );
      }
      return;
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Aluno desvinculado'),
          backgroundColor: FlutterFlowTheme.of(context).primary,
          duration: const Duration(milliseconds: 2500),
        ),
      );
    }
    safeSetState(() {
      _model.clearLsialunoturmaCache();
      _model.apiRequestCompleted = false;
    });
    await _model.waitForApiRequestCompleted();
  }

  Future<void> _salvar() async {
    if (_saving) return;
    if (_model.textController1!.text.trim().isEmpty) {
      await _showAlert('Informe o nome da turma');
      return;
    }
    setState(() => _saving = true);
    try {
      await TurmasTable().update(
        data: {
          'nome_da_turma': _model.textController1!.text,
          'modulo_nivel_turma': _model.textController2!.text,
        },
        matchingRows: (rows) => rows.eqOrNull('id', widget.idTurma),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Turma atualizada'),
            backgroundColor: FlutterFlowTheme.of(context).primary,
            duration: const Duration(milliseconds: 2500),
          ),
        );
      }
      safeSetState(() {
        _model.clearTurmaCache();
        _model.requestCompleted1 = false;
      });
      await _model.waitForRequestCompleted1();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao salvar. Tente novamente.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
            duration: const Duration(milliseconds: 3000),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
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
                child: FutureBuilder<List<TurmasRow>>(
                  future: _model
                      .turma(
                    requestFn: () => TurmasTable().querySingleRow(
                      queryFn: (q) => q.eqOrNull('id', widget.idTurma),
                    ),
                  )
                      .then((res) {
                    _model.requestCompleted1 = true;
                    return res;
                  }),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return _LoadingState(theme: theme);
                    }
                    final list = snapshot.data!;
                    final turma = list.isNotEmpty ? list.first : null;
                    _hydrate(turma);

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
                            nome: turma?.nomeDaTurma ?? '',
                            onBack: () => context.safePop(),
                          ),
                          const SizedBox(height: 24.0),
                          _SectionCard(
                            theme: theme,
                            icon: Icons.info_outline_rounded,
                            chip: 'Dados da turma',
                            title: 'Informações principais',
                            subtitle:
                                'Edite o nome, módulo e o professor responsável.',
                            child: _DadosSection(
                              theme: theme,
                              model: _model,
                              isCompact: isCompact,
                              turma: turma,
                              onSalvarProfessor: _salvarProfessor,
                              onProfessorVisibilityChanged: () =>
                                  safeSetState(() {}),
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          _SectionCard(
                            theme: theme,
                            icon: Icons.event_available_rounded,
                            chip: 'Agenda',
                            title: 'Agenda de aulas',
                            subtitle:
                                'Os horários recorrentes que geram as aulas desta turma.',
                            child: _AgendaSection(
                              theme: theme,
                              model: _model,
                              isCompact: isCompact,
                              turma: turma,
                              onInserir: () => _inserirAgenda(turma!),
                              onRemover: (i) => _removerAgenda(turma!, i),
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          _SectionCard(
                            theme: theme,
                            icon: Icons.person_add_alt_1_rounded,
                            chip: 'Alunos',
                            title: 'Vincular alunos',
                            subtitle:
                                'Selecione os alunos que farão parte desta turma.',
                            child: _VincularAlunosSection(
                              theme: theme,
                              model: _model,
                              isCompact: isCompact,
                              idTurma: widget.idTurma,
                              onVincular: _vincularAluno,
                              onDesvincular: _desvincularAluno,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          _SaveButton(
                            theme: theme,
                            loading: _saving,
                            onTap: _salvar,
                          ),
                          const SizedBox(height: 24.0),
                          _SectionCard(
                            theme: theme,
                            icon: Icons.event_note_rounded,
                            chip: 'Aulas',
                            title: 'Próximas aulas',
                            subtitle:
                                'Acompanhe as próximas aulas agendadas para esta turma.',
                            child: _AulasSection(
                              theme: theme,
                              model: _model,
                              idTurma: widget.idTurma,
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          _SectionCard(
                            theme: theme,
                            icon: Icons.history_rounded,
                            chip: 'Histórico',
                            title: 'Histórico de aulas',
                            subtitle:
                                'Visualize todas as aulas concluídas desta turma.',
                            child: _HistoricoButton(
                              theme: theme,
                              onTap: () => context.pushNamed(
                                HistoricoAulasWidget.routeName,
                                queryParameters: {
                                  'turma': serializeParam(
                                      widget.idTurma, ParamType.String),
                                }.withoutNulls,
                              ),
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
    required this.nome,
    required this.onBack,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final String nome;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final title = nome.trim().isEmpty ? 'Detalhes da turma' : nome;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
          child: Icon(Icons.groups_2_rounded, color: theme.primary, size: 22.0),
        ),
        const SizedBox(width: 14.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
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
                'Detalhes, agenda, alunos e histórico desta turma.',
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
    {String? hint, IconData? prefix}) {
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
    fillColor: theme.secondaryBackground,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.alternate, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.primary, width: 1.4),
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
// DADOS SECTION
// ---------------------------------------------------------------------------

class _DadosSection extends StatelessWidget {
  const _DadosSection({
    required this.theme,
    required this.model,
    required this.isCompact,
    required this.turma,
    required this.onSalvarProfessor,
    required this.onProfessorVisibilityChanged,
  });

  final FlutterFlowTheme theme;
  final DetalhesTurmaModel model;
  final bool isCompact;
  final TurmasRow? turma;
  final VoidCallback onSalvarProfessor;
  final VoidCallback onProfessorVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    final dataIni = turma?.dataInicio == null
        ? '—'
        : dateTimeFormat(
            'd/M/y',
            turma!.dataInicio,
            locale: FFLocalizations.of(context).languageCode,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LabeledField(
          theme: theme,
          label: 'Nome da turma',
          child: TextFormField(
            controller: model.textController1,
            focusNode: model.textFieldFocusNode1,
            style: _fieldTextStyle(theme),
            cursorColor: theme.primary,
            decoration: _fieldDecoration(
              theme,
              hint: 'Ex.: Iniciantes terça/quinta 19h',
              prefix: Icons.label_important_outline_rounded,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        _ResponsiveTwoColumns(
          isCompact: isCompact,
          left: _LabeledField(
            theme: theme,
            label: 'Data de início',
            child: Container(
              height: 48.0,
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              decoration: BoxDecoration(
                color: theme.secondaryBackground.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: theme.alternate, width: 1.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      color: theme.secondaryText, size: 18.0),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      dataIni,
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: theme.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          right: _LabeledField(
            theme: theme,
            label: 'Módulo / Nível',
            child: TextFormField(
              controller: model.textController2,
              focusNode: model.textFieldFocusNode2,
              style: _fieldTextStyle(theme),
              cursorColor: theme.primary,
              decoration: _fieldDecoration(
                theme,
                hint: 'Ex.: Módulo 12, avançado',
                prefix: Icons.tag_rounded,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18.0),
        _ProfessorBlock(
          theme: theme,
          model: model,
          turma: turma,
          isCompact: isCompact,
          onSalvarProfessor: onSalvarProfessor,
          onVisibilityChanged: onProfessorVisibilityChanged,
        ),
      ],
    );
  }
}

class _ProfessorBlock extends StatelessWidget {
  const _ProfessorBlock({
    required this.theme,
    required this.model,
    required this.turma,
    required this.isCompact,
    required this.onSalvarProfessor,
    required this.onVisibilityChanged,
  });

  final FlutterFlowTheme theme;
  final DetalhesTurmaModel model;
  final TurmasRow? turma;
  final bool isCompact;
  final VoidCallback onSalvarProfessor;
  final VoidCallback onVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    final visible = FFAppState().AlterarProfessorVisibility;
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
          FutureBuilder<List<UsersRow>>(
            future: model
                .profResp(
              requestFn: () => UsersTable().querySingleRow(
                queryFn: (q) =>
                    q.eqOrNull('id', turma?.professorResponsavel),
              ),
            )
                .then((res) {
              model.requestCompleted2 = true;
              return res;
            }),
            builder: (context, snapshot) {
              UsersRow? prof;
              if (snapshot.hasData) {
                final list = snapshot.data!;
                prof = list.isNotEmpty ? list.first : null;
              }
              return Row(
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
                            font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600),
                            fontWeight: FontWeight.w600,
                            fontSize: 11.5,
                            letterSpacing: 0.5,
                            color: theme.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          prof?.nome ?? 'Carregando...',
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
                  if (!visible)
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
              );
            },
          ),
          if (visible) ...[
            const SizedBox(height: 14.0),
            FutureBuilder<ApiCallResponse>(
              future: model.listaprof(
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
// AGENDA SECTION
// ---------------------------------------------------------------------------

class _AgendaSection extends StatelessWidget {
  const _AgendaSection({
    required this.theme,
    required this.model,
    required this.isCompact,
    required this.turma,
    required this.onInserir,
    required this.onRemover,
  });

  final FlutterFlowTheme theme;
  final DetalhesTurmaModel model;
  final bool isCompact;
  final TurmasRow? turma;
  final VoidCallback onInserir;
  final void Function(int index) onRemover;

  @override
  Widget build(BuildContext context) {
    final agendas = turma?.agendaAulas.toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isCompact) ...[
          _LabeledField(
            theme: theme,
            label: 'Dia da semana',
            child: _DiaDropDown(theme: theme, model: model),
          ),
          const SizedBox(height: 12.0),
          _ResponsiveTwoColumns(
            isCompact: false,
            left: _LabeledField(
              theme: theme,
              label: 'Hora início',
              child: _HoraField(
                theme: theme,
                controller: model.textFieldhorainiTextController!,
                focusNode: model.textFieldhorainiFocusNode,
                mask: model.textFieldhorainiMask,
              ),
            ),
            right: _LabeledField(
              theme: theme,
              label: 'Hora término',
              child: _HoraField(
                theme: theme,
                controller: model.textFieldhorafimTextController!,
                focusNode: model.textFieldhorafimFocusNode,
                mask: model.textFieldhorafimMask,
              ),
            ),
          ),
          const SizedBox(height: 14.0),
          _SecondaryButton(
            theme: theme,
            icon: Icons.add_rounded,
            label: 'Inserir agenda',
            onTap: onInserir,
            stretch: true,
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: _LabeledField(
                  theme: theme,
                  label: 'Dia da semana',
                  child: _DiaDropDown(theme: theme, model: model),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                flex: 2,
                child: _LabeledField(
                  theme: theme,
                  label: 'Hora início',
                  child: _HoraField(
                    theme: theme,
                    controller: model.textFieldhorainiTextController!,
                    focusNode: model.textFieldhorainiFocusNode,
                    mask: model.textFieldhorainiMask,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                flex: 2,
                child: _LabeledField(
                  theme: theme,
                  label: 'Hora término',
                  child: _HoraField(
                    theme: theme,
                    controller: model.textFieldhorafimTextController!,
                    focusNode: model.textFieldhorafimFocusNode,
                    mask: model.textFieldhorafimMask,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              _SecondaryButton(
                theme: theme,
                icon: Icons.add_rounded,
                label: 'Inserir',
                onTap: onInserir,
              ),
            ],
          ),
        const SizedBox(height: 18.0),
        _AgendasList(
          theme: theme,
          agendas: agendas,
          onRemover: onRemover,
        ),
      ],
    );
  }
}

class _DiaDropDown extends StatelessWidget {
  const _DiaDropDown({required this.theme, required this.model});

  final FlutterFlowTheme theme;
  final DetalhesTurmaModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: FlutterFlowDropDown<String>(
        controller: model.dropDownDiaValueController ??=
            FormFieldController<String>(null),
        options: const [
          'Domingo',
          'Segunda',
          'Terça',
          'Quarta',
          'Quinta',
          'Sexta',
          'Sábado',
        ],
        onChanged: (val) => model.dropDownDiaValue = val,
        width: double.infinity,
        height: 48.0,
        textStyle: _fieldTextStyle(theme),
        hintText: 'Selecione',
        icon: Icon(Icons.keyboard_arrow_down_rounded,
            color: theme.secondaryText, size: 22.0),
        fillColor: theme.secondaryBackground,
        elevation: 0.0,
        borderColor: Colors.transparent,
        borderWidth: 0.0,
        borderRadius: 12.0,
        margin: const EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 14.0, 0.0),
        hidesUnderline: true,
        isOverButton: false,
        isSearchable: false,
        isMultiSelect: false,
      ),
    );
  }
}

class _HoraField extends StatelessWidget {
  const _HoraField({
    required this.theme,
    required this.controller,
    required this.focusNode,
    required this.mask,
  });

  final FlutterFlowTheme theme;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final MaskTextInputFormatter mask;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      style: _fieldTextStyle(theme),
      cursorColor: theme.primary,
      inputFormatters: [mask],
      decoration: _fieldDecoration(
        theme,
        hint: 'hh:mm',
        prefix: Icons.access_time_rounded,
      ),
    );
  }
}

class _AgendasList extends StatelessWidget {
  const _AgendasList({
    required this.theme,
    required this.agendas,
    required this.onRemover,
  });

  final FlutterFlowTheme theme;
  final List<dynamic> agendas;
  final void Function(int index) onRemover;

  @override
  Widget build(BuildContext context) {
    if (agendas.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: theme.secondaryBackground.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: theme.alternate, width: 1.0),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined,
                color: theme.secondaryText, size: 18.0),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                'Nenhuma agenda cadastrada ainda.',
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  fontWeight: FontWeight.w500,
                  fontSize: 13.5,
                  color: theme.secondaryText,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Agendas cadastradas',
          style: theme.titleSmall.override(
            font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
            color: theme.primaryText,
          ),
        ),
        const SizedBox(height: 10.0),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: List.generate(agendas.length, (index) {
            final item = AgendaAulasStruct.maybeFromMap(agendas[index]);
            return _AgendaChip(
              theme: theme,
              dia: item?.dia ?? '',
              inicio: item?.horarioInicio ?? '',
              fim: item?.horarioFinal ?? '',
              onRemove: () => onRemover(index),
            );
          }),
        ),
      ],
    );
  }
}

class _AgendaChip extends StatefulWidget {
  const _AgendaChip({
    required this.theme,
    required this.dia,
    required this.inicio,
    required this.fim,
    required this.onRemove,
  });

  final FlutterFlowTheme theme;
  final String dia;
  final String inicio;
  final String fim;
  final VoidCallback onRemove;

  @override
  State<_AgendaChip> createState() => _AgendaChipState();
}

class _AgendaChipState extends State<_AgendaChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 8.0),
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: _hovered ? 0.14 : 0.10),
          borderRadius: BorderRadius.circular(999.0),
          border: Border.all(
            color: theme.primary.withValues(alpha: _hovered ? 0.5 : 0.25),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_rounded, color: theme.primary, size: 14.0),
            const SizedBox(width: 8.0),
            Text(
              '${widget.dia} · ${widget.inicio} – ${widget.fim}',
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                fontWeight: FontWeight.w600,
                fontSize: 13.0,
                color: theme.primary,
              ),
            ),
            const SizedBox(width: 6.0),
            GestureDetector(
              onTap: widget.onRemove,
              child: Container(
                width: 22.0,
                height: 22.0,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.close_rounded,
                    color: theme.primary, size: 13.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// VINCULAR ALUNOS SECTION
// ---------------------------------------------------------------------------

class _VincularAlunosSection extends StatelessWidget {
  const _VincularAlunosSection({
    required this.theme,
    required this.model,
    required this.isCompact,
    required this.idTurma,
    required this.onVincular,
    required this.onDesvincular,
  });

  final FlutterFlowTheme theme;
  final DetalhesTurmaModel model;
  final bool isCompact;
  final String? idTurma;
  final VoidCallback onVincular;
  final void Function(String userId) onDesvincular;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: model
          .lsialunoturma(
        requestFn: () => SupabaseGroup.listaAlunosPorTurmaCall.call(
          pTurmaId: idTurma,
          token: currentJwtToken,
        ),
      )
          .then((res) {
        model.apiRequestCompleted = true;
        return res;
      }),
      builder: (context, snapAlunosTurma) {
        final loadingTurmaAlunos = !snapAlunosTurma.hasData;
        final alunosVinculados = snapAlunosTurma.hasData
            ? snapAlunosTurma.data!.jsonBody.toList()
            : <dynamic>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<ApiCallResponse>(
              future: model.lsitaaluno(
                requestFn: () => SupabaseGroup.listaAlunosCall.call(
                  pFranquiaId: FFAppState().idfranquia,
                  token: currentJwtToken,
                ),
              ),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return _DropDownPlaceholder(theme: theme);
                }
                final list = (snap.data!.jsonBody
                        .toList()
                        .map<ListaAlunosStruct?>(
                            ListaAlunosStruct.maybeFromMap)
                        .toList() as Iterable<ListaAlunosStruct?>)
                    .withoutNulls
                    .toList();
                final dropdown = Container(
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: theme.alternate, width: 1.0),
                  ),
                  child: FlutterFlowDropDown<String>(
                    controller: model.dropDownAlunoValueController ??=
                        FormFieldController<String>(
                            model.dropDownAlunoValue ??= '0'),
                    options: list.map((e) => e.userId).toList(),
                    optionLabels: list.map((e) => e.nome).toList(),
                    onChanged: (val) => model.dropDownAlunoValue = val,
                    width: double.infinity,
                    height: 48.0,
                    textStyle: _fieldTextStyle(theme),
                    hintText: 'Selecione um aluno',
                    searchHintText: 'Buscar...',
                    icon: Icon(Icons.keyboard_arrow_down_rounded,
                        color: theme.secondaryText, size: 22.0),
                    fillColor: theme.secondaryBackground,
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

                if (isCompact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _LabeledField(
                        theme: theme,
                        label: 'Aluno',
                        child: dropdown,
                      ),
                      const SizedBox(height: 12.0),
                      _SecondaryButton(
                        theme: theme,
                        icon: Icons.person_add_alt_1_rounded,
                        label: 'Vincular aluno',
                        onTap: onVincular,
                        stretch: true,
                      ),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _LabeledField(
                        theme: theme,
                        label: 'Aluno',
                        child: dropdown,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    _SecondaryButton(
                      theme: theme,
                      icon: Icons.person_add_alt_1_rounded,
                      label: 'Vincular aluno',
                      onTap: onVincular,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18.0),
            if (loadingTurmaAlunos)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Center(
                  child: SizedBox(
                    width: 22.0,
                    height: 22.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation(theme.primary),
                    ),
                  ),
                ),
              )
            else
              _AlunosVinculadosList(
                theme: theme,
                alunos: alunosVinculados,
                onRemove: onDesvincular,
              ),
          ],
        );
      },
    );
  }
}

class _AlunosVinculadosList extends StatelessWidget {
  const _AlunosVinculadosList({
    required this.theme,
    required this.alunos,
    required this.onRemove,
  });

  final FlutterFlowTheme theme;
  final List<dynamic> alunos;
  final void Function(String userId) onRemove;

  @override
  Widget build(BuildContext context) {
    if (alunos.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: theme.secondaryBackground.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: theme.alternate, width: 1.0),
        ),
        child: Row(
          children: [
            Icon(Icons.people_outline_rounded,
                color: theme.secondaryText, size: 18.0),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                'Nenhum aluno vinculado ainda.',
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  fontWeight: FontWeight.w500,
                  fontSize: 13.5,
                  color: theme.secondaryText,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Alunos vinculados (${alunos.length})',
          style: theme.titleSmall.override(
            font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
            color: theme.primaryText,
          ),
        ),
        const SizedBox(height: 10.0),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: alunos.map((item) {
            final nome =
                getJsonField(item, r'$.nome')?.toString() ?? '—';
            final userId =
                getJsonField(item, r'$.user_id')?.toString() ?? '';
            return _AlunoChip(
              theme: theme,
              nome: nome,
              onRemove: () => onRemove(userId),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _AlunoChip extends StatefulWidget {
  const _AlunoChip({
    required this.theme,
    required this.nome,
    required this.onRemove,
  });

  final FlutterFlowTheme theme;
  final String nome;
  final VoidCallback onRemove;

  @override
  State<_AlunoChip> createState() => _AlunoChipState();
}

class _AlunoChipState extends State<_AlunoChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final initials = _initialsFrom(widget.nome);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.fromLTRB(6.0, 6.0, 8.0, 6.0),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(999.0),
          border: Border.all(
            color: _hovered ? theme.primary : theme.alternate,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26.0,
              height: 26.0,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: theme.titleSmall.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                  fontWeight: FontWeight.w800,
                  fontSize: 11.0,
                  color: theme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              widget.nome,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                fontWeight: FontWeight.w600,
                fontSize: 13.0,
                color: theme.primaryText,
              ),
            ),
            const SizedBox(width: 8.0),
            GestureDetector(
              onTap: widget.onRemove,
              child: Container(
                width: 22.0,
                height: 22.0,
                decoration: BoxDecoration(
                  color: theme.error.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.close_rounded,
                    color: theme.error, size: 13.0),
              ),
            ),
          ],
        ),
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

// ---------------------------------------------------------------------------
// AULAS SECTION
// ---------------------------------------------------------------------------

class _AulasSection extends StatelessWidget {
  const _AulasSection({
    required this.theme,
    required this.model,
    required this.idTurma,
  });

  final FlutterFlowTheme theme;
  final DetalhesTurmaModel model;
  final String? idTurma;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AulasRow>>(
      future: model.aulas(
        requestFn: () => AulasTable().queryRows(
          queryFn: (q) => q
              .eqOrNull('turma', idTurma)
              .gteOrNull('datetimeinicio_aula',
                  supaSerialize<DateTime>(getCurrentTimestamp))
              .order('datetimeinicio_aula'),
        ),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Center(
              child: SizedBox(
                width: 22.0,
                height: 22.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation(theme.primary),
                ),
              ),
            ),
          );
        }
        final list = snapshot.data!;
        if (list.isEmpty) {
          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: theme.secondaryBackground.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: theme.alternate, width: 1.0),
            ),
            child: Row(
              children: [
                Icon(Icons.event_busy_rounded,
                    color: theme.secondaryText, size: 18.0),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'Nenhuma aula futura agendada.',
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      fontWeight: FontWeight.w500,
                      fontSize: 13.5,
                      color: theme.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(list.length, (i) {
            final aula = list[i];
            return Padding(
              padding: EdgeInsets.only(bottom: i == list.length - 1 ? 0.0 : 8.0),
              child: _AulaTile(
                theme: theme,
                aula: aula,
                onTap: () => context.pushNamed(
                  DetalhesAulaWidget.routeName,
                  queryParameters: {
                    'idAula':
                        serializeParam(aula.id, ParamType.String),
                  }.withoutNulls,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _AulaTile extends StatefulWidget {
  const _AulaTile({
    required this.theme,
    required this.aula,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final AulasRow aula;
  final VoidCallback onTap;

  @override
  State<_AulaTile> createState() => _AulaTileState();
}

class _AulaTileState extends State<_AulaTile> {
  bool _hovered = false;

  Color _statusColor(FlutterFlowTheme theme) {
    final s = widget.aula.statusAula;
    if (s == 'Aguardando Planning') return theme.secondary;
    if (s == 'Planning concluído') return theme.success;
    return theme.secondaryText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final statusColor = _statusColor(theme);
    final dateLabel = widget.aula.datetimeinicioAula == null
        ? '—'
        : dateTimeFormat(
            'd/M/y',
            widget.aula.datetimeinicioAula!,
            locale: FFLocalizations.of(context).languageCode,
          );
    final timeLabel = widget.aula.datetimeinicioAula == null
        ? ''
        : dateTimeFormat(
            'HH:mm',
            widget.aula.datetimeinicioAula!,
            locale: FFLocalizations.of(context).languageCode,
          );
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding:
              const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: _hovered
                ? theme.primary.withValues(alpha: 0.05)
                : theme.secondaryBackground.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: _hovered ? theme.primary : theme.alternate,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.event_rounded,
                    color: theme.primary, size: 18.0),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateLabel,
                      style: theme.titleSmall.override(
                        font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700),
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: theme.primaryText,
                      ),
                    ),
                    if (timeLabel.isNotEmpty) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        timeLabel,
                        style: theme.bodySmall.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 6.0),
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
                    const SizedBox(width: 6.0),
                    Text(
                      widget.aula.statusAula ?? 'Status',
                      style: theme.bodySmall.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              Icon(Icons.chevron_right_rounded,
                  color: theme.secondaryText, size: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HISTORICO BUTTON
// ---------------------------------------------------------------------------

class _HistoricoButton extends StatelessWidget {
  const _HistoricoButton({required this.theme, required this.onTap});

  final FlutterFlowTheme theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: _SecondaryButton(
        theme: theme,
        icon: Icons.open_in_new_rounded,
        label: 'Acessar histórico',
        onTap: onTap,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SECONDARY BUTTON / PRIMARY ACTION / SAVE
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
                  color: theme.primary
                      .withValues(alpha: _hovered ? 0.30 : 0.18),
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

class _SaveButton extends StatefulWidget {
  const _SaveButton({
    required this.theme,
    required this.loading,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final bool loading;
  final VoidCallback onTap;

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return MouseRegion(
      cursor: widget.loading
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown:
            widget.loading ? null : (_) => setState(() => _pressed = true),
        onTapUp:
            widget.loading ? null : (_) => setState(() => _pressed = false),
        onTapCancel:
            widget.loading ? null : () => setState(() => _pressed = false),
        onTap: widget.loading ? null : widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: _pressed ? 0.98 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: 54.0,
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: BorderRadius.circular(14.0),
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withValues(
                      alpha: _hovered && !widget.loading ? 0.32 : 0.18),
                  blurRadius: _hovered && !widget.loading ? 22.0 : 14.0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: widget.loading
                ? const SizedBox(
                    width: 22.0,
                    height: 22.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.save_rounded,
                          color: Colors.white, size: 18.0),
                      const SizedBox(width: 8.0),
                      Text(
                        'Salvar alterações',
                        style: theme.titleSmall.override(
                          font: GoogleFonts.interTight(
                              fontWeight: FontWeight.w700),
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
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
