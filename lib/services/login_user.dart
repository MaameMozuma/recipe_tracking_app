import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String baseUrl =
    'https://us-central1-mobiledev-428400.cloudfunctions.net/nutripal_live1';

Future<bool> loginUser(String username, String password) async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  bool success = false;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await http.post(Uri.parse('$baseUrl/login'),
      headers: {'Accept': '*/*', 'Content-Type': 'application/json'},
      body: {"username": username, "password": password, "fcmtoken": fcmToken});
  if (response.statusCode != 200) {
    throw Exception('Failed to Login');
  }
  if (response.statusCode == 200) {
    await prefs.setString('auth_token', response.body);
    success = true;
  }
  return success;
}
