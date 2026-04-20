import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _name = "KARTHIK OJHA";
  String _email = "karthikojha2502@gmail.com";
  String? _imagePath;

  String get name => _name;
  String get email => _email;
  String? get imagePath => _imagePath;

  /// Call this once at app startup (in main.dart or initState of root widget)
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name') ?? "KARTHIK OJHA";
    _email = prefs.getString('user_email') ?? "karthikojha2502@gmail.com";
    _imagePath = prefs.getString('user_image');
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    _name = name;
    _email = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    notifyListeners();
  }

  Future<void> updateImage(String path) async {
    _imagePath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_image', path);
    notifyListeners();
  }
}
