import 'package:actonic_adboard/models/database.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Advert {
  final int id;
  final String title;
  final String? description;
  final String category;
  final String authorName;
  final int authorPhone;
  final DateTime createdAt;
  final String? image;
  final double? price;

  Advert(
      {required this.id,
      required this.title,
      this.description,
      required this.category,
      required this.authorName,
      required this.authorPhone,
      required this.createdAt,
      this.image,
      this.price});

  Advert.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        category = map['category'],
        authorName = map['author_name'],
        authorPhone = map['author_phone'],
        createdAt = DateTime.parse(map['createdAt']),
        image = map['image'],
        price = map['price'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'author_name': authorName,
      'author_phone': authorPhone,
      'createdAt': createdAt.toString(),
      'image': image,
      'price': price
    };
  }

  static Future<int> create(String title, String? desc, String category,
      String authorName, int authorPhone, String? image, double? price) async {
    final db = await SQLHelper.db();

    final advert = Advert(
        id: 0,
        title: title,
        description: desc,
        category: category,
        authorName: authorName,
        authorPhone: authorPhone,
        createdAt: DateTime.now(),
        image: image,
        price: price);

    final id = await db.insert('data', advert.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Advert>> getAll() async {
    final db = await SQLHelper.db();

    final List<Map<String, dynamic>> maps =
        await db.query('data', orderBy: 'id');

    return List.generate(maps.length, (i) {
      return Advert.fromMap(maps[i]);
    });
  }

  static Future<Advert?> getSingle(int id) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> maps =
        await db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
    if (maps.isNotEmpty) {
      return Advert.fromMap(maps.first);
    } else {
      return null;
    }
  }

  static Future<int> update(
    int id,
    String title,
    String? desc,
    String category,
    String authorName,
    int authorPhone,
    String? image,
    double? price,
  ) async {
    final db = await SQLHelper.db();
    final advert = Advert(
        id: id,
        title: title,
        description: desc,
        category: category,
        authorName: authorName,
        authorPhone: authorPhone,
        createdAt: DateTime.now(),
        image: image,
        price: price);
    final result = await db
        .update('data', advert.toMap(), where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> delete(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('data', where: 'id = ?', whereArgs: [id]);
    } catch (e) {}
  }
}
