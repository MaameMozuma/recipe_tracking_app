import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_proj_leanne/controllers/meal_controller.dart';
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
  List<Meal> _filteredMeals = [];
  final MealController _mealController = MealController();
  final List<Meal> sampleMeals = [];
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  void _fetchMeals() async {
    try {
      final meals = await _mealController.getUserMeals();
      setState(() {
        sampleMeals.clear();
        sampleMeals.addAll(meals);
        _filteredMeals = _filterMealsByDate(_selectedDate);
      });
    } catch (e) {
      // Handle errors if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load meals: $e')),
      );
    }
  }

  String _getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  List<Meal> _filterMealsByDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(date);
    return sampleMeals.where((meal) {
      return meal.date == formattedDate;
    }).toList();
  }

  bool _isToday(DateTime date) {
    final DateTime today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  Future<List<Meal>> filterMeals(String query) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate a delay
    return _filteredMeals.where((meal) {
      final mealNameLower = meal.meal_name.toLowerCase();
      final queryLower = query.toLowerCase();
      return mealNameLower.contains(queryLower);
    }).toList();
  }

  void _deleteMeal(Meal meal) async {
    try {
      await _mealController.deleteMeal(meal.meal_name);
      _fetchMeals();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal deleted successfully')),
      );
    } catch (e) {
      // Handle the error, for example by showing a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete meal: $e')),
      );
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _filteredMeals = _filterMealsByDate(date);
    });
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
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AddMealPage(), // Replace with your destination page
                  ),
                );

                if (result == true) {
                  // Refresh the meal list when returning from AddMealPage
                  setState(() {
                    _fetchMeals();
                  });
                }
              }),
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
                    originalMeals: _filterMealsByDate(_selectedDate),
                  ),
                  const SizedBox(height: 35),
                  CustomCalendar(onDateSelected: (date) {
                    _onDateSelected(date);
                  }),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _isToday(_selectedDate)
                            ? 'Today\'s Meals'
                            : DateFormat('d MMMM, yyyy').format(_selectedDate),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DisplayAllMeals(), // Replace with your destination page
                              ),
                            );
                            if (result == true) {
                              // Refresh the meal list when returning from DisplayAllMeals
                              _fetchMeals();
                            }
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
                    child: _filteredMeals.isEmpty
                        ? const Center(child: Text('No meals found'))
                        : ListView.builder(
                            itemCount: _filteredMeals.length,
                            itemBuilder: (context, index) {
                              final meal = _filteredMeals[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: MealCard(
                                  meal: meal,
                                  onDelete: () => _deleteMeal(meal),
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
