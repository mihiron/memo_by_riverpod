import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

part 'todos_test.g.dart';

void main() {
  MyDatabase? database;

  setUp(() {
    database = MyDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database!.close();
  });

  group('TodoのCRUDテスト', () {
    test('追加した要素の中身がtestになっているかテスト', () async {
      //'test'というnameの要素を追加
      await database!.addTodo('test');

      //すべてのList<Todo>を取得
      final todo = await database!.allTodoEntries;

      //todoの最初の要素のnameが'test'であるかテスト
      expect(todo.first.name, 'test');
    });

    test('要素の数が増えているかテスト', () async {
      //追加前のリストを用意
      final before = await database!.allTodoEntries;

      //要素の数が0個であるかテスト
      expect(before.length, 0);

      //リストに要素を1つ追加
      await database!.addTodo('test');

      //追加後のリストを取得する
      final after = await database!.allTodoEntries;

      //要素の数が増えているかテストする
      expect(after.length, 1);
    });

    test('要素が削除できているかテスト', () async {
      await database!.addTodo('test');

      final before = await database!.allTodoEntries;

      //要素を追加したため、要素の数が1つかテスト
      expect(before.length, 1);

      //要素を1つ削除する
      await database!.deleteTodo(before[before.length - 1]);

      //要素を削除後のリストを取得
      final after = await database!.allTodoEntries;

      //要素の数が0個かテスト
      expect(after.length, 0);
    });
  });
}

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 0, max: 20)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Todos])
class MyDatabase extends _$MyDatabase {
  MyDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  //データベースの値をStreamで取得
  Stream<List<Todo>> watchEntries() {
    return (select(todos).watch());
  }

  //データベースの値を取得
  Future<List<Todo>> get allTodoEntries => select(todos).get();

  //データを追加
  Future<int> addTodo(String name) async {
    return into(todos).insert(TodosCompanion(name: Value(name)));
  }

  //データを更新
  Future<int> updateTodo(Todo todo, String name) async {
    return (update(todos)..where((tbl) => tbl.id.equals(todo.id)))
        .write(TodosCompanion(name: Value(name)));
  }

  //データを削除
  Future<void> deleteTodo(Todo todo) {
    return (delete(todos)..where((tbl) => tbl.id.equals(todo.id))).go();
  }
}
