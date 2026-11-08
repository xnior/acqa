import 'package:flutter/material.dart';

import '../services/app_storage.dart';
import '../theme/app_theme.dart';
import '../utils/dates.dart';
import 'auth_screen.dart';
import 'tasks_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _storage = AppStorage.instance;
  DateTime _selected = dateOnly(DateTime.now());

  Future<void> _openTasks() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => TasksScreen(day: _selected)));
    // Atualiza os contadores ao voltar da lista.
    if (mounted) setState(() {});
  }

  Future<void> _logout() async {
    await _storage.logout();
    if (!mounted) return;
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final user = _storage.currentUser!;
    final counts = _storage.countsFor(_selected);


    /// Segui os exemplos dado pelas aulas da UNIUBE cedida pelo professor Mateus
    /// 
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo(a), ${user.firstName}!',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            Text(
              'MEU RA: ${user.ra}',
              style: const TextStyle(fontSize: 13, color: AppColors.lime),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout_rounded),
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: CalendarDatePicker(
              initialDate: _selected,
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
              onDateChanged: (day) => setState(() => _selected = day),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${weekdayName(_selected)}, ${formatDate(_selected)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.night,
                  ),
                ),
                Text(
                  '${counts.pending} pendente(s) · ${counts.done} concluída(s)',
                  style: const TextStyle(color: AppColors.night),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _openTasks,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.night,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.checklist_rounded),
                  label: const Text('Abrir tarefas do dia'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
