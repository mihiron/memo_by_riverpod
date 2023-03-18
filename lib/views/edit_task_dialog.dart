import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_by_riverpod/main.dart';
import 'package:memo_by_riverpod/services/local/app_database.dart';

enum AddEditMode {
  add,
  edit,
}

class EditTaskDialog extends ConsumerWidget {
  const EditTaskDialog({
    super.key,
    required this.addEditMode,
    required this.textEditingController,
    this.todo,
  });

  final AddEditMode addEditMode;
  final TextEditingController textEditingController;
  final Todo? todo;

  factory EditTaskDialog.addFTask() {
    return EditTaskDialog(
      addEditMode: AddEditMode.add,
      textEditingController: TextEditingController(),
    );
  }

  factory EditTaskDialog.editTask(int index, Todo todo) {
    return EditTaskDialog(
      addEditMode: AddEditMode.edit,
      textEditingController: TextEditingController(),
      todo: todo,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localRepo = ref.read(localRepoProvider);
    final todoRepo = localRepo.todoRepo;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        title: (() {
          switch (addEditMode) {
            case AddEditMode.add:
              return const Text('タスクを追加');
            case AddEditMode.edit:
              return const Text('タスクを編集');
          }
        })(),
        content: TextField(
          keyboardType: TextInputType.text,
          controller: textEditingController,
          decoration: const InputDecoration(hintText: 'タスクを追加'),
          enabled: true,
          maxLength: 20,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'キャンセル'),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              String textValue = textEditingController.text;
              switch (addEditMode) {
                case AddEditMode.add:
                  TodosCompanion newTodo = TodosCompanion(
                    name: Value(textValue),
                    isCompleted: const Value(false),
                  );
                  todoRepo.insertTodo(newTodo);
                  break;
                case AddEditMode.edit:
                  todoRepo.updateTodo(todo!.copyWith(name: textValue));
                  break;
              }
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
