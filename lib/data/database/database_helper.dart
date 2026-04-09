import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'rick_morty.db';
  static const _databaseVersion = 2;
  static const table = 'characters';

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        status TEXT NOT NULL,
        species TEXT NOT NULL,
        type TEXT NOT NULL DEFAULT '',
        gender TEXT NOT NULL,
        origin_name TEXT NOT NULL,
        location_name TEXT NOT NULL,
        image TEXT NOT NULL,
        episode_count INTEGER NOT NULL,
        created TEXT NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        page INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_characters_page ON $table (page)');
    await db.execute(
      'CREATE INDEX idx_characters_favorite ON $table (is_favorite)',
    );
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Migration v1 → v2: recreate for schema safety.
    // Future migrations should be incremental (ALTER TABLE, etc.).
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS $table');
      await _onCreate(db, newVersion);
    }
  }
}
