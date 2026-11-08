class Task {
  Task({
    required this.id,
    required this.title,
    required this.dayKey,
    required this.createdAt,
    this.done = false,
  });

  final String id;
  final String title;
  final String dayKey;
  final DateTime createdAt;
  bool done;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    title: json['title'] as String,
    dayKey: json['dayKey'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    done: json['done'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dayKey': dayKey,
    'createdAt': createdAt.toIso8601String(),
    'done': done,
  };

  /// Pendentes primeiro, depois concluídas; ambas em ordem alfabética
  /// (sem diferenciar maiúsculas nem acentos).
  static int compare(Task a, Task b) {
    if (a.done != b.done) return a.done ? 1 : -1;
    final byTitle = sortKey(a.title).compareTo(sortKey(b.title));
    return byTitle != 0 ? byTitle : a.createdAt.compareTo(b.createdAt);
  }

  static List<Task> sorted(Iterable<Task> tasks) =>
      tasks.toList()..sort(compare);
}


///Peguei de exemplos de documentações 
const _accents = {
  'a': 'áàâãä',
  'e': 'éèêë',
  'i': 'íìîï',
  'o': 'óòôõö',
  'u': 'úùûü',
  'c': 'ç',
  'n': 'ñ',
};

/// Normaliza o texto para que "Água" fique junto de "agenda" na ordenação.
/// Coloquei após a leitura da documentação.
String sortKey(String text) {
  final buffer = StringBuffer();
  for (final char in text.trim().toLowerCase().split('')) {
    final plain = _accents.entries
        .where((e) => e.value.contains(char))
        .map((e) => e.key)
        .firstOrNull;
    buffer.write(plain ?? char);
  }
  return buffer.toString();
}
