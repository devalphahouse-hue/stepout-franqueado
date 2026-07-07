import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'sala_aula_model.dart';
export 'sala_aula_model.dart';

/// Página placeholder — o painel do franqueado NÃO conduz aulas ao vivo.
///
/// A versão anterior era scaffolding morto do FlutterFlow: um webview
/// apontando pro Jitsi PÚBLICO (meet.jit.si) com sala hardcoded
/// "turma-exemplo-123" e sem JWT — fora do tenant JaaS (8x8.vc) usado por
/// aluno/professor. Nada no app navega até aqui; a rota é mantida só pra não
/// quebrar a estrutura gerada. Se um dia o franqueado precisar de sala ao
/// vivo, copiar o trio JaasMeetingView do professor (JitsiMeetExternalAPI
/// oficial + token da Edge Function jitsi-token).
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
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: Center(
          child: Text(
            'A sala de aula ao vivo não está disponível neste painel.',
            style: FlutterFlowTheme.of(context).bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
