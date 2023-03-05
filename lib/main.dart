import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/screens/home_page.dart';
import 'package:apneadiag/utilities/local_notifications.dart';
import 'package:apneadiag/utilities/sound_recorder.dart';
import 'package:apneadiag/utilities/app_data.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'testNotification':
        LocalNotifications.showNotification(
            title: 'Test notification', body: 'This is a test notification');
        break;
      case 'scheduledNotification':
        LocalNotifications.showNotification(
            title: 'Scheduled notification',
            body: 'This is a scheduled notification');
        break;
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prepare everything before running the app
  await AppData.init();
  await SoundRecorder.init();
  await LocalNotifications.init();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);

  // Schedule a notification at 23:30 to remind the user of the recording
  LocalNotifications.scheduleNotification(
      title: 'Grabación programada',
      body: 'Grabación programada para las 23:45',
      scheduledDate: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 23, 30));
  // Test AlarmManager
  DateTime scheduledTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute + 1);
  if (scheduledTime.isBefore(DateTime.now())) {
    scheduledTime = scheduledTime.add(const Duration(days: 1));
  }
  Duration timeUntilScheduled = scheduledTime.difference(DateTime.now());
  Workmanager().registerPeriodicTask('startRecording', 'startRecording',
      initialDelay: timeUntilScheduled,
      frequency: const Duration(days: 1),
      constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: true,
          requiresCharging: true,
          requiresStorageNotLow: true));
  runApp(const Apneadiag());
}

class Apneadiag extends StatelessWidget {
  const Apneadiag({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Apneadiag',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.lightBlue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
