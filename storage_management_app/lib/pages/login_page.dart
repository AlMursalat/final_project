  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';
  import 'package:storage_management_app/pages/register_page.dart';
  import 'package:storage_management_app/pages/main_menu_page.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class LoginPage extends StatefulWidget {
    @override
    State<LoginPage> createState() => _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage> {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final String baseUrl = 'http://192.168.43.138:5000/api';

    Future<void> _login() async {
      String username = usernameController.text;
      String password = passwordController.text;

      if (username.isEmpty || password.isEmpty) {
        _showAlertDialog('Login Gagal', 'Username dan password harus diisi.');
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        await _saveToken(token);
        _showAlertDialog('Login Berhasil', 'Selamat datang!');
      } else {
        _showAlertDialog('Login Gagal', 'Username atau password salah.');
      }
    }

    Future<void> _saveToken(String token) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    }

    void _showAlertDialog(String title, String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (title == 'Login Berhasil') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainMenuPage()),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.red,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _page(),
        ),
      );
    }

    Widget _page() {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _icon(),
              const SizedBox(height: 50),
              _inputField("Username", usernameController),
              const SizedBox(height: 20),
              _inputField("Password", passwordController, isPassword: true),
              const SizedBox(height: 50),
              _loginBtn(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: _extraText(),
              ),
            ],
          ),
        ),
      );
    }

    Widget _icon() {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, color: Colors.white, size: 120),
      );
    }

    Widget _inputField(String hintText, TextEditingController controller, {isPassword = false}) {
      var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white),
      );

      return TextField(
        style: const TextStyle(color: Colors.white),
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          enabledBorder: border,
          focusedBorder: border,
        ),
        obscureText: isPassword,
      );
    }

    Widget _loginBtn() {
      return ElevatedButton(
        onPressed: _login,
        child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      );
    }

    Widget _extraText() {
      return const Text(
        "Belum punya akun? Register.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    }
  }
