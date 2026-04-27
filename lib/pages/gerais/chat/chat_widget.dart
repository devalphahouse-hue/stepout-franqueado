import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/empty_list/empty_list_widget.dart';
import '/componentes/nova_conversa/nova_conversa_widget.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'chat_model.dart';
export 'chat_model.dart';

String _formatarHoraMensagem(DateTime? dtRaw) {
  if (dtRaw == null) return '';
  final dt = dtRaw.toLocal();
  final agora = DateTime.now();
  final hoje = DateTime(agora.year, agora.month, agora.day);
  final dia = DateTime(dt.year, dt.month, dt.day);
  final hora = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  if (dia == hoje) return hora;
  final ontem = hoje.subtract(const Duration(days: 1));
  if (dia == ontem) return 'Ontem $hora';
  return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} $hora';
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
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wrapWithModel(
                model: _model.sidebarModel,
                updateCallback: () => safeSetState(() {}),
                child: SidebarWidget(
                  route: 'Chat',
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                        child: FutureBuilder<ApiCallResponse>(
                          future: _model
                              .listaChats(
                            requestFn: () =>
                                SupabaseGroup.listaChatsAbertosCall.call(
                              pUserId: currentUserUid,
                              token: currentJwtToken,
                            ),
                          )
                              .then((result) {
                            _model.apiRequestCompleted = true;
                            return result;
                          }),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              );
                            }
                            final rowListaChatsAbertosResponse = snapshot.data!;

                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Container(
                                    height:
                                        MediaQuery.sizeOf(context).height * 1.0,
                                    decoration: BoxDecoration(),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 2.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.2,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              1.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, 0.0),
                                                        child: Text(
                                                          'Chats ativos',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineSmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmall
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Builder(
                                                          builder: (context) {
                                                            // Lista de chats vinda do RPC (pode ter duplicatas: aluno em N turmas vira N linhas no LEFT JOIN)
                                                            final meusChatsRaw = (rowListaChatsAbertosResponse
                                                                        .jsonBody
                                                                        .toList()
                                                                        .map<ChatAtivoStruct?>(
                                                                            ChatAtivoStruct.maybeFromMap)
                                                                        .toList() as Iterable<ChatAtivoStruct?>)
                                                                    .withoutNulls
                                                                    ?.toList() ??
                                                                [];

                                                            final seenChatIds = <String>{};
                                                            final meusChats = <ChatAtivoStruct>[];
                                                            for (final c in meusChatsRaw) {
                                                              final cid = c.chatId;
                                                              if (cid != null && cid.isNotEmpty && seenChatIds.add(cid)) {
                                                                meusChats.add(c);
                                                              }
                                                            }

                                                            if (meusChats.isEmpty) {
                                                              return EmptyListWidget(
                                                                texto:
                                                                    'Nenhum chat ativo',
                                                              );
                                                            }

                                                            // RLS de mensagens_chats está aberta; o filtro abaixo evita receber mensagens de chats que não são deste usuário
                                                            final chatIds = meusChats.map((c) => c.chatId!).toList();

                                                            return StreamBuilder<List<MensagensChatsRow>>(
                                                              stream: SupaFlow
                                                                  .client
                                                                  .from('mensagens_chats')
                                                                  .stream(primaryKey: ['id'])
                                                                  .inFilter('chat_id', chatIds)
                                                                  .map((list) => list
                                                                      .map((item) => MensagensChatsRow(item))
                                                                      .toList()),
                                                              builder: (context, msgSnapshot) {
                                                                final allMessages = msgSnapshot.data ?? [];

                                                                // Build unread counts and last message time per chat
                                                            final Map<String, int> unreadCounts = {};
                                                            final Map<String, DateTime> lastMessageTimes = {};
                                                            for (final msg in allMessages) {
                                                              final chatId = msg.chatId ?? '';
                                                              if (chatId.isEmpty) continue;
                                                              // Last message time
                                                              final msgTime = msg.createdAt;
                                                              if (!lastMessageTimes.containsKey(chatId) ||
                                                                  msgTime.isAfter(lastMessageTimes[chatId]!)) {
                                                                lastMessageTimes[chatId] = msgTime;
                                                              }
                                                              // Unread count
                                                              if (msg.senderId != currentUserUid &&
                                                                  msg.lida != true) {
                                                                unreadCounts[chatId] = (unreadCounts[chatId] ?? 0) + 1;
                                                              }
                                                            }

                                                            // Sort by last message time (most recent first)
                                                            meusChats.sort((a, b) {
                                                              final timeA = lastMessageTimes[a.chatId];
                                                              final timeB = lastMessageTimes[b.chatId];
                                                              if (timeA == null && timeB == null) return 0;
                                                              if (timeA == null) return 1;
                                                              if (timeB == null) return -1;
                                                              return timeB.compareTo(timeA);
                                                            });

                                                            return SingleChildScrollView(
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: List.generate(
                                                                        meusChats
                                                                            .length,
                                                                        (meusChatsIndex) {
                                                                  final meusChatsItem =
                                                                      meusChats[
                                                                          meusChatsIndex];
                                                                  final unreadCount = unreadCounts[meusChatsItem.chatId] ?? 0;
                                                                  final lastMsgTime = lastMessageTimes[meusChatsItem.chatId];
                                                                  return Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        InkWell(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      focusColor:
                                                                          Colors
                                                                              .transparent,
                                                                      hoverColor:
                                                                          Colors
                                                                              .transparent,
                                                                      highlightColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onTap:
                                                                          () async {
                                                                        FFAppState().chatId =
                                                                            meusChatsItem.chatId;
                                                                        FFAppState()
                                                                            .update(() {});
                                                                        safeSetState(() {});

                                                                        // Marcar mensagens como lidas. Sem filtro de "lida=false" porque o filtro .neq('lida', true) não pega mensagens com lida=NULL (NULL <> true é NULL em SQL).
                                                                        await MensagensChatsTable().update(
                                                                          data: {'lida': true},
                                                                          matchingRows: (rows) => rows
                                                                              .eqOrNull('chat_id', meusChatsItem.chatId)
                                                                              .neq('sender_id', currentUserUid),
                                                                        );
                                                                      },
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        elevation:
                                                                            2.0,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(12.0),
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(12.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Container(
                                                                                  width: 72.0,
                                                                                  height: 72.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                    image: DecorationImage(
                                                                                      fit: BoxFit.cover,
                                                                                      image: Image.network(
                                                                                        meusChatsItem.otherUser.imagemPerfil != null && meusChatsItem.otherUser.imagemPerfil != '' ? meusChatsItem.otherUser.imagemPerfil : 'https://qmfitknztvxvzpgjyvxf.supabase.co/storage/v1/object/public/geral/Ellipse%2051.png',
                                                                                      ).image,
                                                                                    ),
                                                                                    shape: BoxShape.circle,
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Text(
                                                                                              valueOrDefault<String>(
                                                                                                meusChatsItem.otherUser.nome,
                                                                                                'Nome',
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    fontSize: 16.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                          Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              if (lastMsgTime != null)
                                                                                                Text(
                                                                                                  _formatarHoraMensagem(lastMsgTime),
                                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                        font: GoogleFonts.inter(),
                                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                        fontSize: 11.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                      ),
                                                                                                ),
                                                                                              if (unreadCount > 0)
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(top: 4.0),
                                                                                                  child: Container(
                                                                                                    padding: EdgeInsets.all(6.0),
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                                      shape: BoxShape.circle,
                                                                                                    ),
                                                                                                    child: Text(
                                                                                                      unreadCount.toString(),
                                                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                            font: GoogleFonts.inter(
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                            ),
                                                                                                            color: Colors.white,
                                                                                                            fontSize: 12.0,
                                                                                                            letterSpacing: 0.0,
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Text(
                                                                                        meusChatsItem.otherUser.role,
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              font: GoogleFonts.inter(
                                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                              ),
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                            ),
                                                                                      ),
                                                                                      if (meusChatsItem.turma != null && meusChatsItem.turma != '')
                                                                                        Text(
                                                                                          valueOrDefault<String>(
                                                                                            meusChatsItem.turma,
                                                                                            'Turma',
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                font: GoogleFonts.inter(
                                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                ),
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                              ),
                                                                                        ),
                                                                                    ].divide(SizedBox(height: 6.0)),
                                                                                  ),
                                                                                ),
                                                                              ].divide(SizedBox(width: 12.0)),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                })
                                                                    .divide(SizedBox(
                                                                        height:
                                                                            12.0))
                                                                    .addToStart(
                                                                        SizedBox(
                                                                            height:
                                                                                12.0))
                                                                    .addToEnd(SizedBox(
                                                                        height:
                                                                            12.0)),
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
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Builder(
                                                    builder: (context) =>
                                                        Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  12.0),
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (dialogContext) {
                                                              return Dialog(
                                                                elevation: 0,
                                                                insetPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                alignment: AlignmentDirectional(
                                                                        0.0,
                                                                        0.0)
                                                                    .resolve(
                                                                        Directionality.of(
                                                                            context)),
                                                                child:
                                                                    WebViewAware(
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      FocusScope.of(
                                                                              dialogContext)
                                                                          .unfocus();
                                                                      FocusManager
                                                                          .instance
                                                                          .primaryFocus
                                                                          ?.unfocus();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.75,
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.45,
                                                                      child:
                                                                          NovaConversaWidget(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        text:
                                                            'Iniciar novo chat',
                                                        icon: Icon(
                                                          Icons.chat_outlined,
                                                          size: 24.0,
                                                        ),
                                                        options:
                                                            FFButtonOptions(
                                                          height: 40.0,
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      16.0,
                                                                      0.0,
                                                                      16.0,
                                                                      0.0),
                                                          iconPadding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          textStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .interTight(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontStyle,
                                                                  ),
                                                          elevation: 0.0,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.sizeOf(context).height * 1.0,
                                  decoration: BoxDecoration(),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 12.0),
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 2.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.6,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                1.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    if (FFAppState().chatId !=
                                                            null &&
                                                        FFAppState().chatId !=
                                                            '')
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    12.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 72.0,
                                                              height: 72.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: Image
                                                                      .network(
                                                                    (rowListaChatsAbertosResponse.jsonBody.toList().map<ChatAtivoStruct?>(ChatAtivoStruct.maybeFromMap).toList() as Iterable<ChatAtivoStruct?>).withoutNulls?.where((e) => e.chatId == FFAppState().chatId).toList()?.firstOrNull?.otherUser?.imagemPerfil !=
                                                                                null &&
                                                                            (rowListaChatsAbertosResponse.jsonBody.toList().map<ChatAtivoStruct?>(ChatAtivoStruct.maybeFromMap).toList() as Iterable<ChatAtivoStruct?>).withoutNulls?.where((e) => e.chatId == FFAppState().chatId).toList()?.firstOrNull?.otherUser?.imagemPerfil !=
                                                                                ''
                                                                        ? (rowListaChatsAbertosResponse.jsonBody.toList().map<ChatAtivoStruct?>(ChatAtivoStruct.maybeFromMap).toList() as Iterable<ChatAtivoStruct?>)
                                                                            .withoutNulls
                                                                            .where((e) =>
                                                                                e.chatId ==
                                                                                FFAppState().chatId)
                                                                            .toList()
                                                                            .firstOrNull!
                                                                            .otherUser
                                                                            .imagemPerfil
                                                                        : 'https://qmfitknztvxvzpgjyvxf.supabase.co/storage/v1/object/public/geral/Ellipse%2051.png',
                                                                  ).image,
                                                                ),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      (rowListaChatsAbertosResponse
                                                                              .jsonBody
                                                                              .toList()
                                                                              .map<ChatAtivoStruct?>(ChatAtivoStruct.maybeFromMap)
                                                                              .toList() as Iterable<ChatAtivoStruct?>)
                                                                          .withoutNulls
                                                                          ?.where((e) => e.chatId == FFAppState().chatId)
                                                                          .toList()
                                                                          ?.firstOrNull
                                                                          ?.otherUser
                                                                          ?.nome,
                                                                      'Nome',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          fontSize:
                                                                              16.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      (rowListaChatsAbertosResponse
                                                                              .jsonBody
                                                                              .toList()
                                                                              .map<ChatAtivoStruct?>(ChatAtivoStruct.maybeFromMap)
                                                                              .toList() as Iterable<ChatAtivoStruct?>)
                                                                          .withoutNulls
                                                                          ?.where((e) => e.chatId == FFAppState().chatId)
                                                                          .toList()
                                                                          ?.firstOrNull
                                                                          ?.otherUser
                                                                          ?.role,
                                                                      'Role',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                  if ((rowListaChatsAbertosResponse.jsonBody.toList().map<ChatAtivoStruct?>(ChatAtivoStruct.maybeFromMap).toList() as Iterable<ChatAtivoStruct?>)
                                                                              .withoutNulls
                                                                              ?.where((e) =>
                                                                                  e.chatId ==
                                                                                  FFAppState()
                                                                                      .chatId)
                                                                              .toList()
                                                                              ?.firstOrNull
                                                                              ?.turma !=
                                                                          null &&
                                                                      (rowListaChatsAbertosResponse.jsonBody.toList().map<ChatAtivoStruct?>(ChatAtivoStruct.maybeFromMap).toList() as Iterable<ChatAtivoStruct?>)
                                                                              .withoutNulls
                                                                              ?.where((e) => e.chatId == FFAppState().chatId)
                                                                              .toList()
                                                                              ?.firstOrNull
                                                                              ?.turma !=
                                                                          '')
                                                                    Text(
                                                                      valueOrDefault<
                                                                          String>(
                                                                        (rowListaChatsAbertosResponse.jsonBody.toList().map<ChatAtivoStruct?>(ChatAtivoStruct.maybeFromMap).toList() as Iterable<ChatAtivoStruct?>)
                                                                            .withoutNulls
                                                                            ?.where((e) =>
                                                                                e.chatId ==
                                                                                FFAppState().chatId)
                                                                            .toList()
                                                                            ?.firstOrNull
                                                                            ?.turma,
                                                                        'turma',
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.inter(
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        6.0)),
                                                              ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 12.0)),
                                                        ),
                                                      ),
                                                    if (FFAppState().chatId !=
                                                            null &&
                                                        FFAppState().chatId !=
                                                            '')
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child: StreamBuilder<
                                                              List<
                                                                  MensagensChatsRow>>(
                                                            stream: _model.columnSupabaseStream ??= SupaFlow
                                                                .client
                                                                .from(
                                                                    "mensagens_chats")
                                                                .stream(
                                                                    primaryKey: [
                                                                      'id'
                                                                    ])
                                                                .eqOrNull(
                                                                  'chat_id',
                                                                  FFAppState()
                                                                      .chatId,
                                                                )
                                                                .map((list) => list
                                                                    .map((item) =>
                                                                        MensagensChatsRow(
                                                                            item))
                                                                    .toList()),
                                                            builder: (context,
                                                                snapshot) {
                                                              // Customize what your widget looks like when it's loading.
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Center(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation<
                                                                              Color>(
                                                                        FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              List<MensagensChatsRow>
                                                                  columnMensagensChatsRowList =
                                                                  snapshot
                                                                      .data!;

                                                              return SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: List.generate(
                                                                      columnMensagensChatsRowList
                                                                          .length,
                                                                      (columnIndex) {
                                                                    final columnMensagensChatsRow =
                                                                        columnMensagensChatsRowList[
                                                                            columnIndex];
                                                                    return Builder(
                                                                      builder:
                                                                          (context) {
                                                                        if (columnMensagensChatsRow.senderId ==
                                                                            currentUserUid) {
                                                                          return Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  borderRadius: BorderRadius.only(
                                                                                    bottomLeft: Radius.circular(8.0),
                                                                                    bottomRight: Radius.circular(0.0),
                                                                                    topLeft: Radius.circular(8.0),
                                                                                    topRight: Radius.circular(8.0),
                                                                                  ),
                                                                                ),
                                                                                child: Align(
                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.all(16.0),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Text(
                                                                                          valueOrDefault<String>(
                                                                                            columnMensagensChatsRow.conteudo,
                                                                                            'Mensagem',
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                font: GoogleFonts.inter(
                                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                ),
                                                                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                              ),
                                                                                        ),
                                                                                        const SizedBox(height: 4.0),
                                                                                        Text(
                                                                                          _formatarHoraMensagem(columnMensagensChatsRow.createdAt),
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                font: GoogleFonts.inter(),
                                                                                                color: FlutterFlowTheme.of(context).primaryBackground.withOpacity(0.75),
                                                                                                fontSize: 10.0,
                                                                                                letterSpacing: 0.0,
                                                                                              ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        } else {
                                                                          return Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                  borderRadius: BorderRadius.only(
                                                                                    bottomLeft: Radius.circular(8.0),
                                                                                    bottomRight: Radius.circular(8.0),
                                                                                    topLeft: Radius.circular(0.0),
                                                                                    topRight: Radius.circular(8.0),
                                                                                  ),
                                                                                  border: Border.all(
                                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                                    width: 1.0,
                                                                                  ),
                                                                                ),
                                                                                child: Align(
                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.all(16.0),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Text(
                                                                                          valueOrDefault<String>(
                                                                                            columnMensagensChatsRow.conteudo,
                                                                                            'Mensagem',
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                font: GoogleFonts.inter(
                                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                ),
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                              ),
                                                                                        ),
                                                                                        const SizedBox(height: 4.0),
                                                                                        Text(
                                                                                          _formatarHoraMensagem(columnMensagensChatsRow.createdAt),
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                font: GoogleFonts.inter(),
                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                fontSize: 10.0,
                                                                                                letterSpacing: 0.0,
                                                                                              ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        }
                                                                      },
                                                                    );
                                                                  }).divide(SizedBox(
                                                                      height:
                                                                          8.0)),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      Expanded(
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(
                                                                Icons.chat_bubble_outline,
                                                                size: 64.0,
                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                              ),
                                                              const SizedBox(height: 16.0),
                                                              Text(
                                                                'Selecione uma conversa',
                                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                      font: GoogleFonts.interTight(),
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                              const SizedBox(height: 8.0),
                                                              Text(
                                                                'Escolha um chat na lista ao lado para começar.',
                                                                textAlign: TextAlign.center,
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      font: GoogleFonts.inter(),
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    if (FFAppState().chatId !=
                                                            null &&
                                                        FFAppState().chatId !=
                                                            '')
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          8.0,
                                                                          0.0),
                                                              child:
                                                                  TextFormField(
                                                                controller: _model
                                                                    .tfMobileTextController,
                                                                focusNode: _model
                                                                    .tfMobileFocusNode,
                                                                onChanged: (_) =>
                                                                    EasyDebounce
                                                                        .debounce(
                                                                  '_model.tfMobileTextController',
                                                                  Duration(
                                                                      milliseconds:
                                                                          200),
                                                                  () =>
                                                                      safeSetState(
                                                                          () {}),
                                                                ),
                                                                onFieldSubmitted:
                                                                    (_) async {
                                                                  _model.insertMessageCopy =
                                                                      await MensagensChatsTable()
                                                                          .insert({
                                                                    'sender_id':
                                                                        currentUserUid,
                                                                    'chat_id':
                                                                        FFAppState()
                                                                            .chatId,
                                                                    'conteudo': _model
                                                                        .tfMobileTextController
                                                                        .text,
                                                                  });
                                                                  safeSetState(
                                                                      () {
                                                                    _model
                                                                        .tfMobileTextController
                                                                        ?.clear();
                                                                  });
                                                                  safeSetState(
                                                                      () {
                                                                    _model
                                                                        .clearListaChatsCache();
                                                                    _model.apiRequestCompleted =
                                                                        false;
                                                                  });
                                                                  await _model
                                                                      .waitForApiRequestCompleted();

                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                                autofocus:
                                                                    false,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .send,
                                                                obscureText:
                                                                    false,
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      'Digite sua mensagem',
                                                                  labelStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                  hintStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  errorBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedErrorBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  filled: true,
                                                                  fillColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                validator: _model
                                                                    .tfMobileTextControllerValidator
                                                                    .asValidator(
                                                                        context),
                                                              ),
                                                            ),
                                                          ),
                                                          FlutterFlowIconButton(
                                                            borderColor: Colors
                                                                .transparent,
                                                            borderRadius: 8.0,
                                                            buttonSize: 47.0,
                                                            fillColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                            disabledColor:
                                                                Color(
                                                                    0xFF908686),
                                                            icon: Icon(
                                                              Icons.send,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              size: 24.0,
                                                            ),
                                                            onPressed: (_model
                                                                            .tfMobileTextController
                                                                            .text ==
                                                                        null ||
                                                                    _model.tfMobileTextController
                                                                            .text ==
                                                                        '')
                                                                ? null
                                                                : () async {
                                                                    _model.insertMessage =
                                                                        await MensagensChatsTable()
                                                                            .insert({
                                                                      'sender_id':
                                                                          currentUserUid,
                                                                      'chat_id':
                                                                          FFAppState()
                                                                              .chatId,
                                                                      'conteudo': _model
                                                                          .tfMobileTextController
                                                                          .text,
                                                                    });
                                                                    safeSetState(
                                                                        () {
                                                                      _model
                                                                          .tfMobileTextController
                                                                          ?.clear();
                                                                    });
                                                                    safeSetState(
                                                                        () {
                                                                      _model
                                                                          .clearListaChatsCache();
                                                                      _model.apiRequestCompleted =
                                                                          false;
                                                                    });
                                                                    await _model
                                                                        .waitForApiRequestCompleted();

                                                                    safeSetState(
                                                                        () {});
                                                                  },
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
                                ),
                              ],
                            );
                          },
                        ),
                      ),
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
