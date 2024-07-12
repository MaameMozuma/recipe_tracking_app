import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String baseUrl = 'http://127.0.0.1:5000';

Future<bool> loginUser(String username, String password) async {
  bool success = false;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await http.post(Uri.parse('baseUrl' + '/login'),
      headers: {'Accept': '*/*', 'Content-Type': 'application/json'},
      body: {"username": username, "password": password});
  if (response.statusCode != 200) {
    throw Exception('Failed to Login');
  }
  if (response.statusCode == 200) {
    await prefs.setString('auth_token', response.body);
    success = true;
  }
  return success;
}
