import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/main.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApneadiagState>();
    var id = appState.id;
    var lastRecording = appState.lastRecording;

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
              Share.shareXFiles([XFile(lastRecording)]);
            },
            icon: const Icon(Icons.share),
            label: Text(lastRecording, style: styleSubtitle),
          ),
          const Divider(),
          TextButton.icon(
            onPressed: () {
              appState.clean();
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
