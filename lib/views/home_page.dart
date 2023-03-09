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
      body: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          for (int index = 0; index < taskList.length; index += 1)
            Card(
              key: Key('$index'),
              child: ListTile(
                title: Text(taskList[index].name),
                onTap: () {
                  ref.read(tasksProvider.notifier).toggle(taskList[index].id);
                },
                trailing: taskList[index].isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : null,
              ),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {},
      ),
    );
  }
}
