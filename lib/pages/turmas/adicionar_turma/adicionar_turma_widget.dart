import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'adicionar_turma_model.dart';
export 'adicionar_turma_model.dart';

class AdicionarTurmaWidget extends StatefulWidget {
  const AdicionarTurmaWidget({super.key});

  static String routeName = 'AdicionarTurma';
  static String routePath = '/adicionarTurma';

  @override
  State<AdicionarTurmaWidget> createState() => _AdicionarTurmaWidgetState();
}

class _AdicionarTurmaWidgetState extends State<AdicionarTurmaWidget> {
  late AdicionarTurmaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdicionarTurmaModel());
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textFieldMask3 = MaskTextInputFormatter(mask: '##:##');
    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();
    _model.textFieldMask4 = MaskTextInputFormatter(mask: '##:##');

    FFAppState().AgendasTurma = [];
    FFAppState().ListaAlunos = [];

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _pickDataInicio() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: getCurrentTimestamp,
      firstDate: getCurrentTimestamp,
      lastDate: DateTime(2050),
      builder: (context, child) {
        final theme = FlutterFlowTheme.of(context);
        return wrapInMaterialDatePickerTheme(
          context,
          child!,
          headerBackgroundColor: theme.primary,
          headerForegroundColor: theme.info,
          headerTextStyle: theme.headlineLarge.override(
            font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
            fontWeight: FontWeight.w700,
            fontSize: 30.0,
            letterSpacing: -0.4,
          ),
          pickerBackgroundColor: theme.secondaryBackground,
          pickerForegroundColor: theme.primaryText,
          selectedDateTimeBackgroundColor: theme.primary,
          selectedDateTimeForegroundColor: theme.info,
          actionButtonForegroundColor: theme.primaryText,
          iconSize: 24.0,
        );
      },
    );
    if (pickedDate != null) {
      safeSetState(() {
        _model.datePicked = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );
      });
    }
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

  Future<void> _inserirAgenda() async {
    final dia = _model.dropDownDiaValue;
    final ini = _model.textController3.text.trim();
    final fim = _model.textController4.text.trim();
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
    FFAppState().addToAgendasTurma(AgendaAulasStruct(
      dia: dia,
      horarioFinal: fim,
      horarioInicio: ini,
    ));
    safeSetState(() {});
  }

  Future<void> _removerAgenda(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (alertCtx) => WebViewAware(
        child: AlertDialog(
          title: const Text('Remover essa agenda?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertCtx, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(alertCtx, true),
              child: const Text('Remover'),
            ),
          ],
        ),
      ),
    );
    if (confirm ?? false) {
      FFAppState().removeAtIndexFromAgendasTurma(index);
      safeSetState(() {});
    }
  }

  Future<void> _vincularAluno() async {
    final id = _model.dropDownAlunoValue;
    if (id == null || id.isEmpty || id == '0') {
      await _showAlert('Selecione um aluno');
      return;
    }
    final alreadyAdded =
        FFAppState().ListaAlunos.any((e) => e.userId == id);
    if (alreadyAdded) {
      await _showAlert('Esse aluno já está vinculado');
      return;
    }
    FFAppState().addToListaAlunos(ListaAlunosStruct(userId: id));
    safeSetState(() {});
  }

  Future<void> _desvincularAluno(ListaAlunosStruct item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (alertCtx) => WebViewAware(
        child: AlertDialog(
          title: const Text('Desvincular esse aluno?'),
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
    if (confirm ?? false) {
      FFAppState().removeFromListaAlunos(item);
      safeSetState(() {});
    }
  }

  bool _validate() {
    if (_model.textController1.text.trim().isEmpty) {
      _showAlert('Informe o nome da turma');
      return false;
    }
    if (_model.datePicked == null) {
      _showAlert('Selecione a data de início');
      return false;
    }
    if (_model.textController2.text.trim().isEmpty) {
      _showAlert('Informe o módulo');
      return false;
    }
    if (_model.dropDownValue == null ||
        _model.dropDownValue!.isEmpty ||
        _model.dropDownValue == '0') {
      _showAlert('Selecione o professor responsável');
      return false;
    }
    return true;
  }

  Future<void> _salvar() async {
    if (_saving) return;
    if (!_validate()) return;

    setState(() => _saving = true);
    try {
      _model.turmaCriada = await TurmasTable().insert({
        'nome_da_turma': _model.textController1.text,
        'data_inicio': supaSerialize<DateTime>(_model.datePicked),
        'modulo_nivel_turma': _model.textController2.text,
        'agenda_aulas':
            FFAppState().AgendasTurma.map((e) => e.toMap()).toList(),
        'professor_responsavel': _model.dropDownValue,
        'id_franquia': FFAppState().idfranquia,
      });

      for (var i = 0; i < FFAppState().ListaAlunos.length; i++) {
        final aluno = FFAppState().ListaAlunos[i];
        await MetaAlunosTable().update(
          data: {'turma': _model.turmaCriada?.id},
          matchingRows: (rows) => rows.eqOrNull('user_id', aluno.userId),
        );
      }

      _model.apiPrimeiraAulaCriada = await SupabaseGroup.criarAulaCall.call(
        pTurmaId: _model.turmaCriada?.id,
        token: currentJwtToken,
      );

      await AulasTable().update(
        data: {
          'alunos_convidados':
              FFAppState().ListaAlunos.map((e) => e.userId).toList(),
        },
        matchingRows: (rows) => rows.eqOrNull(
          'id',
          SupabaseGroup.criarAulaCall
              .uuidAula(_model.apiPrimeiraAulaCriada?.jsonBody ?? ''),
        ),
      );

      if (!mounted) return;
      context.pushNamed(
        DetalhesTurmaWidget.routeName,
        queryParameters: {
          'idTurma': serializeParam(_model.turmaCriada?.id, ParamType.String),
        }.withoutNulls,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao criar turma. Tente novamente.'),
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
                child: SingleChildScrollView(
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
                        onBack: () => context.safePop(),
                      ),
                      const SizedBox(height: 24.0),
                      _SectionCard(
                        theme: theme,
                        icon: Icons.info_outline_rounded,
                        chip: 'Dados da turma',
                        title: 'Informações principais',
                        subtitle:
                            'Defina nome, módulo e professor responsável.',
                        child: _DadosSection(
                          theme: theme,
                          model: _model,
                          isCompact: isCompact,
                          onPickData: _pickDataInicio,
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      _SectionCard(
                        theme: theme,
                        icon: Icons.event_available_rounded,
                        chip: 'Agenda',
                        title: 'Agenda de aulas',
                        subtitle:
                            'Adicione os dias e horários recorrentes da turma.',
                        child: _AgendaSection(
                          theme: theme,
                          model: _model,
                          isCompact: isCompact,
                          onInserir: _inserirAgenda,
                          onRemover: _removerAgenda,
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      _SectionCard(
                        theme: theme,
                        icon: Icons.person_add_alt_1_rounded,
                        chip: 'Alunos',
                        title: 'Vincular alunos',
                        subtitle:
                            'Os alunos podem ser vinculados depois na tela de detalhes da turma.',
                        child: _VincularAlunosSection(
                          theme: theme,
                          model: _model,
                          isCompact: isCompact,
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
                      const SizedBox(height: 32.0),
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
    required this.onBack,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
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
                'Adicionar turma',
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
                'Cadastre uma nova turma para um grupo de alunos ou aulas particulares.',
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
  static const double gap = 14.0;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          left,
          SizedBox(height: gap),
          right,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        SizedBox(width: gap),
        Expanded(child: right),
      ],
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
    required this.onPickData,
  });

  final FlutterFlowTheme theme;
  final AdicionarTurmaModel model;
  final bool isCompact;
  final VoidCallback onPickData;

  @override
  Widget build(BuildContext context) {
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
            child: _DateField(
              theme: theme,
              date: model.datePicked,
              onTap: onPickData,
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
        const SizedBox(height: 16.0),
        _LabeledField(
          theme: theme,
          label: 'Professor responsável',
          child: FutureBuilder<ApiCallResponse>(
            future: SupabaseGroup.listaProfessoresCall.call(
              pIdFranquia: FFAppState().idfranquia,
              token: currentJwtToken,
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
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: theme.alternate, width: 1.0),
                ),
                child: FlutterFlowDropDown<String>(
                  controller: model.dropDownValueController ??=
                      FormFieldController<String>(model.dropDownValue),
                  options: list.map((e) => e.userId).toList(),
                  optionLabels: list.map((e) => e.nome).toList(),
                  onChanged: (val) => model.dropDownValue = val,
                  width: double.infinity,
                  height: 48.0,
                  textStyle: _fieldTextStyle(theme),
                  hintText: 'Selecione um professor',
                  searchHintText: 'Buscar...',
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: theme.secondaryText, size: 22.0),
                  fillColor: theme.secondaryBackground,
                  elevation: 4.0,
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
        ),
      ],
    );
  }
}

class _DateField extends StatefulWidget {
  const _DateField({
    required this.theme,
    required this.date,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  State<_DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<_DateField> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final hasDate = widget.date != null;
    final label =
        hasDate ? dateTimeFormat('dd/MM/yyyy', widget.date) : 'dd/mm/aaaa';
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          height: 48.0,
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: _hovered ? theme.primary : theme.alternate,
              width: _hovered ? 1.4 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  color: theme.secondaryText, size: 18.0),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  label,
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    color: hasDate ? theme.primaryText : theme.secondaryText,
                  ),
                ),
              ),
              Icon(Icons.expand_more_rounded,
                  color: theme.secondaryText, size: 20.0),
            ],
          ),
        ),
      ),
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
// AGENDA SECTION
// ---------------------------------------------------------------------------

class _AgendaSection extends StatelessWidget {
  const _AgendaSection({
    required this.theme,
    required this.model,
    required this.isCompact,
    required this.onInserir,
    required this.onRemover,
  });

  final FlutterFlowTheme theme;
  final AdicionarTurmaModel model;
  final bool isCompact;
  final VoidCallback onInserir;
  final void Function(int index) onRemover;

  @override
  Widget build(BuildContext context) {
    final agendas = FFAppState().AgendasTurma;

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
                controller: model.textController3!,
                focusNode: model.textFieldFocusNode3,
                mask: model.textFieldMask3,
              ),
            ),
            right: _LabeledField(
              theme: theme,
              label: 'Hora término',
              child: _HoraField(
                theme: theme,
                controller: model.textController4!,
                focusNode: model.textFieldFocusNode4,
                mask: model.textFieldMask4,
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
                    controller: model.textController3!,
                    focusNode: model.textFieldFocusNode3,
                    mask: model.textFieldMask3,
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
                    controller: model.textController4!,
                    focusNode: model.textFieldFocusNode4,
                    mask: model.textFieldMask4,
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
  final AdicionarTurmaModel model;

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
        elevation: 4.0,
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
      inputFormatters: [mask, FilteringTextInputFormatter.digitsOnly],
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
  final List<AgendaAulasStruct> agendas;
  final void Function(int index) onRemover;

  @override
  Widget build(BuildContext context) {
    if (agendas.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: theme.secondaryBackground.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: theme.alternate,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined,
                color: theme.secondaryText, size: 18.0),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                'Nenhuma agenda adicionada ainda.',
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
            final item = agendas[index];
            return _AgendaChip(
              theme: theme,
              dia: item.dia,
              inicio: item.horarioInicio,
              fim: item.horarioFinal,
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
    required this.onVincular,
    required this.onDesvincular,
  });

  final FlutterFlowTheme theme;
  final AdicionarTurmaModel model;
  final bool isCompact;
  final VoidCallback onVincular;
  final void Function(ListaAlunosStruct) onDesvincular;

  @override
  Widget build(BuildContext context) {
    final alunos = FFAppState().ListaAlunos;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder<ApiCallResponse>(
          future: SupabaseGroup.listaAlunosCall.call(
            pFranquiaId: FFAppState().idfranquia,
            token: currentJwtToken,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return _DropDownPlaceholder(theme: theme);
            }
            final list = (snapshot.data!.jsonBody
                    .toList()
                    .map<ListaAlunosStruct?>(
                        ListaAlunosStruct.maybeFromMap)
                    .toList() as Iterable<ListaAlunosStruct?>)
                .withoutNulls
                .toList();
            final namesById = <String, String>{
              for (final e in list) e.userId: e.nome,
            };

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isCompact) ...[
                  _LabeledField(
                    theme: theme,
                    label: 'Aluno',
                    child: _AlunoDropDown(
                      theme: theme,
                      model: model,
                      list: list,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  _SecondaryButton(
                    theme: theme,
                    icon: Icons.person_add_alt_1_rounded,
                    label: 'Vincular aluno',
                    onTap: onVincular,
                    stretch: true,
                  ),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _LabeledField(
                          theme: theme,
                          label: 'Aluno',
                          child: _AlunoDropDown(
                            theme: theme,
                            model: model,
                            list: list,
                          ),
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
                  ),
                const SizedBox(height: 18.0),
                _AlunosVinculadosList(
                  theme: theme,
                  alunos: alunos,
                  namesById: namesById,
                  onRemove: onDesvincular,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _AlunoDropDown extends StatelessWidget {
  const _AlunoDropDown({
    required this.theme,
    required this.model,
    required this.list,
  });

  final FlutterFlowTheme theme;
  final AdicionarTurmaModel model;
  final List<ListaAlunosStruct> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: FlutterFlowDropDown<String>(
        controller: model.dropDownAlunoValueController ??=
            FormFieldController<String>(model.dropDownAlunoValue),
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
        elevation: 4.0,
        borderColor: Colors.transparent,
        borderWidth: 0.0,
        borderRadius: 12.0,
        margin: const EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 14.0, 0.0),
        hidesUnderline: true,
        isOverButton: false,
        isSearchable: true,
        isMultiSelect: false,
      ),
    );
  }
}

class _AlunosVinculadosList extends StatelessWidget {
  const _AlunosVinculadosList({
    required this.theme,
    required this.alunos,
    required this.namesById,
    required this.onRemove,
  });

  final FlutterFlowTheme theme;
  final List<ListaAlunosStruct> alunos;
  final Map<String, String> namesById;
  final void Function(ListaAlunosStruct) onRemove;

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
          children: alunos.map((aluno) {
            final nome = namesById[aluno.userId] ?? '—';
            return _AlunoChip(
              theme: theme,
              nome: nome,
              onRemove: () => onRemove(aluno),
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
// SECONDARY BUTTON & SAVE BUTTON
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
            height: 48.0,
            width: widget.stretch ? double.infinity : null,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: _hovered
                  ? theme.primary.withValues(alpha: 0.10)
                  : theme.secondaryBackground,
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
                  color: theme.primary
                      .withValues(alpha: _hovered && !widget.loading ? 0.32 : 0.18),
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
                        'Salvar turma',
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
