import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_by_riverpod/models/task.dart';

enum EditMode {
  add,
  edit,
}

class EditTaskDialog extends ConsumerWidget {
  const EditTaskDialog({
    super.key,
    required this.editMode,
    this.index,
    this.name,
  });

  final EditMode editMode;
  final int? index;
  final String? name;

  factory EditTaskDialog.addTask() {
    return const EditTaskDialog(editMode: EditMode.add);
  }

  factory EditTaskDialog.editTask(int index, String name) {
    return EditTaskDialog(editMode: EditMode.edit, index: index, name: name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController textEditingController = TextEditingController();

    if (editMode == EditMode.edit) {
      textEditingController.text = name!;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        title: (() {
          switch (editMode) {
            case EditMode.add:
              return const Text('タスクを追加');
            case EditMode.edit:
              return const Text('タスクを追加');
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
              switch (editMode) {
                case EditMode.add:
                  ref.read(tasksProvider.notifier).addTask(
                      Task(id: 1, name: textValue, isCompleted: false));
                  break;
                case EditMode.edit:
                  ref
                      .read(tasksProvider.notifier)
                      .updateTask(index!, textValue);
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

Future<String?> showEditTaskDialog(
  BuildContext context,
  EditMode editMode, {
  int? index,
  String? name,
}) async {
  return await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      switch (editMode) {
        case EditMode.add:
          return EditTaskDialog.addTask();
        case EditMode.edit:
          return EditTaskDialog.editTask(index!, name!);
      }
    },
  );
}
