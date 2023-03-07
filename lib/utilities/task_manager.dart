import 'dart:async';

import 'package:flutter/material.dart';

class TaskManager {
  static List<Timer> _timers = [];
  static Duration calculateInitialDelay(TimeOfDay scheduledTime) {
    var now = DateTime.now();
    var scheduledDateTime = DateTime(now.year, now.month,
        now.day, scheduledTime.hour, scheduledTime.minute);
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }
    return scheduledDateTime.difference(now);
  }

  static void scheduleTask(
      {required TimeOfDay scheduledTime, required Function() task}) {
    // We create a timer to run the first time the task is scheduled
    // and another timer to run the task periodically
    _timers.add(Timer(
        calculateInitialDelay(scheduledTime),
        () => {
              task(),
              _timers.add(
                  Timer.periodic(const Duration(days: 1), (timer) => task()))
            }));
  }

  static void cancelAllTasks() {
    for (var timer in _timers) {
      timer.cancel();
    }
    _timers = [];
  }
}
