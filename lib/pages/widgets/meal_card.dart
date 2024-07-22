import 'package:flutter/material.dart';
import 'package:team_proj_leanne/model/meal.dart';
import 'package:team_proj_leanne/pages/sub_pages/meal_detail_page.dart';
import 'package:intl/intl.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onDelete;

  const MealCard({
    super.key,
    required this.meal,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    //final Formatted = DateFormat.Hm().format(meal.date);
    final name = meal.meal_name;
    final totalCalories = meal.total_calories;
    final img = meal.image_url;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipOval(
          child: img.isNotEmpty
              ? Image.network(
                  img,
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Handle image loading error
                    return Container(
                      width: 55,
                      height: 55,
                      color:
                          Colors.grey[300], // Background color for error state
                      child: Icon(
                        Icons.fastfood, // Default meal icon
                        size: 30,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                )
              : Container(
                  width: 55,
                  height: 55,
                  color: Colors.grey[300], // Background color for empty image
                  child: Icon(
                    Icons.fastfood, // Default meal icon
                    size: 30,
                    color: Colors.grey[600],
                  ),
                ),
        ),
        title: Text(name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        subtitle:
            Text('$totalCalories cals', style: const TextStyle(fontSize: 16)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //Text(timeFormatted, style: const TextStyle(fontSize: 12)),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  Map<String, dynamic> mealMap = meal.toMap();

                  showMealDetailModal(context, mealMap, onDelete);
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
