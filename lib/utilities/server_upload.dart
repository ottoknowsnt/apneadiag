import 'package:http/http.dart' as http;

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
    await request.send();
  }
}
