import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'app_data.dart';
import 'local_notifications.dart';
import 'server_upload.dart';

class SoundRecorder extends ChangeNotifier {
  factory SoundRecorder() {
    return _instance;
  }

  SoundRecorder._internal();
  static final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  static String _lastRecordingPath = '';

  static final SoundRecorder _instance = SoundRecorder._internal();

  Future<void> start() async {
    if (!isRecording) {
      await _recorder.openRecorder();
      final Directory path = await getApplicationDocumentsDirectory();
      final DateTime now = DateTime.now();
      final String dateTimeString =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}_'
          '${now.hour.toString().padLeft(2, '0')}-'
          '${now.minute.toString().padLeft(2, '0')}-'
          '${now.second.toString().padLeft(2, '0')}';
      final String id = AppData().id;
      _lastRecordingPath = '${path.path}/${id}_recording_$dateTimeString.wav';
      await LocalNotifications.startForegroundService(
        id: 2,
        title: 'Grabación en curso',
        body: 'Grabación iniciada a las '
            '${now.hour.toString().padLeft(2, '0')}:'
            '${now.minute.toString().padLeft(2, '0')}',
        foregroundServiceTypes: <AndroidServiceForegroundType>{
          AndroidServiceForegroundType.foregroundServiceTypeMicrophone
        },
      );
      await _recorder.startRecorder(
        toFile: _lastRecordingPath,
        codec: Codec.pcm16WAV, // PCM 16bit
        sampleRate: 8000, // 8kHz
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
      final DateTime now = DateTime.now();
      await LocalNotifications.stopForegroundService();
      await LocalNotifications.showNotification(
          id: 3,
          title: 'Grabación finalizada',
          body: 'Grabación finalizada a las '
              '${now.hour.toString().padLeft(2, '0')}:'
              '${now.minute.toString().padLeft(2, '0')}');
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
