import 'package:flutter/material.dart';

class AlarmInfo {
  DateTime alarmTime;
  String description;
  late bool isActive;

  AlarmInfo(this.alarmTime, {required this.description});
}

List<AlarmInfo> alarmList = [
  AlarmInfo(DateTime.now().add(Duration(hours: 1)), description: 'Office'),
  AlarmInfo(DateTime.now().add(Duration(hours: 2)), description: 'Lunch'),
];
