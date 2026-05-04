import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'detalhes_professor_model.dart';
export 'detalhes_professor_model.dart';

class DetalhesProfessorWidget extends StatefulWidget {
  const DetalhesProfessorWidget({
    super.key,
    required this.profId,
    required this.metaProfId,
  });

  final String? profId;
  final String? metaProfId;

  static String routeName = 'DetalhesProfessor';
  static String routePath = '/detalhesProfessor';

  @override
  State<DetalhesProfessorWidget> createState() =>
      _DetalhesProfessorWidgetState();
}

class _DetalhesProfessorWidgetState extends State<DetalhesProfessorWidget> {
  late DetalhesProfessorModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _saving = false;
  bool _deleting = false;
  bool _controllersHydrated = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhesProfessorModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textFieldMask3 = MaskTextInputFormatter(mask: '(##) #####-####');

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();
    _model.textFieldMask4 = MaskTextInputFormatter(mask: '###.###.###-##');

    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();
    _model.textFieldMask5 = MaskTextInputFormatter(mask: '##/##/####');

    _model.textController6 ??= TextEditingController();
    _model.textFieldFocusNode6 ??= FocusNode();

    _model.textController7 ??= TextEditingController();
    _model.textFieldFocusNode7 ??= FocusNode();
    _model.textFieldMask7 = MaskTextInputFormatter(mask: '#####-###');

    _model.textController8 ??= TextEditingController();
    _model.textFieldFocusNode8 ??= FocusNode();

    _model.textController9 ??= TextEditingController();
    _model.textFieldFocusNode9 ??= FocusNode();

    _model.textController10 ??= TextEditingController();
    _model.textFieldFocusNode10 ??= FocusNode();

    _model.textController11 ??= TextEditingController();
    _model.textFieldFocusNode11 ??= FocusNode();

    _model.textController12 ??= TextEditingController();
    _model.textFieldFocusNode12 ??= FocusNode();

    _model.textController13 ??= TextEditingController();
    _model.textFieldFocusNode13 ??= FocusNode();

    _model.textController14 ??= TextEditingController();
    _model.textFieldFocusNode14 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FFAppState().AlterarProfessorVisibility = false;
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _hydrateControllers(UsersRow user) {
    if (_controllersHydrated) return;
    _model.textController1!.text = user.nome ?? '';
    _model.textController2!.text = user.email ?? '';
    _model.textController3!.text = user.telefone ?? '';
    _model.textController4!.text = user.cpf ?? '';
    _model.textController5!.text = user.dataNascimento ?? '';
    _model.textController6!.text = user.nacionalidade ?? '';
    _model.textController7!.text = user.cep ?? '';
    _model.textController8!.text = user.pais ?? '';
    _model.textController9!.text = user.endereco ?? '';
    _model.textController10!.text = user.bairro ?? '';
    _model.textController11!.text = user.numero ?? '';
    _model.textController12!.text = user.complemento ?? '';
    _model.textController13!.text = user.cidade ?? '';
    _model.textController14!.text = user.uf ?? '';
    _controllersHydrated = true;
  }

  Future<void> _handleCepLookup() async {
    final cep =
        _model.textController7!.text.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) return;
    final apiCEP = await BuscarCEPCall.call(cep: _model.textController7!.text);
    if (!(apiCEP.succeeded)) return;
    final body = apiCEP.jsonBody;
    safeSetState(() {
      _model.textController8!.text = 'Brasil';
      _model.textController9!.text = BuscarCEPCall.rua(body) ?? '';
      _model.textController10!.text = BuscarCEPCall.bairro(body) ?? '';
      _model.textController13!.text = BuscarCEPCall.cidade(body) ?? '';
      _model.textController14!.text = BuscarCEPCall.uf(body) ?? '';
    });
  }

  Future<void> _pickPhoto() async {
    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      storageFolderPath: 'imagens_perfil',
      allowPhoto: true,
    );
    if (selectedMedia == null ||
        !selectedMedia
            .every((m) => validateFileFormat(m.storagePath, context))) {
      return;
    }
    safeSetState(
        () => _model.isDataUploading_uploadSubsFotoPerfil = true);
    var uploadedLocal = <FFUploadedFile>[];
    var downloadUrls = <String>[];
    try {
      uploadedLocal = selectedMedia
          .map((m) => FFUploadedFile(
                name: m.storagePath.split('/').last,
                bytes: m.bytes,
                height: m.dimensions?.height,
                width: m.dimensions?.width,
                blurHash: m.blurHash,
                originalFilename: m.originalFilename,
              ))
          .toList();
      downloadUrls = await uploadSupabaseStorageFiles(
        bucketName: 'geral',
        selectedFiles: selectedMedia,
      );
    } finally {
      _model.isDataUploading_uploadSubsFotoPerfil = false;
    }
    if (uploadedLocal.length != selectedMedia.length ||
        downloadUrls.length != selectedMedia.length) {
      safeSetState(() {});
      return;
    }
    safeSetState(() {
      _model.uploadedLocalFile_uploadSubsFotoPerfil = uploadedLocal.first;
      _model.uploadedFileUrl_uploadSubsFotoPerfil = downloadUrls.first;
    });
    await UsersTable().update(
      data: {
        'imagem_perfil': _model.uploadedFileUrl_uploadSubsFotoPerfil,
      },
      matchingRows: (rows) => rows.eqOrNull('id', widget.profId),
    );
    if (!mounted) return;
    _model.clearUserCache();
    safeSetState(() {});
  }

  bool _validate() {
    final theme = FlutterFlowTheme.of(context);
    String? errorMsg;
    if (_model.textController1!.text.trim().isEmpty) {
      errorMsg = 'Informe o nome do professor.';
    } else if (_model.textController2!.text.trim().isEmpty) {
      errorMsg = 'Informe o e-mail do professor.';
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
        .hasMatch(_model.textController2!.text.trim())) {
      errorMsg = 'E-mail inválido.';
    }
    if (errorMsg != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(errorMsg, style: const TextStyle(color: Colors.white)),
          backgroundColor: theme.error,
          duration: const Duration(milliseconds: 3500),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_validate()) return;

    final theme = FlutterFlowTheme.of(context);
    safeSetState(() => _saving = true);
    try {
      await UsersTable().update(
        data: {
          'nome': _model.textController1!.text,
          'email': _model.textController2!.text,
          'telefone': _model.textController3!.text,
          'cpf': _model.textController4!.text,
          'data_nascimento': _model.textController5!.text,
          'nacionalidade': _model.textController6!.text,
          'cep': _model.textController7!.text,
          'pais': _model.textController8!.text,
          'endereco': _model.textController9!.text,
          'bairro': _model.textController10!.text,
          'numero': _model.textController11!.text,
          'complemento': _model.textController12!.text,
          'cidade': _model.textController13!.text,
          'uf': _model.textController14!.text,
          if (_model.uploadedFileUrl_uploadSubsFotoPerfil.isNotEmpty)
            'imagem_perfil': _model.uploadedFileUrl_uploadSubsFotoPerfil,
        },
        matchingRows: (rows) => rows.eqOrNull('id', widget.profId),
      );
      if (!mounted) return;
      _model.clearUserCache();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Alterações salvas',
            style: TextStyle(color: theme.primaryBackground),
          ),
          duration: const Duration(milliseconds: 3000),
          backgroundColor: theme.primary,
        ),
      );
    } finally {
      if (mounted) safeSetState(() => _saving = false);
    }
  }

  Future<void> _deleteProfessor() async {
    if (_deleting) return;

    final confirm = await showDialog<bool>(
          context: context,
          builder: (alertDialogContext) {
            return WebViewAware(
              child: AlertDialog(
                title: const Text('Excluir este professor?'),
                content: const Text(
                    'O registro será desativado e o professor perderá acesso ao app.'),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(alertDialogContext, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(alertDialogContext, true),
                    child: const Text('Excluir'),
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
    if (!confirm) return;

    safeSetState(() => _deleting = true);
    try {
      final turmasAtivas = await TurmasTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('professor_responsavel', widget.profId)
            .eqOrNull('deleted_at', null),
      );
      if (turmasAtivas.isNotEmpty) {
        if (!mounted) return;
        final confirmarVinculo = await showDialog<bool>(
              context: context,
              builder: (alertDialogContext) {
                return WebViewAware(
                  child: AlertDialog(
                    title: const Text('Atenção'),
                    content: Text(
                        'Este professor possui ${turmasAtivas.length} turma(s) ativa(s). Ao excluir, ele será desvinculado dessas turmas.'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(alertDialogContext, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(alertDialogContext, true),
                        child: const Text('Confirmar'),
                      ),
                    ],
                  ),
                );
              },
            ) ??
            false;
        if (!confirmarVinculo) return;
        for (final turma in turmasAtivas) {
          await TurmasTable().update(
            data: {'professor_responsavel': null},
            matchingRows: (rows) => rows.eqOrNull('id', turma.id),
          );
        }
      }
      final now = DateTime.now().toUtc().toIso8601String();
      await MetaProfessorTable().update(
        data: {'deleted_at': now},
        matchingRows: (rows) => rows.eqOrNull('user_id', widget.profId),
      );
      await UsersTable().update(
        data: {'deleted_at': now},
        matchingRows: (rows) => rows.eqOrNull('id', widget.profId),
      );
      if (!mounted) return;
      context.goNamed(ListaProfessoresWidget.routeName);
    } finally {
      if (mounted) safeSetState(() => _deleting = false);
    }
  }

  Future<void> _vincularTurma() async {
    if (_model.dropDownTurmasValue == null ||
        _model.dropDownTurmasValue == '0') {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return WebViewAware(
            child: AlertDialog(
              title: const Text('Selecione uma turma'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: const Text('Ok'),
                ),
              ],
            ),
          );
        },
      );
      return;
    }
    await TurmasTable().update(
      data: {'professor_responsavel': widget.profId},
      matchingRows: (rows) =>
          rows.eqOrNull('id', _model.dropDownTurmasValue),
    );
    if (!mounted) return;
    final theme = FlutterFlowTheme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Turma vinculada com sucesso',
          style: TextStyle(color: theme.primaryBackground),
        ),
        duration: const Duration(milliseconds: 3000),
        backgroundColor: theme.primary,
      ),
    );
    safeSetState(() {
      _model.clearListaTurmasCache();
      _model.requestCompleted = false;
      _model.dropDownTurmasValue = null;
      _model.dropDownTurmasValueController?.reset();
    });
    await _model.waitForRequestCompleted();
  }

  Future<void> _desvincularTurma(TurmasRow turma) async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (alertDialogContext) {
            return WebViewAware(
              child: AlertDialog(
                title: const Text('Desvincular essa turma?'),
                content: Text(
                    '${turma.nomeDaTurma ?? 'Turma'} será removida deste professor.'),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(alertDialogContext, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(alertDialogContext, true),
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
    if (!confirm) return;
    await TurmasTable().update(
      data: {'professor_responsavel': null},
      matchingRows: (rows) => rows.eqOrNull('id', turma.id),
    );
    if (!mounted) return;
    safeSetState(() {
      _model.clearListaTurmasCache();
      _model.requestCompleted = false;
    });
    await _model.waitForRequestCompleted();
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
                child: FutureBuilder<List<UsersRow>>(
                  future: _model.user(
                    requestFn: () => UsersTable().querySingleRow(
                      queryFn: (q) => q.eqOrNull('id', widget.profId),
                    ),
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 32.0,
                          height: 32.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(theme.primary),
                          ),
                        ),
                      );
                    }
                    final users = snapshot.data!;
                    final user = users.isNotEmpty ? users.first : null;
                    if (user == null) {
                      return Center(
                        child: Text(
                          'Professor não encontrado.',
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.inter(
                                fontWeight: FontWeight.w500),
                            fontWeight: FontWeight.w500,
                            color: theme.secondaryText,
                          ),
                        ),
                      );
                    }
                    _hydrateControllers(user);
                    final fotoExibida = _model
                            .uploadedFileUrl_uploadSubsFotoPerfil.isNotEmpty
                        ? _model.uploadedFileUrl_uploadSubsFotoPerfil
                        : (user.imagemPerfil ?? '');

                    return SingleChildScrollView(
                      primary: false,
                      padding: EdgeInsets.symmetric(
                        horizontal: hPad,
                        vertical: isCompact ? 20.0 : 28.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Header(
                            isCompact: isCompact,
                            onBack: () => context.safePop(),
                            onDelete: _deleting ? null : _deleteProfessor,
                            deleting: _deleting,
                          ),
                          SizedBox(height: isCompact ? 16.0 : 22.0),
                          _SectionCard(
                            title: 'Dados pessoais',
                            subtitle:
                                'Informações de identificação e contato do professor.',
                            icon: Icons.person_rounded,
                            child: _DadosPessoaisSection(
                              model: _model,
                              fotoUrl: fotoExibida,
                              uploading: _model
                                  .isDataUploading_uploadSubsFotoPerfil,
                              onPickPhoto: _pickPhoto,
                              isCompact: isCompact,
                            ),
                          ),
                          SizedBox(height: isCompact ? 14.0 : 18.0),
                          _SectionCard(
                            title: 'Endereço',
                            subtitle:
                                'O CEP preenche automaticamente os campos de localização.',
                            icon: Icons.location_on_rounded,
                            child: _EnderecoSection(
                              model: _model,
                              onCepChanged: () {
                                EasyDebounce.debounce(
                                  '_detalhes_prof_cep',
                                  const Duration(milliseconds: 600),
                                  _handleCepLookup,
                                );
                              },
                              isCompact: isCompact,
                            ),
                          ),
                          SizedBox(height: isCompact ? 14.0 : 18.0),
                          _SectionCard(
                            title: 'Turmas vinculadas',
                            subtitle:
                                'Turmas onde este professor está como responsável.',
                            icon: Icons.groups_rounded,
                            child: _TurmasSection(
                              model: _model,
                              profId: widget.profId,
                              isCompact: isCompact,
                              onVincular: _vincularTurma,
                              onDesvincular: _desvincularTurma,
                            ),
                          ),
                          SizedBox(height: isCompact ? 22.0 : 28.0),
                          _SaveButton(
                            loading: _saving,
                            onTap: _save,
                          ),
                          const SizedBox(height: 24.0),
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
// HEADER
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.isCompact,
    required this.onBack,
    required this.onDelete,
    required this.deleting,
  });

  final bool isCompact;
  final VoidCallback onBack;
  final VoidCallback? onDelete;
  final bool deleting;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _IconPillButton(
          icon: Icons.arrow_back_rounded,
          onTap: onBack,
        ),
        const SizedBox(width: 14.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Detalhes do professor',
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
              const SizedBox(height: 4.0),
              Text(
                'Edite os dados, vincule turmas e gerencie o cadastro.',
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
        _IconPillButton(
          icon: Icons.delete_outline_rounded,
          onTap: onDelete,
          destructive: true,
          loading: deleting,
        ),
      ],
    );
  }
}

class _IconPillButton extends StatefulWidget {
  const _IconPillButton({
    required this.icon,
    required this.onTap,
    this.destructive = false,
    this.loading = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool destructive;
  final bool loading;

  @override
  State<_IconPillButton> createState() => _IconPillButtonState();
}

class _IconPillButtonState extends State<_IconPillButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final accent = widget.destructive ? theme.error : theme.primary;
    final disabled = widget.onTap == null || widget.loading;
    return MouseRegion(
      cursor:
          disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: disabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            color: _hovered && !disabled
                ? accent.withValues(alpha: 0.10)
                : theme.primaryBackground,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(
              color: _hovered && !disabled ? accent : theme.alternate,
              width: 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: widget.loading
              ? SizedBox(
                  width: 16.0,
                  height: 16.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(accent),
                  ),
                )
              : Icon(
                  widget.icon,
                  size: 20.0,
                  color: _hovered && !disabled
                      ? accent
                      : (widget.destructive
                          ? theme.error
                          : theme.primaryText),
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
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 18.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 22.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                child: Icon(icon, size: 18.0, color: theme.primary),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.titleMedium.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FontWeight.w800,
                        ),
                        fontWeight: FontWeight.w800,
                        fontSize: 16.0,
                        letterSpacing: -0.2,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle,
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
          const SizedBox(height: 18.0),
          child,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LABELED FIELD + INPUT DECORATION
// ---------------------------------------------------------------------------

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
    this.hint,
  });

  final String label;
  final String? hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.labelMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            fontWeight: FontWeight.w600,
            fontSize: 12.5,
            letterSpacing: 0.1,
            color: theme.primaryText,
          ),
        ),
        const SizedBox(height: 6.0),
        child,
        if (hint != null) ...[
          const SizedBox(height: 4.0),
          Text(
            hint!,
            style: theme.bodySmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              fontWeight: FontWeight.w500,
              fontSize: 11.5,
              color: theme.secondaryText,
            ),
          ),
        ],
      ],
    );
  }
}

InputDecoration _inputDecoration(
  BuildContext context, {
  String? hint,
  IconData? prefixIcon,
}) {
  final theme = FlutterFlowTheme.of(context);
  return InputDecoration(
    isDense: true,
    hintText: hint,
    hintStyle: theme.labelMedium.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.w400),
      fontWeight: FontWeight.w400,
      fontSize: 13.5,
      color: theme.secondaryText,
    ),
    prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, size: 18.0, color: theme.secondaryText)
        : null,
    filled: true,
    fillColor: theme.secondaryBackground,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.alternate, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.alternate, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.error, width: 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.error, width: 1.5),
    ),
  );
}

TextStyle _fieldTextStyle(BuildContext context) {
  final theme = FlutterFlowTheme.of(context);
  return theme.bodyMedium.override(
    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: theme.primaryText,
  );
}

class _ResponsiveTwoColumns extends StatelessWidget {
  const _ResponsiveTwoColumns({
    required this.left,
    required this.right,
    required this.isCompact,
  });

  final Widget left;
  final Widget right;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          left,
          const SizedBox(height: 14.0),
          right,
        ],
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

// ---------------------------------------------------------------------------
// DADOS PESSOAIS
// ---------------------------------------------------------------------------

class _DadosPessoaisSection extends StatelessWidget {
  const _DadosPessoaisSection({
    required this.model,
    required this.fotoUrl,
    required this.uploading,
    required this.onPickPhoto,
    required this.isCompact,
  });

  final DetalhesProfessorModel model;
  final String fotoUrl;
  final bool uploading;
  final Future<void> Function() onPickPhoto;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PhotoChip(
          uploading: uploading,
          imageUrl: fotoUrl,
          onTap: onPickPhoto,
        ),
        const SizedBox(height: 18.0),
        _LabeledField(
          label: 'Nome completo',
          child: TextFormField(
            controller: model.textController1,
            focusNode: model.textFieldFocusNode1,
            textCapitalization: TextCapitalization.words,
            style: _fieldTextStyle(context),
            decoration: _inputDecoration(
              context,
              hint: 'Ex.: João Carlos da Silva',
              prefixIcon: Icons.person_outline_rounded,
            ),
          ),
        ),
        const SizedBox(height: 14.0),
        _ResponsiveTwoColumns(
          isCompact: isCompact,
          left: _LabeledField(
            label: 'E-mail',
            child: TextFormField(
              controller: model.textController2,
              focusNode: model.textFieldFocusNode2,
              keyboardType: TextInputType.emailAddress,
              style: _fieldTextStyle(context),
              decoration: _inputDecoration(
                context,
                hint: 'professor@exemplo.com',
                prefixIcon: Icons.alternate_email_rounded,
              ),
            ),
          ),
          right: _LabeledField(
            label: 'Telefone',
            child: TextFormField(
              controller: model.textController3,
              focusNode: model.textFieldFocusNode3,
              keyboardType: TextInputType.phone,
              inputFormatters: [model.textFieldMask3],
              style: _fieldTextStyle(context),
              decoration: _inputDecoration(
                context,
                hint: '(00) 00000-0000',
                prefixIcon: Icons.phone_rounded,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14.0),
        _ResponsiveTwoColumns(
          isCompact: isCompact,
          left: _LabeledField(
            label: 'CPF',
            child: TextFormField(
              controller: model.textController4,
              focusNode: model.textFieldFocusNode4,
              keyboardType: TextInputType.number,
              inputFormatters: [model.textFieldMask4],
              style: _fieldTextStyle(context),
              decoration: _inputDecoration(
                context,
                hint: '000.000.000-00',
                prefixIcon: Icons.badge_outlined,
              ),
            ),
          ),
          right: _LabeledField(
            label: 'Data de nascimento',
            child: TextFormField(
              controller: model.textController5,
              focusNode: model.textFieldFocusNode5,
              keyboardType: TextInputType.datetime,
              inputFormatters: [model.textFieldMask5],
              style: _fieldTextStyle(context),
              decoration: _inputDecoration(
                context,
                hint: 'dd/mm/aaaa',
                prefixIcon: Icons.cake_outlined,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14.0),
        _LabeledField(
          label: 'Nacionalidade',
          child: TextFormField(
            controller: model.textController6,
            focusNode: model.textFieldFocusNode6,
            style: _fieldTextStyle(context),
            decoration: _inputDecoration(
              context,
              hint: 'Brasileiro',
              prefixIcon: Icons.flag_outlined,
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoChip extends StatefulWidget {
  const _PhotoChip({
    required this.uploading,
    required this.imageUrl,
    required this.onTap,
  });

  final bool uploading;
  final String imageUrl;
  final Future<void> Function() onTap;

  @override
  State<_PhotoChip> createState() => _PhotoChipState();
}

class _PhotoChipState extends State<_PhotoChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasImage = widget.imageUrl.isNotEmpty;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.uploading ? null : () => widget.onTap(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: _hovered
                ? theme.primary.withValues(alpha: 0.06)
                : theme.secondaryBackground,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(
              color: _hovered ? theme.primary : theme.alternate,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56.0,
                height: 56.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primary.withValues(alpha: 0.10),
                  image: hasImage
                      ? DecorationImage(
                          image: NetworkImage(widget.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                  border: Border.all(color: theme.alternate, width: 1.0),
                ),
                alignment: Alignment.center,
                child: hasImage
                    ? null
                    : Icon(Icons.person_rounded,
                        size: 26.0, color: theme.primary),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasImage ? 'Foto de perfil' : 'Adicionar foto de perfil',
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      hasImage
                          ? 'Toque para substituir a imagem'
                          : 'Opcional · PNG, JPG até 5MB',
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
              const SizedBox(width: 8.0),
              if (widget.uploading)
                SizedBox(
                  width: 18.0,
                  height: 18.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(theme.primary),
                  ),
                )
              else
                Icon(
                  hasImage ? Icons.refresh_rounded : Icons.add_rounded,
                  size: 18.0,
                  color: theme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ENDEREÇO
// ---------------------------------------------------------------------------

class _EnderecoSection extends StatelessWidget {
  const _EnderecoSection({
    required this.model,
    required this.onCepChanged,
    required this.isCompact,
  });

  final DetalhesProfessorModel model;
  final VoidCallback onCepChanged;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ResponsiveTwoColumns(
          isCompact: isCompact,
          left: _LabeledField(
            label: 'CEP',
            hint: 'O endereço será preenchido automaticamente.',
            child: TextFormField(
              controller: model.textController7,
              focusNode: model.textFieldFocusNode7,
              keyboardType: TextInputType.number,
              inputFormatters: [model.textFieldMask7],
              onChanged: (_) => onCepChanged(),
              style: _fieldTextStyle(context),
              decoration: _inputDecoration(
                context,
                hint: '00000-000',
                prefixIcon: Icons.markunread_mailbox_outlined,
              ),
            ),
          ),
          right: _LabeledField(
            label: 'País',
            child: TextFormField(
              controller: model.textController8,
              focusNode: model.textFieldFocusNode8,
              style: _fieldTextStyle(context),
              decoration: _inputDecoration(
                context,
                hint: 'Brasil',
                prefixIcon: Icons.public_rounded,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14.0),
        _LabeledField(
          label: 'Rua',
          child: TextFormField(
            controller: model.textController9,
            focusNode: model.textFieldFocusNode9,
            style: _fieldTextStyle(context),
            decoration: _inputDecoration(
              context,
              hint: 'Nome da rua',
              prefixIcon: Icons.location_on_outlined,
            ),
          ),
        ),
        const SizedBox(height: 14.0),
        _ResponsiveTwoColumns(
          isCompact: isCompact,
          left: _LabeledField(
            label: 'Bairro',
            child: TextFormField(
              controller: model.textController10,
              focusNode: model.textFieldFocusNode10,
              style: _fieldTextStyle(context),
              decoration: _inputDecoration(context, hint: 'Bairro'),
            ),
          ),
          right: _LabeledField(
            label: 'Número',
            child: TextFormField(
              controller: model.textController11,
              focusNode: model.textFieldFocusNode11,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: _fieldTextStyle(context),
              decoration: _inputDecoration(context, hint: '123'),
            ),
          ),
        ),
        const SizedBox(height: 14.0),
        _LabeledField(
          label: 'Complemento',
          child: TextFormField(
            controller: model.textController12,
            focusNode: model.textFieldFocusNode12,
            style: _fieldTextStyle(context),
            decoration: _inputDecoration(
              context,
              hint: 'Apartamento, bloco, referência (opcional)',
            ),
          ),
        ),
        const SizedBox(height: 14.0),
        _ResponsiveTwoColumns(
          isCompact: isCompact,
          left: _LabeledField(
            label: 'Cidade',
            child: TextFormField(
              controller: model.textController13,
              focusNode: model.textFieldFocusNode13,
              style: _fieldTextStyle(context),
              decoration: _inputDecoration(context, hint: 'Cidade'),
            ),
          ),
          right: _LabeledField(
            label: 'UF',
            child: TextFormField(
              controller: model.textController14,
              focusNode: model.textFieldFocusNode14,
              textCapitalization: TextCapitalization.characters,
              style: _fieldTextStyle(context),
              decoration: _inputDecoration(context, hint: 'SP'),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// TURMAS VINCULADAS
// ---------------------------------------------------------------------------

class _TurmasSection extends StatelessWidget {
  const _TurmasSection({
    required this.model,
    required this.profId,
    required this.isCompact,
    required this.onVincular,
    required this.onDesvincular,
  });

  final DetalhesProfessorModel model;
  final String? profId;
  final bool isCompact;
  final Future<void> Function() onVincular;
  final Future<void> Function(TurmasRow turma) onDesvincular;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder<List<TurmasRow>>(
          future: model.turmas(
            requestFn: () => TurmasTable().queryRows(
              queryFn: (q) => q.eqOrNull(
                'id_franquia',
                FFAppState().idfranquia,
              ),
            ),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: 48.0,
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: theme.alternate, width: 1.0),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation(theme.primary),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      'Carregando turmas...',
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
            final turmas = snapshot.data!;
            return _ResponsiveTwoColumns(
              isCompact: isCompact,
              left: _LabeledField(
                label: 'Adicionar nova turma',
                child: FlutterFlowDropDown<String>(
                  controller: model.dropDownTurmasValueController ??=
                      FormFieldController<String>(
                          model.dropDownTurmasValue ??= '0'),
                  options:
                      List<String>.from(turmas.map((e) => e.id).toList()),
                  optionLabels: turmas
                      .map((e) => e.nomeDaTurma)
                      .withoutNulls
                      .toList(),
                  onChanged: (val) => model.dropDownTurmasValue = val,
                  width: double.infinity,
                  height: 48.0,
                  textStyle: _fieldTextStyle(context),
                  hintText: 'Selecione uma turma',
                  searchHintText: 'Buscar turma',
                  searchHintTextStyle: theme.labelMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                    color: theme.secondaryText,
                  ),
                  searchTextStyle: _fieldTextStyle(context),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: theme.secondaryText,
                    size: 22.0,
                  ),
                  fillColor: theme.secondaryBackground,
                  elevation: 2.0,
                  borderColor: theme.alternate,
                  borderWidth: 1.0,
                  borderRadius: 12.0,
                  margin: const EdgeInsetsDirectional.fromSTEB(
                      14.0, 0.0, 12.0, 0.0),
                  hidesUnderline: true,
                  isOverButton: false,
                  isSearchable: true,
                  isMultiSelect: false,
                ),
              ),
              right: _LabeledField(
                label: ' ',
                child: _SecondaryButton(
                  icon: Icons.add_link_rounded,
                  label: 'Vincular turma',
                  onTap: () => onVincular(),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 18.0),
        FutureBuilder<List<TurmasRow>>(
          future: model
              .listaTurmas(
            requestFn: () => TurmasTable().queryRows(
              queryFn: (q) => q.eqOrNull('professor_responsavel', profId),
            ),
          )
              .then((result) {
            model.requestCompleted = true;
            return result;
          }),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 14.0,
                      height: 14.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation(theme.primary),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      'Carregando turmas vinculadas...',
                      style: theme.bodySmall.override(
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
            final turmasVinculadas = snapshot.data!;
            return _LinkedTurmasList(
              turmas: turmasVinculadas,
              onRemove: onDesvincular,
            );
          },
        ),
      ],
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
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
            height: 48.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: _hovered
                  ? theme.primary.withValues(alpha: 0.10)
                  : theme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: theme.primary, width: 1.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: theme.primary, size: 18.0),
                const SizedBox(width: 8.0),
                Text(
                  widget.label,
                  style: theme.titleSmall.override(
                    font: GoogleFonts.interTight(
                      fontWeight: FontWeight.w700,
                    ),
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    letterSpacing: 0.2,
                    color: theme.primary,
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

class _LinkedTurmasList extends StatelessWidget {
  const _LinkedTurmasList({
    required this.turmas,
    required this.onRemove,
  });

  final List<TurmasRow> turmas;
  final Future<void> Function(TurmasRow turma) onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (turmas.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: theme.alternate, width: 1.0),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded,
                color: theme.secondaryText, size: 18.0),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                'Nenhuma turma vinculada. Use o seletor acima para adicionar.',
                style: theme.bodySmall.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  fontWeight: FontWeight.w500,
                  fontSize: 12.5,
                  color: theme.secondaryText,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 2.0),
          child: Text(
            '${turmas.length} ${turmas.length == 1 ? 'turma vinculada' : 'turmas vinculadas'}',
            style: theme.labelMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
              letterSpacing: 0.1,
              color: theme.primaryText,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(turmas.length, (idx) {
            return _LinkedTurmaChip(
              turma: turmas[idx],
              onRemove: () => onRemove(turmas[idx]),
            );
          }),
        ),
      ],
    );
  }
}

class _LinkedTurmaChip extends StatefulWidget {
  const _LinkedTurmaChip({
    required this.turma,
    required this.onRemove,
  });

  final TurmasRow turma;
  final VoidCallback onRemove;

  @override
  State<_LinkedTurmaChip> createState() => _LinkedTurmaChipState();
}

class _LinkedTurmaChipState extends State<_LinkedTurmaChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 8.0),
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: _hovered ? 0.16 : 0.10),
          borderRadius: BorderRadius.circular(999.0),
          border: Border.all(
            color: theme.primary.withValues(alpha: 0.30),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.groups_rounded, size: 14.0, color: theme.primary),
            const SizedBox(width: 6.0),
            Text(
              widget.turma.nomeDaTurma ?? 'Turma',
              style: theme.titleSmall.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                color: theme.primary,
              ),
            ),
            const SizedBox(width: 6.0),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  width: 22.0,
                  height: 22.0,
                  decoration: BoxDecoration(
                    color: theme.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.close_rounded,
                    size: 12.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SAVE BUTTON
// ---------------------------------------------------------------------------

class _SaveButton extends StatefulWidget {
  const _SaveButton({required this.loading, required this.onTap});

  final bool loading;
  final Future<void> Function() onTap;

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final disabled = widget.loading;
    final scale = _pressed ? 0.98 : 1.0;
    return MouseRegion(
      cursor:
          disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
        onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: disabled ? null : () => widget.onTap(),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: 52.0,
            decoration: BoxDecoration(
              color: disabled
                  ? theme.primary.withValues(alpha: 0.55)
                  : theme.primary,
              borderRadius: BorderRadius.circular(14.0),
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withValues(
                    alpha: _hovered && !disabled ? 0.30 : 0.18,
                  ),
                  blurRadius: _hovered && !disabled ? 22.0 : 14.0,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.save_rounded,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        'Salvar alterações',
                        style: theme.titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700,
                          ),
                          fontWeight: FontWeight.w700,
                          fontSize: 15.0,
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
