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
    var stopScheduledTime = appData.stopScheduledTime;

    var theme = Theme.of(context);
    var styleTitle = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );
    var style = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );
    var styleSubtitle = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    var data = 'ID: $id\nEdad: $age\nPeso: $weight\nAltura: $height';

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ajustes',
                style: styleTitle, textAlign: TextAlign.center, softWrap: true),
            const SizedBox(height: 10),
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
              label: Text(
                  'Hora de inicio: ${startScheduledTime.format(context)}',
                  style: style,
                  textAlign: TextAlign.center,
                  softWrap: true),
            ),
            Text('Hora de fin: ${stopScheduledTime.format(context)}',
                style: styleSubtitle,
                textAlign: TextAlign.center,
                softWrap: true),
            const Divider(),
            Text('Datos del paciente',
                style: style, textAlign: TextAlign.center, softWrap: true),
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: data)).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Datos copiados al portapapeles',
                          textAlign: TextAlign.left, softWrap: true),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.copy),
              label: Text(data,
                  style: styleSubtitle,
                  textAlign: TextAlign.center,
                  softWrap: true),
            ),
            const Divider(),
            if (lastRecordingPath.isNotEmpty) ...[
              Text('Última grabación',
                  style: style, textAlign: TextAlign.center, softWrap: true),
              TextButton.icon(
                onPressed: () {
                  Provider.of<ServerUpload>(context, listen: false)
                      .uploadFile(filePath: lastRecordingPath);
                },
                icon: const Icon(Icons.cloud_upload),
                label: Text(lastRecordingPathShort,
                    style: styleSubtitle,
                    textAlign: TextAlign.center,
                    softWrap: true),
              ),
              const Divider(),
            ],
            TextButton.icon(
              onPressed: () {
                openAppSettings();
              },
              icon: const Icon(Icons.settings),
              label: Text('Borrar datos de la aplicación',
                  style: style, textAlign: TextAlign.center, softWrap: true),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
