import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'indicacoes_model.dart';
export 'indicacoes_model.dart';

const Color _kFranquiaColor = Color(0xFF1A56DB);
const Color _kFranquiaColorDark = Color(0xFF1E40AF);
const Color _kAlunoColor = Color(0xFF15803D);
const Color _kAlunoColorDark = Color(0xFF166534);

class IndicacoesWidget extends StatefulWidget {
  const IndicacoesWidget({super.key});

  static String routeName = 'Indicacoes';
  static String routePath = '/indicacoes';

  @override
  State<IndicacoesWidget> createState() => _IndicacoesWidgetState();
}

class _IndicacoesWidgetState extends State<IndicacoesWidget> {
  late IndicacoesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _justCopied = false;

  String get _link =>
      'https://franqueado.stepout.com.br/planos?indication=${FFAppState().idfranquia}';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IndicacoesModel());

    _model.textController ??= TextEditingController(text: _link);
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: _link));
    if (!mounted) return;
    setState(() => _justCopied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _justCopied = false);
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
              child: SidebarWidget(route: 'Indicacao'),
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
                        const SizedBox(height: 20),
                        _buildHero(theme, isMobile),
                        const SizedBox(height: 20),
                        _buildCommissions(theme, isMobile),
                        const SizedBox(height: 20),
                        _buildHowItWorks(theme, isMobile),
                        const SizedBox(height: 20),
                        _buildLinkSection(theme, isMobile),
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
              Icon(Icons.workspace_premium_rounded,
                  size: 14, color: theme.primary),
              const SizedBox(width: 6),
              Text(
                'Programa de indicações',
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
          'Indicações',
          style: GoogleFonts.interTight(
            fontWeight: FontWeight.w800,
            fontSize: isMobile ? 24 : 30,
            color: theme.primaryText,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Compartilhe seu link, indique novos investidores e ganhe comissão por franquia e aluno ativo.',
          style: GoogleFonts.inter(
            fontSize: 13.5,
            color: theme.secondaryText,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildHero(FlutterFlowTheme theme, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.celebration_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Indique e ganhe!',
                  style: GoogleFonts.interTight(
                    fontWeight: FontWeight.w800,
                    fontSize: isMobile ? 18 : 20,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Veja suas bonificações ao realizar uma indicação bem-sucedida.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.92),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommissions(FlutterFlowTheme theme, bool isMobile) {
    final cardA = _commissionCard(
      theme: theme,
      icon: Icons.storefront_rounded,
      accent: _kFranquiaColor,
      accentDark: _kFranquiaColorDark,
      percent: '50%',
      title: 'Comissão por franquia',
      description: 'No valor de venda de cada franquia indicada.',
      footnote:
          'Comissão única, calculada sobre o valor de aquisição da franquia.',
    );
    final cardB = _commissionCard(
      theme: theme,
      icon: Icons.person_add_alt_1_rounded,
      accent: _kAlunoColor,
      accentDark: _kAlunoColorDark,
      percent: '5%',
      title: 'Comissão por aluno',
      description:
          'Do valor mensal de cada aluno pagante dentro da franquia ativa.',
      footnote:
          'Comissão recorrente, calculada sobre o valor do plano ativo.',
    );

    if (isMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          cardA,
          const SizedBox(height: 16),
          cardB,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: cardA),
        const SizedBox(width: 16),
        Expanded(child: cardB),
      ],
    );
  }

  Widget _commissionCard({
    required FlutterFlowTheme theme,
    required IconData icon,
    required Color accent,
    required Color accentDark,
    required String percent,
    required String title,
    required String description,
    required String footnote,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      clipBehavior: Clip.antiAlias,
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  percent,
                  style: GoogleFonts.interTight(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.interTight(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              color: theme.primaryText,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: theme.primaryText,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: accent.withOpacity(0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Icon(Icons.info_outline_rounded,
                      size: 14, color: accentDark),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    footnote,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: accentDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks(FlutterFlowTheme theme, bool isMobile) {
    final steps = <Map<String, dynamic>>[
      {
        'n': '1',
        'icon': Icons.share_rounded,
        'title': 'Compartilhe o link',
        'desc':
            'Envie seu link de indicação para contatos e possíveis investidores.',
      },
      {
        'n': '2',
        'icon': Icons.shopping_cart_checkout_rounded,
        'title': 'Indicado finaliza a compra',
        'desc':
            'O comprador faz o cadastro e finaliza a compra utilizando o seu link.',
      },
      {
        'n': '3',
        'icon': Icons.payments_rounded,
        'title': 'Receba sua comissão',
        'desc':
            'Você recebe comissão por cada franquia adquirida e pelos alunos ativos.',
      },
    ];

    Widget stepCard(Map<String, dynamic> s) {
      return Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
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
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    s['n'] as String,
                    style: GoogleFonts.interTight(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(s['icon'] as IconData, size: 18, color: theme.primary),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              s['title'] as String,
              style: GoogleFonts.interTight(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: theme.primaryText,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              s['desc'] as String,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: theme.secondaryText,
              ),
            ),
          ],
        ),
      );
    }

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
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.lightbulb_rounded,
                    size: 18, color: theme.primary),
              ),
              const SizedBox(width: 10),
              Text(
                'Veja como funciona',
                style: GoogleFonts.interTight(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: theme.primaryText,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isMobile)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                stepCard(steps[0]),
                const SizedBox(height: 12),
                stepCard(steps[1]),
                const SizedBox(height: 12),
                stepCard(steps[2]),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: stepCard(steps[0])),
                const SizedBox(width: 12),
                Expanded(child: stepCard(steps[1])),
                const SizedBox(width: 12),
                Expanded(child: stepCard(steps[2])),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLinkSection(FlutterFlowTheme theme, bool isMobile) {
    final field = TextFormField(
      controller: _model.textController,
      focusNode: _model.textFieldFocusNode,
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
          borderSide: BorderSide(color: theme.primary, width: 1.4),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final copyBtn = InkWell(
      onTap: _handleCopy,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _justCopied ? theme.success : theme.primary,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _justCopied
                  ? Icons.check_rounded
                  : Icons.content_copy_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              _justCopied ? 'Link copiado!' : 'Copiar link',
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
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.link_rounded,
                    size: 18, color: theme.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seu link de indicação',
                      style: GoogleFonts.interTight(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: theme.primaryText,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Copie e compartilhe este link com seus indicados.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: theme.secondaryText,
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
