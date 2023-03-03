import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/screens/home_page.dart';
import 'package:apneadiag/utilities/local_notifications.dart';
import 'package:apneadiag/utilities/sound_recorder.dart';
import 'package:apneadiag/utilities/app_data.dart';
import 'package:apneadiag/utilities/alarm_manager.dart';

void testNotification() {
  LocalNotifications.showNotification(
    title: 'Test notification',
    body: 'This is a test notification',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prepare everything before running the app
  await AppData.init();
  await SoundRecorder.init();
  await LocalNotifications.init();
  await AlarmManager.init();
  // Schedule a notification at 23:30 to remind the user of the recording
  LocalNotifications.scheduleNotification(
      title: 'Grabación programada',
      body: 'Grabación programada para las 23:45',
      scheduledDate: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 23, 30));
  // Test AlarmManager
  AlarmManager.scheduleAlarm(
      id: 0,
      scheduledTime: DateTime.now().add(const Duration(seconds: 5)),
      callback: testNotification);
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
