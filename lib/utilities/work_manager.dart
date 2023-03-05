import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';

class WorkManager {
  static void init(callbackDispatcher) {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  }

  static void scheduleTask(
      {required String taskName,
      required String task,
      required DateTime scheduledDate,
      required Constraints constraints}) {
    if (scheduledDate.isBefore(DateTime.now())) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    Duration timeUntilScheduled = scheduledDate.difference(DateTime.now());
    Workmanager().registerPeriodicTask(taskName, task,
        initialDelay: timeUntilScheduled,
        frequency: const Duration(days: 1),
        constraints: constraints);
  }
}
