import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:apneadiag/utilities/local_notifications.dart';
import 'package:apneadiag/utilities/server_upload.dart';
import 'package:apneadiag/utilities/app_data.dart';

class SoundRecorder {
  static final _recorder = Record();
  static String _lastRecordingPath = '';

  static Future<void> init() async {
    await _recorder.hasPermission();
  }

  static Future<void> start() async {
    final path = await getApplicationDocumentsDirectory();
    _lastRecordingPath =
        '${path.path}/${DateTime.now().millisecondsSinceEpoch}.wav';
    await AppData().setIsRecording(true);
    await _recorder.start(
      path: _lastRecordingPath,
      encoder: AudioEncoder.wav,
    );
    LocalNotifications.showNotification(
        title: 'Grabación iniciada',
        body: 'Grabación iniciada a las ${DateTime.now()}');
  }

  static Future<void> stop() async {
    await _recorder.stop();
    await AppData().setIsRecording(false);
    await AppData().setLastRecordingPath(_lastRecordingPath);
    LocalNotifications.showNotification(
        title: 'Grabación finalizada',
        body: 'Grabación finalizada a las ${DateTime.now()}');
    ServerUpload.uploadFile(filePath: _lastRecordingPath);
  }
}
