import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

List<dynamic> removeJsonItem(
  List<dynamic> list,
  int index,
) {
  final newList = List<Map<String, dynamic>>.from(list);
  if (index >= 0 && index < newList.length) {
    newList.removeAt(index);
  }
  return newList;
}

List<dynamic> addJsonItem(
  String? dia,
  String? horarioInicio,
  String? horarioFinal,
  List<dynamic> list,
) {
  final newList = List<Map<String, dynamic>>.from(list);

  final newItem = {
    "dia": dia,
    "horarioInicio": horarioInicio,
    "horarioFinal": horarioFinal,
  };

  newList.add(newItem);

  return newList;
}

List<DiaCalendarioAulasStruct>? gerarLista7Dias(DateTime? dataInicial) {
  // Função que recebe a data de hoje e cria uma lista de 7 itens para salvar em App State como datatype. Cada item representa um dia consecutivo a partir da data recebida, com dois campos: dia_hora_inicio (00:00) e dia_hora_termino (23:59), considerando o timezone de Brasília. Ex.: se a data é 04/09/2025, a lista terá {04/09/2025 00:00, 04/09/2025 23:59}, {05/09/2025 00:00, 05/09/2025 23:59}… até 10/09/2025
  if (dataInicial == null) return null;

  List<DiaCalendarioAulasStruct> listaDias = [];
  DateTime dataAtual = dataInicial;

  for (int i = 0; i < 7; i++) {
    DateTime inicio = DateTime(
        dataAtual.year, dataAtual.month, dataAtual.day, 0, 0, 0, 0, 0); // 00:00
    DateTime fim = DateTime(dataAtual.year, dataAtual.month, dataAtual.day, 23,
        59, 59, 999, 999); // 23:59
    listaDias.add(
        DiaCalendarioAulasStruct(diaHoraInicio: inicio, diaHoraTermino: fim));
    dataAtual = dataAtual.add(Duration(days: 1));
  }

  return listaDias;
}

String? datetimeToString(DateTime? date) {
  // convert datetime do string
  if (date == null) return null; // Check if date is null
  return DateFormat('yyyy-MM-dd HH:mm:ss')
      .format(date); // Format date to string
}

DateTime? stringToDatetime(String? date) {
  if (date == null) return null;

  try {
    // Normaliza: "YYYY-MM-DD HH:mm:ss" -> "YYYY-MM-DDTHH:mm:ss"
    var s = date.trim().replaceFirst(' ', 'T');

    // Normaliza offset "+00" / "-03" para "+00:00" / "-03:00"
    s = s.replaceAllMapped(RegExp(r'([+-]\d{2})$'), (m) => '${m[1]}:00');
    s = s.replaceAllMapped(
        RegExp(r'([+-]\d{2})(\d{2})$'), (m) => '${m[1]}:${m[2]}');

    final parsed = DateTime.parse(s);

    final hasTz = RegExp(r'(Z|[+-]\d{2}:\d{2})$').hasMatch(s);

    if (hasTz) {
      // String já está em um instante absoluto (UTC ou com offset).
      // Converte para horário de São Paulo (UTC-3).
      final spUtcInstant = parsed.toUtc().subtract(const Duration(hours: 3));

      // Retorna como "local-like" (sem o sufixo Z), já ajustado para SP.
      return DateTime(
        spUtcInstant.year,
        spUtcInstant.month,
        spUtcInstant.day,
        spUtcInstant.hour,
        spUtcInstant.minute,
        spUtcInstant.second,
        spUtcInstant.millisecond,
        spUtcInstant.microsecond,
      );
    } else {
      // String sem timezone: assume que é SP e converte para UTC.
      return parsed.toUtc().add(const Duration(hours: 3));
    }
  } catch (e) {
    return null;
  }
}

String? datetimeToDiaSemana(DateTime? dia) {
  // receba um timestamp e retorne o dia da seman da data em pt-br. Exemplo 2025-09-06 23:00:00+00 é Sábado
  if (dia == null) return null;
  List<String> diasDaSemana = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo'
  ];
  return diasDaSemana[dia.weekday - 1];
}

DateTime? calcula7diasFrente(DateTime? data) {
  if (data == null) return null; // Verifica se a data é nula
  return data.add(const Duration(days: 7)); // Adiciona 7 dias à data
}

DateTime? calcula7diasTras(DateTime? data) {
  // recebe uma data e calcula uma data 7 dias para trás dessa data
  if (data == null) return null; // Verifica se a data é nula
  return data.subtract(const Duration(days: 7)); // Subtrai 7 dias da data
}

List<String>? addItemToList(
  List<String>? listaAtual,
  String item,
) {
  // recebe uma lista de strings, e adiciona uma nova string, se a lista estiver vazia, crie uma nova apenas com o item adicionado
  if (listaAtual == null || listaAtual.isEmpty) {
    return [
      item
    ]; // Create a new list with the item if the current list is null or empty
  } else {
    listaAtual.add(item); // Add the item to the existing list
    return listaAtual; // Return the updated list
  }
}

List<String> remofromListinIndex(
  int itemIndex,
  List<String> list,
) {
  // remova um item da lista que está no index itemIndex
  if (itemIndex < 0 || itemIndex >= list.length) {
    return list; // Return the original list if index is out of bounds
  }
  list.removeAt(itemIndex); // Remove the item at the specified index
  return list; // Return the modified list
}

Color funColorTable(int index) {
  // de acordo com o meu index pinta de cores sendo #FFFFFFF e #f1f4f8 intercalando como uma tabela
  List<Color> colors = [
    Color(0xFFFFFFFF),
    Color(0xFFF1F4F8),
  ];

  return colors[index % 2];
}

String retornaValorTotal(List<CobrancasRow> total) {
  double soma = 0.0;

  for (var cobranca in total) {
    soma += cobranca.valor ?? 0.0;
  }

  final formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  return formatter.format(soma);
}

bool verificaDatasIguais(
  String dataLista,
  String dataBanco,
) {
  // ver se dataliSTA (2025-11-25 00:00:00.000) É IGUAL A dataBanco (2025-11-25 13:00:00.000) desconsiderando a hora
  // Parse the input date strings to DateTime objects
  DateTime listaDate = DateTime.parse(dataLista).toLocal();
  DateTime bancoDate = DateTime.parse(dataBanco).toLocal();

  // Compare only the date parts (year, month, day)
  return listaDate.year == bancoDate.year &&
      listaDate.month == bancoDate.month &&
      listaDate.day == bancoDate.day;
}

DateTime? addFuso(DateTime? date) {
  if (date == null) return null;

  return date.add(const Duration(hours: 3));
}

String formatCurrencyBr(dynamic value) {
  if (value == null) return 'R\$ 0,00';
  num? n = value is num ? value : num.tryParse(value.toString());
  if (n == null) return 'R\$ 0,00';
  final f = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  return f.format(n);
}

String cobrancaStatusLabel(String? status) {
  final s = (status ?? '').toUpperCase().trim();
  if (s.isEmpty) return 'Pendente';
  if (['CONFIRMED', 'RECEIVED', 'PAID', 'PAGO', 'RECEIVED_IN_CASH'].contains(s))
    return 'Paga';
  if (['OVERDUE', 'ATRASADO', 'ATRASADA'].contains(s)) return 'Atrasada';
  if (['CANCELLED', 'CANCELADA', 'CANCELADO', 'REFUNDED', 'CHARGEBACK']
      .contains(s)) return 'Cancelada';
  if (['PENDING', 'AGUARDANDO', 'AWAITING_PAYMENT'].contains(s))
    return 'Pendente';
  return 'Pendente';
}

Color cobrancaStatusColorBg(String? status) {
  final label = cobrancaStatusLabel(status);
  if (label == 'Paga') return const Color(0xFFE6F4EA);
  if (label == 'Atrasada') return const Color(0xFFFCE8E8);
  if (label == 'Cancelada') return const Color(0xFFEEEEEE);
  return const Color(0xFFFFF4D6); // Pendente
}

Color cobrancaStatusColorFg(String? status) {
  final label = cobrancaStatusLabel(status);
  if (label == 'Paga') return const Color(0xFF1E7E34);
  if (label == 'Atrasada') return const Color(0xFFB00020);
  if (label == 'Cancelada') return const Color(0xFF616161);
  return const Color(0xFF8A6D00); // Pendente
}

String shortIdFallback(String? asaasId, String? internalId) {
  if (asaasId != null && asaasId.isNotEmpty) return asaasId;
  if (internalId == null || internalId.isEmpty) return '—';
  return '#${internalId.substring(0, internalId.length >= 8 ? 8 : internalId.length)}';
}

List<dynamic> sortCobrancasByDateDesc(List<dynamic>? list) {
  if (list == null) return <dynamic>[];
  final copy = List<dynamic>.from(list);
  copy.sort((a, b) {
    final ad = (a is Map ? a['created_at'] : null)?.toString() ?? '';
    final bd = (b is Map ? b['created_at'] : null)?.toString() ?? '';
    return bd.compareTo(ad);
  });
  return copy;
}

String sumCobrancasValor(List<dynamic>? list) {
  if (list == null || list.isEmpty) return formatCurrencyBr(0);
  num total = 0;
  for (final item in list) {
    if (item is Map) {
      final v = item['valor'];
      if (v is num) total += v;
      else if (v != null) {
        final p = num.tryParse(v.toString());
        if (p != null) total += p;
      }
    }
  }
  return formatCurrencyBr(total);
}
