import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_profile.dart';

String baseUrl =
    'https://us-central1-mobiledev-428400.cloudfunctions.net/nutripal_live1';

Future<UserProfile> fetchProfile() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('auth_token');
  final response =
      await http.get(Uri.parse(baseUrl + '/view_account'), headers: {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });
  if (response.statusCode == 200) {
    return UserProfile.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load User Profile');
  }
}
