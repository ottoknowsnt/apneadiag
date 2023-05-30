import 'package:apneadiag/screens/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/screens/recorder_page.dart';
import 'package:apneadiag/screens/settings_page.dart';
import 'package:apneadiag/utilities/app_data.dart';
import 'package:apneadiag/screens/permissions_page.dart';
import 'package:apneadiag/utilities/permission_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appData = context.watch<AppData>();
    var isLogged = appData.isLogged;
    var permissionManager = context.watch<PermissionManager>();
    var allPermissionsGranted = permissionManager.allPermissionsGranted;

    if (!isLogged && !allPermissionsGranted) {
      return LayoutBuilder(builder: (context, constraints) {
        return const OnboardingPage();
      });
    } else if (!allPermissionsGranted) {
      return LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          body: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            alignment: Alignment.center,
            child: const PermissionsPage(),
          ),
        );
      });
    } else {
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

      return LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          bottomNavigationBar: NavigationBar(
            destinations: const [
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
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
          body: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            alignment: Alignment.center,
            child: page,
          ),
        );
      });
    }
  }
}
