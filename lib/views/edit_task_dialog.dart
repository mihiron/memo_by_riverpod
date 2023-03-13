import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_by_riverpod/models/tasks.dart';

enum AddEditMode {
  addFirst,
  addLast,
  edit,
}

class EditTaskDialog extends ConsumerWidget {
  const EditTaskDialog({
    super.key,
    required this.addEditMode,
    required this.textEditingController,
    this.index,
    this.name,
  });

  final AddEditMode addEditMode;
  final TextEditingController textEditingController;
  final int? index;
  final String? name;

  factory EditTaskDialog.addFirstTask() {
    return EditTaskDialog(
      addEditMode: AddEditMode.addFirst,
      textEditingController: TextEditingController(),
    );
  }

  factory EditTaskDialog.addLastTask() {
    return EditTaskDialog(
      addEditMode: AddEditMode.addLast,
      textEditingController: TextEditingController(),
    );
  }

  factory EditTaskDialog.editTask(int index, String name) {
    return EditTaskDialog(
      addEditMode: AddEditMode.edit,
      textEditingController: TextEditingController(),
      index: index,
      name: name,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        title: (() {
          switch (addEditMode) {
            case AddEditMode.addFirst:
              return const Text('タスクを追加');
            case AddEditMode.addLast:
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
              //TODO: drift利用時にidをオートインクリメントするように修正
              switch (addEditMode) {
                case AddEditMode.addFirst:
                  ref.read(tasksProvider.notifier).addFirstTask(
                      Task(id: 1, name: textValue, isCompleted: false));
                  break;
                case AddEditMode.addLast:
                  ref.read(tasksProvider.notifier).addLastTask(
                      Task(id: 1, name: textValue, isCompleted: false));
                  break;
                case AddEditMode.edit:
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
