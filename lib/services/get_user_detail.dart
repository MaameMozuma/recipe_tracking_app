import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:team_proj_leanne/model/user_profile.dart';

Future<UserProfile> fetchContact(String userId) async {
  final response = await http.get(Uri.parse(
      'https://apps.ashesi.edu.gh/contactmgt/actions/get_a_contact_mob?contid=$userId'));
  if (response.statusCode == 200) {
    return UserProfile.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load User Profile');
  }
}