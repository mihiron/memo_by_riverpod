import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_by_riverpod/models/edit.dart';
import 'package:memo_by_riverpod/models/task.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Task> taskList = ref.watch(tasksProvider);
    final isEditMode = ref.watch(editProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoリスト'),
        actions: [
          isEditMode
              ? IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    ref.read(editProvider.notifier).toggleEditMode();
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.mode_edit),
                  onPressed: () {
                    ref.read(editProvider.notifier).toggleEditMode();
                  },
                ),
        ],
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        header: isEditMode
            ? Card(
                child: ListTile(
                  title: const Text('タスクを追加'),
                  onTap: () {},
                ),
              )
            : null,
        footer: isEditMode
            ? Card(
                child: ListTile(
                  title: const Text('タスクを追加'),
                  onTap: () {},
                ),
              )
            : null,
        children: [
          for (int index = 0; index < taskList.length; index += 1)
            Card(
              key: Key('$index'),
              child: ListTile(
                title: Text(taskList[index].name),
                onTap: () {
                  ref.read(tasksProvider.notifier).toggleCompleted(index);
                },
                trailing: isEditMode
                    ? IconButton(
                        onPressed: () {
                          ref.read(tasksProvider.notifier).deleteTask(index);
                        },
                        icon: const Icon(Icons.clear))
                    : (taskList[index].isCompleted
                        ? const Icon(Icons.check, color: Colors.green)
                        : null),
              ),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {},
      ),
    );
  }
}
