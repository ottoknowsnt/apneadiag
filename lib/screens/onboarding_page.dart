import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/screens/register_page.dart';
import 'package:apneadiag/screens/permissions_page.dart';
import 'package:apneadiag/utilities/permission_manager.dart';

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
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: const [
            PermissionsPage(),
            RegisterPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: !allPermissionsGranted || currentIndex == 1
                ? null
                : () {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
            child: const Text('Siguiente'),
          ),
        ),
      ),
    );
  }
}
