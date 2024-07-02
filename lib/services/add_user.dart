import 'package:http/http.dart' as http;

Future<bool> addUser(String firstName, String lastName, String email,
    String contactNumber, String password) async {
  bool success = false;
  final response = await http.post(
      Uri.parse(
          'https://apps.ashesi.edu.gh/contactmgt/actions/add_contact_mob'),
      //headers: {'Accept': '*/*', 'Content-Type': 'application/json'},
      body: {});
  if (response.statusCode != 200) {
    throw Exception('Failed to post data');
  }
  if (response.statusCode == 200) {
    success = true;
  }
  return success;
}