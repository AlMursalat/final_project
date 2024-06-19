import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _tokenKey = 'token';

  // Menyimpan token
  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Mendapatkan token
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Menghapus token
  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
