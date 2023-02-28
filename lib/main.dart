import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apneadiag/screens/home_page.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const Apneadiag());
}

class Apneadiag extends StatelessWidget {
  const Apneadiag({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApneadiagState(),
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
  final Codec _codec = Codec.aacMP4;
  String path = '';
  FlutterSoundRecorder? recorder = FlutterSoundRecorder();
  bool _recorderInitialized = false;

  Future initRecorder() async {
    await Permission.microphone.request();
    await recorder!.openRecorder();
    _recorderInitialized = true;
    notifyListeners();
  }

  Future startRecorder() async {
    if (!_recorderInitialized) {
      await initRecorder();
    }
    path = '${(await getApplicationDocumentsDirectory()).path}/recording.mp4';
    await recorder!.startRecorder(toFile: path, codec: _codec);
    notifyListeners();
  }

  Future stopRecorder() async {
    await recorder!.stopRecorder();
    notifyListeners();
  }

  @override
  void dispose() {
    recorder!.closeRecorder();
    recorder = null;
    _recorderInitialized = false;

    super.dispose();
  }

  String id = '';

  Future getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
  }

  Future saveId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
    this.id = id;
    notifyListeners();
  }

  Future deleteId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    this.id = '';
    notifyListeners();
  }
}
