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
  static TimeOfDay _startScheduledTime = const TimeOfDay(hour: 23, minute: 45);
  static TimeOfDay _stopScheduledTime = calculateStopScheduledTime();
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
    _startScheduledTime = TimeOfDay(
        hour: prefs.getInt('startScheduledTimeHour') ?? 23,
        minute: prefs.getInt('startScheduledTimeMinute') ?? 45);
    _stopScheduledTime = calculateStopScheduledTime();
  }

  static TimeOfDay calculateStopScheduledTime() {
    return TimeOfDay(
        hour: (_startScheduledTime.hour + 7) % 24,
        minute: _startScheduledTime.minute);
  }

  static Future<void> scheduleRecording() async {
    LocalNotifications.cancelAllNotifications();
    TaskManager.cancelAllTasks();
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
    var subHour = 0;
    if ((_startScheduledTime.minute - 15) < 0) {
      subHour = 1;
    } else {
      subHour = 0;
    }
    await LocalNotifications.scheduleNotification(
        id: 0,
        title: 'Grabación programada',
        body:
            'Grabación programada para las ${_startScheduledTime.hour.toString().padLeft(2, '0')}:${_startScheduledTime.minute.toString().padLeft(2, '0')}',
        scheduledTime: TimeOfDay(
            hour: _startScheduledTime.hour - subHour,
            minute: (_startScheduledTime.minute - 15) % 60),
        fullScreenIntent: false);
    // Schedule a notification to remind the user of the recording 1 minute before it starts
    if ((_startScheduledTime.minute - 1) < 0) {
      subHour = 1;
    } else {
      subHour = 0;
    }
    await LocalNotifications.scheduleNotification(
        id: 1,
        title: 'Grabación a punto de comenzar',
        body:
            'Pulse aquí si no se ha abierto la aplicación para comenzar la grabación',
        scheduledTime: TimeOfDay(
            hour: _startScheduledTime.hour - subHour,
            minute: (_startScheduledTime.minute - 1) % 60),
        fullScreenIntent: true);
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

  Future<void> setStartScheduledTime(TimeOfDay time) async {
    _startScheduledTime = time;
    _stopScheduledTime = calculateStopScheduledTime();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('startScheduledTimeHour', _startScheduledTime.hour);
    prefs.setInt('startScheduledTimeMinute', _startScheduledTime.minute);
    await scheduleRecording();
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
  TimeOfDay get startScheduledTime => _startScheduledTime;
  TimeOfDay get stopScheduledTime => _stopScheduledTime;
}
