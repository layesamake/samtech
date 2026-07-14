import 'package:spk_db_001/src/security/database_key.dart';
import 'package:sqlite3/sqlite3.dart';

void configureEncryptedConnection(Database database, DatabaseKey key) {
  if (database.select('PRAGMA cipher;').isEmpty) {
    throw StateError('SQLite3MultipleCiphers is not linked into this binary.');
  }

  database
    ..execute("PRAGMA cipher = 'chacha20';")
    ..execute('PRAGMA key = "x\'${key.toHex()}\'";')
    ..execute('PRAGMA foreign_keys = ON;')
    ..execute('PRAGMA secure_delete = ON;')
    ..execute('PRAGMA temp_store = MEMORY;')
    ..execute('PRAGMA journal_mode = WAL;');
}

bool encryptedConnectionIsAvailable(Database database) =>
    database.select('PRAGMA cipher;').isNotEmpty;
