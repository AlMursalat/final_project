import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const baseUrl = 'http://192.168.43.138:5000/api/auth';

  Future<bool> login(String username, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/login'), body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var token = responseData['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('username', username); // Simpan username
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String username, String password, String imageUrl) async {
    final response = await http.post(Uri.parse('$baseUrl/register'), body: {
      'username': username,
      'password': password,
      'image': imageUrl,
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
