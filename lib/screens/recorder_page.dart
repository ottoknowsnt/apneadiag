import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/utilities/sound_recorder.dart';

class RecorderPage extends StatelessWidget {
  const RecorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    var recorder = context.watch<SoundRecorder>();
    var isRecording = recorder.isRecording;

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
          Text(isRecording ? 'Grabación en curso' : 'Listo para grabar',
              style: styleTitle),
          const SizedBox(height: 30),
          Card(
              color: isRecording ? Colors.red : Colors.green,
              child: SizedBox(
                width: 200,
                height: 200,
                child: TextButton(
                  onPressed: () {
                    if (kDebugMode) {
                      if (isRecording) {
                        recorder.stop();
                      } else {
                        recorder.start();
                      }
                    }
                  },
                  child: Text(isRecording ? 'Grabando' : 'Listo',
                      style: styleButton),
                ),
              )),
          const SizedBox(height: 30),
          Text(
              isRecording
                  ? 'La grabación finalizará a las 6:45'
                  : 'La grabación empezará a las 23:45',
              style: styleTitle),
        ],
      ),
    );
  }
}
