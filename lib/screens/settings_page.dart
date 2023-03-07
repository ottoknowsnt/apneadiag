import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:apneadiag/utilities/app_data.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appData = context.watch<AppData>();
    var id = appData.id;
    var lastRecordingPath = appData.lastRecordingPath;
    var autoMode = appData.autoMode;
    var startScheduledTime = appData.startScheduledTime;
    var stopScheduledTime = appData.stopScheduledTime;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Modo Automático', style: styleTitle),
              Checkbox(
                value: autoMode,
                onChanged: (value) {
                  appData.setAutoMode(value!);
                },
              ),
            ],
          ),
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
            onPressed: () async {
              var time = await showTimePicker(
                context: context,
                initialTime: stopScheduledTime,
              );
              if (time != null) {
                appData.setStopScheduledTime(time);
              }
            },
            icon: const Icon(Icons.access_time),
            label: Text('Fin: ${stopScheduledTime.format(context)}',
                style: styleTitle),
          ),
          const Divider(),
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: id)).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ID Copiado al Portapapeles'),
                  ),
                );
              });
            },
            icon: const Icon(Icons.copy),
            label: Text('ID Paciente: $id', style: styleTitle),
          ),
          const Divider(),
          Text('Ruta de la última Grabación', style: styleTitle),
          TextButton.icon(
            onPressed: () {
              Share.shareXFiles([XFile(lastRecordingPath)]);
            },
            icon: const Icon(Icons.share),
            label: Text(lastRecordingPath, style: styleSubtitle),
          ),
          const Divider(),
          TextButton.icon(
            onPressed: () {
              appData.logout();
            },
            icon: const Icon(Icons.delete),
            label: Text('Borrar Datos Paciente', style: styleTitle),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
