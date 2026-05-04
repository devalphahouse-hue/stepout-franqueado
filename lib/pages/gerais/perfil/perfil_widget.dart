import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'perfil_model.dart';
export 'perfil_model.dart';

class PerfilWidget extends StatefulWidget {
  const PerfilWidget({super.key});

  static String routeName = 'Perfil';
  static String routePath = '/perfil';

  @override
  State<PerfilWidget> createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends State<PerfilWidget> {
  late PerfilModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _saving = false;
  bool _loadingCep = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilModel());

    _model.textFieldNomeFocusNode ??= FocusNode();
    _model.textFieldEmailFocusNode ??= FocusNode();
    _model.textFieldTelefoneFocusNode ??= FocusNode();
    _model.textFieldTelefoneMask =
        MaskTextInputFormatter(mask: '(##) #####-####');
    _model.textFieldCPFFocusNode ??= FocusNode();
    _model.textFieldCPFMask = MaskTextInputFormatter(mask: '###.###.###-##');
    _model.textFieldDNascFocusNode ??= FocusNode();
    _model.textFieldDNascMask = MaskTextInputFormatter(mask: '##/##/####');
    _model.textFieldNocionFocusNode ??= FocusNode();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldMask = MaskTextInputFormatter(mask: '#####-###');
    _model.textFieldPaisFocusNode ??= FocusNode();
    _model.textFieldEnderecoFocusNode ??= FocusNode();
    _model.textFieldBairroFocusNode ??= FocusNode();
    _model.textFieldNumeroFocusNode ??= FocusNode();
    _model.textFieldCompleFocusNode ??= FocusNode();
    _model.textFieldCidadeFocusNode ??= FocusNode();
    _model.textFieldUFFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await UsersTable().update(
        data: {
          'nome': _model.textFieldNomeTextController.text,
          'email': _model.textFieldEmailTextController.text,
          'telefone': _model.textFieldTelefoneTextController.text,
          'cpf': _model.textFieldCPFTextController.text,
          'data_nascimento': _model.textFieldDNascTextController.text,
          'nacionalidade': _model.textFieldNocionTextController.text,
          'cep': _model.textController7.text,
          'pais': _model.textFieldPaisTextController.text,
          'endereco': _model.textFieldEnderecoTextController.text,
          'bairro': _model.textFieldBairroTextController.text,
          'numero': _model.textFieldNumeroTextController.text,
          'complemento': _model.textFieldCompleTextController.text,
          'cidade': _model.textFieldCidadeTextController.text,
          'uf': _model.textFieldUFTextController.text,
          if (_model.uploadedFileUrl_uploadSubsFotoPerfilFranquia.isNotEmpty)
            'imagem_perfil': _model.uploadedFileUrl_uploadSubsFotoPerfilFranquia,
        },
        matchingRows: (rows) => rows.eqOrNull('id', currentUserUid),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Perfil atualizado com sucesso!',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: FlutterFlowTheme.of(context).success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao salvar: $e',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
    safeSetState(() =>
        _model.isDataUploading_uploadSubsFotoPerfilFranquia = true);

    var selectedUploadedFiles = <FFUploadedFile>[];
    var downloadUrls = <String>[];
    try {
      selectedUploadedFiles = selectedMedia
          .map(
            (m) => FFUploadedFile(
              name: m.storagePath.split('/').last,
              bytes: m.bytes,
              height: m.dimensions?.height,
              width: m.dimensions?.width,
              blurHash: m.blurHash,
              originalFilename: m.originalFilename,
            ),
          )
          .toList();

      downloadUrls = await uploadSupabaseStorageFiles(
        bucketName: 'geral',
        selectedFiles: selectedMedia,
      );
    } finally {
      _model.isDataUploading_uploadSubsFotoPerfilFranquia = false;
    }

    if (selectedUploadedFiles.length == selectedMedia.length &&
        downloadUrls.length == selectedMedia.length) {
      safeSetState(() {
        _model.uploadedLocalFile_uploadSubsFotoPerfilFranquia =
            selectedUploadedFiles.first;
        _model.uploadedFileUrl_uploadSubsFotoPerfilFranquia =
            downloadUrls.first;
      });
    } else {
      safeSetState(() {});
    }
  }

  void _onCepChanged() {
    EasyDebounce.debounce(
      'perfil_cep',
      const Duration(milliseconds: 800),
      () async {
        final raw = _model.textController7.text.replaceAll(RegExp(r'\D'), '');
        if (raw.length != 8) return;
        if (!mounted) return;
        setState(() => _loadingCep = true);
        try {
          _model.resultCEP =
              await BuscarCEPCall.call(cep: _model.textController7.text);
          if ((_model.resultCEP?.succeeded ?? false)) {
            final body = _model.resultCEP?.jsonBody ?? '';
            safeSetState(() {
              _model.textFieldPaisTextController?.text = 'Brasil';
              _model.textFieldEnderecoTextController?.text =
                  BuscarCEPCall.rua(body) ?? '';
              _model.textFieldBairroTextController?.text =
                  BuscarCEPCall.bairro(body) ?? '';
              _model.textFieldCidadeTextController?.text =
                  BuscarCEPCall.cidade(body) ?? '';
              _model.textFieldUFTextController?.text =
                  BuscarCEPCall.uf(body) ?? '';
            });
          } else {
            if (!mounted) return;
            await showDialog(
              context: context,
              builder: (ctx) => WebViewAware(
                child: AlertDialog(
                  content: const Text('Não foi possível buscar este CEP.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Ok'),
                    ),
                  ],
                ),
              ),
            );
          }
        } finally {
          if (mounted) setState(() => _loadingCep = false);
        }
      },
    );
  }

  double _padH(double w) {
    if (w < 720) return 12.0;
    if (w < 1080) return 24.0;
    return 48.0;
  }

  String _applyMask(MaskTextInputFormatter formatter, String? raw) {
    if (raw == null || raw.isEmpty) return '';
    formatter.clear();
    return formatter
        .formatEditUpdate(
          const TextEditingValue(text: ''),
          TextEditingValue(
            text: raw,
            selection: TextSelection.collapsed(offset: raw.length),
          ),
        )
        .text;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 720;
    final isTablet = width < 1080;
    final padH = _padH(width);

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
                child: SidebarWidget(route: 'Perfil'),
              ),
              Expanded(
                child: FutureBuilder<List<UsersRow>>(
                  future: UsersTable().querySingleRow(
                    queryFn: (q) => q.eqOrNull('id', currentUserUid),
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 42,
                          height: 42,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.primary),
                          ),
                        ),
                      );
                    }
                    final user = snapshot.data!.isNotEmpty
                        ? snapshot.data!.first
                        : null;

                    return SingleChildScrollView(
                      primary: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(padH,
                            isMobile ? 16 : 28, padH, isMobile ? 24 : 40),
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeader(theme, isMobile),
                              const SizedBox(height: 20),
                              _buildPersonalSection(
                                  theme, isMobile, isTablet, user),
                              const SizedBox(height: 20),
                              _buildAddressSection(
                                  theme, isMobile, isTablet, user),
                              const SizedBox(height: 24),
                              _buildSaveButton(theme),
                            ],
                          ),
                        ),
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

  Widget _buildHeader(FlutterFlowTheme theme, bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: theme.primary.withOpacity(0.30)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_circle_rounded,
                  size: 14, color: theme.primary),
              const SizedBox(width: 6),
              Text(
                'Conta',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                  color: theme.primary,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Meu perfil',
          style: GoogleFonts.interTight(
            fontWeight: FontWeight.w800,
            fontSize: isMobile ? 24 : 30,
            color: theme.primaryText,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Mantenha seus dados pessoais e endereço sempre atualizados.',
          style: GoogleFonts.inter(
            fontSize: 13.5,
            color: theme.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalSection(
      FlutterFlowTheme theme, bool isMobile, bool isTablet, UsersRow? user) {
    final formColumn = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LabeledField(
          label: 'Nome',
          theme: theme,
          child: _buildTextField(
            controller: _model.textFieldNomeTextController ??=
                TextEditingController(text: user?.nome),
            focusNode: _model.textFieldNomeFocusNode!,
            hint: 'Seu nome completo',
            theme: theme,
          ),
        ),
        const SizedBox(height: 14),
        _LabeledField(
          label: 'E-mail',
          theme: theme,
          child: _buildTextField(
            controller: _model.textFieldEmailTextController ??=
                TextEditingController(text: user?.email),
            focusNode: _model.textFieldEmailFocusNode!,
            hint: 'seu@email.com',
            keyboardType: TextInputType.emailAddress,
            theme: theme,
          ),
        ),
        const SizedBox(height: 14),
        if (isMobile) ...[
          _LabeledField(
            label: 'Telefone',
            theme: theme,
            child: _buildTextField(
              controller: _model.textFieldTelefoneTextController ??=
                  TextEditingController(
                      text: _applyMask(
                          _model.textFieldTelefoneMask, user?.telefone)),
              focusNode: _model.textFieldTelefoneFocusNode!,
              hint: '(00) 00000-0000',
              theme: theme,
              keyboardType: TextInputType.phone,
              formatters: [_model.textFieldTelefoneMask],
            ),
          ),
          const SizedBox(height: 14),
          _LabeledField(
            label: 'CPF',
            theme: theme,
            child: _buildTextField(
              controller: _model.textFieldCPFTextController ??=
                  TextEditingController(
                      text:
                          _applyMask(_model.textFieldCPFMask, user?.cpf)),
              focusNode: _model.textFieldCPFFocusNode!,
              hint: '000.000.000-00',
              theme: theme,
              keyboardType: TextInputType.number,
              formatters: [_model.textFieldCPFMask],
            ),
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Telefone',
                  theme: theme,
                  child: _buildTextField(
                    controller: _model.textFieldTelefoneTextController ??=
                        TextEditingController(
                            text: _applyMask(_model.textFieldTelefoneMask,
                                user?.telefone)),
                    focusNode: _model.textFieldTelefoneFocusNode!,
                    hint: '(00) 00000-0000',
                    theme: theme,
                    keyboardType: TextInputType.phone,
                    formatters: [_model.textFieldTelefoneMask],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'CPF',
                  theme: theme,
                  child: _buildTextField(
                    controller: _model.textFieldCPFTextController ??=
                        TextEditingController(
                            text: _applyMask(
                                _model.textFieldCPFMask, user?.cpf)),
                    focusNode: _model.textFieldCPFFocusNode!,
                    hint: '000.000.000-00',
                    theme: theme,
                    keyboardType: TextInputType.number,
                    formatters: [_model.textFieldCPFMask],
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 14),
        if (isMobile) ...[
          _LabeledField(
            label: 'Data de nascimento',
            theme: theme,
            child: _buildTextField(
              controller: _model.textFieldDNascTextController ??=
                  TextEditingController(
                      text: _applyMask(
                          _model.textFieldDNascMask, user?.dataNascimento)),
              focusNode: _model.textFieldDNascFocusNode!,
              hint: 'dd/mm/aaaa',
              theme: theme,
              keyboardType: TextInputType.datetime,
              formatters: [_model.textFieldDNascMask],
            ),
          ),
          const SizedBox(height: 14),
          _LabeledField(
            label: 'Nacionalidade',
            theme: theme,
            child: _buildTextField(
              controller: _model.textFieldNocionTextController ??=
                  TextEditingController(text: user?.nacionalidade),
              focusNode: _model.textFieldNocionFocusNode!,
              hint: 'Brasileiro',
              theme: theme,
            ),
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Data de nascimento',
                  theme: theme,
                  child: _buildTextField(
                    controller: _model.textFieldDNascTextController ??=
                        TextEditingController(
                            text: _applyMask(_model.textFieldDNascMask,
                                user?.dataNascimento)),
                    focusNode: _model.textFieldDNascFocusNode!,
                    hint: 'dd/mm/aaaa',
                    theme: theme,
                    keyboardType: TextInputType.datetime,
                    formatters: [_model.textFieldDNascMask],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Nacionalidade',
                  theme: theme,
                  child: _buildTextField(
                    controller: _model.textFieldNocionTextController ??=
                        TextEditingController(text: user?.nacionalidade),
                    focusNode: _model.textFieldNocionFocusNode!,
                    hint: 'Brasileiro',
                    theme: theme,
                  ),
                ),
              ),
            ],
          ),
      ],
    );

    final photoCard = _buildPhotoCard(theme, user);

    return _Section(
      theme: theme,
      icon: Icons.badge_rounded,
      title: 'Dados pessoais',
      subtitle: 'Suas informações de contato e identificação.',
      child: isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                photoCard,
                const SizedBox(height: 16),
                formColumn,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: formColumn),
                const SizedBox(width: 24),
                SizedBox(width: isTablet ? 200 : 240, child: photoCard),
              ],
            ),
    );
  }

  Widget _buildPhotoCard(FlutterFlowTheme theme, UsersRow? user) {
    final localUrl = _model.uploadedFileUrl_uploadSubsFotoPerfilFranquia;
    final url = localUrl.isNotEmpty ? localUrl : (user?.imagemPerfil ?? '');
    final hasImage = url.isNotEmpty;
    final uploading = _model.isDataUploading_uploadSubsFotoPerfilFranquia;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.alternate,
                  image: hasImage
                      ? DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: !hasImage
                    ? Icon(Icons.person_rounded,
                        size: 56, color: theme.secondaryText)
                    : null,
              ),
              if (uploading)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.45),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Foto de perfil',
            style: GoogleFonts.interTight(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: theme.primaryText,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'JPG ou PNG, até 5MB.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 14),
          _FilledPillButton(
            theme: theme,
            label: hasImage ? 'Trocar foto' : 'Selecionar foto',
            icon: Icons.photo_camera_rounded,
            onTap: uploading ? null : _pickPhoto,
            full: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(
      FlutterFlowTheme theme, bool isMobile, bool isTablet, UsersRow? user) {
    Widget cepField() => _LabeledField(
          label: 'CEP',
          theme: theme,
          child: _buildTextField(
            controller: _model.textController7 ??= TextEditingController(
                text: _applyMask(_model.textFieldMask, user?.cep)),
            focusNode: _model.textFieldFocusNode!,
            hint: '00000-000',
            theme: theme,
            keyboardType: TextInputType.number,
            formatters: [_model.textFieldMask],
            onChanged: (_) => _onCepChanged(),
            suffix: _loadingCep
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(theme.primary),
                      ),
                    ),
                  )
                : Icon(Icons.search_rounded, color: theme.secondaryText),
          ),
        );

    Widget paisField() => _LabeledField(
          label: 'País',
          theme: theme,
          child: _buildTextField(
            controller: _model.textFieldPaisTextController ??=
                TextEditingController(text: user?.pais),
            focusNode: _model.textFieldPaisFocusNode!,
            hint: 'Brasil',
            theme: theme,
          ),
        );

    Widget enderecoField() => _LabeledField(
          label: 'Endereço',
          theme: theme,
          child: _buildTextField(
            controller: _model.textFieldEnderecoTextController ??=
                TextEditingController(text: user?.endereco),
            focusNode: _model.textFieldEnderecoFocusNode!,
            hint: 'Rua/Avenida',
            theme: theme,
          ),
        );

    Widget bairroField() => _LabeledField(
          label: 'Bairro',
          theme: theme,
          child: _buildTextField(
            controller: _model.textFieldBairroTextController ??=
                TextEditingController(text: user?.bairro),
            focusNode: _model.textFieldBairroFocusNode!,
            hint: 'Bairro',
            theme: theme,
          ),
        );

    Widget numeroField() => _LabeledField(
          label: 'Número',
          theme: theme,
          child: _buildTextField(
            controller: _model.textFieldNumeroTextController ??=
                TextEditingController(text: user?.numero),
            focusNode: _model.textFieldNumeroFocusNode!,
            hint: 'Nº',
            theme: theme,
            keyboardType: TextInputType.number,
          ),
        );

    Widget compleField() => _LabeledField(
          label: 'Complemento',
          theme: theme,
          child: _buildTextField(
            controller: _model.textFieldCompleTextController ??=
                TextEditingController(text: user?.complemento),
            focusNode: _model.textFieldCompleFocusNode!,
            hint: 'Apto, bloco...',
            theme: theme,
          ),
        );

    Widget cidadeField() => _LabeledField(
          label: 'Cidade',
          theme: theme,
          child: _buildTextField(
            controller: _model.textFieldCidadeTextController ??=
                TextEditingController(text: user?.cidade),
            focusNode: _model.textFieldCidadeFocusNode!,
            hint: 'Cidade',
            theme: theme,
          ),
        );

    Widget ufField() => _LabeledField(
          label: 'UF',
          theme: theme,
          child: _buildTextField(
            controller: _model.textFieldUFTextController ??=
                TextEditingController(text: user?.uf),
            focusNode: _model.textFieldUFFocusNode!,
            hint: 'UF',
            theme: theme,
          ),
        );

    return _Section(
      theme: theme,
      icon: Icons.place_rounded,
      title: 'Endereço',
      subtitle: 'Digite o CEP para preencher automaticamente.',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isMobile) ...[
            cepField(),
            const SizedBox(height: 14),
            paisField(),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cepField()),
                const SizedBox(width: 12),
                Expanded(child: paisField()),
              ],
            ),
          const SizedBox(height: 14),
          if (isMobile) ...[
            enderecoField(),
            const SizedBox(height: 14),
            bairroField(),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: enderecoField()),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: bairroField()),
              ],
            ),
          const SizedBox(height: 14),
          if (isMobile) ...[
            numeroField(),
            const SizedBox(height: 14),
            compleField(),
            const SizedBox(height: 14),
            cidadeField(),
            const SizedBox(height: 14),
            ufField(),
          ] else if (isTablet)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: numeroField()),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: compleField()),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: cidadeField()),
                    const SizedBox(width: 12),
                    Expanded(child: ufField()),
                  ],
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 110, child: numeroField()),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: compleField()),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: cidadeField()),
                const SizedBox(width: 12),
                SizedBox(width: 90, child: ufField()),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(FlutterFlowTheme theme) {
    return InkWell(
      onTap: _saving ? null : _handleSave,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _saving
              ? theme.primary.withOpacity(0.55)
              : theme.primary,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_saving)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              const Icon(Icons.check_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              _saving ? 'Salvando...' : 'Salvar alterações',
              style: GoogleFonts.interTight(
                fontWeight: FontWeight.w800,
                fontSize: 14.5,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required FlutterFlowTheme theme,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    void Function(String)? onChanged,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      onChanged: onChanged,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 13.5,
          color: theme.secondaryText.withOpacity(0.7),
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: theme.secondaryBackground,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.alternate),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primary, width: 1.4),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final FlutterFlowTheme theme;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const _Section({
    required this.theme,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: theme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.interTight(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: theme.primaryText,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final FlutterFlowTheme theme;
  final Widget child;

  const _LabeledField({
    required this.label,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: theme.secondaryText,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _PillIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _PillIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_PillIconButton> createState() => _PillIconButtonState();
}

class _PillIconButtonState extends State<_PillIconButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hover
                  ? theme.primary.withOpacity(0.10)
                  : theme.primaryBackground,
              border: Border.all(
                color: _hover ? theme.primary : theme.alternate,
                width: _hover ? 1.4 : 1.0,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: _hover ? theme.primary : theme.primaryText,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilledPillButton extends StatefulWidget {
  final FlutterFlowTheme theme;
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool full;

  const _FilledPillButton({
    required this.theme,
    required this.label,
    required this.icon,
    required this.onTap,
    this.full = false,
  });

  @override
  State<_FilledPillButton> createState() => _FilledPillButtonState();
}

class _FilledPillButtonState extends State<_FilledPillButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final disabled = widget.onTap == null;
    return MouseRegion(
      cursor: disabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 44,
          width: widget.full ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: disabled
                ? theme.primary.withOpacity(0.5)
                : (_hover
                    ? theme.primary.withOpacity(0.92)
                    : theme.primary),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: widget.full ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.interTight(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
