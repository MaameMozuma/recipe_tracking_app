import 'package:flutter/material.dart';
import 'package:team_proj_leanne/model/recipe_model.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Card(
        color: const Color.fromARGB(255, 249, 249, 252),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.grey, // Color of the border
            width: 1, // Width of the border
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.info,
                    color: Color.fromARGB(255, 120, 82, 174),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                                      'https://storage.googleapis.com/mobiledev-f3a76.appspot.com/recipe_images/food-template2.png',
                                      fit: BoxFit
                    .cover, // Adjust this to control how the image should be resized or fit.
                                    ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                recipe.recipeName,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    size: 12,
                    color: Color.fromARGB(255, 120, 82, 174),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${recipe.totalCalories.toString()} kcal",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
