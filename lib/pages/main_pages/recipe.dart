import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:team_proj_leanne/pages/sub_pages/create_recipe.dart';
import 'package:team_proj_leanne/pages/sub_pages/recipe_detail.dart';
import 'package:team_proj_leanne/pages/widgets/recipe_card.dart';

class AllRecipesPages extends StatefulWidget {
  const AllRecipesPages({super.key});

  @override
  State<AllRecipesPages> createState() => _AllRecipesPagesState();
}

class _AllRecipesPagesState extends State<AllRecipesPages> {
  @override
  Widget build(BuildContext context) {
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
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Samuel Blankson',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateRecipe(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 120, 82, 174), // Background color
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(13), // Rounded corners
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
                  decoration: InputDecoration(
                    hintText: 'Search for recipes...', // Placeholder text
                    filled: true,
                    fillColor: Colors.grey[200], // Grey background color
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // Remove the border
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  'Popular dishes',
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
                  itemCount: 10, // Number of cards you want to display
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecipeDetail(),
                              ),
                            );
                          },
                          child: const RecipeCard()),
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
                  'Recipes of the week',
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
                  itemCount: 10, // Number of cards you want to display
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecipeDetail(),
                              ),
                            );
                          },
                          child: const RecipeCard()),
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
}
