import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import for CupertinoNavigationBarBackButton
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? imageUrl;
  String? username;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final response = await http.get(
      Uri.parse('http://192.168.43.138:5000/api/user/${widget.username}'),
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      setState(() {
        imageUrl = userData['image'];
        username = userData['username'];
      });
    } else {
      _showErrorDialog('Failed to load user profile.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageUrl != null
                ? CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(imageUrl!),
                  )
                : CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                  ),
            SizedBox(height: 20),
            Text(
              'Username: ${username ?? 'Loading...'}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
