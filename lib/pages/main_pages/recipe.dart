import 'package:flutter/material.dart';
import 'package:team_proj_leanne/controllers/recipe_controller.dart';
import 'package:team_proj_leanne/controllers/user_controller.dart';
import 'package:team_proj_leanne/model/recipe_model.dart';
import 'package:team_proj_leanne/model/user_profile.dart';

import '/pages/sub_pages/create_recipe.dart';
import '/pages/sub_pages/recipe_detail.dart';
import '/pages/widgets/recipe_card.dart';

class AllRecipesPages extends StatefulWidget {
  const AllRecipesPages({super.key});

  @override
  State<AllRecipesPages> createState() => _AllRecipesPagesState();
}

class _AllRecipesPagesState extends State<AllRecipesPages> {
  late Future<List<dynamic>> _allRecipesFuture;
  final RecipeController _recipeController = RecipeController();
  final UserController _userController = UserController();
  late UserProfile userData;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Recipe> _allRecipes = [];
  List<Recipe> _userRecipes = [];

  @override
  void initState() {
    super.initState();
    _allRecipesFuture = Future.wait([
      _recipeController.getAllRecipes(),
      _recipeController.getUserRecipes(),
      _userController.getUserStatistics(),
    ]);

    // Set up listener for search input
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  void _navigateToRecipeDetail(BuildContext context, Recipe recipe) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetail(recipe: recipe),
      ),
    );

    if (result == true) {
      setState(() {
        _allRecipesFuture = Future.wait([
          _recipeController.getAllRecipes(),
          _recipeController.getUserRecipes(),
          _userController.getUserStatistics(),
        ]);
      });
    }
  }

  void _navigateToCreateRecipe(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateRecipe(),
      ),
    );

    if (result == true) {
      setState(() {
        _allRecipesFuture = Future.wait([
          _recipeController.getAllRecipes(),
          _recipeController.getUserRecipes(),
          _userController.getUserStatistics(),
        ]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _allRecipesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: const Center(child: Text('No data available')),
          );
        } else {
          _allRecipes = snapshot.data![0] as List<Recipe>;
          _userRecipes = snapshot.data![1] as List<Recipe>;
          userData = snapshot.data![2] as UserProfile;

          final filteredAllRecipes = _allRecipes
              .where((recipe) =>
                  recipe.recipeName.toLowerCase().contains(_searchQuery))
              .toList();
          final filteredUserRecipes = _userRecipes
              .where((recipe) =>
                  recipe.recipeName.toLowerCase().contains(_searchQuery))
              .toList();

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: AppBar(
                backgroundColor: Colors.white,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              userData.username,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _navigateToCreateRecipe(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255, 120, 82, 174), // Background color
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10), // Button padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      13), // Rounded corners
                                ),
                              ),
                              child: const Text(
                                'New Recipe',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold), // Text color
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for recipes...', // Placeholder text
                          filled: true,
                          fillColor: Colors.grey[200], // Grey background color
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none, // Remove the border
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color.fromARGB(255, 120, 82, 174),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'All dishes',
                        // textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromARGB(255, 120, 82, 174),
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredAllRecipes
                            .length, // Number of cards you want to display
                        itemBuilder: (context, index) {
                          final recipe = filteredAllRecipes[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipeDetail(
                                        recipe: recipe,
                                      ),
                                    ),
                                  );
                                },
                                child: RecipeCard(recipe: recipe)),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Your recipes',
                        // textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromARGB(255, 120, 82, 174),
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredUserRecipes
                            .length, // Number of cards you want to display
                        itemBuilder: (context, index) {
                          final recipe = filteredUserRecipes[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: GestureDetector(
                                onTap: () {
                                  _navigateToRecipeDetail(context, recipe);
                                },
                                child: RecipeCard(recipe: recipe)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
