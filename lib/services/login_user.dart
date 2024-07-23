import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_proj_leanne/model/user_login.dart';

String baseUrl =
    'https://us-central1-mobiledev-428400.cloudfunctions.net/nutripal_live1';

Future<bool> loginUser(String username, String password) async {
  print(username);
  print(password);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  bool success = false;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final loginData = {
            "username" : username,
            "password" : password,
            "fcmtoken" : fcmToken
          };

  // print(loginData.toJson());

  final response = await http.post(Uri.parse('$baseUrl/login'),
      headers: {'Accept': '*/*', 'Content-Type': 'application/json'},
      body: jsonEncode(loginData));

  if (response.statusCode != 200) {
    throw Exception('Failed to Login');
  }
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final String token = responseData['access_token'];
    await prefs.setString('auth_token', token);
    success = true;
  }
  return success;
}
