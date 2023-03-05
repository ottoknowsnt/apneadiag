import 'package:http/http.dart' as http;
import 'package:apneadiag/utilities/local_notifications.dart';
import 'package:apneadiag/utilities/app_data.dart';

class ServerUpload {
  static Future<void> uploadFile(
      {required String filePath, required AppData appData}) async {
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
    appData.setIsUploading(true);
    final response = await request.send();
    appData.setIsUploading(false);

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
