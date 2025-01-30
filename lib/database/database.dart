import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:todone/database/id.dart';
import 'package:todone/database/todo_items.dart';

part 'database.g.dart';

@DriftDatabase(tables: [TodoItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        for (final table in allTables) {
          await m.deleteTable(table.actualTableName);
          await m.createAll();
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'todone_db',
    );
  }

  Future<void> deleteTodo(String id) async {
    await (delete(todoItems)..where((item) => item.id.equals(id))).go();
  }

  Future<void> deleteDoneTodo() async {
    await (delete(todoItems)..where((item) => item.completed.equals(true)))
        .go();
  }

  Future<void> updateDone(String id) async {
    final task = await (select(todoItems)..where((item) => item.id.equals(id)))
        .getSingle();

    await (update(todoItems)..where((item) => item.id.equals(id)))
        .write(TodoItemsCompanion(completed: Value(!task.completed)));
  }
}

final AppDatabase database = AppDatabase();
