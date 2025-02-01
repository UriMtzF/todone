import 'package:drift/drift.dart';

Never _unsupported() {
  throw UnsupportedError('No suitable sqlite implementation for this platform');
}

Future<void> validateDatabaseSchema(GeneratedDatabase database) {
  _unsupported();
}
