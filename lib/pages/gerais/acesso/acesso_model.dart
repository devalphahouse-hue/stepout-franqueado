import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'acesso_widget.dart' show AcessoWidget;
import 'package:flutter/material.dart';

class AcessoModel extends FlutterFlowModel<AcessoWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Sidebar component.
  late SidebarModel sidebarModel;
  // Controllers for the read-only link fields.
  FocusNode? professorFocusNode;
  TextEditingController? professorController;
  FocusNode? alunoFocusNode;
  TextEditingController? alunoController;
  FocusNode? appStoreFocusNode;
  TextEditingController? appStoreController;
  FocusNode? playStoreFocusNode;
  TextEditingController? playStoreController;

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    sidebarModel.dispose();
    professorFocusNode?.dispose();
    professorController?.dispose();
    alunoFocusNode?.dispose();
    alunoController?.dispose();
    appStoreFocusNode?.dispose();
    appStoreController?.dispose();
    playStoreFocusNode?.dispose();
    playStoreController?.dispose();
  }
}
