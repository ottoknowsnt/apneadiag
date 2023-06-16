import 'package:apneadiag/utilities/app_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apneadiag/utilities/local_notifications.dart';
import 'package:apneadiag/config.dart';

class ServerUpload extends ChangeNotifier {
  static bool _isUploading = false;

  static final ServerUpload _instance = ServerUpload._internal();

  factory ServerUpload() {
    return _instance;
  }

  ServerUpload._internal();

  Future<void> uploadFile({required String filePath}) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(serverAddress),
    );
    var file = await http.MultipartFile.fromPath('files', filePath);
    double fileSize = double.parse(file.length.toString());
    // Convert file size to MB
    fileSize = fileSize / (1024 * 1024);
    request.files.add(
      file,
    );
    _isUploading = true;
    notifyListeners();
    Stopwatch stopwatch = Stopwatch()..start();
    request.send().timeout(const Duration(minutes: 10)).then((response) async {
      stopwatch.stop();

      var now = DateTime.now();
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
      var speed = (8 * fileSize) / (stopwatch.elapsedMilliseconds / 1000);
      // Only keep 2 decimal places
      speed = double.parse(speed.toStringAsFixed(2));
      AppData().setUploadSpeed(speed);
    }).catchError((error) {
      stopwatch.stop();

      var now = DateTime.now();
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
