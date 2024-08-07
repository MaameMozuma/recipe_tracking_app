import 'package:flutter/material.dart';
import 'package:team_proj_leanne/controllers/recipe_controller.dart';
import 'package:team_proj_leanne/model/recipe_model.dart';
import 'package:team_proj_leanne/pages/sub_pages/create_recipe.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetail({super.key, required this.recipe});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  late Future<Recipe> _futureRecipe;
  final RecipeController _recipeController = RecipeController();

  @override
  void initState() {
    super.initState();
    _futureRecipe = _recipeController.getRecipeById(widget.recipe.recipeId);
  }

  Future<void> _deleteRecipe() async {
    try {
      await _recipeController.deleteRecipe(widget.recipe.recipeId);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete recipe: $e')),
      );
    }
  }

  void _navigateToCreateRecipe(BuildContext context, Recipe recipe) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRecipe(recipe: recipe),
      ),
    );

    if (result == true) {
      setState(() {
        _futureRecipe = _recipeController.getRecipeById(widget.recipe.recipeId);
      });
    }
  }

  void openSMSAppWithMessage(String message) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: '', // Leave path empty to not pre-fill any number
      queryParameters: <String, String>{'body': message},
    );

    // Check if the URL can be launched
    if (await canLaunchUrl(smsUri)) {
      // Launch the URL
      await launchUrl(smsUri);
    } else {
      throw 'Could not launch SMS app';
    }
  }

  void _shareRecipe(String recipeId) {
    String message =
        "Hey there! I just found this delicious recipe and thought you’d love it too! Here’s a little sneak peek of what’s cooking: \nhttps://us-central1-mobiledev-428400.cloudfunctions.net/nutripal_live1/share_recipe/$recipeId";

    openSMSAppWithMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Recipe>(
      future: _futureRecipe,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final recipe = snapshot.data!;
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(250),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
                child: Container(
                  color: const Color.fromARGB(255, 252, 249, 249),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 40.0, left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.black),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            // IconButton(
                            //   icon: const Icon(Icons.add, color: Colors.black),
                            //   onPressed: () {},
                            // ),
                          ],
                        ),
                        Center(
                          child: recipe.imageUrl != null ? Image.network(
                  recipe.imageUrl!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Handle image loading error
                    return Center(
                      child: Container(
                        width: 105,
                        height: 105,
                        color:
                            Colors.grey[300], // Background color for error state
                        child: Icon(
                          Icons.fastfood, // Default meal icon
                          size: 30,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  },
                ): SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe name
                    Text(
                      recipe.recipeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Calories and duration
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              color: Color.fromARGB(255, 120, 82, 174),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${recipe.totalCalories} kcal',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer,
                              color: Color.fromARGB(255, 120, 82, 174),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${recipe.duration} min',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      recipe.details,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Icon(
                          Icons.food_bank,
                          color: Color.fromARGB(255, 120, 82, 174),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Ingredients list
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: recipe.ingredients.map((ingredient) {
                        return Text(
                          '${ingredient.item}: ${ingredient.calories} kcal',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Icon(
                          Icons.receipt,
                          color: Color.fromARGB(255, 120, 82, 174),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Steps',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Steps list
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: recipe.steps.map((step) {
                        final stepNumber = recipe.steps.indexOf(step) + 1;
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$stepNumber. ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text: step.description,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        recipe.userRecipe!
                            ? Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    color:
                                        const Color.fromARGB(255, 120, 82, 174),
                                    onPressed: () {
                                      _navigateToCreateRecipe(context, recipe);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color:
                                        const Color.fromARGB(255, 120, 82, 174),
                                    onPressed: () async {
                                      await _deleteRecipe();
                                    },
                                  )
                                ],
                              )
                            : const SizedBox(),
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Color.fromARGB(255, 120, 82, 174),
                          ),
                          onPressed: () {
                            _shareRecipe(recipe.recipeId);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('No data')),
          );
        }
      },
    );
  }
}
