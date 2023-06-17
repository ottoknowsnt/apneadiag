import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> startForegroundService(
      {required int id,
      required String title,
      required String body,
      Set<AndroidServiceForegroundType>? foregroundServiceTypes}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'apneadiag',
      'Apneadiag',
      channelDescription: 'Apneadiag Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      ongoing: true,
      autoCancel: false,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(id, title, body,
            notificationDetails: androidPlatformChannelSpecifics,
            payload: 'Apneadiag',
            foregroundServiceTypes: foregroundServiceTypes);
  }

  static Future<void> stopForegroundService() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.stopForegroundService();
  }

  static Future<void> showNotification(
      {required int id, required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'apneadiag',
      'Apneadiag',
      channelDescription: 'Apneadiag Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin
        .show(id, title, body, platformChannelSpecifics, payload: 'Apneadiag');
  }

  static Future<void> scheduleNotification(
      {required int id,
      required String title,
      required String body,
      required TimeOfDay scheduledTime,
      required bool fullScreenIntent}) async {
    final DateTime now = DateTime.now();
    final DateTime scheduledDateTime = DateTime(
        now.year, now.month, now.day, scheduledTime.hour, scheduledTime.minute);
    tz_data.initializeTimeZones();
    final tz.TZDateTime scheduledDateTz =
        tz.TZDateTime.from(scheduledDateTime, tz.local);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'apneadiag',
      'Apneadiag',
      channelDescription: 'Apneadiag Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      fullScreenIntent: fullScreenIntent,
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id, title, body, scheduledDateTz, platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'Apneadiag');
  }

  static Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
