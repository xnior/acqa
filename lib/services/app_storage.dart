import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import '../models/task.dart';
import '../utils/dates.dart';


/// Este código copiei de exemplos da internet e adquei a minha demanda da ACQA.

/// Persistência local que substitui o Firebase (Auth + banco de tarefas).
/// Usuários e tarefas ficam salvos no próprio aparelho.
class AppStorage {
  AppStorage._();

  static final instance = AppStorage._();

  static const _usersKey = 'diadia.users';
  static const _sessionKey = 'diadia.session';

  late SharedPreferences _prefs;
  AppUser? currentUser;
  List<Task> _tasks = [];

  String _tasksKey(String email) => 'diadia.tasks.$email';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final email = _prefs.getString(_sessionKey);
    if (email == null) return;
    currentUser = _readUsers()[email];
    if (currentUser != null) _loadTasks();
  }

  // ---------- Autenticação ----------

  Map<String, AppUser> _readUsers() {
    final raw = _prefs.getString(_usersKey);
    if (raw == null) return {};
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map(
      (email, json) =>
          MapEntry(email, AppUser.fromJson(json as Map<String, dynamic>)),
    );
  }

  /// Retorna uma mensagem de erro, ou `null` em caso de sucesso.
  Future<String?> register({
    required String name,
    required String ra,
    required String email,
    required String password,
  }) async {
    final users = _readUsers();
    final key = email.trim().toLowerCase();
    if (users.containsKey(key)) return 'Este e-mail já está cadastrado.';

    final user = AppUser(
      name: name.trim(),
      ra: ra.trim(),
      email: key,
      password: password,
    );
    users[key] = user;
    await _prefs.setString(
      _usersKey,
      jsonEncode(users.map((k, v) => MapEntry(k, v.toJson()))),
    );
    await _startSession(user);
    return null;
  }

  /// Retorna uma mensagem de erro, ou `null` em caso de sucesso.
  Future<String?> login(String email, String password) async {
    final user = _readUsers()[email.trim().toLowerCase()];
    if (user == null) return 'Usuário não encontrado. Que tal se cadastrar?';
    if (user.password != password) return 'Senha incorreta.';
    await _startSession(user);
    return null;
  }

  Future<void> _startSession(AppUser user) async {
    currentUser = user;
    await _prefs.setString(_sessionKey, user.email);
    _loadTasks();
  }

  Future<void> logout() async {
    currentUser = null;
    _tasks = [];
    await _prefs.remove(_sessionKey);
  }

  // ---------- Tarefas ----------

  void _loadTasks() {
    final raw = _prefs.getString(_tasksKey(currentUser!.email));
    if (raw == null) {
      _tasks = [];
      return;
    }
    _tasks = (jsonDecode(raw) as List)
        .map((json) => Task.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveTasks() => _prefs.setString(
    _tasksKey(currentUser!.email),
    jsonEncode(_tasks.map((t) => t.toJson()).toList()),
  );

  /// Tarefas do dia já ordenadas (pendentes → concluídas, A→Z).
  List<Task> tasksFor(DateTime day) {
    final key = dayKey(day);
    return Task.sorted(_tasks.where((t) => t.dayKey == key));
  }

  ({int pending, int done}) countsFor(DateTime day) {
    final key = dayKey(day);
    var pending = 0, done = 0;
    for (final t in _tasks.where((t) => t.dayKey == key)) {
      t.done ? done++ : pending++;
    }
    return (pending: pending, done: done);
  }

  Future<Task> addTask(DateTime day, String title) async {
    final now = DateTime.now();
    final task = Task(
      id: now.microsecondsSinceEpoch.toString(),
      title: title.trim(),
      dayKey: dayKey(day),
      createdAt: now,
    );
    _tasks.add(task);
    await _saveTasks();
    return task;
  }

  Future<void> toggleTask(Task task) {
    task.done = !task.done;
    return _saveTasks();
  }

  Future<void> removeTask(Task task) {
    _tasks.removeWhere((t) => t.id == task.id);
    return _saveTasks();
  }

  Future<void> restoreTask(Task task) {
    _tasks.add(task);
    return _saveTasks();
  }
}
