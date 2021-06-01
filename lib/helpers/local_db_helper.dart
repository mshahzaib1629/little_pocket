import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/models/tag.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();

    return sql.openDatabase(path.join(dbPath, 'localdata.db'),
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE tags(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, tagType TEXT, lastTimeUsed TEXT, isActive INT)');
      await db.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, tagId INT, dateTime TEXT, amount REAL, transactionType TEXT, balanceChange TEXT, description TEXT)');
      await db.execute(
          'CREATE TABLE mini_transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, transactionId INT, name TEXT, amount REAL, balanceChange TEXT)');
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

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await LocalDatabase.database();
    return db.query('transactions');
  }

  static Future<List<Map<String, dynamic>>> getMiniTransactions(
      int transId) async {
    final db = await LocalDatabase.database();
    return db.query(
      'mini_transactions',
      where: 'transactionId = ?',
      whereArgs: [transId],
    );
  }

  static Future<List<Map<String, dynamic>>> getTagsOfType(
      TagType tagType) async {
    final db = await LocalDatabase.database();
    return db.query(
      'tags',
      where: 'tagType = ? AND isActive = ?',
      whereArgs: [tagType.toString(), 1],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllTags() async {
    final db = await LocalDatabase.database();
    return db.query('tags');
  }

  static Future<Map<String, dynamic>> getTag(int id) async {
    final db = await LocalDatabase.database();
    var tagsFetched = await db.query(
      'tags',
      where: 'id = ?',
      whereArgs: [id],
    );
    return tagsFetched[0];
  }

  static Future<void> delete(String table, int id) async {
    final db = await LocalDatabase.database();
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteMiniTransactions(int transactionId) async {
    final db = await LocalDatabase.database();
    await db.delete('mini_transactions',
        where: 'transactionId = ?', whereArgs: [transactionId]);
  }

  static Future<void> update(
      String table, int id, Map<String, dynamic> data) async {
    final db = await LocalDatabase.database();
    await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> cleanDatabase() async {
    final db = await LocalDatabase.database();
    await db.delete('mini_transactions');
    await db.delete('transactions');
    await db.delete('tags');
  }
}
