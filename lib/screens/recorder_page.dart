import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/utilities/sound_recorder.dart';
import 'package:apneadiag/utilities/app_data.dart';
import 'package:apneadiag/utilities/server_upload.dart';

class RecorderPage extends StatelessWidget {
  const RecorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appData = context.watch<AppData>();
    var autoMode = appData.autoMode;
    var startScheduledTime = appData.startScheduledTime;
    var stopScheduledTime = appData.stopScheduledTime;
    var recorder = context.watch<SoundRecorder>();
    var isRecording = recorder.isRecording;
    var serverUpload = context.watch<ServerUpload>();
    var isUploading = serverUpload.isUploading;

    var theme = Theme.of(context);
    var styleTitle = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );
    var styleButton = theme.textTheme.titleLarge!.copyWith(
      color: Colors.white,
    );

    bool canManualRecord = !(autoMode || isUploading);
    String topText = '';
    String buttonText = '';
    Color buttonColor = isUploading
        ? Colors.orange
        : isRecording
            ? Colors.red
            : Colors.green;
    String bottomText = '';
    if (isUploading) {
      topText = 'Subida en curso';
      buttonText = 'Subiendo';
      bottomText = 'La subida finalizará pronto';
    } else if (autoMode) {
      if (isRecording) {
        topText = 'Grabación en curso';
        buttonText = 'Grabando';
        bottomText =
            'La grabación finalizará a las ${stopScheduledTime.format(context)}';
      } else {
        topText = 'Listo para grabar';
        buttonText = 'Listo';
        bottomText =
            'La grabación empezará a las ${startScheduledTime.format(context)}';
      }
    } else {
      if (isRecording) {
        topText = 'Grabación en curso';
        buttonText = 'Parar';
        bottomText = 'Pulsa para parar';
      } else {
        topText = 'Listo para grabar';
        buttonText = 'Grabar';
        bottomText = 'Pulsa para empezar';
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(topText, style: styleTitle),
          const SizedBox(height: 30),
          Card(
              color: buttonColor,
              child: SizedBox(
                width: 200,
                height: 200,
                child: TextButton(
                  onPressed: () {
                    if (canManualRecord) {
                      if (isRecording) {
                        recorder.stop(appData, serverUpload);
                      } else {
                        recorder.start();
                      }
                    }
                  },
                  child: Text(buttonText, style: styleButton),
                ),
              )),
          const SizedBox(height: 30),
          Text(bottomText, style: styleTitle),
        ],
      ),
    );
  }
}
