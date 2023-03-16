import 'package:memo_by_riverpod/services/local/daos/todo_dao.dart';
import 'package:memo_by_riverpod/services/local/database.dart';

class LocalTodoRepository {
  final TodosDao todosDao;

  LocalTodoRepository(AppDatabase appDatabase)
      : todosDao = appDatabase.todosDao;

  Future<List<Todo>> getAllTodos() {
    return todosDao.getAllTodos();
  }

  Stream<List<Todo>> watchAllTodos() {
    return todosDao.watchAllTodos();
  }

  Future<void> insertTodo(TodosCompanion todo) {
    return todosDao.insertTodo(todo);
  }

  Future<void> updateTodo(Todo todo) {
    return todosDao.updateTodo(todo);
  }

  Future<void> deleteTodo(int id) {
    return todosDao.deleteTodoById(id);
  }
}
