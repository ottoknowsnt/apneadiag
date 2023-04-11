import 'package:apneadiag/utilities/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> testUploadSpeed(AppData appData) async {
    // Upload a 1MB file we have in the assets folder, measure the time it takes
    // and calculate the upload speed
    ByteData bytes = await rootBundle.load('assets/1MB.txt');
    Uint8List bytesList =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    final request = http.MultipartRequest(
      'POST',
      // Change this to production server address
      Uri.parse('http://192.168.68.100:8000/upload'),
    );
    request.files.add(
      http.MultipartFile.fromBytes(
        'files',
        bytesList,
      ),
    );
    Stopwatch stopwatch = Stopwatch()..start();
    await request.send();
    stopwatch.stop();
    // The upload speed is in Mbps
    var speed = 8 / (stopwatch.elapsedMilliseconds / 1000);
    // Only keep 2 decimal places
    speed = double.parse(speed.toStringAsFixed(2));
    appData.setUploadSpeed(speed);
  }

  bool get isUploading => _isUploading;
}
