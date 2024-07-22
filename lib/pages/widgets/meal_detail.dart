import 'dart:ffi';

import 'package:flutter/material.dart';

class MealDetailCard extends StatefulWidget {
  final String mealName;
  final double mealCalories;
  final String mealImage;
  final List<Map<String, dynamic>> mealIngredients;
  final VoidCallback onDelete;

  const MealDetailCard({
    super.key,
    required this.mealName,
    required this.mealCalories,
    required this.mealImage,
    required this.mealIngredients,
    required this.onDelete,
  });

  @override
  State<MealDetailCard> createState() => _MealDetailCardState();
}

class _MealDetailCardState extends State<MealDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
              child: widget.mealImage.isNotEmpty
                  ? Image.network(
                      widget.mealImage,
                      width: 100,
                      height: 100,
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
                  : const Icon(
                      Icons.fastfood,
                      size: 100,
                      color: Colors.grey,
                    ),
            ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mealName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.mealCalories} calories',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            for (var ingredient in widget.mealIngredients)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ingredient['item']),
                    Text('${ingredient['calories']} cals'),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                )),
          ],
        ),
      ),
    );
  }
}
