import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:medihelp/screens/reminder-screen.dart';

import '../components/alarm-info.dart';

class datetime extends StatefulWidget {
  const datetime({Key? key}) : super(key: key);

  @override
  State<datetime> createState() => _datetimeState();
}

class _datetimeState extends State<datetime> {
  DateTime dateTime = DateTime(2023, 5, 26, 5, 30);
  TextEditingController _mednameController = TextEditingController();
  String medNameDosage = "";
  void saveInputText(String text) {
    setState(() {
      medNameDosage = text;
      print(medNameDosage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Text(
                "Select Date",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final date = await pickdate();
                        if (date == null) return;
                        final newDateTime = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          dateTime.hour,
                          dateTime.minute,
                        );
                        showDatePicker(
                          context: context,
                          initialDate: dateTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2025),
                        ).then((date) {
                          setState(() {
                            dateTime = date!;
                          });
                        });
                      },
                      icon: Icon(Icons.calendar_today),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Select Time",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '$hours:$minutes',
                      ),
                    ]),
              ),
              IconButton(
                onPressed: () async {
                  final time = await pickTime();
                  if (time == null) return;
                  final newDateTime = DateTime(
                    dateTime.year,
                    dateTime.month,
                    dateTime.day,
                    time.hour,
                    time.minute,
                  );
                  setState(() {
                    dateTime = newDateTime;
                  });
                },
                icon: Icon(Icons.access_time),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  print(dateTime);
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReminderPage(),
                    ),
                  );
                  int notifID = getNotifID();
                  alarmList.add(AlarmInfo(
                    dateTime,
                    medNameDosage,
                    notifID,
                  ));
                  scheduleNotification(
                    dateTime,
                    notifID,
                    medNameDosage,
                  );
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (text) {
                  saveInputText(text);
                },
                controller: _mednameController,
                decoration: InputDecoration(
                  labelText: 'Enter medicine name',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> pickdate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );

  int getNotifID() {
    int id = AlarmInfo.id += 1;
    return id;
  }
}
