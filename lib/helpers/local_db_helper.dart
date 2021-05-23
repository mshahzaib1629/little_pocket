import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/models/tag.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();

    return sql.openDatabase(path.join(dbPath, 'localdata.db'),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE tags(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, tagType TEXT, lastTimeUsed TEXT, isActive INT)');
      db.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, tagId INT, dateTime TEXT, amount REAL, transactionType TEXT, balanceChange TEXT, description TEXT)');
      db.execute(
          'CREATE TABLE mini_transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, transactionId INT, name TEXT, amount REAL, balanceChange TEXT)');

      // Create Adjustment Tag here while creating db just after tables
      Tag adjustmentTag = Tag(
        name: 'Adjustment',
        tagType: TagType.Adjustment,
        lastTimeUsed: DateTime.now(),
        isActive: true,
      );
      insert('tags', adjustmentTag.toMap());
    }, version: 1);
  }

  static Future<int> insert(String table, Map<String, Object> data) async {
    final db = await LocalDatabase.database();
    int id = await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getTagsOfType(
      TagType tagType) async {
    final db = await LocalDatabase.database();
    return db
        .query('tags', where: 'tagType = ?', whereArgs: [tagType.toString()]);
  }

  static Future<void> delete(String table, int id) async {
    final db = await LocalDatabase.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}