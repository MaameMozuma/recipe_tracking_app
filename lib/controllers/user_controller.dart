import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_proj_leanne/model/user_profile.dart';
import 'package:team_proj_leanne/services/api_service.dart';

class UserController {
  //final token =
  //"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcyMTQzMTgzNCwianRpIjoiOTlmMjU2NDYtYjBjNi00ZTk4LTg2M2MtYzkyNDcyZTcxZTBiIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6IkFkbWluMyIsIm5iZiI6MTcyMTQzMTgzNCwiZXhwIjoxNzI0MDIzODM0fQ.UbpT5ykTzGPMnuKVEPx8n_6D7Q192D1sXdfbmpQWLMg";
  final ApiService _apiService = ApiService();

  Future<UserProfile> getUserStatistics() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response =
        await _apiService.get('view_account', token: token.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      UserProfile user = UserProfile.fromJson(jsonData);
      return user;
    } else {
      throw Exception(
          'Failed to load user. Status code: ${response.statusCode}');
    }
  }

  Future<bool> editUser(profile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response = await _apiService.patch(
      'update_account',
      profile,
      token: token.toString(),
    );
    if (response.statusCode != 200) {
      return false;
    }
    return true;
  }
}
