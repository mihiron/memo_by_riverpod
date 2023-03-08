import 'package:flutter/material.dart';

@immutable
class Task {
  Task({
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
