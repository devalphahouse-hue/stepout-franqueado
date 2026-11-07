import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/flutter_flow/flutter_flow_theme.dart';

class PeriodoExportacaoDialog extends StatefulWidget {
  const PeriodoExportacaoDialog({super.key, required this.hoje});

  final DateTime hoje;

  @override
  State<PeriodoExportacaoDialog> createState() =>
      _PeriodoExportacaoDialogState();
}

class _PeriodoExportacaoDialogState extends State<PeriodoExportacaoDialog> {
  static final _primeiraData = DateTime(2020);
  final _form = GlobalKey<FormState>();
  final _formato = DateFormat('dd/MM/yyyy');
  late final TextEditingController _inicio;
  late final TextEditingController _fim;

  @override
  void initState() {
    super.initState();
    final hoje = _formato.format(widget.hoje);
    _inicio = TextEditingController(text: hoje);
    _fim = TextEditingController(text: hoje);
  }

  @override
  void dispose() {
    _inicio.dispose();
    _fim.dispose();
    super.dispose();
  }

  DateTime? _data(String? texto) =>
      _formato.tryParseStrict(texto?.trim() ?? '');

  String? _validar(String? texto, {required bool dataFinal}) {
    final data = _data(texto);
    if (data == null) return 'Use dd/mm/aaaa.';
    if (data.isBefore(_primeiraData) || data.isAfter(widget.hoje)) {
      return 'Escolha uma data até hoje, a partir de 2020.';
    }
    final inicio = _data(_inicio.text);
    if (dataFinal && inicio != null && data.isBefore(inicio)) {
      return 'A data final deve ser igual ou posterior à inicial.';
    }
    return null;
  }

  Future<void> _escolherData(
    BuildContext dialogContext,
    TextEditingController controller,
  ) async {
    final atual = _data(controller.text);
    final data = await showDatePicker(
      context: dialogContext,
      locale: const Locale('pt', 'BR'),
      firstDate: _primeiraData,
      lastDate: widget.hoje,
      initialDate:
          atual != null &&
              !atual.isBefore(_primeiraData) &&
              !atual.isAfter(widget.hoje)
          ? atual
          : widget.hoje,
    );
    if (!mounted || data == null) return;
    controller.text = _formato.format(data);
  }

  void _baixar() {
    if (!_form.currentState!.validate()) return;
    Navigator.of(
      context,
    ).pop(DateTimeRange(start: _data(_inicio.text)!, end: _data(_fim.text)!));
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final cores = Theme.of(context).colorScheme.copyWith(
      primary: theme.primary,
      onPrimary: Colors.white,
      surface: theme.primaryBackground,
      onSurface: theme.primaryText,
    );
    final borda = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: theme.alternate),
    );

    Widget campo(
      BuildContext dialogContext,
      String rotulo,
      TextEditingController controller, {
      bool dataFinal = false,
    }) {
      return TextFormField(
        controller: controller,
        keyboardType: TextInputType.datetime,
        validator: (texto) => _validar(texto, dataFinal: dataFinal),
        onFieldSubmitted: (_) => _baixar(),
        decoration: InputDecoration(
          labelText: rotulo,
          hintText: 'dd/mm/aaaa',
          filled: true,
          fillColor: theme.secondaryBackground,
          border: borda,
          enabledBorder: borda,
          errorMaxLines: 2,
          suffixIcon: IconButton(
            tooltip: 'Selecionar ${rotulo.toLowerCase()}',
            onPressed: () => _escolherData(dialogContext, controller),
            icon: Icon(
              Icons.calendar_today_outlined,
              color: theme.primary,
              size: 18,
            ),
          ),
        ),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(colorScheme: cores),
      child: Builder(
        builder: (dialogContext) => AlertDialog(
          backgroundColor: theme.primaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          scrollable: true,
          title: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.download_rounded, color: theme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Exportar aulas finalizadas',
                  style: theme.titleLarge.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 460,
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Selecione o período das aulas que deseja baixar.',
                    style: theme.bodyMedium.copyWith(
                      color: theme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (_, constraints) {
                      final inicio = campo(
                        dialogContext,
                        'Data inicial',
                        _inicio,
                      );
                      final fim = campo(
                        dialogContext,
                        'Data final',
                        _fim,
                        dataFinal: true,
                      );
                      if (constraints.maxWidth < 360) {
                        return Column(
                          children: [inicio, const SizedBox(height: 12), fim],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: inicio),
                          const SizedBox(width: 12),
                          Expanded(child: fim),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: _baixar,
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('Baixar CSV'),
              style: FilledButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
