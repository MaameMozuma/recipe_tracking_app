import 'package:flutter/material.dart';
import 'package:team_proj_leanne/controllers/meal_controller.dart';
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
  List<Meal> _filteredMeals = [];
  final List<Meal> sampleMeals = [];
  final MealController _mealController = MealController();
  bool _isLoading = true;
  String? _errorMessage;

  Future<List<Meal>> filterMeals(String query) async {
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate a delay
    return sampleMeals.where((meal) {
      final mealNameLower = meal.meal_name.toLowerCase();
      final queryLower = query.toLowerCase();
      return mealNameLower.contains(queryLower);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  Future<void> _fetchMeals() async {
    try {
      List<Meal> meals = await _mealController.getUserMeals();
      setState(() {
        sampleMeals.addAll(meals);
        _filteredMeals = sampleMeals; // Initialize filtered meals
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load meals: $e';
        _isLoading = false;
      });
    }
  }

  void _deleteMeal(Meal meal) async {
    try {
      await _mealController.deleteMeal(meal.meal_name);
      setState(() {
        sampleMeals.remove(meal);
        _filteredMeals = sampleMeals;
      });
    } catch (e) {
      // Handle the error, for example by showing a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete meal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Meal>> groupedMeals = groupMealsByDate(_filteredMeals);
    List<String> pastWeekDates = getPastWeekDates();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(230, 230, 250, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
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
                  originalMeals: List.from(sampleMeals),
                ),
                const SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                        ? Center(child: Text(_errorMessage!))
                        :_filteredMeals.isEmpty
                            ? const Center(child: Text('No meals found'))
                        : Expanded(
                            child: ListView(
                              children: pastWeekDates.map((date) {
                                String title = getDayTitle(date);
                                return groupedMeals.containsKey(date)
                                    ? Mealselection(
                                        title: title,
                                        meals: groupedMeals[date]!,
                                        onDelete: _deleteMeal,
                                      )
                                    : Container();
                              }).toList(),
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
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
      String date = meal.date;
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
    } else if (date ==
        DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE')
          .format(dateTime); // Return day name (e.g., Monday)
    }
  }
}
