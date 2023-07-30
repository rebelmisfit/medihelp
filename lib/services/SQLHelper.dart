import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SQLHelper {
  static const dbName = "medihelp.db";
  static const dbVersion = 1;
  static const dbTable = "medInfo";
  static const columnID = "id";
  static const columnDesc = "desc";
  static const columnTime = "time";
  //constructor
  static final SQLHelper instance = SQLHelper();
  //initialising db
  static Database? _database;

  Future<Database?> get database async {
    _database ??= await initDB();
    return _database;
    //   if (database != null) return _database;
    //
    //   _database = await initDB();
    //   return _database;
  }

  initDB() async {
    print("I am inside init method !!");
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    db.execute('''
    CREATE TABLE $dbTable (
      $columnID INT PRIMARY KEY,
      $columnDesc TEXT NOT NULL,
      $columnTime TEXT NOT NULL
    )
    ''');
    print("table created successfully");
  }

  insertRecord(Map<String, dynamic> row) async {
    print("I am inside insertRecord");
    Database? db = await instance.database;
    return await db!.insert(dbTable, row);
  }

  Future<List<Map<String, dynamic>>> queryRecord() async {
    Database? db = await instance.database;
    return await db!.query(dbTable);
  }

  Future<int> updateRecord(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnID];
    return db!.update(dbTable, row, where: "$columnID = ?", whereArgs: [id]);
  }

  Future<int> deleteRecorde(int id) async {
    Database? db = await instance.database;
    return await db!.delete(dbTable, where: "$columnID = ?", whereArgs: [id]);
  }
}

