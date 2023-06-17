import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_page.dart';
import 'utilities/app_data.dart';
import 'utilities/local_notifications.dart';
import 'utilities/permission_manager.dart';
import 'utilities/server_upload.dart';
import 'utilities/sound_recorder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prepare everything before running the app
  await AppData.init();
  await LocalNotifications.init();
  await PermissionManager.init();

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
        ChangeNotifierProvider(create: (BuildContext context) => SoundRecorder()),
        ChangeNotifierProvider(create: (BuildContext context) => AppData()),
        ChangeNotifierProvider(create: (BuildContext context) => ServerUpload()),
        ChangeNotifierProvider(create: (BuildContext context) => PermissionManager()),
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
