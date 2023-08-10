import 'package:sqflite/sqflite.dart' as sql;

class Category {
  final int id;
  final String name;

  Category(this.id, this.name);
}

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        author_name TEXT NOT NULL,
        author_phone TEXT NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        image TEXT,
        price REAL
)""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("database_name.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
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
      String author_phone,
      String? image,
      int? price) async {
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
    String author_phone,
    String? image,
    int? price,
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
