import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/app_data.dart';
import '../utilities/permission_manager.dart';
import 'onboarding_page.dart';
import 'permissions_page.dart';
import 'recorder_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AppData appData = context.watch<AppData>();
    final bool isLogged = appData.isLogged;
    final PermissionManager permissionManager =
        context.watch<PermissionManager>();
    final bool allPermissionsGranted = permissionManager.allPermissionsGranted;

    if (!isLogged) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return const OnboardingPage();
      });
    } else if (!allPermissionsGranted) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          body: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            alignment: Alignment.center,
            child: const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: PermissionsPage(),
              ),
            ),
          ),
        );
      });
    } else {
      // We have all permissions and the user is logged in
      // We can start the recording service
      AppData.scheduleRecording();
      Widget page;
      switch (selectedIndex) {
        case 0:
          page = const RecorderPage();
          break;
        case 1:
          page = const SettingsPage();
          break;
        default:
          throw UnimplementedError('no widget for $selectedIndex');
      }

      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          bottomNavigationBar: NavigationBar(
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.mic),
                label: 'Grabadora',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: 'Ajustes',
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (int value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
          body: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            alignment: Alignment.center,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: page,
              ),
            ),
          ),
        );
      });
    }
  }
}
