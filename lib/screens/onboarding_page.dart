import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/screens/register_page.dart';
import 'package:apneadiag/screens/permissions_page.dart';
import 'package:apneadiag/utilities/permission_manager.dart';
import 'package:apneadiag/screens/instructions_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  var currentIndex = 0;
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var permissionManager = context.watch<PermissionManager>();
    var allPermissionsGranted = permissionManager.allPermissionsGranted;

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        alignment: Alignment.center,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: const [
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
          children: [
            TextButton(
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
