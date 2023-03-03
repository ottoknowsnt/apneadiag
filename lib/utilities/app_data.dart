import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  static String _id = '';
  static String _lastRecordingPath = '';
  static bool _isRecording = false;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.getString('id') ?? '';
    _lastRecordingPath = prefs.getString('lastRecordingPath') ?? '';
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

  Future<void> setIsRecording(bool isRecording) async {
    _isRecording = isRecording;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isRecording', _isRecording);
    notifyListeners();
  }

  String get id => _id;
  bool get isLogged => _id.isNotEmpty;
  String get lastRecordingPath => _lastRecordingPath;
  bool get isRecording => _isRecording;

  Future<void> logout() async {
    _id = '';
    _lastRecordingPath = '';
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', _id);
    prefs.setString('lastRecordingPath', _lastRecordingPath);
    notifyListeners();
  }
}
