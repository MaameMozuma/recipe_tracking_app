import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/widgets/mealSelection.dart';
import 'package:team_proj_leanne/pages/widgets/search.dart';
import 'package:team_proj_leanne/model/meal.dart';
import 'package:intl/intl.dart';

class DisplayAllMeals extends StatefulWidget {
  const DisplayAllMeals({super.key});

  @override
  State<DisplayAllMeals> createState() => _DisplayAllMealsState();
}

class _DisplayAllMealsState extends State<DisplayAllMeals> {
  late List<Meal> _filteredMeals;
  final List<Meal> sampleMeals = [
    Meal(
      name: 'Avocado Salad',
      totalCalories: 280,
      mealImage:
          'https://www.eatwell101.com/wp-content/uploads/2019/04/avocado-salad-recipe.jpg',
      date:DateTime.timestamp(),
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
     Meal(
      name: 'Quinoa Salad',
      totalCalories: 350,
      mealImage:
          'https://www.eatwell101.com/wp-content/uploads/2019/04/avocado-salad-recipe.jpg',
      date: DateTime(2024, 6, 27, 13, 0),
      mealIngredients: [
        {"name": "Quinoa", "quantity": "200g", "calories": 120},
        {"name": "Tomatoes", "quantity": "100g", "calories": 18}
      ],
    ),
    Meal(
      name: 'Steak and Veggies',
      totalCalories: 450,
      mealImage:
          'https://www.eatwell101.com/wp-content/uploads/2019/04/avocado-salad-recipe.jpg',
      date: DateTime(2024, 6, 27, 20, 0),
      mealIngredients: [
        {"name": "Steak", "quantity": "250g", "calories": 271},
        {"name": "Broccoli", "quantity": "100g", "calories": 34}
      ],
    ),
    Meal(
      name: 'Scrambled Eggs',
      totalCalories: 220,
      mealImage:
          'https://www.eatwell101.com/wp-content/uploads/2019/04/avocado-salad-recipe.jpg',
      date: DateTime(2024, 6, 26, 7, 30),
      mealIngredients: [
        {"name": "Eggs", "quantity": "3", "calories": 210},
        {"name": "Butter", "quantity": "10g", "calories": 72}
      ],
    ),
    Meal(
      name: 'Tuna Sandwich',
      totalCalories: 310,
      mealImage:
          'https://www.eatwell101.com/wp-content/uploads/2019/04/avocado-salad-recipe.jpg',
      date: DateTime(2024, 6, 26, 12, 15),
      mealIngredients: [
        {"name": "Tuna", "quantity": "100g", "calories": 132},
        {"name": "Whole Grain Bread", "quantity": "2 slices", "calories": 138}
      ],
    ),
    Meal(
      name: 'Veggie Stir-Fry',
      totalCalories: 280,
      mealImage:
          'https://www.eatwell101.com/wp-content/uploads/2019/04/avocado-salad-recipe.jpg',
      date: DateTime(2024, 6, 26, 18, 30),
      mealIngredients: [
        {"name": "Bell Peppers", "quantity": "150g", "calories": 45},
        {"name": "Carrots", "quantity": "100g", "calories": 41}
      ],
    ),
  ];

  Future<List<Meal>> filterMeals(String query) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate a delay
    return sampleMeals.where((meal) {
      final mealNameLower = meal.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return mealNameLower.contains(queryLower);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _filteredMeals = sampleMeals;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Meal>> groupedMeals = groupMealsByDate(sampleMeals);
    List<String> pastWeekDates = getPastWeekDates();
    return Scaffold(
            appBar: AppBar(
        backgroundColor: const Color.fromRGBO(230, 230, 250, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(230, 230, 250, 1.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Meals',
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
                  const SizedBox(height: 20,),
                  Expanded(
                    child: ListView(
                    children: pastWeekDates.map((date){
                      String title = getDayTitle(date);
                      return groupedMeals.containsKey(date)?
                      Mealselection(title: title, meals: groupedMeals[date]!):
                      Container();
                    }).toList(),
                  ),
                  ),
              ],
              ),),),),
    );
  }

List<String> getPastWeekDates() {
  List<String> dates = [];
  DateTime now = DateTime.now();

  for (int i = 0; i < 7; i++) {
    DateTime date = now.subtract(Duration(days: i));
    dates.add(DateFormat('yyyy-MM-dd').format(date));
  }

  return dates;
}

Map<String, List<Meal>> groupMealsByDate(List<Meal> meals) {
  Map<String, List<Meal>> groupedMeals = {};

  for (Meal meal in meals) {
    String date = DateFormat('yyyy-MM-dd').format(meal.date);
    if (!groupedMeals.containsKey(date)) {
      groupedMeals[date] = [];
    }
    groupedMeals[date]!.add(meal);
  }
  return groupedMeals;
}

  String getDayTitle(String date) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(date);

    if (date == DateFormat('yyyy-MM-dd').format(now)) {
      return 'Today';
    } else if (date == DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE').format(dateTime); // Return day name (e.g., Monday)
    }
  }

}