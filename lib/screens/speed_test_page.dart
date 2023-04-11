import 'package:apneadiag/utilities/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/utilities/server_upload.dart';

class SpeedTestPage extends StatelessWidget {
  const SpeedTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appData = context.watch<AppData>();
    var uploadSpeed = appData.uploadSpeed;
    var serverUpload = context.watch<ServerUpload>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Speed Test'),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              await serverUpload.testUploadSpeed(appData);
            },
            child: const Text('Probar velocidad de subida'),
          ),
          const SizedBox(height: 30),
          Text('Velocidad de subida: $uploadSpeed Mbps'),
        ],
      ),
    );
  }
}
