import 'package:flutter/material.dart';
import 'package:storage_management_app/pages/login_page.dart';
import 'package:storage_management_app/pages/main_menu_page.dart';
import 'package:storage_management_app/pages/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/main_menu': (context) => MainMenuPage(),
      },
    );
  }
}
