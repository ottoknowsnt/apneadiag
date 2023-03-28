import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apneadiag/utilities/local_notifications.dart';

class ServerUpload extends ChangeNotifier {
  static bool _isUploading = false;

  Future<void> uploadFile({required String filePath}) async {
    final request = http.MultipartRequest(
      'POST',
      // Change this to production server address
      Uri.parse('http://192.168.68.100:8000/upload'),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'files',
        filePath,
      ),
    );
    _isUploading = true;
    notifyListeners();
    final response = await request.send();
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
  }

  bool get isUploading => _isUploading;
}
