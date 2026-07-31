import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'acesso_model.dart';
export 'acesso_model.dart';

const Color _kProfessorColor = Color(0xFF1A56DB);
const Color _kAlunoColor = Color(0xFF15803D);

class AcessoWidget extends StatefulWidget {
  const AcessoWidget({super.key});

  static String routeName = 'Acesso';
  static String routePath = '/acesso';

  @override
  State<AcessoWidget> createState() => _AcessoWidgetState();
}

class _AcessoWidgetState extends State<AcessoWidget> {
  late AcessoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Which card was most recently copied (null = none). Resets after 2s.
  String? _copied;

  static const String _professorLink = 'https://professor.stepout.com.br';
  static const String _alunoLink = 'https://aluno.stepout.com.br';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AcessoModel());

    _model.professorController ??=
        TextEditingController(text: _professorLink);
    _model.professorFocusNode ??= FocusNode();
    _model.alunoController ??= TextEditingController(text: _alunoLink);
    _model.alunoFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleCopy(String key, String link) async {
    await Clipboard.setData(ClipboardData(text: link));
    if (!mounted) return;
    setState(() => _copied = key);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _copied == key) setState(() => _copied = null);
    });
  }

  double _padH(double w) {
    if (w < 720) return 12.0;
    if (w < 1080) return 24.0;
    return 48.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 720;
    final padH = _padH(width);

    return Scaffold(
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
              child: SidebarWidget(route: 'Acesso'),
            ),
            Expanded(
              child: SingleChildScrollView(
                primary: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      padH, isMobile ? 16 : 28, padH, isMobile ? 24 : 40),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(theme, isMobile),
                        const SizedBox(height: 24),
                        _buildLinkCard(
                          theme: theme,
                          isMobile: isMobile,
                          accent: _kProfessorColor,
                          icon: Icons.co_present_rounded,
                          badge: 'Professor',
                          title: 'Portal do Professor',
                          subtitle:
                              'Envie este link para o professor acessar o painel de aulas, turmas e conteúdos.',
                          controller: _model.professorController!,
                          focusNode: _model.professorFocusNode!,
                          copyKey: 'professor',
                          link: _professorLink,
                        ),
                        const SizedBox(height: 16),
                        _buildLinkCard(
                          theme: theme,
                          isMobile: isMobile,
                          accent: _kAlunoColor,
                          icon: Icons.school_rounded,
                          badge: 'Aluno',
                          title: 'Portal do Aluno',
                          subtitle:
                              'Envie este link para o aluno acessar as aulas ao vivo, o chat e as cobranças.',
                          controller: _model.alunoController!,
                          focusNode: _model.alunoFocusNode!,
                          copyKey: 'aluno',
                          link: _alunoLink,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
              Icon(Icons.link_rounded, size: 14, color: theme.primary),
              const SizedBox(width: 6),
              Text(
                'Links de acesso',
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
          'Acesso',
          style: GoogleFonts.interTight(
            fontWeight: FontWeight.w800,
            fontSize: isMobile ? 24 : 30,
            color: theme.primaryText,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Copie o link do portal e envie para o professor ou para o aluno.',
          style: GoogleFonts.inter(
            fontSize: 13.5,
            color: theme.secondaryText,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkCard({
    required FlutterFlowTheme theme,
    required bool isMobile,
    required Color accent,
    required IconData icon,
    required String badge,
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String copyKey,
    required String link,
  }) {
    final justCopied = _copied == copyKey;

    final field = TextFormField(
      controller: controller,
      focusNode: focusNode,
      readOnly: true,
      style: GoogleFonts.inter(
        fontSize: 13,
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        prefixIcon:
            Icon(Icons.public_rounded, size: 18, color: theme.secondaryText),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 40, minHeight: 0),
        filled: true,
        fillColor: theme.secondaryBackground,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.alternate),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accent, width: 1.4),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final copyBtn = InkWell(
      onTap: () => _handleCopy(copyKey, link),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: justCopied ? theme.success : accent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              justCopied ? Icons.check_rounded : Icons.content_copy_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              justCopied ? 'Link copiado!' : 'Copiar link',
              style: GoogleFonts.interTight(
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: GoogleFonts.interTight(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: theme.primaryText,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 10.5,
                              color: accent,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: theme.secondaryText,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (isMobile)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                field,
                const SizedBox(height: 10),
                copyBtn,
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: field),
                const SizedBox(width: 12),
                copyBtn,
              ],
            ),
        ],
      ),
    );
  }
}
