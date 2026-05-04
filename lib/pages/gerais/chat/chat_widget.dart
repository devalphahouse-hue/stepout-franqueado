import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/nova_conversa/nova_conversa_widget.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'chat_model.dart';
export 'chat_model.dart';

const String _kAvatarFallback =
    'https://qmfitknztvxvzpgjyvxf.supabase.co/storage/v1/object/public/geral/Ellipse%2051.png';

String _formatHora(DateTime? dtRaw) {
  if (dtRaw == null) return '';
  final dt = dtRaw.toLocal();
  return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

String _formatChatPreview(DateTime? dtRaw) {
  if (dtRaw == null) return '';
  final dt = dtRaw.toLocal();
  final agora = DateTime.now();
  final hoje = DateTime(agora.year, agora.month, agora.day);
  final dia = DateTime(dt.year, dt.month, dt.day);
  if (dia == hoje) return _formatHora(dt);
  final ontem = hoje.subtract(const Duration(days: 1));
  if (dia == ontem) return 'Ontem';
  return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
}

String _dateChipLabel(DateTime dtRaw) {
  final dt = dtRaw.toLocal();
  final agora = DateTime.now();
  final hoje = DateTime(agora.year, agora.month, agora.day);
  final dia = DateTime(dt.year, dt.month, dt.day);
  if (dia == hoje) return 'Hoje';
  final ontem = hoje.subtract(const Duration(days: 1));
  if (dia == ontem) return 'Ontem';
  return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

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

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  static String routeName = 'Chat';
  static String routePath = '/chat';

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? _streamChatId;
  Stream<List<MensagensChatsRow>>? _msgStream;

  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';

  final ScrollController _msgScroll = ScrollController();

  Stream<List<MensagensChatsRow>>? _streamForChat(String chatId) {
    if (chatId.isEmpty) return null;
    if (_streamChatId != chatId) {
      _streamChatId = chatId;
      _msgStream = SupaFlow.client
          .from('mensagens_chats')
          .stream(primaryKey: ['id'])
          .eqOrNull('chat_id', chatId)
          .map((list) => list.map((item) => MensagensChatsRow(item)).toList());
    }
    return _msgStream;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatModel());

    _model.tfMobileTextController ??= TextEditingController();
    _model.tfMobileFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _msgScroll.dispose();
    EasyDebounce.cancel('chat_search');
    EasyDebounce.cancel('_model.tfMobileTextController');
    _model.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_msgScroll.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_msgScroll.hasClients) return;
      _msgScroll.animateTo(
        _msgScroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _enviarMensagem(String chatIdAtual) async {
    final text = (_model.tfMobileTextController?.text ?? '').trim();
    if (text.isEmpty) return;
    _model.tfMobileTextController?.clear();
    safeSetState(() {});
    await MensagensChatsTable().insert({
      'sender_id': currentUserUid,
      'chat_id': chatIdAtual,
      'conteudo': text,
    });
    _model.clearListaChatsCache();
    _model.apiRequestCompleted = false;
    safeSetState(() {});
    await _model.waitForApiRequestCompleted();
    if (!mounted) return;
    safeSetState(() {});
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    final chatIdAtual =
        GoRouterState.of(context).uri.queryParameters['chatId'] ?? '';

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
                child: SidebarWidget(route: 'Chat'),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: FutureBuilder<ApiCallResponse>(
                    future: _model
                        .listaChats(
                      requestFn: () => SupabaseGroup.listaChatsAbertosCall.call(
                        pUserId: currentUserUid,
                        token: currentJwtToken,
                      ),
                    )
                        .then((result) {
                      _model.apiRequestCompleted = true;
                      return result;
                    }),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
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
                      final meusChatsRaw = ((response.jsonBody
                                      .toList()
                                      .map<ChatAtivoStruct?>(
                                          ChatAtivoStruct.maybeFromMap)
                                      .toList()
                                  as Iterable<ChatAtivoStruct?>)
                              .withoutNulls
                              ?.toList()) ??
                          [];

                      // Dedup
                      final seen = <String>{};
                      final meusChats = <ChatAtivoStruct>[];
                      for (final c in meusChatsRaw) {
                        final cid = c.chatId;
                        if (cid != null && cid.isNotEmpty && seen.add(cid)) {
                          meusChats.add(c);
                        }
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Coluna esquerda — lista de chats
                          SizedBox(
                            width: 340,
                            child: _ChatListPanel(
                              chats: meusChats,
                              chatIdAtual: chatIdAtual,
                              searchCtrl: _searchCtrl,
                              search: _search,
                              onSearchChanged: (v) {
                                EasyDebounce.debounce(
                                  'chat_search',
                                  Duration(milliseconds: 250),
                                  () => safeSetState(() => _search = v.trim().toLowerCase()),
                                );
                              },
                              onSearchClear: () {
                                _searchCtrl.clear();
                                EasyDebounce.cancel('chat_search');
                                safeSetState(() => _search = '');
                              },
                              onTapChat: (chat) async {
                                context.goNamed(
                                  ChatWidget.routeName,
                                  queryParameters: {
                                    'chatId': chat.chatId ?? '',
                                  },
                                );
                                await MensagensChatsTable().update(
                                  data: {'lida': true},
                                  matchingRows: (rows) => rows
                                      .eqOrNull('chat_id', chat.chatId)
                                      .neq('sender_id', currentUserUid),
                                );
                              },
                              onNovoChat: () async {
                                await showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      elevation: 0,
                                      insetPadding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      alignment: Alignment.center,
                                      child: WebViewAware(
                                        child: GestureDetector(
                                          onTap: () {
                                            FocusScope.of(dialogContext).unfocus();
                                            FocusManager.instance.primaryFocus?.unfocus();
                                          },
                                          child: SizedBox(
                                            height: MediaQuery.sizeOf(context).height * 0.75,
                                            width: MediaQuery.sizeOf(context).width * 0.45,
                                            child: NovaConversaWidget(),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          // Coluna direita — conversa
                          Expanded(
                            child: _ChatConversationPanel(
                              chatIdAtual: chatIdAtual,
                              chatAtual: chatIdAtual.isEmpty
                                  ? null
                                  : meusChats.firstWhere(
                                      (e) => e.chatId == chatIdAtual,
                                      orElse: () => meusChats.isNotEmpty
                                          ? meusChats.first
                                          : ChatAtivoStruct(),
                                    ),
                              streamForChat: _streamForChat,
                              msgScrollController: _msgScroll,
                              messageController: _model.tfMobileTextController!,
                              messageFocus: _model.tfMobileFocusNode!,
                              onChangedMessage: () => safeSetState(() {}),
                              onEnviar: () => _enviarMensagem(chatIdAtual),
                            ),
                          ),
                        ],
                      );
                    },
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

// ============================================================================
// CHAT LIST PANEL (coluna esquerda)
// ============================================================================
class _ChatListPanel extends StatelessWidget {
  final List<ChatAtivoStruct> chats;
  final String chatIdAtual;
  final TextEditingController searchCtrl;
  final String search;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final ValueChanged<ChatAtivoStruct> onTapChat;
  final VoidCallback onNovoChat;

  const _ChatListPanel({
    required this.chats,
    required this.chatIdAtual,
    required this.searchCtrl,
    required this.search,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onTapChat,
    required this.onNovoChat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final chatIds = chats.map((c) => c.chatId!).toList();

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Color(0x14000000),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.forum_rounded, color: theme.primary, size: 18),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Chats ativos',
                        style: GoogleFonts.interTight(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: theme.primaryText,
                        ),
                      ),
                      Text(
                        '${chats.length} ${chats.length == 1 ? "conversa" : "conversas"}',
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
          ),
          // Search
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _SearchField(
              controller: searchCtrl,
              onChanged: onSearchChanged,
              onClear: onSearchClear,
            ),
          ),
          SizedBox(height: 12),
          // Lista
          Expanded(
            child: chatIds.isEmpty
                ? _EmptyHint(
                    icon: Icons.forum_outlined,
                    title: 'Nenhum chat ainda',
                    subtitle: 'Toque em "Novo chat" para começar uma conversa.',
                  )
                : StreamBuilder<List<MensagensChatsRow>>(
                    stream: SupaFlow.client
                        .from('mensagens_chats')
                        .stream(primaryKey: ['id'])
                        .inFilter('chat_id', chatIds)
                        .map((list) => list
                            .map((item) => MensagensChatsRow(item))
                            .toList()),
                    builder: (context, msgSnapshot) {
                      final allMessages = msgSnapshot.data ?? [];
                      final unreadCounts = <String, int>{};
                      final lastTimes = <String, DateTime>{};
                      final lastTexts = <String, String>{};
                      final lastSenders = <String, String?>{};
                      for (final msg in allMessages) {
                        final cid = msg.chatId ?? '';
                        if (cid.isEmpty) continue;
                        final t = msg.createdAt;
                        if (!lastTimes.containsKey(cid) ||
                            t.isAfter(lastTimes[cid]!)) {
                          lastTimes[cid] = t;
                          lastTexts[cid] = msg.conteudo ?? '';
                          lastSenders[cid] = msg.senderId;
                        }
                        if (msg.senderId != currentUserUid && msg.lida != true) {
                          unreadCounts[cid] = (unreadCounts[cid] ?? 0) + 1;
                        }
                      }

                      // Ordenar por última mensagem
                      final sorted = [...chats]..sort((a, b) {
                          final ta = lastTimes[a.chatId];
                          final tb = lastTimes[b.chatId];
                          if (ta == null && tb == null) return 0;
                          if (ta == null) return 1;
                          if (tb == null) return -1;
                          return tb.compareTo(ta);
                        });

                      // Filtrar pelo search
                      final filtered = search.isEmpty
                          ? sorted
                          : sorted.where((c) {
                              final n = (c.otherUser.nome ?? '').toLowerCase();
                              final t = (c.turma ?? '').toLowerCase();
                              return n.contains(search) || t.contains(search);
                            }).toList();

                      if (filtered.isEmpty) {
                        return _EmptyHint(
                          icon: Icons.search_off_rounded,
                          title: 'Nenhuma conversa encontrada',
                          subtitle: 'Tente outro termo de busca.',
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => SizedBox(height: 6),
                        itemBuilder: (context, idx) {
                          final c = filtered[idx];
                          final cid = c.chatId ?? '';
                          return _ChatListItem(
                            chat: c,
                            active: cid == chatIdAtual,
                            unread: unreadCounts[cid] ?? 0,
                            lastTime: lastTimes[cid],
                            lastText: lastTexts[cid],
                            lastFromMe:
                                lastSenders[cid] == currentUserUid,
                            onTap: () => onTapChat(c),
                          );
                        },
                      );
                    },
                  ),
          ),
          // Botão novo chat
          Padding(
            padding: EdgeInsets.all(12),
            child: _PrimaryButton(
              icon: Icons.add_comment_rounded,
              label: 'Iniciar novo chat',
              onTap: onNovoChat,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatListItem extends StatefulWidget {
  final ChatAtivoStruct chat;
  final bool active;
  final int unread;
  final DateTime? lastTime;
  final String? lastText;
  final bool lastFromMe;
  final VoidCallback onTap;
  const _ChatListItem({
    required this.chat,
    required this.active,
    required this.unread,
    required this.lastTime,
    required this.lastText,
    required this.lastFromMe,
    required this.onTap,
  });

  @override
  State<_ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<_ChatListItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final chat = widget.chat;
    final nome = chat.otherUser.nome ?? 'Usuário';
    final role = chat.otherUser.role ?? '';
    final turma = (chat.turma ?? '').replaceAll(RegExp(r'\s*/\s*$'), '').trim();
    final isAluno = role.toLowerCase().contains('aluno');

    final bg = widget.active
        ? theme.primary.withValues(alpha: 0.10)
        : (_hover ? theme.alternate.withValues(alpha: 0.45) : Colors.transparent);
    final borderColor = widget.active
        ? theme.primary.withValues(alpha: 0.35)
        : Colors.transparent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onTap,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Avatar(
                    nome: nome,
                    imagem: chat.otherUser.imagemPerfil,
                    size: 46,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                nome,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.interTight(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: theme.primaryText,
                                ),
                              ),
                            ),
                            if (widget.lastTime != null)
                              Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text(
                                  _formatChatPreview(widget.lastTime),
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    color: widget.unread > 0
                                        ? theme.primary
                                        : theme.secondaryText,
                                    fontWeight: widget.unread > 0
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            _RoleChip(
                              role: role,
                              isAluno: isAluno,
                              solid: widget.active,
                            ),
                            if (turma.isNotEmpty) ...[
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  '· $turma',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryText
                                        .withValues(alpha: 0.65),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.lastText == null ||
                                        widget.lastText!.isEmpty
                                    ? 'Nenhuma mensagem ainda'
                                    : (widget.lastFromMe
                                        ? 'Você: ${widget.lastText!}'
                                        : widget.lastText!),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: widget.unread > 0
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: widget.unread > 0
                                      ? theme.primaryText
                                      : theme.secondaryText,
                                ),
                              ),
                            ),
                            if (widget.unread > 0)
                              Container(
                                margin: EdgeInsets.only(left: 6),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                constraints: BoxConstraints(minWidth: 20),
                                decoration: BoxDecoration(
                                  color: theme.primary,
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 6,
                                      color: theme.primary
                                          .withValues(alpha: 0.30),
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.unread > 99
                                      ? '99+'
                                      : widget.unread.toString(),
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
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

// ============================================================================
// CONVERSATION PANEL (coluna direita)
// ============================================================================
class _ChatConversationPanel extends StatelessWidget {
  final String chatIdAtual;
  final ChatAtivoStruct? chatAtual;
  final Stream<List<MensagensChatsRow>>? Function(String) streamForChat;
  final ScrollController msgScrollController;
  final TextEditingController messageController;
  final FocusNode messageFocus;
  final VoidCallback onChangedMessage;
  final VoidCallback onEnviar;

  const _ChatConversationPanel({
    required this.chatIdAtual,
    required this.chatAtual,
    required this.streamForChat,
    required this.msgScrollController,
    required this.messageController,
    required this.messageFocus,
    required this.onChangedMessage,
    required this.onEnviar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Color(0x14000000),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (chatAtual != null && chatIdAtual.isNotEmpty)
            _ConversationHeader(chat: chatAtual!),
          if (chatAtual != null && chatIdAtual.isNotEmpty)
            Container(height: 1, color: theme.alternate),
          Expanded(
            child: chatIdAtual.isEmpty
                ? _EmptyConversation()
                : StreamBuilder<List<MensagensChatsRow>>(
                    stream: streamForChat(chatIdAtual),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                            ),
                          ),
                        );
                      }
                      final mensagens = snapshot.data!;
                      mensagens.sort((a, b) => a.createdAt.compareTo(b.createdAt));

                      if (mensagens.isEmpty) {
                        return _EmptyHint(
                          icon: Icons.waving_hand_rounded,
                          title: 'Diga olá',
                          subtitle: 'Esta conversa ainda não tem mensagens. Mande a primeira!',
                        );
                      }

                      // auto-scroll para o fim quando chega nova mensagem
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (msgScrollController.hasClients) {
                          msgScrollController.jumpTo(
                            msgScrollController.position.maxScrollExtent,
                          );
                        }
                      });

                      // Agrupamento por dia
                      final widgets = <Widget>[];
                      DateTime? lastDate;
                      for (final m in mensagens) {
                        final dt = m.createdAt.toLocal();
                        final dia = DateTime(dt.year, dt.month, dt.day);
                        if (lastDate == null || dia != lastDate) {
                          widgets.add(_DateDivider(label: _dateChipLabel(dt)));
                          lastDate = dia;
                        }
                        widgets.add(_MessageBubble(
                          mensagem: m,
                          isMine: m.senderId == currentUserUid,
                          chat: chatAtual,
                        ));
                      }

                      return ListView(
                        controller: msgScrollController,
                        padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                        children: widgets,
                      );
                    },
                  ),
          ),
          if (chatIdAtual.isNotEmpty)
            _MessageInput(
              controller: messageController,
              focusNode: messageFocus,
              onChanged: onChangedMessage,
              onEnviar: onEnviar,
            ),
        ],
      ),
    );
  }
}

// Cores saturadas para chips de role — garantem contraste em qualquer fundo
const Color _kAlunoColor = Color(0xFF1A56DB); // azul saturado (blue-700)
const Color _kAlunoColorDark = Color(0xFF1E40AF); // blue-800 para active
const Color _kProfColor = Color(0xFFB45309); // âmbar saturado (amber-700)
const Color _kProfColorDark = Color(0xFF92400E); // amber-800 para active

class _RoleChip extends StatelessWidget {
  final String role;
  final bool isAluno;
  final double fontSize;
  final EdgeInsets padding;
  final bool solid;
  const _RoleChip({
    required this.role,
    required this.isAluno,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    this.solid = false,
  });

  @override
  Widget build(BuildContext context) {
    // Chip SEMPRE sólido com cor saturada e texto branco — garante leitura.
    final base = solid
        ? (isAluno ? _kAlunoColorDark : _kProfColorDark)
        : (isAluno ? _kAlunoColor : _kProfColor);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            blurRadius: solid ? 8 : 4,
            color: base.withValues(alpha: solid ? 0.40 : 0.25),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAluno ? Icons.person_rounded : Icons.school_rounded,
            size: fontSize + 1,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            role.isEmpty ? 'Usuário' : role,
            style: GoogleFonts.inter(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationHeader extends StatelessWidget {
  final ChatAtivoStruct chat;
  const _ConversationHeader({required this.chat});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final nome = chat.otherUser.nome ?? 'Usuário';
    final role = chat.otherUser.role ?? '';
    final turma = (chat.turma ?? '').replaceAll(RegExp(r'\s*/\s*$'), '').trim();
    final isAluno = role.toLowerCase().contains('aluno');

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 16, 16),
      child: Row(
        children: [
          _Avatar(
            nome: nome,
            imagem: chat.otherUser.imagemPerfil,
            size: 56,
            withRing: true,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.interTight(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: theme.primaryText,
                  ),
                ),
                SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _RoleChip(role: role, isAluno: isAluno, fontSize: 12),
                    if (turma.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: theme.alternate),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.groups_rounded,
                                size: 13, color: theme.primaryText),
                            SizedBox(width: 5),
                            Text(
                              turma,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: theme.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateDivider extends StatelessWidget {
  final String label;
  const _DateDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: theme.alternate)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: theme.alternate),
              ),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: theme.secondaryText,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: theme.alternate)),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MensagensChatsRow mensagem;
  final bool isMine;
  final ChatAtivoStruct? chat;
  const _MessageBubble({
    required this.mensagem,
    required this.isMine,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final conteudo = mensagem.conteudo ?? '';

    final bubble = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.42,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: isMine
              ? LinearGradient(
                  colors: [
                    theme.primary,
                    theme.primary.withValues(alpha: 0.92),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isMine ? null : theme.secondaryBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
          border: isMine
              ? null
              : Border.all(color: theme.alternate),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: isMine
                  ? theme.primary.withValues(alpha: 0.18)
                  : Color(0x10000000),
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              conteudo,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: isMine ? Colors.white : theme.primaryText,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatHora(mensagem.createdAt),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isMine
                    ? Colors.white.withValues(alpha: 0.8)
                    : theme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine && chat != null) ...[
            _Avatar(
              nome: chat!.otherUser.nome,
              imagem: chat!.otherUser.imagemPerfil,
              size: 28,
            ),
            SizedBox(width: 8),
          ],
          if (isMine) Spacer(),
          Flexible(child: bubble),
          if (!isMine) Spacer(),
        ],
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onChanged;
  final VoidCallback onEnviar;

  const _MessageInput({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onEnviar,
  });

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  bool _focus = false;
  bool _hoverSend = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _focus = widget.focusNode.hasFocus);
  }

  bool get _hasText => widget.controller.text.trim().isNotEmpty;

  void _handleEnviar() {
    if (!_hasText) return;
    widget.onEnviar();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _focus
                      ? theme.primary.withValues(alpha: 0.55)
                      : theme.alternate,
                  width: 1.4,
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 140),
                child: Shortcuts(
                  shortcuts: <LogicalKeySet, Intent>{
                    LogicalKeySet(LogicalKeyboardKey.enter):
                        const _SendIntent(),
                    LogicalKeySet(LogicalKeyboardKey.shift,
                        LogicalKeyboardKey.enter): const _NewLineIntent(),
                  },
                  child: Actions(
                    actions: <Type, Action<Intent>>{
                      _SendIntent: CallbackAction<_SendIntent>(
                        onInvoke: (_) {
                          _handleEnviar();
                          return null;
                        },
                      ),
                      _NewLineIntent: CallbackAction<_NewLineIntent>(
                        onInvoke: (_) {
                          final ctrl = widget.controller;
                          final s = ctrl.selection;
                          final text = ctrl.text;
                          final start = s.start < 0 ? text.length : s.start;
                          final end = s.end < 0 ? text.length : s.end;
                          ctrl.text = text.replaceRange(start, end, '\n');
                          ctrl.selection = TextSelection.collapsed(
                              offset: start + 1);
                          widget.onChanged();
                          return null;
                        },
                      ),
                    },
                    child: TextField(
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      onChanged: (_) {
                        EasyDebounce.debounce(
                          '_model.tfMobileTextController',
                          Duration(milliseconds: 150),
                          () => widget.onChanged(),
                        );
                      },
                      maxLines: null,
                      minLines: 1,
                      textInputAction: TextInputAction.newline,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: theme.primaryText,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Digite sua mensagem…',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: theme.secondaryText,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          MouseRegion(
            cursor: _hasText
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            onEnter: (_) => setState(() => _hoverSend = true),
            onExit: (_) => setState(() => _hoverSend = false),
            child: AnimatedScale(
              duration: Duration(milliseconds: 120),
              scale: (_hoverSend && _hasText) ? 0.96 : 1.0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 160),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _hasText
                      ? theme.primary
                      : theme.alternate.withValues(alpha: 0.6),
                  boxShadow: _hasText
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
                    customBorder: CircleBorder(),
                    onTap: _hasText ? _handleEnviar : null,
                    child: Icon(
                      Icons.send_rounded,
                      color: _hasText
                          ? Colors.white
                          : theme.secondaryText,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SendIntent extends Intent {
  const _SendIntent();
}

class _NewLineIntent extends Intent {
  const _NewLineIntent();
}

// ============================================================================
// Helpers visuais
// ============================================================================
class _Avatar extends StatelessWidget {
  final String? nome;
  final String? imagem;
  final double size;
  final bool withRing;
  const _Avatar({
    required this.nome,
    required this.imagem,
    required this.size,
    this.withRing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasImg = imagem != null && imagem!.isNotEmpty && imagem != _kAvatarFallback;

    final core = Container(
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
      ),
      alignment: Alignment.center,
      child: hasImg
          ? null
          : Text(
              _initials(nome),
              style: GoogleFonts.interTight(
                fontSize: size * 0.36,
                fontWeight: FontWeight.w800,
                color: theme.primary,
              ),
            ),
    );

    if (!withRing) return core;
    return Container(
      padding: EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            theme.primary,
            theme.primary.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.primaryBackground,
        ),
        padding: EdgeInsets.all(2),
        child: core,
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
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: _hover
                ? theme.primary.withValues(alpha: 0.4)
                : theme.alternate,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.search_rounded,
                  size: 18, color: theme.secondaryText),
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                onChanged: (v) {
                  setState(() {});
                  widget.onChanged(v);
                },
                style: GoogleFonts.inter(
                    fontSize: 13.5, color: theme.primaryText),
                decoration: InputDecoration(
                  hintText: 'Buscar conversa…',
                  hintStyle: GoogleFonts.inter(
                      fontSize: 13.5, color: theme.secondaryText),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            if (hasText)
              IconButton(
                onPressed: widget.onClear,
                icon: Icon(Icons.close_rounded,
                    size: 16, color: theme.secondaryText),
                splashRadius: 18,
                tooltip: 'Limpar',
              ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: Duration(milliseconds: 120),
        scale: _hover ? 0.98 : 1.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 160),
          width: double.infinity,
          decoration: BoxDecoration(
            color: _hover ? theme.primary : theme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hover
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
              borderRadius: BorderRadius.circular(12),
              onTap: widget.onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon,
                        size: 18,
                        color: _hover ? Colors.white : theme.primary),
                    SizedBox(width: 8),
                    Text(
                      widget.label,
                      style: GoogleFonts.interTight(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _hover ? Colors.white : theme.primary,
                        letterSpacing: 0.2,
                      ),
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 26, color: theme.primary),
            ),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.interTight(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: theme.primaryText,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: theme.secondaryText,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyConversation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    theme.primary.withValues(alpha: 0.12),
                    theme.primary.withValues(alpha: 0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.forum_rounded,
                size: 42,
                color: theme.primary,
              ),
            ),
            SizedBox(height: 18),
            Text(
              'Selecione uma conversa',
              textAlign: TextAlign.center,
              style: GoogleFonts.interTight(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: theme.primaryText,
              ),
            ),
            SizedBox(height: 6),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 360),
              child: Text(
                'Escolha um chat na lista ao lado para começar a conversar com alunos e professores.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: theme.secondaryText,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
