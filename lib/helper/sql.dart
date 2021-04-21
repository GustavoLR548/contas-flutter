import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class SQLDatabase {
  static Future<Database> get database async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'contas.db'),
        onCreate: (db, version) async {
      await db.execute('CREATE TABLE users(' +
          'id INTEGER PRIMARY KEY,' +
          'name TEXT,' +
          'email TEXT,' +
          'password TEXT)');
      version++;
      await db.execute('CREATE TABLE contas(' +
          'id INTEGER PRIMARY KEY,' +
          'creator_id INTEGER,' +
          'target_time TEXT,' +
          'title TEXT,' +
          'description TEXT,' +
          'icon INTEGER)');
    }, version: 1);
  }

  static Future<int> insert(String table, Map<String, Object> data) async {
    final sqlDb = await SQLDatabase.database;
    return await sqlDb.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
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
