import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class Task {
  const Task({
    required this.id,
    required this.name,
    required this.isCompleted,
  });

  final int id;
  final String name;
  final bool isCompleted;

  Task copyWith({int? id, String? name, bool? isCompleted}) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

const List<Task> tasksList = [
  Task(id: 0, name: 'task1', isCompleted: false),
  Task(id: 1, name: 'task2', isCompleted: false),
  Task(id: 2, name: 'task3', isCompleted: false),
];

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super(tasksList);

  void addTask(Task newTask) {
    state = [...state, newTask];
  }

  void toggle(int id) {
    List<Task> newState = [];
    for (final task in state) {
      if (task.id == id) {
        newState.add(task.copyWith(isCompleted: !task.isCompleted));
      } else {
        newState.add(task);
      }
      state = newState;
    }
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier();
});
