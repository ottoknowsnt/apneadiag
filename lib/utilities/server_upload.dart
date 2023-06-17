import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import 'app_data.dart';
import 'local_notifications.dart';

class ServerUpload extends ChangeNotifier {
  factory ServerUpload() {
    return _instance;
  }

  ServerUpload._internal();
  static bool _isUploading = false;

  static final ServerUpload _instance = ServerUpload._internal();

  Future<void> uploadFile({required String filePath}) async {
    final http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse(serverAddress),
    );
    final http.MultipartFile file =
        await http.MultipartFile.fromPath('files', filePath);
    double fileSize = double.parse(file.length.toString());
    // Convert file size to MB
    fileSize = fileSize / (1024 * 1024);
    request.files.add(
      file,
    );
    _isUploading = true;
    notifyListeners();
    final Stopwatch stopwatch = Stopwatch()..start();
    await request
        .send()
        .timeout(const Duration(minutes: 10))
        .then((http.StreamedResponse response) async {
      stopwatch.stop();

      final DateTime now = DateTime.now();
      if (response.statusCode == 204) {
        await LocalNotifications.showNotification(
            id: 4,
            title: 'Subida de archivo exitosa',
            body:
                'Subida de archivo a las ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}');
      } else {
        await LocalNotifications.showNotification(
            id: 4,
            title: 'Error al subir archivo',
            body:
                'Error al subir archivo a las ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}');
      }

      // The upload speed is in Mbps
      double speed = (8 * fileSize) / (stopwatch.elapsedMilliseconds / 1000);
      // Only keep 2 decimal places
      speed = double.parse(speed.toStringAsFixed(2));
      await AppData().setUploadSpeed(speed);
    }).catchError((dynamic error) {
      stopwatch.stop();

      final DateTime now = DateTime.now();
      LocalNotifications.showNotification(
          id: 4,
          title: 'Error al subir archivo',
          body:
              'Error al subir archivo a las ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}');
    }).whenComplete(() {
      _isUploading = false;
      notifyListeners();
    });
  }

  bool get isUploading => _isUploading;
}
