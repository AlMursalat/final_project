import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:storage_management_app/services/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final String baseUrl = 'http://192.168.43.138:5000/api';
  final AuthService authService = AuthService();

  Future<void> _register(BuildContext context) async {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        imageUrlController.text.isEmpty) {
      _showAlertDialog(context, 'Registrasi Gagal', 'Semua kolom harus diisi.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': usernameController.text,
          'password': passwordController.text,
          'image': imageUrlController.text,
        }),
      );

      if (response.statusCode == 200) {
        _showAlertDialog(context, 'Registrasi Berhasil', 'Akun Anda berhasil dibuat.');
      } else {
        _showAlertDialog(context, 'Registrasi Gagal', 'Terjadi kesalahan, coba lagi.');
      }
    } catch (e) {
      print('Error during registration: $e');
      _showAlertDialog(context, 'Registrasi Gagal', 'Terjadi kesalahan, coba lagi.');
    }
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
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
                if (title == 'Registrasi Berhasil') {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectImage(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageUrlController.text = pickedFile.path;
    }
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
        body: _page(context),
      ),
    );
  }

  Widget _page(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon(context),
            const SizedBox(height: 30),
            _inputField("Username", usernameController),
            const SizedBox(height: 10),
            _inputField("Password", passwordController, isPassword: true),
            const SizedBox(height: 30),
            _registerBtn(context),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: _extraText(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _icon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectImage(context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.camera_alt, color: Colors.white, size: 120),
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller, {bool isPassword = false}) {
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

  Widget _registerBtn(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _register(context),
        child: Text(
          "Register",
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _extraText() {
    return const Text(
      "Sudah punya akun? Login.",
      style: TextStyle(fontSize: 14, color: Colors.white),
    );
  }
}
