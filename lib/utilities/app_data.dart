import 'package:apneadiag/utilities/server_upload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:apneadiag/utilities/sound_recorder.dart';
import 'package:apneadiag/utilities/task_manager.dart';

class AppData extends ChangeNotifier {
  static String _id = '';
  static String _lastRecordingPath = '';
  static bool _autoMode = false;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.getString('id') ?? '';
    _lastRecordingPath = prefs.getString('lastRecordingPath') ?? '';
    _autoMode = prefs.getBool('autoMode') ?? false;
    if (_autoMode) {
      scheduleRecording();
    }
  }

  static void scheduleRecording() {
    var now = DateTime.now();
    var startScheduledTime = DateTime(
        now.year, now.month, now.day, 23, 45);
    TaskManager.scheduleTask(
        scheduledTime: startScheduledTime,
        task: () async {
          await SoundRecorder().start();
        });
    var stopScheduledTime = DateTime(
        now.year, now.month, now.day, 6, 45);
    TaskManager.scheduleTask(
        scheduledTime: stopScheduledTime,
        task: () async {
          await SoundRecorder().stop(AppData(), ServerUpload());
        });
  }

  Future<void> login(String id) async {
    _id = id;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', _id);
    notifyListeners();
  }

  Future<void> setLastRecordingPath(String path) async {
    _lastRecordingPath = path;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastRecordingPath', _lastRecordingPath);
    notifyListeners();
  }

  Future<void> setAutoMode(bool autoMode) async {
    _autoMode = autoMode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('autoMode', _autoMode);
    if (_autoMode) {
      scheduleRecording();
    } else {
      TaskManager.cancelAllTasks();
    }
    notifyListeners();
  }

  String get id => _id;
  bool get isLogged => _id.isNotEmpty;
  String get lastRecordingPath => _lastRecordingPath;
  bool get autoMode => _autoMode;

  Future<void> logout() async {
    _id = '';
    _lastRecordingPath = '';
    _autoMode = false;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', _id);
    prefs.setString('lastRecordingPath', _lastRecordingPath);
    prefs.setBool('autoMode', _autoMode);
    notifyListeners();
  }
}
