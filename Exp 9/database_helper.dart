import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'calculator.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            expression TEXT,
            result TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertHistory(String expression, String result) async {
    final dbClient = await db;
    await dbClient.insert('history', {
      'expression': expression,
      'result': result,
    });
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final dbClient = await db;
    return await dbClient.query('history', orderBy: 'id DESC');
  }

  Future<void> clearHistory() async {
    final dbClient = await db;
    await dbClient.delete('history');
  }
}
