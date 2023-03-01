import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apneadiag/screens/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:apneadiag/utilities/local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prepare everything before running the app
  final prefs = await SharedPreferences.getInstance();
  final id = prefs.getString('id') ?? '';
  final lastRecording = prefs.getString('lastRecording') ?? '';
  final path = await getApplicationDocumentsDirectory();
  FlutterSoundRecorder? recorder = FlutterSoundRecorder();
  await Permission.microphone.request();
  await recorder.openRecorder();
  await LocalNotifications.init();

  runApp(Apneadiag(
      id: id,
      path: path.path,
      recorder: recorder,
      lastRecording: lastRecording));
}

class Apneadiag extends StatelessWidget {
  const Apneadiag({
    super.key,
    required this.id,
    required this.path,
    required this.recorder,
    required this.lastRecording,
  });

  final String id;
  final String path;
  final FlutterSoundRecorder recorder;
  final String lastRecording;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApneadiagState(id, path, recorder, lastRecording),
      child: MaterialApp(
        title: 'Apneadiag',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.lightBlue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class ApneadiagState extends ChangeNotifier {
  ApneadiagState(this._id, this._path, this._recorder, this._lastRecording);

  String _id;
  final String _path;
  final FlutterSoundRecorder _recorder;
  final Codec _codec = Codec.aacMP4;
  String _lastRecording;

  Future startRecorder() async {
    _lastRecording = '$_path/${DateTime.now()}.mp4';
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastRecording', _lastRecording);
    await _recorder.startRecorder(toFile: _lastRecording, codec: _codec);
    LocalNotifications.showNotification(
        title: 'Grabación iniciada',
        body: 'Grabación iniciada a las ${DateTime.now()}');
    notifyListeners();
  }

  Future stopRecorder() async {
    await _recorder.stopRecorder();
    LocalNotifications.showNotification(
        title: 'Grabación finalizada',
        body: 'Grabación finalizada a las ${DateTime.now()}');
    notifyListeners();
  }

  Future saveId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
    _id = id;
    notifyListeners();
  }

  Future clean() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    prefs.remove('lastRecording');
    _id = '';
    _lastRecording = '';
    notifyListeners();
  }

  bool get isRecording => _recorder.isRecording;
  String get id => _id;
  String get lastRecording => _lastRecording;
}
