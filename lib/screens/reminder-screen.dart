import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medihelp/main.dart';
import '/components/alarm-info.dart';
import 'package:timezone/timezone.dart' as tz;

import 'add-reminder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meditation App',
      theme: ThemeData(
        fontFamily: "SourceSansPro",
        scaffoldBackgroundColor: Color(0xFFA7B2D0),
        //textTheme: Theme.of(context).textTheme.apply(displayColor: kTextColor),
      ),
      home: ReminderPage(),
    );
  }
}

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Center(
              child: const Text(
                "Reminders",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: "SourceSansPro",
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: alarmList.map((alarm) {
                  String amOrPm;
                  if (alarm.alarmTime.hour > 11) {
                    amOrPm = "pm";
                  } else {
                    amOrPm = "am";
                    print(alarm.alarmId);
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 36),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF375AB4),
                          Color(0xFFF2BEA1),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.label,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  alarm.description,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'avenir'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              alarm.alarmTime.hour.toString() +
                                  " : " +
                                  alarm.alarmTime.minute.toString() +
                                  "  " +
                                  amOrPm,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'avenir',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                deleteNotification(alarm.alarmId);
                                removeElementFromList(alarm.alarmId);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).followedBy(
                  [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF375AB4),
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const datetime(),
                            ),
                          );
                          //scheduleNotification();
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.add_alarm_outlined,
                              size: 24,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Add Reminder",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void scheduleNotification(DateTime dt, int notifID, String description) async {
  String timeZone = 'Asia/Kolkata';
  var scheduleNotifcationDateTime =
      tz.TZDateTime.from(dt, tz.getLocation(timeZone));
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'alarm_notif',
    'alarm_notif',
    channelDescription: 'Channel for Alarm notification',
    icon: 'medihelp_logo',
    largeIcon: DrawableResourceAndroidBitmap('medihelp_logo'),
  );
  var iOSPlatformChannelSpecifics = DarwinNotificationDetails(
    sound: 'a_long_cold_sting.wav',
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  notificationPlugin = FlutterLocalNotificationsPlugin();
  await notificationPlugin.zonedSchedule(
    notifID,
    description,
    "",
    scheduleNotifcationDateTime,
    platformChannelSpecifics,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
  );
}

void deleteNotification(int notifID) async {
  await notificationPlugin.cancel(
    notifID,
  );
  print("deleted id\n");
  print(notifID);
}

void removeElementFromList(int id) {
  int index = -1;
  for (int i = 0; i < alarmList.length; i++) {
    if (alarmList[i].alarmId == id) {
      index = i;
      break;
    }
  }
  if (index != -1) {
    alarmList.removeAt(index);
  }
}
