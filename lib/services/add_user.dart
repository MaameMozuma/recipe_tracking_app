import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:team_proj_leanne/model/user_profile.dart';

String baseUrl =
    'https://us-central1-mobiledev-428400.cloudfunctions.net/nutripal_live1';

Future<bool> addUser(String username, String email, String contactNumber,
    String password, String height, String weight, String DOB) async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  bool success = false;
  final Data = UserProfile(
      username: username,
      weight: weight,
      height: height,
      telno: contactNumber,
      dob: DOB,
      email: email,
      fcmtoken: fcmToken.toString());
  final response = await http.post(Uri.parse('$baseUrl/signup'),
      headers: {'Accept': '*/*', 'Content-Type': 'application/json'},
      body: jsonEncode(Data.toJson()));
  if (response.statusCode != 201) {
    throw Exception('Failed to post data');
  }
  if (response.statusCode == 201) {
    success = true;
  }
  return success;
}

Future<bool> sendOTP(String contactNumber) async {
  final Map<String, dynamic> requestBody = {
    'phone_number': contactNumber,
  };
  bool success = false;
  final response = await http.post(Uri.parse('$baseUrl/send_otp'),
      headers: {'Accept': '*/*', 'Content-Type': 'application/json'},
      body: jsonEncode(requestBody));
  if (response.statusCode != 200) {
    throw Exception('Failed to generate OTP');
  }
  if (response.statusCode == 200) {
    success = true;
  }
  return success;
}

Future<bool> verifyOTP(String OTP, String contactNumber) async {
  final Map<String, dynamic> requestBody = {
    'phone_number': contactNumber,
    "code": OTP
  };
  bool success = false;
  final response = await http.post(Uri.parse('$baseUrl/verify_otp'),
      headers: {'Accept': '*/*', 'Content-Type': 'application/json'},
      body: jsonEncode(requestBody));
  if (response.statusCode != 200) {
    throw Exception('Failed to post data');
  }
  if (response.statusCode == 200) {
    success = true;
  }
  return success;
}
