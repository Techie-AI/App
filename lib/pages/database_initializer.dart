// lib/database_initializer.dart
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseInitializer {
  static Future<void> initializeDatabase() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Initialize sqflite_ffi for desktop platforms
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final db = await openDatabase(
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

    // Ensure the table is created
    final List<Map<String, dynamic>> tableInfo = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='results'");

    if (tableInfo.isEmpty) {
      await db.execute(
        'CREATE TABLE results(date TEXT PRIMARY KEY, name TEXT, data TEXT)',
      );
    }

    await db.close();
  }
}
