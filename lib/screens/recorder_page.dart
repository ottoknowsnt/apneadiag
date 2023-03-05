import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/utilities/sound_recorder.dart';
import 'package:apneadiag/utilities/app_data.dart';
import 'package:apneadiag/utilities/server_upload.dart';

class RecorderPage extends StatelessWidget {
  const RecorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context);
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
                        recorder.stop(appData, serverUpload);
                      } else {
                        recorder.start();
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
          const SizedBox(height: 30),
          TextButton(
            onPressed: () {
              DateTime scheduledDate =
                  DateTime.now().add(const Duration(minutes: 1));
              if (scheduledDate.isBefore(DateTime.now())) {
                scheduledDate = scheduledDate.add(const Duration(days: 1));
              }
              Duration timeUntilScheduled =
                  scheduledDate.difference(DateTime.now());
              Timer(timeUntilScheduled, () {
                recorder.start();
              });
              scheduledDate = DateTime.now().add(const Duration(minutes: 2));
              if (scheduledDate.isBefore(DateTime.now())) {
                scheduledDate = scheduledDate.add(const Duration(days: 1));
              }
              timeUntilScheduled = scheduledDate.difference(DateTime.now());
              Timer(timeUntilScheduled, () {
                recorder.stop(appData, serverUpload);
              });
            },
            child: const Text('Programar grabación'),
          ),
        ],
      ),
    );
  }
}
