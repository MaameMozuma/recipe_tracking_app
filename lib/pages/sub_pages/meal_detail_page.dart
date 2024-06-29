import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/widgets/meal_detail.dart';

void showMealDetailModal(BuildContext context, Map<String, dynamic> meal) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController){
          return SingleChildScrollView(
            controller: scrollController,
            child: MealDetailCard(
              mealName: meal['name'],
              mealCalories: meal['totalCalories'],
              mealImage: meal['mealImage'],
              mealIngredients: meal['mealIngredients'],
            ),
          );
        } 
        );
    },
  );
}