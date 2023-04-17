import 'package:apneadiag/utilities/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:apneadiag/utilities/local_notifications.dart';

class ServerUpload extends ChangeNotifier {
  static bool _isUploading = false;

  static final ServerUpload _instance = ServerUpload._internal();

  factory ServerUpload() {
    return _instance;
  }

  ServerUpload._internal();

  Future<void> uploadFile(
      {required String filePath}) async {
    final request = http.MultipartRequest(
      'POST',
      // Change this to production server address
      Uri.parse('http://192.168.68.100:8000/upload'),
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
    final response = await request.send();
    stopwatch.stop();
    _isUploading = false;
    notifyListeners();

    var now = DateTime.now();
    if (response.statusCode == 204) {
      await LocalNotifications.showNotification(
          title: 'Subida de archivo', body: 'Subida de archivo a las $now');
    } else {
      await LocalNotifications.showNotification(
          title: 'Error al subir archivo',
          body: 'Error al subir archivo a las $now');
    }

    // The upload speed is in Mbps
    var speed = (8 * fileSize) / (stopwatch.elapsedMilliseconds / 1000);
    // Only keep 2 decimal places
    speed = double.parse(speed.toStringAsFixed(2));
    AppData().setUploadSpeed(speed);
  }

  bool get isUploading => _isUploading;
}
