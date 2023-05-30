import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/utilities/app_data.dart';
import 'package:apneadiag/utilities/server_upload.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appData = context.watch<AppData>();
    var id = appData.id;
    var age = appData.age;
    var weight = appData.weight;
    var height = appData.height;
    var lastRecordingPath = appData.lastRecordingPath;
    var lastRecordingPathShort = lastRecordingPath.split('/').last;
    var startScheduledTime = appData.startScheduledTime;

    var theme = Theme.of(context);
    var styleTitle = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );
    var styleSubtitle = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Divider(),
          TextButton.icon(
            onPressed: () async {
              var time = await showTimePicker(
                context: context,
                initialTime: startScheduledTime,
              );
              if (time != null) {
                appData.setStartScheduledTime(time);
              }
            },
            icon: const Icon(Icons.access_time),
            label: Text('Inicio: ${startScheduledTime.format(context)}',
                style: styleTitle),
          ),
          const Divider(),
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(
                      text:
                          'ID Paciente: $id\nEdad: $age\nPeso: $weight\nAltura: $height'))
                  .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Datos copiados al portapapeles'),
                  ),
                );
              });
            },
            icon: const Icon(Icons.copy),
            label: Text(
                'ID Paciente: $id\nEdad: $age\nPeso: $weight\nAltura: $height',
                style: styleTitle),
          ),
          const Divider(),
          Text('Nombre de la última Grabación', style: styleTitle),
          TextButton.icon(
            onPressed: () {
              Provider.of<ServerUpload>(context, listen: false)
                  .uploadFile(filePath: lastRecordingPath);
            },
            icon: const Icon(Icons.cloud_upload),
            label: Text(lastRecordingPathShort, style: styleSubtitle),
          ),
          const Divider(),
          TextButton.icon(
            onPressed: () {
              openAppSettings();
            },
            icon: const Icon(Icons.settings),
            label: Text('Borrar Datos Aplicación', style: styleTitle),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
