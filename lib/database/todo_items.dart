import 'package:drift/drift.dart';
import 'package:todone/database/id.dart';

class TodoItems extends Table {
  TextColumn get id => text().clientDefault(ID.unique)();
  TextColumn get title => text().withLength(max: 100)();
  TextColumn get body => text().withDefault(const Variable(''))();
  BoolColumn get completed => boolean().withDefault(const Variable(false))();
  DateTimeColumn get creation =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get completion => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
