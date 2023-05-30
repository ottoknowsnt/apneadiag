import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/utilities/sound_recorder.dart';
import 'package:apneadiag/utilities/app_data.dart';
import 'package:apneadiag/utilities/server_upload.dart';
import 'package:battery_plus/battery_plus.dart';

class RecorderPage extends StatefulWidget {
  const RecorderPage({super.key});

  @override
  State<RecorderPage> createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {
  final Battery _battery = Battery();

  BatteryState? _batteryState;
  StreamSubscription<BatteryState>? _batteryStateSubscription;
  bool _isCharging = false;

  @override
  void initState() {
    super.initState();
    _battery.batteryState.then(_updateBatteryState);
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen(_updateBatteryState);
  }

  void _updateBatteryState(BatteryState state) {
    if (_batteryState == state) return;
    setState(() {
      _batteryState = state;
      _isCharging = state == BatteryState.charging;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    var appData = context.watch<AppData>();
    var uploadSpeed = appData.uploadSpeed;
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
    var styleSubtitle = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );
    var styleButton = theme.textTheme.titleLarge!.copyWith(
      color: Colors.white,
    );

    String topText = isUploading
        ? 'Subida en curso'
        : isRecording
            ? 'Grabación en curso'
            : 'Listo para grabar';
    String buttonText = isUploading
        ? 'Subiendo'
        : isRecording
            ? 'Grabando'
            : 'Listo';
    Color buttonColor = isUploading
        ? Colors.orange
        : isRecording
            ? Colors.red
            : Colors.green;
    String bottomText = isUploading
        ? 'La subida finalizará pronto'
        : isRecording
            ? 'La grabación finalizará a las ${stopScheduledTime.format(context)}'
            : 'La grabación empezará a las ${startScheduledTime.format(context)}';

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(topText,
                style: styleTitle, textAlign: TextAlign.center, softWrap: true),
            const SizedBox(height: 30),
            if (_batteryState != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isCharging ? Icons.check : Icons.close,
                    color: _isCharging ? Colors.green : Colors.red,
                  ),
                  Flexible(
                    child: Text(
                      _isCharging ? 'Cargando' : 'No está cargando.',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: styleSubtitle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
            if (uploadSpeed != -1.00) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  Flexible(
                      child: Text(
                    'Velocidad de subida: $uploadSpeed Mbps',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: styleSubtitle,
                  )),
                ],
              ),
              const SizedBox(height: 30),
            ],
            Card(
                color: buttonColor,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: TextButton(
                    onPressed: null,
                    child: Text(buttonText,
                        style: styleButton,
                        textAlign: TextAlign.center,
                        softWrap: true),
                  ),
                )),
            const SizedBox(height: 30),
            if (_batteryState != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isCharging ? Icons.check : Icons.question_mark,
                    color: _isCharging ? Colors.green : Colors.grey,
                  ),
                  Flexible(
                    child: Text(
                      _isCharging
                          ? 'Las condiciones son óptimas'
                          : 'No podemos asegurar unas condiciones óptimas.\nCompruebe los avisos en la parte superior de la pantalla.',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: styleSubtitle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
            Text(
              bottomText,
              style: styleTitle,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
