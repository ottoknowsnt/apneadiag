import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserData extends ChangeNotifier {
  static String _id = '';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.getString('id') ?? '';
  }

  Future<void> login(String id) async {
    _id = id;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', _id);
    notifyListeners();
  }

  String get id => _id;
  bool get isLogged => _id.isNotEmpty;

  Future<void> logout() async {
    _id = '';
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', _id);
    notifyListeners();
  }
}
