import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

import 'dummy_data.dart';

class Category {
  final int id;
  final String name;

  Category(this.id, this.name);
}

class SQLHelper {
  static Future<String> get _databasePath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return path.join(directory.path, "database_name.db");
  }

  static Future<bool> checkDataExists(sql.Database database) async {
    final result = await database.rawQuery("SELECT COUNT(*) FROM data");
    return Sqflite.firstIntValue(result) == 0;
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE data(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        author_name TEXT NOT NULL,
        author_phone INTEGER NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        image TEXT,
        price REAL
      )
    """);
  }

  static Future<sql.Database> db() async {
    final String path = await _databasePath;
    final bool databaseExists = await File(path).exists();
    if (!databaseExists) {
      final sql.Database database = await sql.openDatabase(path, version: 1,
          onCreate: (sql.Database db, int version) async {
        await createTables(db);
        await createDummyData();
      });
      return database;
    } else {
      return sql.openDatabase(path);
    }
  }
}
