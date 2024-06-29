import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key});

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
                // mainAxisSize: MainAxisSize.min,
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
              Center(child: Image.asset('assets/images/food-template.png')),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Avocado Toast',
                // textAlign: TextAlign.left,
                style: TextStyle(
                  // color: Color.fromARGB(255, 120, 82, 174),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 12,
                    color: Color.fromARGB(255, 120, 82, 174),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '245kcal',
                    // textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
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
