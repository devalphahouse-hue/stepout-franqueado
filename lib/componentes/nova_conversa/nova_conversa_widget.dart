import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nova_conversa_model.dart';
export 'nova_conversa_model.dart';

const String _kAvatarFallback =
    'https://qmfitknztvxvzpgjyvxf.supabase.co/storage/v1/object/public/geral/Ellipse%2051.png';

String _initials(String? nome) {
  if (nome == null || nome.trim().isEmpty) return '?';
  final partes = nome.trim().split(RegExp(r'\s+'));
  if (partes.length == 1) {
    return partes.first.characters.take(2).toString().toUpperCase();
  }
  return (partes.first.characters.take(1).toString() +
          partes.last.characters.take(1).toString())
      .toUpperCase();
}

// Cores saturadas para chips de role — garantem contraste em qualquer fundo
const Color _kAlunoColor = Color(0xFF1A56DB);
const Color _kProfColor = Color(0xFFB45309);

enum _RoleFilter { todos, alunos, professores }

class NovaConversaWidget extends StatefulWidget {
  const NovaConversaWidget({super.key});

  @override
  State<NovaConversaWidget> createState() => _NovaConversaWidgetState();
}

class _NovaConversaWidgetState extends State<NovaConversaWidget> {
  late NovaConversaModel _model;
  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';
  _RoleFilter _filter = _RoleFilter.todos;
  String? _busyUserId;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NovaConversaModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    EasyDebounce.cancel('nova_conversa_search');
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _abrirChat(dynamic usersItem) async {
    final userId = getJsonField(usersItem, r'''$.id''').toString();
    if (_busyUserId != null) return;
    setState(() => _busyUserId = userId);
    try {
      _model.apiResultclt = await SupabaseGroup.buscarChatCall.call(
        pUserA: userId,
        pUserB: currentUserUid,
        token: currentJwtToken,
      );

      String? targetChatId;
      if (SupabaseGroup.buscarChatCall
              .chatid((_model.apiResultclt?.jsonBody ?? '')) ==
          'false') {
        _model.criarchat = await ChatsTable().insert({
          'user1': currentUserUid,
          'user2': userId,
        });
        targetChatId = _model.criarchat?.id;
      } else {
        targetChatId = SupabaseGroup.buscarChatCall
            .chatid((_model.apiResultclt?.jsonBody ?? ''));
      }

      if (!mounted) return;
      context.goNamed(
        ChatWidget.routeName,
        queryParameters: {
          'chatId': targetChatId ?? '',
        },
        extra: <String, dynamic>{
          '__transition_info__': TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.fade,
            duration: Duration(milliseconds: 0),
          ),
        },
      );
      Navigator.of(context).maybePop();
    } finally {
      if (mounted) setState(() => _busyUserId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            color: Color(0x33000000),
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: FutureBuilder<ApiCallResponse>(
        future: _model.listarContatos(
          requestFn: () => SupabaseGroup.listarContatosChatCall.call(
            token: currentJwtToken,
          ),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                width: 42,
                height: 42,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                ),
              ),
            );
          }
          final response = snapshot.data!;
          final users = response.jsonBody.toList();

          final filtered = users.where((u) {
            final nome = (getJsonField(u, r'''$.nome''')?.toString() ?? '')
                .toLowerCase();
            final email = (getJsonField(u, r'''$.email''')?.toString() ?? '')
                .toLowerCase();
            final role = (getJsonField(u, r'''$.role''')?.toString() ?? '')
                .toLowerCase();

            if (_filter == _RoleFilter.alunos && !role.contains('aluno')) {
              return false;
            }
            if (_filter == _RoleFilter.professores &&
                !role.contains('professor')) {
              return false;
            }
            if (_search.isEmpty) return true;
            return nome.contains(_search) ||
                email.contains(_search) ||
                role.contains(_search);
          }).toList();

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _Header(onClose: () => Navigator.of(context).maybePop()),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Column(
                  children: [
                    _SearchField(
                      controller: _searchCtrl,
                      onChanged: (v) {
                        EasyDebounce.debounce(
                          'nova_conversa_search',
                          Duration(milliseconds: 250),
                          () => setState(
                              () => _search = v.trim().toLowerCase()),
                        );
                      },
                      onClear: () {
                        _searchCtrl.clear();
                        EasyDebounce.cancel('nova_conversa_search');
                        setState(() => _search = '');
                      },
                    ),
                    SizedBox(height: 12),
                    _FilterRow(
                      total: users.length,
                      countAlunos: users
                          .where((u) =>
                              (getJsonField(u, r'''$.role''')?.toString() ?? '')
                                  .toLowerCase()
                                  .contains('aluno'))
                          .length,
                      countProfessores: users
                          .where((u) =>
                              (getJsonField(u, r'''$.role''')?.toString() ?? '')
                                  .toLowerCase()
                                  .contains('professor'))
                          .length,
                      filter: _filter,
                      onChanged: (f) => setState(() => _filter = f),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: theme.alternate),
              Expanded(
                child: filtered.isEmpty
                    ? _EmptyHint(
                        icon: _search.isEmpty
                            ? Icons.contacts_rounded
                            : Icons.search_off_rounded,
                        title: _search.isEmpty
                            ? 'Nenhum usuário disponível'
                            : 'Nenhum usuário encontrado',
                        subtitle: _search.isEmpty
                            ? 'Os usuários disponíveis para conversa aparecerão aqui.'
                            : 'Tente outro termo ou troque o filtro.',
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(16, 14, 16, 20),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8),
                        itemBuilder: (context, idx) {
                          final u = filtered[idx];
                          final id = getJsonField(u, r'''$.id''').toString();
                          return _ContactCard(
                            nome: getJsonField(u, r'''$.nome''')?.toString() ??
                                '',
                            email: getJsonField(u, r'''$.email''')
                                    ?.toString() ??
                                '',
                            role: getJsonField(u, r'''$.role''')?.toString() ??
                                '',
                            imagem: getJsonField(u, r'''$.imagem_perfil''')
                                ?.toString(),
                            busy: _busyUserId == id,
                            onTap: () => _abrirChat(u),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// Sub-widgets
// ============================================================================
class _Header extends StatelessWidget {
  final VoidCallback onClose;
  const _Header({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 18, 14, 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.add_comment_rounded,
                color: theme.primary, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Iniciar nova conversa',
                  style: GoogleFonts.interTight(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: theme.primaryText,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Escolha um aluno ou professor para começar a conversar.',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: theme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          _CloseButton(onTap: onClose),
        ],
      ),
    );
  }
}

class _CloseButton extends StatefulWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Tooltip(
      message: 'Fechar',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedScale(
          duration: Duration(milliseconds: 120),
          scale: _hover ? 0.96 : 1.0,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hover
                  ? theme.error.withValues(alpha: 0.12)
                  : theme.secondaryBackground,
              border: Border.all(color: theme.alternate),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: CircleBorder(),
                onTap: widget.onTap,
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: _hover ? theme.error : theme.secondaryText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  bool _hover = false;
  bool _focus = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _focus = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasText = widget.controller.text.isNotEmpty;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _focus
                ? theme.primary.withValues(alpha: 0.55)
                : (_hover
                    ? theme.primary.withValues(alpha: 0.4)
                    : theme.alternate),
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.search_rounded,
                  size: 20, color: theme.secondaryText),
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                onChanged: (v) {
                  setState(() {});
                  widget.onChanged(v);
                },
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: theme.primaryText,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar por nome, email ou cargo…',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: theme.secondaryText,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            if (hasText)
              IconButton(
                onPressed: widget.onClear,
                icon: Icon(Icons.close_rounded,
                    size: 18, color: theme.secondaryText),
                splashRadius: 20,
                tooltip: 'Limpar',
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final int total;
  final int countAlunos;
  final int countProfessores;
  final _RoleFilter filter;
  final ValueChanged<_RoleFilter> onChanged;
  const _FilterRow({
    required this.total,
    required this.countAlunos,
    required this.countProfessores,
    required this.filter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterChip(
          label: 'Todos',
          count: total,
          icon: Icons.groups_rounded,
          active: filter == _RoleFilter.todos,
          onTap: () => onChanged(_RoleFilter.todos),
          baseColorRoleAluno: false,
        ),
        SizedBox(width: 8),
        _FilterChip(
          label: 'Alunos',
          count: countAlunos,
          icon: Icons.person_rounded,
          active: filter == _RoleFilter.alunos,
          onTap: () => onChanged(_RoleFilter.alunos),
          baseColorRoleAluno: true,
        ),
        SizedBox(width: 8),
        _FilterChip(
          label: 'Professores',
          count: countProfessores,
          icon: Icons.school_rounded,
          active: filter == _RoleFilter.professores,
          onTap: () => onChanged(_RoleFilter.professores),
          baseColorRoleAluno: false,
          warningColor: true,
        ),
      ],
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final int count;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final bool baseColorRoleAluno;
  final bool warningColor;
  const _FilterChip({
    required this.label,
    required this.count,
    required this.icon,
    required this.active,
    required this.onTap,
    this.baseColorRoleAluno = false,
    this.warningColor = false,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    // Cores saturadas: aluno=azul, professor=âmbar, todos=primary (verde)
    final base = widget.warningColor
        ? _kProfColor
        : (widget.baseColorRoleAluno ? _kAlunoColor : theme.primary);
    final bg = widget.active
        ? base
        : (_hover ? theme.secondaryBackground : theme.primaryBackground);
    final fg = widget.active ? Colors.white : theme.primaryText;
    final borderColor = widget.active
        ? base
        : theme.alternate;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: widget.onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, size: 14, color: fg),
                  SizedBox(width: 6),
                  Text(
                    widget.label,
                    style: GoogleFonts.interTight(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: fg,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(width: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.active
                          ? Colors.white.withValues(alpha: 0.25)
                          : theme.primaryText.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      widget.count.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  final String nome;
  final String email;
  final String role;
  final String? imagem;
  final bool busy;
  final VoidCallback onTap;

  const _ContactCard({
    required this.nome,
    required this.email,
    required this.role,
    required this.imagem,
    required this.busy,
    required this.onTap,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isAluno = widget.role.toLowerCase().contains('aluno');
    final base = isAluno ? _kAlunoColor : _kProfColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: Duration(milliseconds: 120),
        scale: _hover ? 0.99 : 1.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hover
                  ? theme.primary.withValues(alpha: 0.45)
                  : theme.alternate,
              width: 1.2,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      blurRadius: 10,
                      color: theme.primary.withValues(alpha: 0.10),
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: widget.busy ? null : widget.onTap,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _Avatar(
                      nome: widget.nome,
                      imagem: widget.imagem,
                      size: 50,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.nome.isEmpty ? '—' : widget.nome,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.interTight(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: theme.primaryText,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: base,
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: base.withValues(alpha: 0.25),
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isAluno
                                          ? Icons.person_rounded
                                          : Icons.school_rounded,
                                      size: 11,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      widget.role.isEmpty
                                          ? 'Usuário'
                                          : widget.role,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (widget.email.isNotEmpty) ...[
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.alternate_email_rounded,
                                    size: 12, color: theme.secondaryText),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: theme.secondaryText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    _OpenChatButton(
                      busy: widget.busy,
                      hoverParent: _hover,
                      onTap: widget.onTap,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OpenChatButton extends StatelessWidget {
  final bool busy;
  final bool hoverParent;
  final VoidCallback onTap;
  const _OpenChatButton({
    required this.busy,
    required this.hoverParent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final highlight = hoverParent && !busy;
    return AnimatedContainer(
      duration: Duration(milliseconds: 160),
      decoration: BoxDecoration(
        color: busy
            ? theme.alternate
            : (highlight
                ? theme.primary
                : theme.primary.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(999),
        boxShadow: highlight
            ? [
                BoxShadow(
                  blurRadius: 10,
                  color: theme.primary.withValues(alpha: 0.30),
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: busy ? null : onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (busy)
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          theme.secondaryText),
                    ),
                  )
                else
                  Icon(
                    Icons.send_rounded,
                    size: 14,
                    color: highlight ? Colors.white : theme.primary,
                  ),
                SizedBox(width: 6),
                Text(
                  busy ? 'Abrindo…' : 'Abrir chat',
                  style: GoogleFonts.interTight(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: busy
                        ? theme.secondaryText
                        : (highlight ? Colors.white : theme.primary),
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

class _Avatar extends StatelessWidget {
  final String? nome;
  final String? imagem;
  final double size;
  const _Avatar({
    required this.nome,
    required this.imagem,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasImg =
        imagem != null && imagem!.isNotEmpty && imagem != _kAvatarFallback;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.primary.withValues(alpha: 0.12),
        image: hasImg
            ? DecorationImage(
                image: NetworkImage(imagem!),
                fit: BoxFit.cover,
              )
            : null,
        border: Border.all(
          color: theme.primary.withValues(alpha: 0.20),
          width: 1.2,
        ),
      ),
      alignment: Alignment.center,
      child: hasImg
          ? null
          : Text(
              _initials(nome),
              style: GoogleFonts.interTight(
                fontSize: size * 0.34,
                fontWeight: FontWeight.w800,
                color: theme.primary,
              ),
            ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyHint({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: theme.primary),
            ),
            SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.interTight(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: theme.primaryText,
              ),
            ),
            SizedBox(height: 4),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 320),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: theme.secondaryText,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
