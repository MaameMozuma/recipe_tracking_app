import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_profile.dart';

String baseUrl = 'http://127.0.0.1:5000';

Future<UserProfile> fetchProfile(String userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('auth_token');
  final response =
      await http.get(Uri.parse(baseUrl + '/view_account'), headers: {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer' + '' + token.toString()
  });
  if (response.statusCode == 200) {
    return UserProfile.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load User Profile');
  }
}
