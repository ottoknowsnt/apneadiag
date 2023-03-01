import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/screens/home_page.dart';
import 'package:apneadiag/utilities/local_notifications.dart';
import 'package:apneadiag/utilities/sound_recorder.dart';
import 'package:apneadiag/utilities/user_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prepare everything before running the app
  await UserData.init();
  await SoundRecorder.init();
  await LocalNotifications.init();

  runApp(const Apneadiag());
}

class Apneadiag extends StatelessWidget {
  const Apneadiag({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>(
          create: (context) => UserData(),
        ),
        ChangeNotifierProvider<SoundRecorder>(
          create: (context) => SoundRecorder(),
        ),
      ],
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
