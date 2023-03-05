import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:apneadiag/utilities/local_notifications.dart';
import 'package:apneadiag/utilities/server_upload.dart';
import 'package:apneadiag/utilities/app_data.dart';

class SoundRecorder extends ChangeNotifier {
  static final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  static String _lastRecordingPath = '';

  static Future<void> init() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  Future<void> start() async {
    final path = await getApplicationDocumentsDirectory();
    _lastRecordingPath =
        '${path.path}/${DateTime.now().millisecondsSinceEpoch}.wav';
    await _recorder.startRecorder(
      toFile: _lastRecordingPath,
    );
    notifyListeners();
    LocalNotifications.showNotification(
        title: 'Grabación iniciada',
        body: 'Grabación iniciada a las ${DateTime.now()}');
  }

  Future<void> stop(AppData appData, ServerUpload serverUpload) async {
    await _recorder.stopRecorder();
    notifyListeners();
    await appData.setLastRecordingPath(_lastRecordingPath);
    LocalNotifications.showNotification(
        title: 'Grabación finalizada',
        body: 'Grabación finalizada a las ${DateTime.now()}');
    await serverUpload.uploadFile(filePath: _lastRecordingPath);
  }

  bool get isRecording => _recorder.isRecording;

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}
