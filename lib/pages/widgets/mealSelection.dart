import 'package:flutter/material.dart';
import 'package:team_proj_leanne/model/meal.dart';
import 'package:team_proj_leanne/pages/widgets/meal_card.dart';

class Mealselection extends StatelessWidget {
  final String title;
  final List<Meal> meals;
  final void Function(Meal) onDelete;
  
  const Mealselection({
    super.key,
    required this.title,
    required this.meals,
    required this.onDelete,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        ),
        ...meals.map((meal) => MealCard(meal: meal, onDelete: () => onDelete(meal))),
      ],);
  }
}