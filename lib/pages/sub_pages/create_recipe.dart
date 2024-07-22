import 'dart:io';

import 'package:flutter/material.dart';
import 'package:team_proj_leanne/controllers/recipe_controller.dart';
import 'package:team_proj_leanne/model/ingredient_model.dart';
import 'package:team_proj_leanne/model/recipe_model.dart';
import 'package:team_proj_leanne/model/step_model.dart' as recipeStep;
import 'package:image_picker/image_picker.dart';
import 'package:team_proj_leanne/pages/widgets/image_picker.dart';

class CreateRecipe extends StatefulWidget {
  final Recipe? recipe;

  const CreateRecipe({super.key, this.recipe});

  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final RecipeController _recipeController = RecipeController();
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  List<List<TextEditingController>> _ingredientControllers = [];
  List<TextEditingController> _stepControllers = [];

  File? _recipeImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (PickedFile != null) {
      setState(() {
        _recipeImage = File(PickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize with one empty ingredient and step text field

    if (widget.recipe != null) {
      _initializeFields(widget.recipe!);
    } else {
      _addIngredientField();
      _addStepField();
    }
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _detailsController.dispose();
    _durationController.dispose();
    _ingredientControllers.forEach((controllers) {
      controllers.forEach((controller) => controller.dispose());
    });
    _stepControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _initializeFields(Recipe recipe) {
    _recipeNameController.text = recipe.recipeName;
    _detailsController.text = recipe.details;
    _durationController.text = recipe.duration.toString();

    // Initialize ingredient fields
    for (var ingredient in recipe.ingredients) {
      _ingredientControllers.add([
        TextEditingController(text: ingredient.item),
        TextEditingController(text: ingredient.quantity)
      ]);
    }

    // Initialize step fields
    for (var step in recipe.steps) {
      _stepControllers.add(TextEditingController(text: step.description));
    }
  }

  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add([
        TextEditingController(), // Item controller
        TextEditingController() // Quantity controller
      ]);
    });
  }

  void _removeIngredientField(int index) {
    setState(() {
      if (_ingredientControllers.length > 1) {
        _ingredientControllers.removeAt(index);
      }
    });
  }

  void _addStepField() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStepField(int index) {
    setState(() {
      if (_stepControllers.length > 1) {
        _stepControllers.removeAt(index);
      }
    });
  }

  Recipe prepareRecipeObj() {
    List<Ingredient> ingredients = _ingredientControllers.map((controllers) {
      // Get item and quantity
      var item = controllers[0].text;
      var quantity = controllers[1].text;

      return Ingredient(
        // calories: 0,
        item: item,
        quantity: quantity, // Default to 0 if parsing fails
      );
    }).toList();

    List<recipeStep.Step> steps = _stepControllers.asMap().entries.map((entry) {
      int idx = entry.key;
      TextEditingController controller = entry.value;
      return recipeStep.Step(
        stepNumber: 'Step ${idx + 1}',
        description: controller.text,
      );
    }).toList();

    Recipe recipe = Recipe(
      recipeId: widget.recipe != null ? widget.recipe!.recipeId : 'None',
      recipeName: _recipeNameController.text,
      details: _detailsController.text,
      duration: int.parse(_durationController.text),
      ingredients: ingredients,
      steps: steps,
    );

    return recipe;
  }

  void _createAndEditRecipe() async {
    try {
      Recipe recipe = prepareRecipeObj();

      if (widget.recipe != null) {
        await _recipeController.editRecipe(recipe);
        Navigator.pop(context, true);

      } else {
        await _recipeController.createRecipe(recipe);
        Navigator.pop(context, true);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipe != null ? 'Edit Recipe' : 'Create New Recipe',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recipe Name',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _recipeNameController,
                decoration: InputDecoration(
                  hintText: 'eg. Jollof Rice',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Details',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(
                  hintText: 'Recipe details',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Duration (minutes)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'eg. 45',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ingredients',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  IconButton(
                    onPressed: _addIngredientField,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: List.generate(_ingredientControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ingredientControllers[index][0],
                            decoration: InputDecoration(
                              hintText: 'Item',
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _ingredientControllers[index][1],
                            decoration: InputDecoration(
                              hintText: 'Qty(g)',
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        if (_ingredientControllers.length > 1 || index > 0)
                          IconButton(
                            onPressed: () => _removeIngredientField(index),
                            icon: const Icon(Icons.remove),
                          ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Steps',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  IconButton(
                    onPressed: _addStepField,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: List.generate(_stepControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _stepControllers[index],
                            decoration: InputDecoration(
                              hintText: 'Step ${index + 1}',
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        if (_stepControllers.length > 1 || index > 0)
                          IconButton(
                            onPressed: () => _removeStepField(index),
                            icon: const Icon(Icons.remove),
                          ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Recipe Image',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const SizedBox(height: 10),
              const ImagePickerInput(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _createAndEditRecipe,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 120, 82, 174),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      widget.recipe != null ? 'Edit Recipe' : 'Create Recipe',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
