import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager extends ChangeNotifier {
  static bool _micPermissionGranted = false;
  static bool _notificationPermissionGranted = false;
  static bool _ignoreBatteryOptimizationsGranted = false;

  static Future<void> init() async {
    _micPermissionGranted = await Permission.microphone.isGranted;
    _notificationPermissionGranted = await Permission.notification.isGranted;
    _ignoreBatteryOptimizationsGranted =
        await Permission.ignoreBatteryOptimizations.isGranted;
  }

  Future<void> requestMicPermission() async {
    await Permission.microphone.request();
    _micPermissionGranted = await Permission.microphone.isGranted;
    notifyListeners();
  }

  Future<void> requestNotificationPermission() async {
    await Permission.notification.request();
    _notificationPermissionGranted = await Permission.notification.isGranted;
    notifyListeners();
  }

  Future<void> requestIgnoreBatteryOptimizations() async {
    await Permission.ignoreBatteryOptimizations.request();
    _ignoreBatteryOptimizationsGranted =
        await Permission.ignoreBatteryOptimizations.isGranted;
    notifyListeners();
  }

  bool get micPermissionGranted => _micPermissionGranted;
  bool get notificationPermissionGranted => _notificationPermissionGranted;
  bool get ignoreBatteryOptimizationsGranted =>
      _ignoreBatteryOptimizationsGranted;
  bool get allPermissionsGranted =>
      _micPermissionGranted &&
      _notificationPermissionGranted &&
      _ignoreBatteryOptimizationsGranted;
}
