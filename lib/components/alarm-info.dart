import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medihelp/services/SQLHelper.dart';

class AlarmInfo {
  static int id = 0;
  int alarmId;
  DateTime alarmTime;
  String description;
  AlarmInfo(this.alarmTime, this.description, this.alarmId);
  static void updateId() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      id++; // Increment the id by 1 every 2 seconds
    });
  }
}

List<AlarmInfo> alarmList = [];

void addValuesFromDB() async {
  print("Adding DB values to List");
  var data = await SQLHelper.instance.queryRecord();
  for (Map<String, dynamic> it in data) {
    AlarmInfo alarmInfo = AlarmInfo(
        getDateTimeFromString(it[SQLHelper.columnTime]),
        it[SQLHelper.columnDesc],
        it[SQLHelper.columnID]);
    alarmList.add(alarmInfo);
  }
}

DateTime getDateTimeFromString(String s) {
  try {
    return DateTime.parse(s);
  } catch (e) {
    return DateTime(1999);
  }
}
