import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  static Future<void> init() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin!.initialize(initializationSettings);
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
    await _flutterLocalNotificationsPlugin!
        .show(0, title, body, platformChannelSpecifics, payload: 'Apneadiag');
  }
}
