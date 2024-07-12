import 'package:http/http.dart' as http;

String baseUrl = 'http://127.0.0.1:5000';

Future<bool> addUser(
    String firstName,
    String lastName,
    String email,
    String contactNumber,
    String password,
    double height,
    double weight,
    String DOB) async {
  bool success = false;
  final response = await http.post(Uri.parse(baseUrl + '/signup'), headers: {
    'Accept': '*/*',
    'Content-Type': 'application/json'
  }, body: {
    {
      "username": '$firstName$lastName',
      "email": email,
      "password": password,
      "height": height,
      "weight": weight,
      "dob": DOB,
      "phone_number": contactNumber
    }
  });
  if (response.statusCode != 200) {
    throw Exception('Failed to post data');
  }
  if (response.statusCode == 201) {
    sendOTP(contactNumber);
  }
  return success;
}

Future<bool> sendOTP(String contactNumber) async {
  bool success = false;
  final response = await http.post(Uri.parse(baseUrl + '/send_otp'),
      headers: {'Accept': '*/*', 'Content-Type': 'application/json'},
      body: {"phone_number": contactNumber});
  if (response.statusCode != 201) {
    throw Exception('Failed to post data');
  }
  if (response.statusCode == 201) {
    success = true;
  }
  return success;
}

Future<bool> verifyOTP(String OTP, String contactNumber) async {
  bool success = false;
  final response = await http.post(Uri.parse(baseUrl + '/verify_otp'),
      headers: {'Accept': '*/*', 'Content-Type': 'application/json'},
      body: {"code": OTP, "phone_number": contactNumber});
  if (response.statusCode != 200) {
    throw Exception('Failed to post data');
  }
  if (response.statusCode == 200) {
    success = true;
  }
  return success;
}
