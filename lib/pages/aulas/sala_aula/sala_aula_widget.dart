import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'sala_aula_model.dart';
export 'sala_aula_model.dart';

class SalaAulaWidget extends StatefulWidget {
  const SalaAulaWidget({super.key});

  static String routeName = 'SalaAula';
  static String routePath = '/salaAula';

  @override
  State<SalaAulaWidget> createState() => _SalaAulaWidgetState();
}

class _SalaAulaWidgetState extends State<SalaAulaWidget> {
  late SalaAulaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SalaAulaModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Page Title',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FlutterFlowWebView(
                content:
                    '<html lang=\"pt-br\">\n<head>\n  <meta charset=\"utf-8\" />\n  <meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1\" />\n  <title>Sala de Aula</title>\n  <style>\n    html, body, #meet { height: 100%; width: 100%; margin: 0; padding: 0; background: #000; }\n  </style>\n  <!-- Política que ajuda a liberar câmera/mic no iframe -->\n  <meta http-equiv=\"origin-trial\" content=\"\">\n</head>\n<body>\n  <div id=\"meet\"></div>\n\n  <script src=\"https://meet.jit.si/external_api.js\"></script>\n  <script>\n    (function() {\n      // Ajuste aqui os valores dinamicamente se quiser:\n      var ROOM_NAME = \"turma-exemplo-123\";   // ex.: vindo do seu DB\n      var DISPLAY_NAME = \"Aluno(a)\";         // ex.: nome do usuário logado\n\n      // Domínio público do Jitsi\n      var domain = \"meet.jit.si\";\n\n      // Opções do IFrame API\n      var options = {\n        roomName: ROOM_NAME,\n        parentNode: document.querySelector(\'#meet\'),\n        width: \"100%\",\n        height: \"100%\",\n        // Importante: desabilita deep link para app nativo e tela de pre-join\n        configOverwrite: {\n          prejoinPageEnabled: false,\n          startWithAudioMuted: false,\n          startWithVideoMuted: false,\n          disableDeepLinking: true,\n          // Permite compartilhamento de tela\n          enableWelcomePage: false\n        },\n        interfaceConfigOverwrite: {\n          // Remova/adicione botões conforme necessário\n          TOOLBAR_BUTTONS: [\n            \'microphone\', \'camera\', \'desktop\', \'chat\', \'raisehand\',\n            \'tileview\', \'hangup\', \'participants-pane\', \'settings\'\n          ]\n        },\n        userInfo: {\n          displayName: DISPLAY_NAME\n        }\n      };\n\n      // Cria o iFrame do Jitsi\n      var api = new JitsiMeetExternalAPI(domain, options);\n\n      // Tenta ligar câmera/mic assim que carregar (vai disparar o prompt do navegador)\n      api.addEventListener(\'videoConferenceJoined\', function() {\n        // Opcional: garantir que o usuário entre com áudio/vídeo ativos (se permitido)\n        api.executeCommand(\'toggleAudio\');   // se estiver mutado, alterna\n        api.executeCommand(\'toggleAudio\');   // dupla chamada garante estado desejado\n        api.executeCommand(\'toggleVideo\');\n        api.executeCommand(\'toggleVideo\');\n      });\n\n      // Segurança extra: ajustar atributos do iframe gerado\n      var iframe = document.querySelector(\'iframe\');\n      if (iframe) {\n        // Permissões explícitas\n        iframe.setAttribute(\'allow\', \'camera; microphone; fullscreen; display-capture; autoplay\');\n        // Sandbox mantendo scripts e mesma origem do conteúdo Jitsi\n        iframe.setAttribute(\'sandbox\', \'allow-same-origin allow-scripts allow-forms allow-popups allow-presentation allow-downloads\');\n        // Para iOS algumas versões precisam de fullscreen\n        iframe.setAttribute(\'allowfullscreen\', \'true\');\n      }\n    })();\n  </script>\n</body>\n',
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 1.0,
                verticalScroll: false,
                horizontalScroll: false,
                html: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
