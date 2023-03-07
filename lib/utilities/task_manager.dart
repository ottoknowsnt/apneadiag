import 'dart:async';

class TaskManager {
  static List<Timer> _timers = [];
  static Duration calculateInitialDelay(DateTime scheduledTime) {
    if (scheduledTime.isBefore(DateTime.now())) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    return scheduledTime.difference(DateTime.now());
  }

  // For allowing functions with parameters to be passed as tasks
  // we need to use a wrapper function
  static void scheduleTask(
      {required DateTime scheduledTime, required Function() task}) {
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
