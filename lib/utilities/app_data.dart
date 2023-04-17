import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:apneadiag/utilities/sound_recorder.dart';
import 'package:apneadiag/utilities/task_manager.dart';
import 'package:apneadiag/utilities/local_notifications.dart';

class AppData extends ChangeNotifier {
  static String _id = '';
  static int _age = 0;
  static double _weight = 0.0;
  static int _height = 0;
  static String _lastRecordingPath = '';
  static bool _autoMode = false;
  static TimeOfDay _startScheduledTime = const TimeOfDay(hour: 23, minute: 45);
  static TimeOfDay _stopScheduledTime = const TimeOfDay(hour: 6, minute: 45);
  static double _uploadSpeed = -1.00;

  static final AppData _instance = AppData._internal();

  factory AppData() {
    return _instance;
  }

  AppData._internal();

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.getString('id') ?? '';
    _age = prefs.getInt('age') ?? 0;
    _weight = prefs.getDouble('weight') ?? 0.0;
    _height = prefs.getInt('height') ?? 0;
    _lastRecordingPath = prefs.getString('lastRecordingPath') ?? '';
    _uploadSpeed = prefs.getDouble('uploadSpeed') ?? -1.00;
    _autoMode = prefs.getBool('autoMode') ?? false;
    // Start cleaning up the already scheduled notifications and tasks
    LocalNotifications.cancelAllNotifications();
    TaskManager.cancelAllTasks();
    if (_autoMode) {
      _startScheduledTime = TimeOfDay(
          hour: prefs.getInt('startScheduledTimeHour') ?? 23,
          minute: prefs.getInt('startScheduledTimeMinute') ?? 45);
      _stopScheduledTime = TimeOfDay(
          hour: prefs.getInt('stopScheduledTimeHour') ?? 6,
          minute: prefs.getInt('stopScheduledTimeMinute') ?? 45);
      await scheduleRecording();
    }
  }

  static Future<void> scheduleRecording() async {
    TaskManager.scheduleTask(
        scheduledTime: _startScheduledTime,
        task: () async {
          await SoundRecorder().start();
        });
    TaskManager.scheduleTask(
        scheduledTime: _stopScheduledTime,
        task: () async {
          await SoundRecorder().stop();
        });
    // Schedule a notification to remind the user of the recording 15 minutes before it starts
    await LocalNotifications.scheduleNotification(
        title: 'Grabación programada',
        body:
            'Grabación programada para las $_startScheduledTime.hour:$_startScheduledTime.minute',
        scheduledTime: TimeOfDay(
            hour: _startScheduledTime.hour,
            minute: _startScheduledTime.minute - 15));
  }

  Future<void> login(String id, int age, double weight, int height) async {
    _id = id;
    _age = age;
    _weight = weight;
    _height = height;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', _id);
    prefs.setInt('age', _age);
    prefs.setDouble('weight', _weight);
    prefs.setInt('height', _height);
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
    // Start cleaning up the already scheduled notifications and tasks
    LocalNotifications.cancelAllNotifications();
    TaskManager.cancelAllTasks();
    if (_autoMode) {
      await scheduleRecording();
    }
    notifyListeners();
  }

  Future<void> setStartScheduledTime(TimeOfDay time) async {
    _startScheduledTime = time;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('startScheduledTimeHour', _startScheduledTime.hour);
    prefs.setInt('startScheduledTimeMinute', _startScheduledTime.minute);
    // Start cleaning up the already scheduled notifications and tasks
    LocalNotifications.cancelAllNotifications();
    TaskManager.cancelAllTasks();
    if (_autoMode) {
      await scheduleRecording();
    }
    notifyListeners();
  }

  Future<void> setStopScheduledTime(TimeOfDay time) async {
    _stopScheduledTime = time;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('stopScheduledTimeHour', _stopScheduledTime.hour);
    prefs.setInt('stopScheduledTimeMinute', _stopScheduledTime.minute);
    // Start cleaning up the already scheduled notifications and tasks
    LocalNotifications.cancelAllNotifications();
    TaskManager.cancelAllTasks();
    if (_autoMode) {
      await scheduleRecording();
    }
    notifyListeners();
  }

  Future<void> setUploadSpeed(double speed) async {
    _uploadSpeed = speed;
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('uploadSpeed', _uploadSpeed);
    notifyListeners();
  }

  String get id => _id;
  int get age => _age;
  double get weight => _weight;
  int get height => _height;
  bool get isLogged => _id.isNotEmpty;
  String get lastRecordingPath => _lastRecordingPath;
  double get uploadSpeed => _uploadSpeed;
  bool get autoMode => _autoMode;
  TimeOfDay get startScheduledTime => _startScheduledTime;
  TimeOfDay get stopScheduledTime => _stopScheduledTime;
}
