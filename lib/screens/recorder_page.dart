import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/utilities/sound_recorder.dart';
import 'package:apneadiag/utilities/app_data.dart';

class RecorderPage extends StatelessWidget {
  const RecorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appData = context.watch<AppData>();
    var isRecording = appData.isRecording;
    var isUploading = appData.isUploading;

    var theme = Theme.of(context);
    var styleTitle = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );
    var styleButton = theme.textTheme.titleLarge!.copyWith(
      color: Colors.white,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              isUploading
                  ? "Subida en curso"
                  : isRecording
                      ? 'Grabación en curso'
                      : 'Listo para grabar',
              style: styleTitle),
          const SizedBox(height: 30),
          Card(
              color: isUploading
                  ? Colors.orange
                  : isRecording
                      ? Colors.red
                      : Colors.green,
              child: SizedBox(
                width: 200,
                height: 200,
                child: TextButton(
                  onPressed: () {
                    if (kDebugMode || !isUploading) {
                      if (isRecording) {
                        SoundRecorder.stop(appData);
                      } else {
                        SoundRecorder.start(appData);
                      }
                    }
                  },
                  child: Text(
                      isUploading
                          ? 'Subiendo'
                          : isRecording
                              ? 'Grabando'
                              : 'Listo',
                      style: styleButton),
                ),
              )),
          const SizedBox(height: 30),
          Text(
              isUploading
                  ? 'La subida finalizará pronto'
                  : isRecording
                      ? 'La grabación finalizará a las 6:45'
                      : 'La grabación empezará a las 23:45',
              style: styleTitle),
        ],
      ),
    );
  }
}
