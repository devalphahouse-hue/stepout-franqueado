import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/cobranca_criada/cobranca_criada_widget.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:data_table_2/data_table_2.dart' show ColumnSize;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'detalhes_aluno_model.dart';
export 'detalhes_aluno_model.dart';

class DetalhesAlunoWidget extends StatefulWidget {
  const DetalhesAlunoWidget({
    super.key,
    required this.idaluno,
  });

  final String? idaluno;

  static String routeName = 'DetalhesAluno';
  static String routePath = '/detalhesAluno';

  @override
  State<DetalhesAlunoWidget> createState() => _DetalhesAlunoWidgetState();
}

class _DetalhesAlunoWidgetState extends State<DetalhesAlunoWidget> {
  late DetalhesAlunoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _saving = false;
  bool _deleting = false;
  bool _sendingCobranca = false;
  bool _alterarTurmaOpen = false;
  bool _controllersHydrated = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhesAlunoModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.dadosAluno = await UsersTable().queryRows(
        queryFn: (q) => q.eqOrNull('id', widget.idaluno),
      );
      _model.dadosMetaAluno = await MetaAlunosTable().queryRows(
        queryFn: (q) => q.eqOrNull('user_id', widget.idaluno),
      );
    });

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

    _model.textController15 ??= TextEditingController();
    _model.textFieldFocusNode10 ??= FocusNode();

    _model.textController16 ??= TextEditingController();
    _model.textFieldFocusNode11 ??= FocusNode();

    _model.textController17 ??= TextEditingController();
    _model.textFieldFocusNode12 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _hydrate(UsersRow user, MetaAlunosRow? meta) {
    if (_controllersHydrated) return;
    _model.textController1!.text = user.nome ?? '';
    _model.textController2!.text = user.email ?? '';
    _model.textController3!.text = user.telefone ?? '';
    _model.textController4!.text = user.cpf ?? '';
    _model.textController5!.text = user.dataNascimento ?? '';
    _model.textController6!.text = user.nacionalidade ?? '';
    _model.textController7!.text = user.cep ?? '';
    _model.txtPaisTextController!.text = user.pais ?? '';
    _model.txtRuaTextController!.text = user.endereco ?? '';
    _model.textBairroTextController!.text = user.bairro ?? '';
    _model.textController11!.text = user.numero ?? '';
    _model.textController12!.text = user.complemento ?? '';
    _model.textCidadeTextController!.text = user.cidade ?? '';
    _model.ufTextController!.text = user.uf ?? '';
    _model.textController15!.text = meta?.objetivoDoAluno ?? '';
    _model.textController16!.text = meta?.experienciasDoAluno ?? '';
    _model.textController17!.text = meta?.disponilidadeEPreferencias ?? '';
    _model.dropDownValue2 ??= meta?.comoConheceu;
    final dataExperimental = meta?.dataAulaExperimental;
    if (dataExperimental != null &&
        dataExperimental.isNotEmpty &&
        _model.datePicked == null) {
      _model.datePicked = DateTime.tryParse(dataExperimental);
    }
    _controllersHydrated = true;
  }

  Future<void> _handleCepLookup() async {
    final cep =
        _model.textController7!.text.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) return;
    _model.apiCEP =
        await BuscarCEPCall.call(cep: _model.textController7!.text);
    if (!(_model.apiCEP?.succeeded ?? false)) return;
    final body = _model.apiCEP?.jsonBody ?? '';
    safeSetState(() {
      _model.txtPaisTextController!.text = 'Brasil';
      _model.txtRuaTextController!.text = BuscarCEPCall.rua(body) ?? '';
      _model.textBairroTextController!.text =
          BuscarCEPCall.bairro(body) ?? '';
      _model.textCidadeTextController!.text =
          BuscarCEPCall.cidade(body) ?? '';
      _model.ufTextController!.text = BuscarCEPCall.uf(body) ?? '';
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
        () => _model.isDataUploading_uploadFotoPerfil = true);
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
      _model.isDataUploading_uploadFotoPerfil = false;
    }
    if (uploadedLocal.length != selectedMedia.length ||
        downloadUrls.length != selectedMedia.length) {
      safeSetState(() {});
      return;
    }
    safeSetState(() {
      _model.uploadedLocalFile_uploadFotoPerfil = uploadedLocal.first;
      _model.uploadedFileUrl_uploadFotoPerfil = downloadUrls.first;
    });
    await UsersTable().update(
      data: {'imagem_perfil': _model.uploadedFileUrl_uploadFotoPerfil},
      matchingRows: (rows) => rows.eqOrNull('id', widget.idaluno),
    );
    if (!mounted) return;
    final theme = FlutterFlowTheme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Foto de perfil atualizada',
          style: TextStyle(color: theme.primaryBackground),
        ),
        duration: const Duration(milliseconds: 3000),
        backgroundColor: theme.primary,
      ),
    );
    _model.clearUsersCache();
    safeSetState(() {});
  }

  bool _validate() {
    final theme = FlutterFlowTheme.of(context);
    String? errorMsg;
    if (_model.textController1!.text.trim().isEmpty) {
      errorMsg = 'Informe o nome do aluno.';
    } else if (_model.textController2!.text.trim().isEmpty) {
      errorMsg = 'Informe o e-mail do aluno.';
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
      await MetaAlunosTable().update(
        data: {
          'como_conheceu': _model.dropDownValue2,
          'data_aula_experimental': _model.datePicked?.toString(),
          'objetivo_do_aluno': _model.textController15!.text,
          'experiencias_do_aluno': _model.textController16!.text,
          'disponilidade_e_preferencias': _model.textController17!.text,
        },
        matchingRows: (rows) =>
            rows.eqOrNull('user_id', widget.idaluno),
      );
      await UsersTable().update(
        data: {
          'nome': _model.textController1!.text,
          'email': _model.textController2!.text,
          'telefone': _model.textController3!.text,
          'cpf': _model.textController4!.text,
          'data_nascimento': _model.textController5!.text,
          'nacionalidade': _model.textController6!.text,
          'cep': _model.textController7!.text,
          'pais': _model.txtPaisTextController!.text,
          'endereco': _model.txtRuaTextController!.text,
          'bairro': _model.textBairroTextController!.text,
          'numero': _model.textController11!.text,
          'complemento': _model.textController12!.text,
          'cidade': _model.textCidadeTextController!.text,
          'uf': _model.ufTextController!.text,
        },
        matchingRows: (rows) => rows.eqOrNull('id', widget.idaluno),
      );
      if (!mounted) return;
      _model.clearUsersCache();
      _model.clearMetaAulaCache();
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

  Future<void> _deleteAluno() async {
    if (_deleting) return;
    final confirm = await showDialog<bool>(
          context: context,
          builder: (alertDialogContext) {
            return WebViewAware(
              child: AlertDialog(
                title: const Text('Excluir este aluno?'),
                content: const Text(
                    'O registro será desativado e o aluno perderá acesso ao app.'),
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
      final now = DateTime.now().toUtc().toIso8601String();
      await MetaAlunosTable().update(
        data: {'deleted_at': now},
        matchingRows: (rows) =>
            rows.eqOrNull('user_id', widget.idaluno),
      );
      await UsersTable().update(
        data: {'deleted_at': now},
        matchingRows: (rows) => rows.eqOrNull('id', widget.idaluno),
      );
      if (!mounted) return;
      context.goNamed(ListaAlunosWidget.routeName);
    } finally {
      if (mounted) safeSetState(() => _deleting = false);
    }
  }

  Future<void> _alterarTurma() async {
    if (_model.dropDownValue1 == null || _model.dropDownValue1 == '0') {
      final theme = FlutterFlowTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Selecione uma turma',
            style: TextStyle(color: theme.primaryBackground),
          ),
          duration: const Duration(milliseconds: 3000),
          backgroundColor: theme.error,
        ),
      );
      return;
    }
    await MetaAlunosTable().update(
      data: {'turma': _model.dropDownValue1},
      matchingRows: (rows) =>
          rows.eqOrNull('user_id', widget.idaluno),
    );
    if (!mounted) return;
    safeSetState(() {
      _model.clearMetaAulaCache();
      _model.requestCompleted1 = false;
    });
    await _model.waitForRequestCompleted1();
    safeSetState(() {
      _model.clearTurmaCache();
      _model.requestCompleted3 = false;
    });
    await _model.waitForRequestCompleted3();
    if (!mounted) return;
    final theme = FlutterFlowTheme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Turma atualizada',
          style: TextStyle(color: theme.primaryBackground),
        ),
        duration: const Duration(milliseconds: 3000),
        backgroundColor: theme.primary,
      ),
    );
    safeSetState(() {
      _alterarTurmaOpen = false;
      _model.dropDownValue1 = null;
      _model.dropDownValueController1?.reset();
    });
  }

  Future<void> _enviarCobrancaInicial() async {
    if (_sendingCobranca) return;
    if (_model.dropDownPlanoValue == null ||
        _model.dropDownPlanoValue == '0') {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return WebViewAware(
            child: AlertDialog(
              title: const Text('Selecione um plano'),
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
    safeSetState(() => _sendingCobranca = true);
    try {
      _model.dadosfranquia = await FranquiasTable().queryRows(
        queryFn: (q) => q.eqOrNull('id', FFAppState().idfranquia),
      );
      _model.planoDeta = await PlanosTable().queryRows(
        queryFn: (q) => q.eqOrNull('id', _model.dropDownPlanoValue),
      );
      _model.cobrancaCriadaSupa = await CobrancasTable().insert({
        'tipo_cobranca': 'aluno',
        'if_franquia': FFAppState().idfranquia,
        'user_id': widget.idaluno,
        'plano_aluno': _model.dropDownPlanoValue,
        'desconto': _model.dropDownDescontoValue,
        'indicacao': _model.dadosfranquia?.firstOrNull?.idIndicacao,
        'num_parcelas': _model.planoDeta?.firstOrNull?.numParcelas,
        'valor_parcelas': _model.planoDeta?.firstOrNull?.valorParcela,
        'valor': _model.planoDeta?.firstOrNull?.precoPlano,
      });
      if (!mounted) return;
      _model.clearCobrancaCache();
      final theme = FlutterFlowTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cobrança criada com sucesso',
            style: TextStyle(color: theme.primaryText),
          ),
          duration: const Duration(milliseconds: 3000),
          backgroundColor: theme.secondary,
        ),
      );
      await _showCobrancaDialog(_model.cobrancaCriadaSupa?.id);
    } finally {
      if (mounted) safeSetState(() => _sendingCobranca = false);
    }
  }

  Future<void> _enviarCobrancaRenovacao() async {
    if (_sendingCobranca) return;
    if (_model.dropDownPlano123Value == null ||
        _model.dropDownPlano123Value == '0') {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return WebViewAware(
            child: AlertDialog(
              title: const Text('Selecione um plano'),
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
    safeSetState(() => _sendingCobranca = true);
    try {
      _model.dadosfranquia2 = await FranquiasTable().queryRows(
        queryFn: (q) => q.eqOrNull('id', FFAppState().idfranquia),
      );
      _model.planoDetalhe = await PlanosTable().queryRows(
        queryFn: (q) => q.eqOrNull('id', _model.dropDownPlano123Value),
      );
      _model.cobrancaCriadaSupa2 = await CobrancasTable().insert({
        'tipo_cobranca': 'aluno',
        'if_franquia': FFAppState().idfranquia,
        'user_id': widget.idaluno,
        'plano_aluno': _model.dropDownPlano123Value,
        'desconto': _model.dropDownDesconto123Value,
        'indicacao': _model.dadosfranquia2?.firstOrNull?.idIndicacao,
        'valor': _model.planoDetalhe?.firstOrNull?.precoPlano,
        'valor_parcelas': _model.planoDetalhe?.firstOrNull?.valorParcela,
        'num_parcelas': _model.planoDetalhe?.firstOrNull?.numParcelas,
      });
      if (!mounted) return;
      safeSetState(() {
        _model.clearCobrancaCache();
        _model.requestCompleted2 = false;
      });
      final theme = FlutterFlowTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cobrança criada com sucesso',
            style: TextStyle(color: theme.primaryText),
          ),
          duration: const Duration(milliseconds: 3000),
          backgroundColor: theme.secondary,
        ),
      );
      await _showCobrancaDialog(_model.cobrancaCriadaSupa2?.id);
      await _model.waitForRequestCompleted2();
    } finally {
      if (mounted) safeSetState(() => _sendingCobranca = false);
    }
  }

  Future<void> _showCobrancaDialog(String? idCobranca) async {
    if (idCobranca == null) return;
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: AlignmentDirectional.center
              .resolve(Directionality.of(context)),
          child: WebViewAware(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(dialogContext).unfocus();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SizedBox(
                height: 450.0,
                width: 450.0,
                child: CobrancaCriadaWidget(idCobranca: idCobranca),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _cancelarCobranca(CobrancasRow cobranca) async {
    final theme = FlutterFlowTheme.of(context);
    final confirm = await showDialog<bool>(
          context: context,
          builder: (alertDialogContext) {
            return WebViewAware(
              child: AlertDialog(
                title: const Text('Cancelar essa cobrança?'),
                content: const Text(
                    'A cobrança não poderá ser paga depois do cancelamento.'),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(alertDialogContext, false),
                    child: const Text('Manter'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(alertDialogContext, true),
                    child: const Text('Cancelar cobrança'),
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
    if (!confirm) return;
    await CobrancasTable().update(
      data: {'status_plat': 'Cancelada'},
      matchingRows: (rows) => rows.eqOrNull('id', cobranca.id),
    );
    if (!mounted) return;
    safeSetState(() {
      _model.clearCobrancaCache();
      _model.requestCompleted2 = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cobrança cancelada',
          style: TextStyle(color: theme.primaryBackground),
        ),
        duration: const Duration(milliseconds: 3000),
        backgroundColor: theme.primary,
      ),
    );
    await _model.waitForRequestCompleted2();
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
                child: FutureBuilder<List<UsersRow>>(
                  future: _model.users(
                    requestFn: () => UsersTable().querySingleRow(
                      queryFn: (q) => q.eqOrNull('id', widget.idaluno),
                    ),
                  ),
                  builder: (context, userSnap) {
                    if (!userSnap.hasData) {
                      return _LoadingState(theme: theme);
                    }
                    final user =
                        userSnap.data!.isNotEmpty ? userSnap.data!.first : null;
                    if (user == null) {
                      return Center(
                        child: Text(
                          'Aluno não encontrado.',
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.inter(
                                fontWeight: FontWeight.w500),
                            fontWeight: FontWeight.w500,
                            color: theme.secondaryText,
                          ),
                        ),
                      );
                    }
                    return FutureBuilder<List<MetaAlunosRow>>(
                      future: _model
                          .metaAula(
                        requestFn: () => MetaAlunosTable().querySingleRow(
                          queryFn: (q) =>
                              q.eqOrNull('user_id', widget.idaluno),
                        ),
                      )
                          .then((result) {
                        _model.requestCompleted1 = true;
                        return result;
                      }),
                      builder: (context, metaSnap) {
                        if (!metaSnap.hasData) {
                          return _LoadingState(theme: theme);
                        }
                        final meta = metaSnap.data!.isNotEmpty
                            ? metaSnap.data!.first
                            : null;
                        _hydrate(user, meta);
                        final fotoExibida = _model
                                .uploadedFileUrl_uploadFotoPerfil.isNotEmpty
                            ? _model.uploadedFileUrl_uploadFotoPerfil
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
                                onDelete:
                                    _deleting ? null : _deleteAluno,
                                deleting: _deleting,
                              ),
                              SizedBox(height: isCompact ? 16.0 : 22.0),
                              _SectionCard(
                                title: 'Dados pessoais',
                                subtitle:
                                    'Informações de identificação e contato do aluno.',
                                icon: Icons.person_rounded,
                                child: _DadosPessoaisSection(
                                  model: _model,
                                  fotoUrl: fotoExibida,
                                  uploading: _model
                                      .isDataUploading_uploadFotoPerfil,
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
                                      '_detalhes_aluno_cep',
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
                                    'Turma atual do aluno e opção de alterar.',
                                icon: Icons.groups_rounded,
                                child: _TurmaSection(
                                  model: _model,
                                  meta: meta,
                                  alterarOpen: _alterarTurmaOpen,
                                  onToggle: () => safeSetState(() {
                                    _alterarTurmaOpen = !_alterarTurmaOpen;
                                    if (!_alterarTurmaOpen) {
                                      _model.dropDownValue1 = null;
                                      _model.dropDownValueController1
                                          ?.reset();
                                    }
                                  }),
                                  onSave: _alterarTurma,
                                ),
                              ),
                              SizedBox(height: isCompact ? 14.0 : 18.0),
                              _SectionCard(
                                title: 'Aula experimental',
                                subtitle:
                                    'Origem do contato, data da aula e perfil pedagógico.',
                                icon: Icons.event_note_rounded,
                                child: _AulaExperimentalSection(
                                  model: _model,
                                  isCompact: isCompact,
                                  onPickDate: _pickDataExperimental,
                                ),
                              ),
                              SizedBox(height: isCompact ? 14.0 : 18.0),
                              _SectionCard(
                                title: 'Financeiro',
                                subtitle:
                                    'Cobranças do aluno e gestão de novos pagamentos.',
                                icon: Icons.attach_money_rounded,
                                child: _FinanceiroSection(
                                  model: _model,
                                  userId: user.id,
                                  isCompact: isCompact,
                                  sendingCobranca: _sendingCobranca,
                                  onEnviarInicial: _enviarCobrancaInicial,
                                  onEnviarRenovacao:
                                      _enviarCobrancaRenovacao,
                                  onReenviar: _showCobrancaDialog,
                                  onCancelar: _cancelarCobranca,
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

  Future<void> _pickDataExperimental() async {
    final theme = FlutterFlowTheme.of(context);
    final picked = await showDatePicker(
      context: context,
      initialDate: _model.datePicked ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return wrapInMaterialDatePickerTheme(
          context,
          child!,
          headerBackgroundColor: theme.primary,
          headerForegroundColor: theme.info,
          headerTextStyle: theme.headlineLarge.override(
            font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
            fontSize: 32.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w600,
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
    if (picked == null) return;
    safeSetState(() {
      _model.datePicked = DateTime(picked.year, picked.month, picked.day);
    });
  }
}

// ===========================================================================
// SHARED HEADER + SECTION CARD + LOADING
// ===========================================================================

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
          strokeWidth: 2.4,
          valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
        ),
      ),
    );
  }
}

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
                'Detalhes do aluno',
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
                'Edite cadastro, turma, aula experimental e cobranças.',
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

// ===========================================================================
// LABELED FIELD + INPUT DECORATION
// ===========================================================================

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

// ===========================================================================
// DADOS PESSOAIS
// ===========================================================================

class _DadosPessoaisSection extends StatelessWidget {
  const _DadosPessoaisSection({
    required this.model,
    required this.fotoUrl,
    required this.uploading,
    required this.onPickPhoto,
    required this.isCompact,
  });

  final DetalhesAlunoModel model;
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

// ===========================================================================
// ENDEREÇO
// ===========================================================================

class _EnderecoSection extends StatelessWidget {
  const _EnderecoSection({
    required this.model,
    required this.onCepChanged,
    required this.isCompact,
  });

  final DetalhesAlunoModel model;
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

// ===========================================================================
// TURMA
// ===========================================================================

class _TurmaSection extends StatelessWidget {
  const _TurmaSection({
    required this.model,
    required this.meta,
    required this.alterarOpen,
    required this.onToggle,
    required this.onSave,
  });

  final DetalhesAlunoModel model;
  final MetaAlunosRow? meta;
  final bool alterarOpen;
  final VoidCallback onToggle;
  final Future<void> Function() onSave;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder<List<TurmasRow>>(
          future: model
              .turma(
            requestFn: () => TurmasTable().queryRows(
              queryFn: (q) => q.eqOrNull('id', meta?.turma),
            ),
          )
              .then((result) {
            model.requestCompleted3 = true;
            return result;
          }),
          builder: (context, snapshot) {
            final loading = !snapshot.hasData;
            final turma =
                (snapshot.data?.isNotEmpty ?? false) ? snapshot.data!.first : null;
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: theme.alternate, width: 1.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.primary.withValues(alpha: 0.12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.label_important_outline_rounded,
                        size: 18.0, color: theme.primary),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Turma atual',
                          style: theme.labelMedium.override(
                            font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600),
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                            color: theme.secondaryText,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          loading
                              ? 'Carregando...'
                              : (turma?.nomeDaTurma ?? 'Sem turma vinculada'),
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.inter(
                                fontWeight: FontWeight.w700),
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                            color: theme.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  _SecondaryButton(
                    icon: alterarOpen
                        ? Icons.close_rounded
                        : Icons.swap_horiz_rounded,
                    label: alterarOpen ? 'Cancelar' : 'Alterar',
                    onTap: onToggle,
                  ),
                ],
              ),
            );
          },
        ),
        if (alterarOpen) ...[
          const SizedBox(height: 14.0),
          FutureBuilder<ApiCallResponse>(
            future: model.listaturma(
              requestFn: () => SupabaseGroup.listaTurmasCall.call(
                pIdFranquia: FFAppState().idfranquia,
                token: currentJwtToken,
              ),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  height: 48.0,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: theme.alternate, width: 1.0),
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
                        'Carregando turmas...',
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.inter(
                              fontWeight: FontWeight.w500),
                          fontWeight: FontWeight.w500,
                          fontSize: 13.5,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                );
              }
              final List<ListaTurmasStruct> list = (snapshot
                          .data!.jsonBody as List<dynamic>)
                      .map<ListaTurmasStruct?>(
                          ListaTurmasStruct.maybeFromMap)
                      .where((e) => e != null)
                      .cast<ListaTurmasStruct>()
                      .toList();
              return Row(
                children: [
                  Expanded(
                    child: FlutterFlowDropDown<String>(
                      controller: model.dropDownValueController1 ??=
                          FormFieldController<String>(
                              model.dropDownValue1 ??= '0'),
                      options:
                          List<String>.from(list.map((e) => e.id).toList()),
                      optionLabels:
                          list.map((e) => e.nomeDaTurma).toList(),
                      onChanged: (val) => model.dropDownValue1 = val,
                      width: double.infinity,
                      height: 48.0,
                      textStyle: _fieldTextStyle(context),
                      hintText: 'Selecione uma turma',
                      searchHintText: 'Buscar turma',
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
                  const SizedBox(width: 12.0),
                  _SecondaryButton(
                    icon: Icons.check_rounded,
                    label: 'Salvar nova turma',
                    onTap: () => onSave(),
                  ),
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}

// ===========================================================================
// AULA EXPERIMENTAL
// ===========================================================================

class _AulaExperimentalSection extends StatelessWidget {
  const _AulaExperimentalSection({
    required this.model,
    required this.isCompact,
    required this.onPickDate,
  });

  final DetalhesAlunoModel model;
  final bool isCompact;
  final Future<void> Function() onPickDate;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final dataLabel = model.datePicked != null
        ? dateTimeFormat(
            'd/M/y',
            model.datePicked,
            locale: FFLocalizations.of(context).languageCode,
          )
        : 'Selecione uma data';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ResponsiveTwoColumns(
          isCompact: isCompact,
          left: _LabeledField(
            label: 'Como conheceu a Stepout?',
            child: FlutterFlowDropDown<String>(
              controller: model.dropDownValueController2 ??=
                  FormFieldController<String>(model.dropDownValue2),
              options: const ['Option 1', 'Option 2', 'Option 3'],
              onChanged: (val) => model.dropDownValue2 = val,
              width: double.infinity,
              height: 48.0,
              textStyle: _fieldTextStyle(context),
              hintText: 'Selecione',
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
              isSearchable: false,
              isMultiSelect: false,
            ),
          ),
          right: _LabeledField(
            label: 'Data da aula experimental',
            child: GestureDetector(
              onTap: () => onPickDate(),
              child: Container(
                height: 48.0,
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: theme.alternate, width: 1.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.event_rounded,
                        size: 18.0, color: theme.secondaryText),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        dataLabel,
                        style: _fieldTextStyle(context),
                      ),
                    ),
                    Icon(Icons.calendar_month_rounded,
                        size: 18.0, color: theme.primary),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14.0),
        _LabeledField(
          label: 'Objetivo do aluno',
          child: TextFormField(
            controller: model.textController15,
            focusNode: model.textFieldFocusNode10,
            minLines: 3,
            maxLines: null,
            style: _fieldTextStyle(context),
            decoration: _inputDecoration(
              context,
              hint: 'O que o aluno espera alcançar?',
            ),
          ),
        ),
        const SizedBox(height: 14.0),
        _LabeledField(
          label: 'Experiências anteriores',
          child: TextFormField(
            controller: model.textController16,
            focusNode: model.textFieldFocusNode11,
            minLines: 3,
            maxLines: null,
            style: _fieldTextStyle(context),
            decoration: _inputDecoration(
              context,
              hint: 'Aulas anteriores, escolas, intercâmbios...',
            ),
          ),
        ),
        const SizedBox(height: 14.0),
        _LabeledField(
          label: 'Disponibilidade e preferências',
          child: TextFormField(
            controller: model.textController17,
            focusNode: model.textFieldFocusNode12,
            minLines: 3,
            maxLines: null,
            style: _fieldTextStyle(context),
            decoration: _inputDecoration(
              context,
              hint: 'Dias, horários e preferências de aula',
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// FINANCEIRO (cobranças)
// ===========================================================================

class _FinanceiroSection extends StatelessWidget {
  const _FinanceiroSection({
    required this.model,
    required this.userId,
    required this.isCompact,
    required this.sendingCobranca,
    required this.onEnviarInicial,
    required this.onEnviarRenovacao,
    required this.onReenviar,
    required this.onCancelar,
  });

  final DetalhesAlunoModel model;
  final String? userId;
  final bool isCompact;
  final bool sendingCobranca;
  final Future<void> Function() onEnviarInicial;
  final Future<void> Function() onEnviarRenovacao;
  final Future<void> Function(String? idCobranca) onReenviar;
  final Future<void> Function(CobrancasRow cobranca) onCancelar;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CobrancasRow>>(
      future: model
          .cobranca(
        requestFn: () => CobrancasTable().queryRows(
          queryFn: (q) => q.eqOrNull('user_id', userId),
        ),
      )
          .then((result) {
        model.requestCompleted2 = true;
        return result;
      }),
      builder: (context, snapshot) {
        final theme = FlutterFlowTheme.of(context);
        if (!snapshot.hasData) {
          return Container(
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
                  'Carregando cobranças...',
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
        final cobrancas = snapshot.data!;
        if (cobrancas.isEmpty) {
          return _CobrancaInicialBlock(
            model: model,
            isCompact: isCompact,
            sending: sendingCobranca,
            onEnviar: onEnviarInicial,
            isInicial: true,
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AsaasObservacao(),
            const SizedBox(height: 14.0),
            _CobrancaInicialBlock(
              model: model,
              isCompact: isCompact,
              sending: sendingCobranca,
              onEnviar: onEnviarRenovacao,
              isInicial: false,
            ),
            const SizedBox(height: 18.0),
            _HistoricoCobrancasTable(
              cobrancas: cobrancas
                  .where((e) => e.statusPlat != 'Cancelada')
                  .toList(),
              controller: model.paginatedDataTableController,
              onReenviar: onReenviar,
              onCancelar: onCancelar,
            ),
          ],
        );
      },
    );
  }
}

class _AsaasObservacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.warning.withValues(alpha: 0.40),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded,
              color: theme.warning, size: 20.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              'Antes de gerar a primeira mensalidade, certifique-se de que sua documentação foi aprovada pelo Banco Asaas. Acesse o painel do Asaas com o e-mail de criação da franquia para enviar os documentos e liberar transações.',
              style: theme.bodySmall.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                fontWeight: FontWeight.w500,
                fontSize: 12.5,
                color: theme.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CobrancaInicialBlock extends StatelessWidget {
  const _CobrancaInicialBlock({
    required this.model,
    required this.isCompact,
    required this.sending,
    required this.onEnviar,
    required this.isInicial,
  });

  final DetalhesAlunoModel model;
  final bool isCompact;
  final bool sending;
  final Future<void> Function() onEnviar;
  final bool isInicial;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isInicial
                    ? Icons.send_rounded
                    : Icons.add_circle_outline_rounded,
                color: theme.primary,
                size: 18.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                isInicial
                    ? 'Primeira cobrança'
                    : 'Nova cobrança',
                style: theme.titleSmall.override(
                  font: GoogleFonts.interTight(
                      fontWeight: FontWeight.w800),
                  fontWeight: FontWeight.w800,
                  fontSize: 14.0,
                  color: theme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            isInicial
                ? 'Selecione o plano e envie o link para o aluno fazer cadastro, aceitar os Termos e pagar.'
                : 'Selecione o plano para gerar uma nova cobrança ao aluno.',
            style: theme.bodySmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              fontWeight: FontWeight.w500,
              fontSize: 12.5,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 14.0),
          _ResponsiveTwoColumns(
            isCompact: isCompact,
            left: _LabeledField(
              label: 'Plano',
              child: FutureBuilder<List<PlanosRow>>(
                future: model.planos(
                  requestFn: () => PlanosTable().queryRows(queryFn: (q) => q),
                ),
                builder: (context, snapshot) {
                  final list = snapshot.data ?? [];
                  return FlutterFlowDropDown<String>(
                    controller: isInicial
                        ? (model.dropDownPlanoValueController ??=
                            FormFieldController<String>(
                                model.dropDownPlanoValue ??= '0'))
                        : (model.dropDownPlano123ValueController ??=
                            FormFieldController<String>(
                                model.dropDownPlano123Value ??= '0')),
                    options:
                        List<String>.from(list.map((e) => e.id).toList()),
                    optionLabels:
                        list.map((e) => e.nomePlano).withoutNulls.toList(),
                    onChanged: (val) {
                      if (isInicial) {
                        model.dropDownPlanoValue = val;
                      } else {
                        model.dropDownPlano123Value = val;
                      }
                    },
                    width: double.infinity,
                    height: 48.0,
                    textStyle: _fieldTextStyle(context),
                    hintText: 'Selecione um plano',
                    searchHintText: 'Buscar...',
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.secondaryText,
                      size: 22.0,
                    ),
                    fillColor: theme.primaryBackground,
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
                  );
                },
              ),
            ),
            right: _LabeledField(
              label: 'Desconto (opcional)',
              child: FutureBuilder<List<DescontosRow>>(
                future: model.descontos(
                  requestFn: () =>
                      DescontosTable().queryRows(queryFn: (q) => q),
                ),
                builder: (context, snapshot) {
                  final list = snapshot.data ?? [];
                  return FlutterFlowDropDown<int>(
                    controller: isInicial
                        ? (model.dropDownDescontoValueController ??=
                            FormFieldController<int>(
                                model.dropDownDescontoValue))
                        : (model.dropDownDesconto123ValueController ??=
                            FormFieldController<int>(
                                model.dropDownDesconto123Value)),
                    options: list.map((e) => e.valorDesconto ?? 0).toList(),
                    optionLabels: list
                        .map((e) =>
                            '${e.nomeDesconto ?? "Desconto"} · ${e.valorDesconto ?? 0}%')
                        .toList(),
                    onChanged: (val) {
                      if (isInicial) {
                        model.dropDownDescontoValue = val;
                      } else {
                        model.dropDownDesconto123Value = val;
                      }
                    },
                    width: double.infinity,
                    height: 48.0,
                    textStyle: _fieldTextStyle(context),
                    hintText: 'Sem desconto',
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.secondaryText,
                      size: 22.0,
                    ),
                    fillColor: theme.primaryBackground,
                    elevation: 2.0,
                    borderColor: theme.alternate,
                    borderWidth: 1.0,
                    borderRadius: 12.0,
                    margin: const EdgeInsetsDirectional.fromSTEB(
                        14.0, 0.0, 12.0, 0.0),
                    hidesUnderline: true,
                    isOverButton: false,
                    isSearchable: false,
                    isMultiSelect: false,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 14.0),
          _PrimaryActionButton(
            icon: Icons.send_rounded,
            label: isInicial
                ? 'Enviar link de cadastro e cobrança'
                : 'Enviar nova cobrança',
            loading: sending,
            onTap: () => onEnviar(),
          ),
        ],
      ),
    );
  }
}

class _HistoricoCobrancasTable extends StatelessWidget {
  const _HistoricoCobrancasTable({
    required this.cobrancas,
    required this.controller,
    required this.onReenviar,
    required this.onCancelar,
  });

  final List<CobrancasRow> cobrancas;
  final FlutterFlowDataTableController<CobrancasRow> controller;
  final Future<void> Function(String? idCobranca) onReenviar;
  final Future<void> Function(CobrancasRow cobranca) onCancelar;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 2.0),
          child: Text(
            'Histórico de cobranças',
            style: theme.labelMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
              letterSpacing: 0.1,
              color: theme.primaryText,
            ),
          ),
        ),
        Container(
          height: 320.0,
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: theme.alternate, width: 1.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: cobrancas.isEmpty
              ? Center(
                  child: Text(
                    'Nenhuma cobrança ativa.',
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0,
                      color: theme.secondaryText,
                    ),
                  ),
                )
              : FlutterFlowDataTable<CobrancasRow>(
                  controller: controller,
                  data: cobrancas,
                  columnsBuilder: (onSortChanged) => [
                    DataColumn2(
                      label: _ColLabel(theme: theme, text: 'Valor'),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: _ColLabel(theme: theme, text: 'Status'),
                      size: ColumnSize.M,
                    ),
                    DataColumn2(
                      label: _ColLabel(theme: theme, text: ''),
                      size: ColumnSize.L,
                    ),
                  ],
                  dataRowBuilder: (item, idx, selected, onSelectChanged) =>
                      DataRow(
                    color: WidgetStateProperty.all(
                      idx % 2 == 0
                          ? theme.primaryBackground
                          : theme.secondaryBackground.withValues(alpha: 0.5),
                    ),
                    cells: [
                      DataCell(_ValorCell(theme: theme, item: item)),
                      DataCell(_StatusCell(theme: theme, item: item)),
                      DataCell(_AcoesCell(
                        theme: theme,
                        item: item,
                        onReenviar: () => onReenviar(item.id),
                        onCancelar: () => onCancelar(item),
                      )),
                    ],
                  ),
                  paginated: true,
                  selectable: false,
                  hidePaginator: false,
                  showFirstLastButtons: false,
                  headingRowHeight: 48.0,
                  dataRowHeight: 56.0,
                  columnSpacing: 12.0,
                  headingRowColor: theme.secondaryBackground,
                  borderRadius: BorderRadius.zero,
                  addHorizontalDivider: true,
                  addTopAndBottomDivider: false,
                  hideDefaultHorizontalDivider: true,
                  horizontalDividerColor: theme.alternate,
                  horizontalDividerThickness: 1.0,
                  addVerticalDivider: false,
                ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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

class _ValorCell extends StatelessWidget {
  const _ValorCell({required this.theme, required this.item});
  final FlutterFlowTheme theme;
  final CobrancasRow item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        valueOrDefault<String>(
          formatNumber(
            item.valor,
            formatType: FormatType.decimal,
            decimalType: DecimalType.commaDecimal,
            currency: 'R\$ ',
          ),
          'R\$ 0,00',
        ),
        style: theme.bodyMedium.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w700),
          fontWeight: FontWeight.w700,
          fontSize: 13.5,
          color: theme.primaryText,
        ),
      ),
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({required this.theme, required this.item});
  final FlutterFlowTheme theme;
  final CobrancasRow item;
  @override
  Widget build(BuildContext context) {
    final status = item.statusCobranca ?? 'Aguardando';
    Color color = theme.secondaryText;
    final lower = status.toLowerCase();
    if (lower.contains('pag') || lower.contains('conclu')) {
      color = theme.primary;
    } else if (lower.contains('atras') || lower.contains('falh')) {
      color = theme.error;
    } else if (lower.contains('aguard')) {
      color = theme.warning;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999.0),
        ),
        child: Text(
          status,
          style: theme.titleSmall.override(
            font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _AcoesCell extends StatelessWidget {
  const _AcoesCell({
    required this.theme,
    required this.item,
    required this.onReenviar,
    required this.onCancelar,
  });

  final FlutterFlowTheme theme;
  final CobrancasRow item;
  final VoidCallback onReenviar;
  final VoidCallback onCancelar;

  @override
  Widget build(BuildContext context) {
    final ativa = item.statusPlat != 'Cancelada' &&
        item.statusPlat != 'Concluída';
    if (!ativa) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            '—',
            style: theme.bodySmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              fontWeight: FontWeight.w500,
              fontSize: 12.5,
              color: theme.secondaryText,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: [
          _MiniButton(
            icon: Icons.send_rounded,
            label: 'Reenviar',
            onTap: onReenviar,
            destructive: false,
          ),
          _MiniButton(
            icon: Icons.cancel_outlined,
            label: 'Cancelar',
            onTap: onCancelar,
            destructive: true,
          ),
        ],
      ),
    );
  }
}

class _MiniButton extends StatefulWidget {
  const _MiniButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.destructive,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  State<_MiniButton> createState() => _MiniButtonState();
}

class _MiniButtonState extends State<_MiniButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final accent = widget.destructive ? theme.error : theme.primary;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
          decoration: BoxDecoration(
            color: _hovered
                ? accent.withValues(alpha: 0.16)
                : accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: accent.withValues(alpha: 0.30),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: accent, size: 14.0),
              const SizedBox(width: 6.0),
              Text(
                widget.label,
                style: theme.titleSmall.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// PRIMARY/SECONDARY/SAVE BUTTONS
// ===========================================================================

class _PrimaryActionButton extends StatefulWidget {
  const _PrimaryActionButton({
    required this.icon,
    required this.label,
    required this.loading,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool loading;
  final Future<void> Function() onTap;

  @override
  State<_PrimaryActionButton> createState() => _PrimaryActionButtonState();
}

class _PrimaryActionButtonState extends State<_PrimaryActionButton> {
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
            height: 48.0,
            decoration: BoxDecoration(
              color: disabled
                  ? theme.primary.withValues(alpha: 0.55)
                  : theme.primary,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withValues(
                    alpha: _hovered && !disabled ? 0.30 : 0.18,
                  ),
                  blurRadius: _hovered && !disabled ? 18.0 : 12.0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: widget.loading
                ? const SizedBox(
                    width: 18.0,
                    height: 18.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 18.0),
                      const SizedBox(width: 8.0),
                      Text(
                        widget.label,
                        style: theme.titleSmall.override(
                          font: GoogleFonts.interTight(
                              fontWeight: FontWeight.w700),
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
            height: 44.0,
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
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
                Icon(widget.icon, color: theme.primary, size: 16.0),
                const SizedBox(width: 6.0),
                Text(
                  widget.label,
                  style: theme.titleSmall.override(
                    font:
                        GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
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
