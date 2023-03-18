import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_by_riverpod/main.dart';
import 'package:memo_by_riverpod/services/local/database.dart';

final todoStreamProvider = StreamProvider<List<Todo>>((ref) {
  final localRepo = ref.read(localRepoProvider);
  final todoRepo = localRepo.todoRepo;
  return todoRepo.watchAllTodos();
});

final todoRepoProvider = Provider((ref) {
  final localRepo = ref.read(localRepoProvider);
  final todoRepo = localRepo.todoRepo;
  return todoRepo;
});
