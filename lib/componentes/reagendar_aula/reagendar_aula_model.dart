import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'reagendar_aula_widget.dart' show ReagendarAulaWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReagendarAulaModel extends FlutterFlowModel<ReagendarAulaWidget> {
  ///  State fields for stateful widgets in this component.

  DateTime? datePicked1;
  DateTime? datePicked2;

  // New fields for separated date/time pickers
  DateTime? selectedDate;
  TimeOfDay? selectedTimeInicio;
  TimeOfDay? selectedTimeFim;

  /// Combines selectedDate + selectedTimeInicio into datePicked1
  /// and selectedDate + selectedTimeFim into datePicked2
  void combineDateTime() {
    if (selectedDate != null && selectedTimeInicio != null) {
      datePicked1 = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTimeInicio!.hour,
        selectedTimeInicio!.minute,
      );
    }
    if (selectedDate != null && selectedTimeFim != null) {
      datePicked2 = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTimeFim!.hour,
        selectedTimeFim!.minute,
      );
    }
  }

  bool get isFormComplete =>
      selectedDate != null &&
      selectedTimeInicio != null &&
      selectedTimeFim != null;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
