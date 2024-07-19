import 'package:flutter/material.dart';

import '/model/meal.dart';
import '/pages/sub_pages/add_meal.dart';
import '/pages/sub_pages/view_all_meals.dart';
import '/pages/widgets/calendar.dart';
import '/pages/widgets/meal_card.dart';
import '/pages/widgets/search.dart';

class MealLogPage extends StatefulWidget {
  const MealLogPage({super.key});

  @override
  State<MealLogPage> createState() => _MealLogPageState();
}

class _MealLogPageState extends State<MealLogPage> {
  late List<Meal> _filteredMeals;
  final List<Meal> sampleMeals = [
    Meal(
      name: 'Avocado Salad',
      totalCalories: 280,
      mealImage:
          'https://www.eatwell101.com/wp-content/uploads/2019/04/avocado-salad-recipe.jpg',
      date: DateTime.timestamp(),
      mealIngredients: [
        {"name": "Oats", "quantity": "100g", "calories": 389},
        {"name": "Milk", "quantity": "200ml", "calories": 130}
      ],
    ),
    Meal(
      name: 'Chicken Salad',
      totalCalories: 300,
      mealImage:
          'https://www.eatwell101.com/wp-content/uploads/2019/04/avocado-salad-recipe.jpg',
      date: DateTime.timestamp(),
      mealIngredients: [
        {"name": "Oats", "quantity": "100g", "calories": 389},
        {"name": "Milk", "quantity": "200ml", "calories": 130}
      ],
    ),
    Meal(
      name: 'Fruit Salad',
      totalCalories: 150,
      mealImage:
          'https://www.eatwell101.com/wp-content/uploads/2019/04/avocado-salad-recipe.jpg',
      date: DateTime.timestamp(),
      mealIngredients: [
        {"name": "Oats", "quantity": "100g", "calories": 389},
        {"name": "Milk", "quantity": "200ml", "calories": 130}
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredMeals = sampleMeals; // Initialize _filteredMeals here
  }

  Future<List<Meal>> filterMeals(String query) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate a delay
    return sampleMeals.where((meal) {
      final mealNameLower = meal.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return mealNameLower.contains(queryLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(230, 230, 250, 1.0),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
              size: 40,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AddMealPage(), // Replace with your destination page
                ),
              );
              // Navigate to the add meal page
            },
          ),
        ],
      ),
      body: Container(
        color: const Color.fromRGBO(230, 230, 250, 1.0),
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Meal Logs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomSearchBar(
                    placeholder: 'Search for meals',
                    filterMeals: filterMeals,
                    onFilteredData: (filteredMeals) {
                      setState(() {
                        _filteredMeals = filteredMeals;
                      });
                    },
                  ),
                  const SizedBox(height: 35),
                  const CustomCalendar(),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Today\'s Meals',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DisplayAllMeals(), // Replace with your destination page
                              ),
                            );
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(160, 160, 160, 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredMeals.length,
                      itemBuilder: (context, index) {
                        final meal = _filteredMeals[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: MealCard(
                            meal: meal,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
