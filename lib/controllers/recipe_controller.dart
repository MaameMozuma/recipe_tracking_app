import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_proj_leanne/model/recipe_model.dart';
import 'package:team_proj_leanne/services/api_service.dart';

class RecipeController {
  //final token =
  //"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcyMTQzMTgzNCwianRpIjoiOTlmMjU2NDYtYjBjNi00ZTk4LTg2M2MtYzkyNDcyZTcxZTBiIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6IkFkbWluMyIsIm5iZiI6MTcyMTQzMTgzNCwiZXhwIjoxNzI0MDIzODM0fQ.UbpT5ykTzGPMnuKVEPx8n_6D7Q192D1sXdfbmpQWLMg";
  final ApiService _apiService = ApiService();

  Future<List<Recipe>> getAllRecipes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response = await _apiService.get('get_all_recipes', token: token);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Recipe> recipes =
          jsonData.map((data) => Recipe.fromJson(data)).toList();
      return recipes;
    } else {
      throw Exception(
          'Failed to load recipes. Status code: ${response.statusCode}');
    }
  }

  Future<List<Recipe>> getUserRecipes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response =
        await _apiService.get('get_all_user_recipes', token: token);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Recipe> recipes =
          jsonData.map((data) => Recipe.fromJson(data)).toList();
      return recipes;
    } else {
      throw Exception(
          'Failed to load recipes. Status code: ${response.statusCode}');
    }
  }

  Future<Recipe> getRecipeById(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response = await _apiService.get('recipes/$id', token: token);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      Recipe recipe = Recipe.fromJson(jsonData);

      return recipe;
    } else {
      throw Exception(
          'Failed to load recipe. Status code: ${response.statusCode}');
    }
  }

  Future<void> createRecipe(Recipe recipe) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response = await _apiService.post(
      'create_recipe',
      recipe.toJson(),
      token: token,
    );
    if (response.statusCode != 201) {
      throw Exception(
          'Failed to create recipe. Status code: ${response.statusCode}');
    }
  }

  Future<void> editRecipe(Recipe recipe) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response = await _apiService.put(
      'update_recipe',
      recipe.toJson(),
      token: token,
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to edit recipe. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final response = await _apiService.delete(
      'delete_recipe/$recipeId',
      token: token,
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete recipe. Status code: ${response.statusCode}');
    }
  }
}
