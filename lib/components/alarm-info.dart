import 'package:flutter/material.dart';

class AlarmInfo {
  static int id = 0;
  int alarmId;
  DateTime alarmTime;
  String description;

  AlarmInfo(this.alarmTime, this.description, this.alarmId);
}

List<AlarmInfo> alarmList = [
  AlarmInfo(
      DateTime.now().add(Duration(hours: 1)), 'Office!', AlarmInfo.id += 1),
  AlarmInfo(DateTime.now().add(Duration(hours: 2)), 'Lunch', AlarmInfo.id += 1),
];
