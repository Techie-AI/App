import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'result_data.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE results(date TEXT PRIMARY KEY, data TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> saveResult(String date, String data) async {
    final db = await database;
    await db.insert(
      'results',
      {'date': date, 'data': data},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getResults() async {
    final db = await database;
    return db.query('results');
  }
}
