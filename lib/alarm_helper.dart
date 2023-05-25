import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';

import 'components/alarm-info.dart';

//Singleton Pattern used
final String tableAlarm = 'alarm';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDateTime = 'alarmDateTime';
final String columnPending = 'isPending';
final String columnColorIndex = 'gradientColorIndex';

class AlarmHelper {
  Database _database;
  static AlarmHelper _alarmHelper = AlarmHelper();
  AlarmHelper._createInstance();
  factory AlarmHelper() {
    if (_alarmHelper == null) {
      _alarmHelper = AlarmHelper._createInstance();
    }
    return _alarmHelper;
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = "${dir}alarms.db";
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        create table $tableAlarm (
          $columnId integer primary
          $columnTitle text not null
          $columnDateTime text not null
          $columnPending integer,
          $columnColorIndex integer,
          )
        ''');
      },
    );
    return database;
  } //initialiseDatabase

  void insertAlarm(AlarmInfo alarmInfo) async {
    var db = await this.database;
    var result = db?.insert(
      tableAlarm,
      alarmInfo.toMap(),
    );
    print(result);
  }
}
