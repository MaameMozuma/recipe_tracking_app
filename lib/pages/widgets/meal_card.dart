import 'package:flutter/material.dart';
import 'package:team_proj_leanne/model/meal.dart';
import 'package:team_proj_leanne/pages/sub_pages/meal_detail_page.dart';
import 'package:intl/intl.dart';

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({super.key,
    required this.meal,
    });

  @override
  Widget build(BuildContext context) {
    final timeFormatted = DateFormat.Hm().format(meal.date);
    final name = meal.name;
    final totalCalories = meal.totalCalories;
    final img = meal.mealImage;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipOval(
          child: Image.network(
            img,
            width: 55,
            height: 55,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        subtitle: Text('$totalCalories cals',
          style: const TextStyle(fontSize: 16)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(timeFormatted, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 8.0,),
            Expanded(
              child: IconButton(
              onPressed: (){
                Map<String, dynamic> mealMap = meal.toMap();
                showMealDetailModal(context, mealMap);
              },
              iconSize: 16,
              icon: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}