import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_proj_leanne/model/meal.dart';
import 'package:team_proj_leanne/services/api_service.dart';

class MealController {
  //final token =
  //"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcyMTQzMTgzNCwianRpIjoiOTlmMjU2NDYtYjBjNi00ZTk4LTg2M2MtYzkyNDcyZTcxZTBiIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6IkFkbWluMyIsIm5iZiI6MTcyMTQzMTgzNCwiZXhwIjoxNzI0MDIzODM0fQ.UbpT5ykTzGPMnuKVEPx8n_6D7Q192D1sXdfbmpQWLMg";
  final ApiService _apiService = ApiService();

  Future<List<Meal>> getAllMealss() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response = await _apiService.get('get_all_meals', token: token);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Meal> meals = jsonData.map((data) => Meal.fromJson(data)).toList();
      return meals;
    } else {
      throw Exception(
          'Failed to load meals. Status code: ${response.statusCode}');
    }
  }

  Future<List<Meal>> getUserMeals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response = await _apiService.get('get_all_user_meals', token: token);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isEmpty) {
        // Handle the case where there are no meals
        print('No meals found for the user.');
        return []; // Return an empty list
      }
      List<Meal> meals = jsonData.map((data) => Meal.fromJson(data)).toList();
      return meals;
    } else {
      throw Exception(
          'Failed to load meals. Status code: ${response.statusCode}');
    }
  }

  Future<Meal> getOneMeal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response = await _apiService.get('get_meal', token: token);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      Meal meal = Meal.fromMap(jsonData);

      return meal;
    } else {
      throw Exception(
          'Failed to load meal. Status code: ${response.statusCode}');
    }
  }

  Future<bool> createMeal(meal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response = await _apiService.post(
      'add_meal',
      meal,
      token: token,
    );
    if (response.statusCode != 201) {
      return false;
    }
    return true;
  }

  Future<void> editMeal(Meal meal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response = await _apiService.put(
      'update_meal',
      meal.toJson(),
      token: token,
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to edit meal. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteMeal(String meal_name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response = await _apiService.delete(
      'delete_meal?meal_name=$meal_name',
      token: token,
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete meal. Status code: ${response.statusCode}');
    }
  }
}
