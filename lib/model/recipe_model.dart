import 'package:team_proj_leanne/model/ingredient_model.dart';
import 'package:team_proj_leanne/model/step_model.dart';

class Recipe {
  String recipeId;
  final bool? userRecipe;
  final List<Ingredient> ingredients;
  final String recipeName;
  final String details;
  final int duration;
  final List<Step> steps;
  final String? imageUrl;
  final double? totalCalories; // Make this nullable

  Recipe({
    required this.recipeId,
    this.userRecipe,
    required this.ingredients,
    required this.recipeName,
    required this.details,
    required this.duration,
    required this.steps,
    this.imageUrl,
    this.totalCalories, // Make this optional
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    var ingredientsFromJson = json['ingredients'] as List;
    List<Ingredient> ingredientList =
        ingredientsFromJson.map((i) => Ingredient.fromJson(i)).toList();

    var stepsFromJson = json['steps'] as List;
    List<Step> stepList = stepsFromJson.map((s) => Step.fromJson(s)).toList();

    return Recipe(
      recipeId: json['recipe_id'],
      ingredients: ingredientList,
      recipeName: json['recipe_name'],
      details: json['details'],
      duration: json['duration'],
      steps: stepList,
      imageUrl: json["image_url"],
      userRecipe: json['user_recipe'] ?? false,
      totalCalories:
          json['total_calories']?.toDouble(), // Handle optional value
    );
  }

  Map<String, dynamic> toJson() {
    final jsonMap = {
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'recipe_name': recipeName,
      'details': details,
      'duration': duration,
      'steps': steps.map((s) => s.toJson()).toList(),
      'recipe_id': recipeId,
      'image_url': imageUrl,
      if (totalCalories != null) 'total_calories': totalCalories,
    };
    return jsonMap;
  }
}
