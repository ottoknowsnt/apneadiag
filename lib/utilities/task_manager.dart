import 'dart:async';

import 'package:flutter/material.dart';

class TaskManager {
  static List<Timer> _timers = <Timer>[];
  static Duration calculateInitialDelay(TimeOfDay scheduledTime) {
    final DateTime now = DateTime.now();
    DateTime scheduledDateTime = DateTime(
        now.year, now.month, now.day, scheduledTime.hour, scheduledTime.minute);
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }
    return scheduledDateTime.difference(now);
  }

  static void scheduleTask(
      {required TimeOfDay scheduledTime, required void Function() task}) {
    // We create a timer to run the first time the task is scheduled
    // and another timer to run the task periodically
    _timers.add(Timer(
        calculateInitialDelay(scheduledTime),
        () => <void>{
              task(),
              _timers.add(Timer.periodic(
                  const Duration(days: 1), (Timer timer) => task()))
            }));
  }

  static void cancelAllTasks() {
    for (final Timer timer in _timers) {
      timer.cancel();
    }
    _timers = <Timer>[];
  }
}
