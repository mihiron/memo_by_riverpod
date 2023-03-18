import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_by_riverpod/models/edit.dart';
import 'package:memo_by_riverpod/repositories/local/local_todo_repository_provider.dart';
import 'package:memo_by_riverpod/views/edit_task_dialog.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(editProvider);
    final todoStreamList = ref.watch(todoStreamProvider);
    final todoRepo = ref.read(todoRepoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoリスト'),
        actions: [
          isEditMode
              ? IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () =>
                      ref.read(editProvider.notifier).toggleEditMode(),
                )
              : IconButton(
                  icon: const Icon(Icons.mode_edit),
                  onPressed: () =>
                      ref.read(editProvider.notifier).toggleEditMode(),
                ),
        ],
      ),
      body: todoStreamList.when(
        error: (err, _) => Text(err.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (data) {
          int itemCount = data.length;
          return ListView.builder(
            itemCount: isEditMode ? itemCount + 1 : itemCount,
            itemBuilder: (context, index) {
              if (isEditMode && index == itemCount) {
                return Card(
                  child: ListTile(
                    title: const Text('タスクを追加'),
                    leading: const Icon(Icons.add),
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return EditTaskDialog.addFTask();
                        },
                      );
                    },
                  ),
                );
              }
              return Card(
                child: ListTile(
                  title: Text(data[index].name),
                  onTap: isEditMode
                      ? () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return EditTaskDialog.editTask(
                                  index, data[index]);
                            },
                          );
                        }
                      : () {
                          todoRepo.updateTodo(data[index]
                              .copyWith(isCompleted: !data[index].isCompleted));
                        },
                  trailing: isEditMode
                      ? IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            todoRepo.deleteTodo(data[index].id);
                          },
                        )
                      : data[index].isCompleted
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
