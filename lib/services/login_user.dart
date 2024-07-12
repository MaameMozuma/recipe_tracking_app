import 'package:http/http.dart' as http;

String baseUrl = 'http://127.0.0.1:5000';

Future<String?> loginUser(String username, String password) async {
  final response = await http.post(Uri.parse('baseUrl' + '/login'),
      headers: {'Accept': '*/*', 'Content-Type': 'application/json'},
      body: {"username": username, "password": password});
  if (response.statusCode != 200) {
    throw Exception('Failed to Login');
  }
  if (response.statusCode == 200) {
    String access_token = response.body;
    return access_token;
  }
}
