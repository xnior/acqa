/// Indexado por `DateTime.weekday - 1` (segunda = 0).
const weekdayNames = [
  'Segunda-feira',
  'Terça-feira',
  'Quarta-feira',
  'Quinta-feira',
  'Sexta-feira',
  'Sábado',
  'Domingo',
];

/// Errei bastante até conseguir executar este código 
String _two(int n) => n.toString().padLeft(2, '0');

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Chave usada para agrupar tarefas por dia (ex.: 2026-10-25).
String dayKey(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';

/// Data no formato brasileiro (ex.: 25/10/2026).
String formatDate(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';

String weekdayName(DateTime d) => weekdayNames[d.weekday - 1];
