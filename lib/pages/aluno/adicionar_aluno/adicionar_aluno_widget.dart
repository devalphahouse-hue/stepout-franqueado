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
import 'adicionar_aluno_model.dart';
export 'adicionar_aluno_model.dart';

class AdicionarAlunoWidget extends StatefulWidget {
  const AdicionarAlunoWidget({super.key});

  static String routeName = 'AdicionarAluno';
  static String routePath = '/adicionarAluno';

  @override
  State<AdicionarAlunoWidget> createState() => _AdicionarAlunoWidgetState();
}

class _AdicionarAlunoWidgetState extends State<AdicionarAlunoWidget> {
  late AdicionarAlunoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdicionarAlunoModel());

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

    _model.txtPaisTextController ??= TextEditingController();
    _model.txtPaisFocusNode ??= FocusNode();

    _model.txtRuaTextController ??= TextEditingController();
    _model.txtRuaFocusNode ??= FocusNode();

    _model.textBairroTextController ??= TextEditingController();
    _model.textBairroFocusNode ??= FocusNode();

    _model.textController11 ??= TextEditingController();
    _model.textFieldFocusNode8 ??= FocusNode();

    _model.textController12 ??= TextEditingController();
    _model.textFieldFocusNode9 ??= FocusNode();

    _model.textCidadeTextController ??= TextEditingController();
    _model.textCidadeFocusNode ??= FocusNode();

    _model.ufTextController ??= TextEditingController();
    _model.ufFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      safeSetState(() {
        _model.textController6?.text = 'Brasileiro';
      });
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleCepLookup() async {
    final cep = _model.textController7.text.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) return;
    _model.apiCEP = await BuscarCEPCall.call(cep: _model.textController7.text);
    if (!(_model.apiCEP?.succeeded ?? false)) return;
    final body = _model.apiCEP?.jsonBody ?? '';
    safeSetState(() {
      _model.txtPaisTextController?.text = 'Brasil';
      _model.txtRuaTextController?.text = BuscarCEPCall.rua(body) ?? '';
      _model.textBairroTextController?.text = BuscarCEPCall.bairro(body) ?? '';
      _model.textCidadeTextController?.text = BuscarCEPCall.cidade(body) ?? '';
      _model.ufTextController?.text = BuscarCEPCall.uf(body) ?? '';
    });
  }

  Future<void> _pickPhoto() async {
    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      storageFolderPath: 'imagens_perfil',
      allowPhoto: true,
    );
    if (selectedMedia == null ||
        !selectedMedia.every(
            (m) => validateFileFormat(m.storagePath, context))) {
      return;
    }
    safeSetState(() =>
        _model.isDataUploading_uploadFotoPerfilAlunio = true);
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
      _model.isDataUploading_uploadFotoPerfilAlunio = false;
    }
    if (uploadedLocal.length == selectedMedia.length &&
        downloadUrls.length == selectedMedia.length) {
      safeSetState(() {
        _model.uploadedLocalFile_uploadFotoPerfilAlunio = uploadedLocal.first;
        _model.uploadedFileUrl_uploadFotoPerfilAlunio = downloadUrls.first;
      });
    } else {
      safeSetState(() {});
    }
  }

  bool _validate() {
    final theme = FlutterFlowTheme.of(context);
    String? errorMsg;
    if (_model.textController1.text.trim().isEmpty) {
      errorMsg = 'Informe o nome do aluno.';
    } else if (_model.textController2.text.trim().isEmpty) {
      errorMsg = 'Informe o e-mail do aluno.';
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
        .hasMatch(_model.textController2.text.trim())) {
      errorMsg = 'E-mail inválido.';
    }
    if (errorMsg != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMsg,
            style: const TextStyle(color: Colors.white),
          ),
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
      _model.criarAluno = await SupabaseGroup.signupCall.call(
        email: _model.textController2.text,
      );

      if (!(_model.criarAluno?.succeeded ?? false)) {
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return WebViewAware(
              child: AlertDialog(
                title: const Text('Erro ao criar conta de aluno'),
                content:
                    Text((_model.criarAluno?.jsonBody ?? '').toString()),
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

      _model.criarUser = await UsersTable().insert({
        'nome': _model.textController1.text,
        'email': _model.textController2.text,
        'role': 'aluno',
        'telefone': _model.textController3.text,
        'cpf': _model.textController4.text,
        'data_nascimento': _model.textController5.text,
        'nacionalidade': _model.textController6.text,
        'cep': _model.textController7.text,
        'pais': _model.txtPaisTextController.text,
        'endereco': _model.txtRuaTextController.text,
        'bairro': _model.textBairroTextController.text,
        'numero': _model.textController11.text,
        'complemento': _model.textController12.text,
        'cidade': _model.textCidadeTextController.text,
        'uf': _model.ufTextController.text,
        'imagem_perfil': _model.uploadedFileUrl_uploadFotoPerfilAlunio,
        'id': SupabaseGroup.signupCall.idUserCriado(
          (_model.criarAluno?.jsonBody ?? ''),
        ),
        'id_franquia': FFAppState().idfranquia,
      });

      _model.criarMetaUser = await MetaAlunosTable().insert({
        'user_id': _model.criarUser?.id,
        'franquia_id': FFAppState().idfranquia,
        'turma': _model.dropDownValue == '0' ? null : _model.dropDownValue,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Aluno adicionado com sucesso',
            style: TextStyle(color: theme.primaryBackground),
          ),
          duration: const Duration(milliseconds: 3500),
          backgroundColor: theme.primary,
        ),
      );

      context.pushNamed(
        DetalhesAlunoWidget.routeName,
        queryParameters: {
          'idaluno': serializeParam(
            _model.criarUser?.id,
            ParamType.String,
          ),
        }.withoutNulls,
      );
    } finally {
      if (mounted) safeSetState(() => _saving = false);
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
                child: const SidebarWidget(route: 'Aluno'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  primary: false,
                  padding: EdgeInsets.fromLTRB(
                    hPad,
                    isCompact ? 20.0 : 28.0,
                    hPad,
                    (isCompact ? 20.0 : 28.0) + 280.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(
                        isCompact: isCompact,
                        onBack: () => context.safePop(),
                      ),
                      SizedBox(height: isCompact ? 16.0 : 22.0),
                      _SectionCard(
                        title: 'Dados pessoais',
                        subtitle:
                            'Informações de identificação e contato do aluno.',
                        icon: Icons.person_rounded,
                        child: _DadosPessoaisSection(
                          model: _model,
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
                              '_model.textController7',
                              const Duration(milliseconds: 600),
                              _handleCepLookup,
                            );
                          },
                          isCompact: isCompact,
                        ),
                      ),
                      SizedBox(height: isCompact ? 14.0 : 18.0),
                      _SectionCard(
                        title: 'Turma',
                        subtitle:
                            'Vincule o aluno a uma turma agora ou faça depois pelo perfil.',
                        icon: Icons.groups_rounded,
                        child: _TurmaSection(model: _model),
                      ),
                      SizedBox(height: isCompact ? 22.0 : 28.0),
                      _SaveButton(
                        loading: _saving,
                        onTap: _save,
                      ),
                      const SizedBox(height: 24.0),
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
  const _Header({required this.isCompact, required this.onBack});

  final bool isCompact;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _BackButton(onTap: onBack),
        const SizedBox(width: 14.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Adicionar aluno',
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
                'Cadastre um novo aluno na sua franquia.',
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

class _BackButton extends StatefulWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            color: _hovered
                ? theme.primary.withValues(alpha: 0.10)
                : theme.primaryBackground,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(
              color: _hovered ? theme.primary : theme.alternate,
              width: 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 20.0,
            color: _hovered ? theme.primary : theme.primaryText,
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
// LABELED FIELD
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

// ---------------------------------------------------------------------------
// DADOS PESSOAIS
// ---------------------------------------------------------------------------

class _DadosPessoaisSection extends StatelessWidget {
  const _DadosPessoaisSection({
    required this.model,
    required this.onPickPhoto,
    required this.isCompact,
  });

  final AdicionarAlunoModel model;
  final Future<void> Function() onPickPhoto;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PhotoChip(
          uploading: model.isDataUploading_uploadFotoPerfilAlunio,
          imageUrl: model.uploadedFileUrl_uploadFotoPerfilAlunio,
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
              hint: 'Ex.: Maria Eduarda Silva',
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
                hint: 'aluno@exemplo.com',
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
                    : Icon(
                        Icons.person_rounded,
                        size: 26.0,
                        color: theme.primary,
                      ),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasImage ? 'Foto carregada' : 'Adicionar foto de perfil',
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

  final AdicionarAlunoModel model;
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
              controller: model.txtPaisTextController,
              focusNode: model.txtPaisFocusNode,
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
            controller: model.txtRuaTextController,
            focusNode: model.txtRuaFocusNode,
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
              controller: model.textBairroTextController,
              focusNode: model.textBairroFocusNode,
              style: _fieldTextStyle(context),
              decoration: _inputDecoration(context, hint: 'Bairro'),
            ),
          ),
          right: _LabeledField(
            label: 'Número',
            child: TextFormField(
              controller: model.textController11,
              focusNode: model.textFieldFocusNode8,
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
            focusNode: model.textFieldFocusNode9,
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
              controller: model.textCidadeTextController,
              focusNode: model.textCidadeFocusNode,
              style: _fieldTextStyle(context),
              decoration: _inputDecoration(context, hint: 'Cidade'),
            ),
          ),
          right: _LabeledField(
            label: 'UF',
            child: TextFormField(
              controller: model.ufTextController,
              focusNode: model.ufFocusNode,
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
// TURMA
// ---------------------------------------------------------------------------

class _TurmaSection extends StatelessWidget {
  const _TurmaSection({required this.model});

  final AdicionarAlunoModel model;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return _LabeledField(
      label: 'Turma',
      hint: 'Você pode trocar a turma depois pelo perfil do aluno.',
      child: FutureBuilder<List<TurmasRow>>(
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
          return FlutterFlowDropDown<String>(
            controller: model.dropDownValueController ??=
                FormFieldController<String>(model.dropDownValue ??= '0'),
            options: List<String>.from(turmas.map((e) => e.id).toList()),
            optionLabels:
                turmas.map((e) => e.nomeDaTurma).withoutNulls.toList(),
            onChanged: (val) => model.dropDownValue = val,
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
            margin: const EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 12.0, 0.0),
            hidesUnderline: true,
            isOverButton: false,
            isSearchable: true,
            isMultiSelect: false,
          );
        },
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
      cursor: disabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
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
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        'Salvar aluno',
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
