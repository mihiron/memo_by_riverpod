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

  void addFirstTask(Task newTask) {
    state = [newTask, ...state];
  }

  void addLastTask(Task newTask) {
    state = [...state, newTask];
  }

  void deleteTask(int index) {
    state = List.from(state)..removeAt(index);
  }

  void updateTask(int index, String name) {
    state = [
      ...state.sublist(0, index),
      state[index].copyWith(name: name),
      ...state.sublist(index + 1),
    ];
  }

  void toggleCompleted(int index) {
    state = [
      ...state.sublist(0, index),
      state[index].copyWith(isCompleted: !state[index].isCompleted),
      ...state.sublist(index + 1),
    ];
  }

  void reorderTask(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final newState = List<Task>.from(state);
    newState.insert(newIndex, newState.removeAt(oldIndex));
    state = newState;
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier();
});
