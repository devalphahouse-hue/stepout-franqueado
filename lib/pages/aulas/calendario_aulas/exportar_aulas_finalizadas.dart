import 'dart:convert';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:intl/intl.dart';

import '/backend/supabase/supabase.dart';

// The calendar uses Brasília time. Dates supported by the export are after
// Brazil stopped observing daylight saving time in 2019.
const _brasiliaOffset = Duration(hours: 3);

Future<bool> exportarAulasFinalizadas({
  required String franquia,
  required DateTime inicio,
  required DateTime fim,
}) async {
  final from = DateTime.utc(
    inicio.year,
    inicio.month,
    inicio.day,
  ).add(_brasiliaOffset);
  final until = DateTime.utc(
    fim.year,
    fim.month,
    fim.day + 1,
  ).add(_brasiliaOffset);
  final client = SupaFlow.client;
  final aulas = <AulasRow>[];
  const pageSize = 250;
  for (var offset = 0; ; offset += pageSize) {
    final page = await client
        .from(AulasTable().tableName)
        .select()
        .eq('franquia', franquia)
        .eq('status_aula', 'Finalizada')
        .gte('datetimeinicio_aula', from.toIso8601String())
        .lt('datetimeinicio_aula', until.toIso8601String())
        .order('datetimeinicio_aula', ascending: true)
        .order('id', ascending: true)
        .range(offset, offset + pageSize - 1);
    aulas.addAll(page.map(AulasRow.new));
    if (page.length < pageSize) break;
  }
  if (aulas.isEmpty) return false;

  final lookups = await Future.wait([
    _nomes('turmas', 'nome_da_turma', {
      for (final aula in aulas)
        if (aula.turma != null) aula.turma!,
    }),
    _nomes('users', 'nome', {
      for (final aula in aulas) ...[
        if (aula.professorResponsavel != null) aula.professorResponsavel!,
        ...aula.alunosConvidados,
        ...aula.alunosPresentes,
      ],
    }),
    _nomes('conteudos', 'nome_conteudo', {
      for (final aula in aulas) ...[
        ...aula.conteudosVinculados,
        ...aula.conteudosUtilizados,
      ],
    }),
  ]);
  final [turmas, usuarios, conteudos] = lookups;
  final data = DateFormat('dd/MM/yyyy');
  final hora = DateFormat('HH:mm');
  final arquivo = DateFormat('yyyy-MM-dd');
  String formatar(DateTime? valor, DateFormat formato) => valor == null
      ? ''
      : formato.format(valor.toUtc().subtract(_brasiliaOffset));
  String nomes(List<String> ids, Map<String, String> nomes) =>
      ids.map((id) => nomes[id] ?? id).join(' | ');

  final rows = <List<String>>[
    [
      'Data de início',
      'Hora de início',
      'Data de término',
      'Hora de término',
      'Turma',
      'Professor',
      'Nível inicial',
      'Status',
      'Qtd. convidados',
      'Alunos convidados',
      'Qtd. presentes',
      'Alunos presentes',
      'Check-in do professor',
      'Conteúdos vinculados (planning)',
      'Conteúdos utilizados',
      'Anotações e comentários',
      'Mural',
      'ID da aula',
    ],
    for (final aula in aulas)
      [
        formatar(aula.datetimeinicioAula, data),
        formatar(aula.datetimeinicioAula, hora),
        formatar(aula.datetimeTerminoaula, data),
        formatar(aula.datetimeTerminoaula, hora),
        turmas[aula.turma] ?? aula.turma ?? '',
        usuarios[aula.professorResponsavel] ?? aula.professorResponsavel ?? '',
        aula.nivelInicio ?? '',
        aula.statusAula ?? '',
        aula.alunosConvidados.length.toString(),
        nomes(aula.alunosConvidados, usuarios),
        aula.alunosPresentes.length.toString(),
        nomes(aula.alunosPresentes, usuarios),
        switch (aula.checkinProfessor) {
          true => 'Sim',
          false => 'Não',
          null => '',
        },
        nomes(aula.conteudosVinculados, conteudos),
        nomes(aula.conteudosUtilizados, conteudos),
        aula.anotacoesComentarios ?? '',
        aula.muralAula ?? '',
        aula.id,
      ],
  ];

  final csv =
      '\uFEFF${rows.map((row) => row.map(_celulaCsv).join(';')).join('\r\n')}\r\n';
  final blob = html.Blob([utf8.encode(csv)], 'text/csv;charset=utf-8');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..download =
        'aulas-finalizadas-${arquivo.format(inicio)}-a-${arquivo.format(fim)}.csv'
    ..click();
  Future<void>.delayed(const Duration(seconds: 10), () {
    html.Url.revokeObjectUrl(url);
  });
  return true;
}

Future<Map<String, String>> _nomes(
  String tabela,
  String coluna,
  Set<String> ids,
) async {
  final nomes = <String, String>{};
  final lista = ids.toList();
  const lote = 75;
  for (var offset = 0; offset < lista.length; offset += lote) {
    final rows = await SupaFlow.client
        .from(tabela)
        .select('id,$coluna')
        .inFilter('id', lista.skip(offset).take(lote).toList());
    for (final row in rows) {
      final nome = row[coluna] as String?;
      if (nome != null && nome.isNotEmpty) nomes[row['id'] as String] = nome;
    }
  }
  return nomes;
}

String _celulaCsv(String valor) {
  // Keep notes and titles as text when opened in a spreadsheet.
  final texto = RegExp(r'^\s*[=+\-@]|^[\t\r\n]').hasMatch(valor)
      ? "'$valor"
      : valor;
  return '"${texto.replaceAll('"', '""')}"';
}
