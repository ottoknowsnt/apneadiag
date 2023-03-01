import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:apneadiag/utilities/local_notifications.dart';
import 'package:flutter/material.dart';

class SoundRecorder extends ChangeNotifier {
  static final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  static String _lastRecordingPath = '';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _lastRecordingPath = prefs.getString('lastRecordingPath') ?? '';
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  Future<void> start() async {
    final path = await getApplicationDocumentsDirectory();
    _lastRecordingPath =
        '${path.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastRecordingPath', _lastRecordingPath);
    await _recorder.startRecorder(
      toFile: _lastRecordingPath,
    );
    LocalNotifications.showNotification(
        title: 'Grabación iniciada',
        body: 'Grabación iniciada a las ${DateTime.now()}');
    notifyListeners();
  }

  Future<void> stop() async {
    await _recorder.stopRecorder();
    LocalNotifications.showNotification(
        title: 'Grabación finalizada',
        body: 'Grabación finalizada a las ${DateTime.now()}');
    notifyListeners();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  bool get isRecording => _recorder.isRecording;
  String get lastRecordingPath => _lastRecordingPath;
}
