import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../utilities/app_data.dart';
import '../utilities/server_upload.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppData appData = context.watch<AppData>();
    final String id = appData.id;
    final int age = appData.age;
    final double weight = appData.weight;
    final int height = appData.height;
    final String lastRecordingPath = appData.lastRecordingPath;
    final String lastRecordingPathShort = lastRecordingPath.split('/').last;
    final TimeOfDay startScheduledTime = appData.startScheduledTime;
    final TimeOfDay stopScheduledTime = appData.stopScheduledTime;

    final ThemeData theme = Theme.of(context);
    final TextStyle styleTitle = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );
    final TextStyle style = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );
    final TextStyle styleSubtitle = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    final String data = 'ID: $id\nEdad: $age\nPeso: $weight\nAltura: $height';

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
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: startScheduledTime,
                );
                if (time != null) {
                  await appData.setStartScheduledTime(time);
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
                Clipboard.setData(ClipboardData(text: data)).then((void value) {
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
              onPressed: openAppSettings,
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
