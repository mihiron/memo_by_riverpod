import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_by_riverpod/models/task.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Task> taskList = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoリスト'),
      ),
      body: ListView(
        children: taskList
            .map((task) => CheckboxListTile(
                  value: task.isCompleted,
                  onChanged: (value) =>
                      ref.read(tasksProvider.notifier).toggle(task.id),
                  title: Text(task.name),
                ))
            .toList(),
      ),
    );
  }
}
