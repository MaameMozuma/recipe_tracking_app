// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/main_pages/dashboard.dart';
import 'package:team_proj_leanne/pages/main_pages/meal_log.dart';
import 'package:team_proj_leanne/pages/main_pages/recipe.dart';

class customBottomNavigationBar extends StatefulWidget {
  final int initialPageIndex;

  const customBottomNavigationBar({super.key, required this.initialPageIndex});

  @override
  State<customBottomNavigationBar> createState() =>
   _customBottomNavigationBar();
}

class _customBottomNavigationBar extends State<customBottomNavigationBar> {
  int currentPage = 0;
  final List<Widget> screens = [
    const Dashboard(),
    const MealLogPage(),
    const AllRecipesPages(),
  ];

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentPage],
      bottomNavigationBar: Container(
        // height: 80, // Adjust the height as per your preference
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -3), // Shadow beneath the nav bar
            ),
          ],
        ),
        child:
          BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: currentPage,
            selectedItemColor: Color.fromRGBO(120, 82, 174, 1.0),
            unselectedItemColor: Colors.grey,
            onTap: (value) {
              setState(() {
            currentPage = value;
              });
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart, size: 35),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_dining, size: 35),
                label: 'Meals',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book, size: 35),
                label: 'Recipes',
              ),
            ],
          ),
      ),
    );
  }
}