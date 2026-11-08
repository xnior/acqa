import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/app_storage.dart';
import '../theme/app_theme.dart';
import '../utils/dates.dart';


/// Modelo padrão de de fazer um task, confesso que REACT JS era mais bacana.
/// 
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, required this.day});

  final DateTime day;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _storage = AppStorage.instance;

  Future<void> _openAddDialog() async {
    var text = '';
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova tarefa'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Ex.: Estudar Flutter'),
          onChanged: (value) => text = value,
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(text),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
    if (title == null || title.trim().isEmpty) return;
    await _storage.addTask(widget.day, title);
    if (mounted) setState(() {});
  }

  Future<void> _toggle(Task task) async {
    await _storage.toggleTask(task);
    setState(() {});
  }

  Future<void> _remove(Task task) async {
    await _storage.removeTask(task);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _storage.tasksFor(widget.day);
    final pending = tasks.where((t) => !t.done).toList();
    final done = tasks.where((t) => t.done).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Dia ${formatDate(widget.day)}')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nova tarefa'),
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma tarefa neste dia',
                style: TextStyle(color: AppColors.muted),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
              children: [
                if (pending.isNotEmpty) ...[
                  _section('Pendentes', AppColors.pink),
                  ...pending.map(_tile),
                ],
                if (done.isNotEmpty) ...[
                  _section('Concluídas', AppColors.lime),
                  ...done.map(_tile),
                ],
              ],
            ),
    );
  }

  Widget _section(String label, Color color) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
    child: Text(
      label.toUpperCase(),
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
    ),
  );

  Widget _tile(Task task) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      onTap: () => _toggle(task),
      leading: Icon(
        task.done
            ? Icons.check_circle_rounded
            : Icons.radio_button_unchecked_rounded,
        color: task.done ? AppColors.lime : AppColors.pink,
      ),
      title: Text(
        task.title,
        style: task.done
            ? const TextStyle(
                color: AppColors.muted,
                decoration: TextDecoration.lineThrough,
              )
            : null,
      ),
      trailing: IconButton(
        tooltip: 'Remover tarefa',
        icon: const Icon(Icons.delete_outline_rounded),
        onPressed: () => _remove(task),
      ),
    ),
  );
}
