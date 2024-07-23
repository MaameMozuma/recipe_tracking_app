import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/widgets/meal_detail.dart';

void showMealDetailModal(BuildContext context, Map<String, dynamic> meal, VoidCallback onDelete) {
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
              mealName: meal['meal_name'],
              mealCalories: meal['total_calories'],
              mealImage: meal['image_url'],
              mealIngredients: meal['ingredients'],
              onDelete: () async {
                // Call the onDelete callback
                onDelete();
                // Close the dialog after deletion
                Navigator.pop(context);
              },
            ),
          );
        } 
        );
    },
  );
}