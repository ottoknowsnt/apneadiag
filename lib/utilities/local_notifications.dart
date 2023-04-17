import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> startForegroundService(
      {required String title,
      required String body,
      Set<AndroidServiceForegroundType>? foregroundServiceTypes}) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
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
        ?.startForegroundService(1, title, body,
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
      required TimeOfDay scheduledTime,
      required bool fullScreenIntent}) async {
    var now = DateTime.now();
    var scheduledDateTime = DateTime(
        now.year, now.month, now.day, scheduledTime.hour, scheduledTime.minute);
    tz_data.initializeTimeZones();
    final tz.TZDateTime scheduledDateTz =
        tz.TZDateTime.from(scheduledDateTime, tz.local);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'apneadiag',
      'Apneadiag',
      channelDescription: 'Apneadiag Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      fullScreenIntent: fullScreenIntent,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0, title, body, scheduledDateTz, platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'Apneadiag');
  }

  static Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
