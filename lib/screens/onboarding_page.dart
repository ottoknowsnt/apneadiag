import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/permission_manager.dart';
import 'instructions_page.dart';
import 'permissions_page.dart';
import 'register_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final PermissionManager permissionManager =
        context.watch<PermissionManager>();
    final bool allPermissionsGranted = permissionManager.allPermissionsGranted;

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        alignment: Alignment.center,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: const <Widget>[
                InstructionsPage(),
                PermissionsPage(),
                RegisterPage(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              // No back button on first page
              onPressed: currentIndex == 0
                  ? null
                  : () {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
              child: const Text('Atrás',
                  textAlign: TextAlign.center, softWrap: true),
            ),
            TextButton(
              // No next button if permissions are not granted or on last page
              onPressed: (currentIndex == 1 && !allPermissionsGranted) ||
                      currentIndex == 2
                  ? null
                  : () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
              child: const Text('Siguiente',
                  textAlign: TextAlign.center, softWrap: true),
            ),
          ],
        ),
      ),
    );
  }
}
