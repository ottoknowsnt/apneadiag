import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class AlarmManager {
  static Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }

  static Future<void> scheduleAlarm(
      {required int id,
      required DateTime scheduledTime,
      required Function callback}) async {
    await AndroidAlarmManager.periodic(const Duration(days: 1), id, callback,
        startAt: scheduledTime, exact: true, rescheduleOnReboot: true);
  }
}
