import 'package:memo_by_riverpod/services/local/database.dart';

import 'local_todo_repository.dart';

class LocalRepositoryProvider {
  final AppDatabase appDatabase;

  late final LocalTodoRepository todoRepo;

  LocalRepositoryProvider(this.appDatabase) {
    todoRepo = LocalTodoRepository(appDatabase);
  }
}
