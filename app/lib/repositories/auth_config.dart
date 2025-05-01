import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AuthConfig {
  static const authKey = 'token';

  late SharedPreferences _prefsInstance;

  late String authToken;

  Future<void> setToken(String token) async {
    _prefsInstance = await SharedPreferences.getInstance();
    _prefsInstance.setString(authKey, token);
  }

  Future<String?> getToken() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance.getString(authKey);
  }

  Future<void> revokeToken() async {
    _prefsInstance = await SharedPreferences.getInstance();
    _prefsInstance.remove(authKey);
  }
}
