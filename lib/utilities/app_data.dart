import 'package:apneadiag/utilities/server_upload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:apneadiag/utilities/sound_recorder.dart';
import 'package:apneadiag/utilities/task_manager.dart';
import 'package:apneadiag/utilities/local_notifications.dart';

class AppData extends ChangeNotifier {
  static String _id = '';
  static String _lastRecordingPath = '';
  static bool _autoMode = false;
  static TimeOfDay _startScheduledTime = const TimeOfDay(hour: 23, minute: 45);
  static TimeOfDay _stopScheduledTime = const TimeOfDay(hour: 6, minute: 45);
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.getString('id') ?? '';
    _lastRecordingPath = prefs.getString('lastRecordingPath') ?? '';
    _autoMode = prefs.getBool('autoMode') ?? false;
    if (_autoMode) {
      _startScheduledTime = TimeOfDay(
          hour: prefs.getInt('startScheduledTimeHour') ?? 23,
          minute: prefs.getInt('startScheduledTimeMinute') ?? 45);
      _stopScheduledTime = TimeOfDay(
          hour: prefs.getInt('stopScheduledTimeHour') ?? 6,
          minute: prefs.getInt('stopScheduledTimeMinute') ?? 45);
      scheduleRecording();
    }
  }

  static void scheduleRecording() {
    TaskManager.scheduleTask(
        scheduledTime: _startScheduledTime,
        task: () async {
          await SoundRecorder().start();
        });
    TaskManager.scheduleTask(
        scheduledTime: _stopScheduledTime,
        task: () async {
          await SoundRecorder().stop(AppData(), ServerUpload());
        });
    // Schedule a notification to remind the user of the recording 15 minutes before it starts
    LocalNotifications.scheduleNotification(
        title: 'Grabación programada',
        body: 'Grabación programada para las $_startScheduledTime.hour:$_startScheduledTime.minute',
        scheduledTime: TimeOfDay(
            hour: _startScheduledTime.hour,
            minute: _startScheduledTime.minute - 15));
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

  Future<void> setStartScheduledTime(TimeOfDay time) async {
    _startScheduledTime = time;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('startScheduledTimeHour', _startScheduledTime.hour);
    prefs.setInt('startScheduledTimeMinute', _startScheduledTime.minute);
    if (_autoMode) {
      TaskManager.cancelAllTasks();
      scheduleRecording();
    }
    notifyListeners();
  }

  Future<void> setStopScheduledTime(TimeOfDay time) async {
    _stopScheduledTime = time;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('stopScheduledTimeHour', _stopScheduledTime.hour);
    prefs.setInt('stopScheduledTimeMinute', _stopScheduledTime.minute);
    if (_autoMode) {
      TaskManager.cancelAllTasks();
      scheduleRecording();
    }
    notifyListeners();
  }

  String get id => _id;
  bool get isLogged => _id.isNotEmpty;
  String get lastRecordingPath => _lastRecordingPath;
  bool get autoMode => _autoMode;
  TimeOfDay get startScheduledTime => _startScheduledTime;
  TimeOfDay get stopScheduledTime => _stopScheduledTime;

  Future<void> logout() async {
    _id = '';
    _lastRecordingPath = '';
    _autoMode = false;
    _startScheduledTime = const TimeOfDay(hour: 23, minute: 45);
    _stopScheduledTime = const TimeOfDay(hour: 6, minute: 45);
    TaskManager.cancelAllTasks();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', _id);
    prefs.setString('lastRecordingPath', _lastRecordingPath);
    prefs.setBool('autoMode', _autoMode);
    prefs.setInt('startScheduledTimeHour', _startScheduledTime.hour);
    prefs.setInt('startScheduledTimeMinute', _startScheduledTime.minute);
    notifyListeners();
  }
}
