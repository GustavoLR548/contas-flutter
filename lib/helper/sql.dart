import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class SQLDatabase {
  static Future<Database> get database async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'contas.db'),
        onCreate: (db, version) async {
      await db.execute('CREATE TABLE users(' +
          'id TEXT PRIMARY KEY,' +
          'name TEXT,' +
          'email TEXT' +
          'password TEXT,');
      await db.execute('CREATE TABLE contas(' +
          'id TEXT PRIMARY KEY,' +
          'creator_id TEXT' +
          'target_time TEXT' +
          'title TEXT,' +
          'description TEXT,' +
          'icon INTEGER');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final sqlDb = await SQLDatabase.database;
    sqlDb.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> read(String table) async {
    final sqlDb = await SQLDatabase.database;
    return sqlDb.query(table);
  }

  static Future<void> delete(String table, String id) async {
    final sqlDb = await SQLDatabase.database;
    sqlDb.delete(table, where: 'id=?', whereArgs: [id]);
  }
}
