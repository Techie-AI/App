// lib/database_helper.dart
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Initialize sqflite_ffi for desktop platforms
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'result_data.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE results(date TEXT PRIMARY KEY, name TEXT, data TEXT)',
        );
      },
      version: 1,
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < newVersion) {
          db.execute('ALTER TABLE results ADD COLUMN name TEXT');
        }
      },
    );
  }

  Future<void> saveResult(String date, String name, String data) async {
    final db = await database;
    await db.insert(
      'results',
      {'date': date, 'name': name, 'data': data},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getResults() async {
    try {
      final db = await database;

      // Check if the results table exists
      final List<Map<String, dynamic>> tableInfo = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='results'");

      if (tableInfo.isEmpty) {
        // Table does not exist, create it
        await db.execute(
          'CREATE TABLE results(date TEXT PRIMARY KEY, name TEXT, data TEXT)',
        );
        return [];
      }

      final results = await db.query('results');
      return results.isNotEmpty ? results : [];
    } catch (e) {
      print("Database error: $e");
      return []; // Error handling or database/table doesn't exist
    }
  }
}
