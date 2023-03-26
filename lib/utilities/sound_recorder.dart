import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    var now = DateTime.now();
    _lastRecordingPath = '${path.path}/${now.millisecondsSinceEpoch}.wav';
    await _recorder.startRecorder(
      toFile: _lastRecordingPath,
    );
    notifyListeners();
    LocalNotifications.startForegroundService(
      title: 'Grabación en curso',
      body: 'Grabación iniciada a las $now',
      foregroundServiceTypes: {
        AndroidServiceForegroundType.foregroundServiceTypeMicrophone
      },
    );
  }

  Future<void> stop(AppData appData, ServerUpload serverUpload) async {
    await _recorder.stopRecorder();
    notifyListeners();
    await appData.setLastRecordingPath(_lastRecordingPath);
    var now = DateTime.now();
    LocalNotifications.stopForegroundService();
    LocalNotifications.showNotification(
        title: 'Grabación finalizada', body: 'Grabación finalizada a las $now');
    await serverUpload.uploadFile(filePath: _lastRecordingPath);
  }

  bool get isRecording => _recorder.isRecording;

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}
