import 'package:http/http.dart' as http;
import 'package:apneadiag/utilities/local_notifications.dart';

class ServerUpload {
  static Future<void> uploadFile(
      {required String filePath}) async {
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
    final response = await request.send();

    if (response.statusCode == 204) {
      LocalNotifications.showNotification(
          title: 'Subida de archivo',
          body: 'Subida de archivo a las ${DateTime.now()}');
    } else {
      LocalNotifications.showNotification(
          title: 'Error al subir archivo',
          body: 'Error al subir archivo a las ${DateTime.now()}');
    }
  }
}
