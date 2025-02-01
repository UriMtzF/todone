import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todone/database/connection/connection.dart' as impl;
import 'package:todone/database/id.dart';
import 'package:todone/database/todo_items.dart';

part 'database.g.dart';

@DriftDatabase(tables: [TodoItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
      : super(
          e ??
              driftDatabase(
                name: 'todone_db',
                native: const DriftNativeOptions(
                  databaseDirectory: getApplicationSupportDirectory,
                ),
                web: DriftWebOptions(
                  sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                  driftWorker: Uri.parse('drift_worker.js'),
                  onResult: (result) {
                    if (result.missingFeatures.isNotEmpty) {
                      debugPrint(
                        'Using ${result.chosenImplementation}'
                        ' due to unsupported '
                        'browser features: ${result.missingFeatures}',
                      );
                    }
                  },
                ),
              ),
        );

  AppDatabase.forTesting(DatabaseConnection super.connection);

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
      beforeOpen: (details) async {
        await impl.validateDatabaseSchema(this);
      },
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

  Future<void> addTodo(String title, String? body, DateTime? dueDate) async {
    await into(todoItems).insert(
      TodoItemsCompanion.insert(
        title: title,
        body: Value(body),
        due: Value(dueDate?.toUtc()),
      ),
    );
  }
}

final AppDatabase database = AppDatabase();
