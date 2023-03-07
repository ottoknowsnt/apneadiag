import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class LocalNotifications {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(
      {required String title, required String body}) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'apneadiag',
      'Apneadiag',
      channelDescription: 'Apneadiag Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'Apneadiag');
  }

  static Future<void> scheduleNotification(
      {required String title,
      required String body,
      required TimeOfDay scheduledTime}) async {
    var now = DateTime.now();
    var scheduledDateTime = DateTime(now.year, now.month, now.day,
        scheduledTime.hour, scheduledTime.minute);
    tz_data.initializeTimeZones();
    final tz.TZDateTime scheduledDateTz =
        tz.TZDateTime.from(scheduledDateTime, tz.local);
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'apneadiag',
      'Apneadiag',
      channelDescription: 'Apneadiag Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0, title, body, scheduledDateTz, platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'Apneadiag');
  }
}
