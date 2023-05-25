import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medihelp/alarm_helper.dart';
import 'package:medihelp/components/notifi-service.dart';
import 'package:medihelp/main.dart';
import '/components/alarm-info.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  AlarmHelper _alarmHelper = AlarmHelper();
  @override
  void initState() {
    _alarmHelper.initializeDatabase().then((value) => {
          print("db ----initialised!"),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          const Text(
            "Reminders",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          Expanded(
            child: ListView(
              children: alarmList.map((alarm) {
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
                                alarm.title!,
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'avenir'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        'Mon-Fri',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'avenir'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "alarmTime",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'avenir',
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.white,
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
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(24),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _alarmHelper.initializeDatabase();
                        var alarmInfo = AlarmInfo(
                          alarmDateTime: DateTime.now(),
                          gradientColorIndex: alarmList.length,
                          title: "PBL",
                        );
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
    );
  }

  void scheduleNotification() async {
    var dateTime = DateTime.now().add(
      Duration(seconds: 10),
    );
    String timeZone = 'Asia/Kolkata';
    String sound = 'a_long_cold_sting.wav';
    var scheduleNotifcationDateTime =
        tz.TZDateTime.from(dateTime, tz.getLocation(timeZone));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      icon: 'medihelp_logo',
      largeIcon: DrawableResourceAndroidBitmap('medihelp_logo'),
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
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
      0,
      "Demo",
      "Hello!",
      scheduleNotifcationDateTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }
}
