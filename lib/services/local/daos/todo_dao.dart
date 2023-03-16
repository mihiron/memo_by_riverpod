import 'package:drift/drift.dart';
import 'package:memo_by_riverpod/services/local/database.dart';

part 'todo_dao.g.dart';

@DriftAccessor(tables: [Todos])
class TodosDao extends DatabaseAccessor<AppDatabase> with _$TodosDaoMixin {
  TodosDao(AppDatabase db) : super(db);

  Future<List<Todo>> getAllTodos() {
    return select(todos).get();
  }

  Stream<List<Todo>> watchAllTodos() {
    return select(todos).watch();
  }

  Future<int> insertTodo(TodosCompanion todo) {
    return into(todos).insert(todo);
  }

  Future updateTodo(Todo todo) {
    return update(todos).replace(todo);
  }

  Future deleteTodoById(int id) {
    return (delete(todos)..where((tbl) => tbl.id.equals(id))).go();
  }
}
