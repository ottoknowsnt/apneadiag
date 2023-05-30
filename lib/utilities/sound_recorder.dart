import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:apneadiag/utilities/local_notifications.dart';
import 'package:apneadiag/utilities/server_upload.dart';
import 'package:apneadiag/utilities/app_data.dart';

class SoundRecorder extends ChangeNotifier {
  static final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  static String _lastRecordingPath = '';

  static final SoundRecorder _instance = SoundRecorder._internal();

  factory SoundRecorder() {
    return _instance;
  }

  SoundRecorder._internal();

  Future<void> start() async {
    if (!isRecording) {
      await _recorder.openRecorder();
      final path = await getApplicationDocumentsDirectory();
      var now = DateTime.now();
      var dateTimeString =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';
      _lastRecordingPath = '${path.path}/recording_$dateTimeString.wav';
      await LocalNotifications.startForegroundService(
        title: 'Grabación en curso',
        body: 'Grabación iniciada a las ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        foregroundServiceTypes: {
          AndroidServiceForegroundType.foregroundServiceTypeMicrophone
        },
      );
      await _recorder.startRecorder(
        toFile: _lastRecordingPath,
        codec: Codec.pcm16WAV, // PCM 16bit
        sampleRate: 8000, // 8kHz
        numChannels: 1, // mono
      );
      notifyListeners();
    }
  }

  Future<void> stop() async {
    if (isRecording) {
      await _recorder.stopRecorder();
      await _recorder.closeRecorder();
      notifyListeners();
      await AppData().setLastRecordingPath(_lastRecordingPath);
      var now = DateTime.now();
      await LocalNotifications.stopForegroundService();
      await LocalNotifications.showNotification(
          title: 'Grabación finalizada',
          body: 'Grabación finalizada a las ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}');
      await ServerUpload().uploadFile(filePath: _lastRecordingPath);
    }
  }

  bool get isRecording => _recorder.isRecording;

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}
