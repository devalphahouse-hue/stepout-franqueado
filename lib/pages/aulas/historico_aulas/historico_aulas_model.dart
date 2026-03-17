import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/empty_list/empty_list_widget.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'historico_aulas_widget.dart' show HistoricoAulasWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HistoricoAulasModel extends FlutterFlowModel<HistoricoAulasWidget> {
  ///  Local state fields for this page.

  List<VinculacaoTurmasStruct> vincularTurmas = [];
  void addToVincularTurmas(VinculacaoTurmasStruct item) =>
      vincularTurmas.add(item);
  void removeFromVincularTurmas(VinculacaoTurmasStruct item) =>
      vincularTurmas.remove(item);
  void removeAtIndexFromVincularTurmas(int index) =>
      vincularTurmas.removeAt(index);
  void insertAtIndexInVincularTurmas(int index, VinculacaoTurmasStruct item) =>
      vincularTurmas.insert(index, item);
  void updateVincularTurmasAtIndex(
          int index, Function(VinculacaoTurmasStruct) updateFn) =>
      vincularTurmas[index] = updateFn(vincularTurmas[index]);

  ///  State fields for stateful widgets in this page.

  // Model for Sidebar component.
  late SidebarModel sidebarModel;
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<AulasRow>();

  /// Query cache managers for this widget.

  final _hiatoricoManager = FutureRequestManager<List<AulasRow>>();
  Future<List<AulasRow>> hiatorico({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<AulasRow>> Function() requestFn,
  }) =>
      _hiatoricoManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearHiatoricoCache() => _hiatoricoManager.clear();
  void clearHiatoricoCacheKey(String? uniqueKey) =>
      _hiatoricoManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    sidebarModel.dispose();
    paginatedDataTableController.dispose();

    /// Dispose query cache managers for this widget.

    clearHiatoricoCache();
  }
}
