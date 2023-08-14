import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

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

  static get io => null;

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        author_name TEXT NOT NULL,
        author_phone INTEGER NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        image TEXT,
        price REAL
)""");
  }

  static Future<sql.Database> db() async {
    final String path = await _databasePath;
    final bool databaseExists = File(await _databasePath).existsSync();

    if (!databaseExists) {
      final sql.Database database = await sql.openDatabase(path, version: 1,
          onCreate: (sql.Database database, int version) async {
        await createTables(database);
        await createDummyData();
      });
      return database;
    } else {
      return sql.openDatabase(path);
    }
  }

  static List<Category> categoriesList = [
    Category(1, 'Животные'),
    Category(2, 'Бытовая техника'),
    Category(3, 'Недвижимость'),
  ];

  static Future<int> createData(
      String title,
      String? desc,
      String category,
      String author_name,
      int author_phone,
      String? image,
      double? price) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': desc,
      'category': category,
      'author_name': author_name,
      'author_phone': author_phone,
      'createdAt': DateTime.now().toString(),
      'image': image,
      'price': price
    };
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLHelper.db();

    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SQLHelper.db();
    return db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(
    int id,
    String title,
    String? desc,
    String category,
    String author_name,
    int author_phone,
    String? image,
    double? price,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'description': desc,
      'category': category,
      'author_name': author_name,
      'author_phone': author_phone,
      'createdAt': DateTime.now().toString(),
      'image': image,
      'price': price
    };
    final result =
        await db.update('data', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('data', where: 'id = ?', whereArgs: [id]);
    } catch (e) {}
  }
}
