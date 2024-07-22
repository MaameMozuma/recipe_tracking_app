import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:team_proj_leanne/controllers/meal_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '/pages/widgets/custom_btn.dart';
import '/pages/widgets/text_field.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final MealController _mealController = MealController();
  List<TextEditingController> itemControllers = [];
  List<TextEditingController> qtyControllers = [];
  TextEditingController mealNameController = TextEditingController();
  TextEditingController timeHoursController = TextEditingController();
  TextEditingController timeMinutesController = TextEditingController();
  File? _foodImage;
  String? _profileImage = "";

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _foodImage = File(pickedFile.path);
      });

      final profilePicUrl = await _uploadImage();
      if (profilePicUrl != null) {
        setState(() {
          _profileImage = profilePicUrl;
        });
      }
    }
  }

  @override
  void dispose() {
    mealNameController.dispose();
    timeHoursController.dispose();
    timeMinutesController.dispose();
    qtyControllers.forEach((controller) => controller.dispose());
    itemControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

    void _validateHours() {
    final hours = int.tryParse(timeHoursController.text) ?? 0;
    if (hours < 0 || hours > 24) {
      // Optionally, show a validation error or adjust the value
      timeHoursController.text = (hours.clamp(0, 24)).toString();
      timeHoursController.selection = TextSelection.fromPosition(
        TextPosition(offset: timeHoursController.text.length),
      );
    }
  }

  void _validateMinutes() {
    final minutes = int.tryParse(timeMinutesController.text) ?? 0;
    if (minutes < 0 || minutes > 59) {
      // Optionally, show a validation error or adjust the value
      timeMinutesController.text = (minutes.clamp(0, 59)).toString();
      timeMinutesController.selection = TextSelection.fromPosition(
        TextPosition(offset: timeMinutesController.text.length),
      );
    }
  }

  void addMeal() async {
    // Check if essential fields are empty
    if (mealNameController.text.isEmpty ||
        timeHoursController.text.isEmpty ||
        timeMinutesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some fields are empty. Kindly fill them!'),
        ),
      );
      return;
    }

    // Check if ingredient fields are empty
    if (itemControllers.isEmpty || qtyControllers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add ingredients!'),
        ),
      );
      return;
    }

    // Convert itemControllers and qtyControllers to a list of maps
    List<Map<String, dynamic>> ingredients = [];
    for (int i = 0; i < itemControllers.length; i++) {
      String item = itemControllers[i].text;
      String quantity = qtyControllers[i].text;

      if (item.isNotEmpty && quantity.isNotEmpty) {
        ingredients.add({
          'item': item,
          'quantity': quantity,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all ingredient fields!'),
          ),
        );
        return;
      }
    }

    // Create the meal JSON
    Map<String, dynamic> mealData = {
      'meal_name': mealNameController.text,
      'time_hours': int.parse(timeHoursController.text),
      'time_minutes': int.parse(timeMinutesController.text),
      'image_url': _profileImage,
      'ingredients': ingredients,
    };

    // Send the meal data to the backend using the MealController
    try {
      var response = await _mealController.createMeal(mealData);
      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meal added successfully!'),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add meal!'),
          ),
        );
      }
    } catch (e) {
      // Handle error, maybe show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add meal: $e')),
      );
    }
  }

  Future<String?> _uploadImage() async {
    if (_foodImage == null) return "";

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef
          .child('meal_images/${DateTime.now().millisecondsSinceEpoch}.png');
      final uploadTask = imagesRef.putFile(_foodImage!);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print("Download URL: $downloadUrl");

      setState(() {
        _profileImage = downloadUrl;
      });

      print("Profile image URL updated: $_profileImage");
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  void addIngredientField() {
    setState(() {
      itemControllers.add(TextEditingController());
      qtyControllers.add(TextEditingController());
    });
  }

  @override
  void initState() {
    super.initState();
    addIngredientField();
    timeHoursController.addListener(_validateHours);
    timeMinutesController.addListener(_validateMinutes);
  }

  void removeIngredientField(int index) {
    setState(() {
      itemControllers.removeAt(index);
      qtyControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Meal',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            LabeledTextField(
              label: 'Meal Name',
              placeholder: 'Enter the name of the meal',
              readOnly: false,
              keyboardType: TextInputType.text,
              controller: mealNameController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: LabeledTextField(
                    label: 'Time',
                    placeholder: '00 hours',
                    readOnly: false,
                    keyboardType: TextInputType.number,
                    controller: timeHoursController,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: LabeledTextField(
                    label: '',
                    placeholder: '00 minutes',
                    readOnly: false,
                    keyboardType: TextInputType.number,
                    controller: timeMinutesController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: addIngredientField,
                ),
              ],
            ),
            Form(
              key: GlobalKey<FormState>(),
              child: Column(
                children: [
                  for (int index = 0; index < itemControllers.length; index++)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Item',
                                  hintStyle: const TextStyle(
                                      color: Color.fromRGBO(202, 201, 201, 1)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                          color: Color.fromRGBO(
                                              120, 82, 174, 1.0))),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Color.fromRGBO(120, 82, 174,
                                            1.0)), // Enabled border color
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(120, 82, 174, 1.0),
                                        width:
                                            2.0), // Focused border color and width
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.red,
                                        width:
                                            2.0), // Error border color and width
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(120, 82, 174, 1.0),
                                        width:
                                            0.0), // Focused border color and width
                                  ),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                ),
                                keyboardType: TextInputType.text,
                                controller: itemControllers[index],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Qty(g)',
                                  hintStyle: const TextStyle(
                                      color: Color.fromRGBO(202, 201, 201, 1)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                          color: Color.fromRGBO(
                                              120, 82, 174, 1.0))),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Color.fromRGBO(120, 82, 174,
                                            1.0)), // Enabled border color
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(120, 82, 174, 1.0),
                                        width:
                                            2.0), // Focused border color and width
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.red,
                                        width:
                                            2.0), // Error border color and width
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(120, 82, 174, 1.0),
                                        width:
                                            0.0), // Focused border color and width
                                  ),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                ),
                                keyboardType: TextInputType.number,
                                controller: qtyControllers[index],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () => removeIngredientField(index),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromRGBO(120, 82, 174, 1.0)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 70,
                      width: double.infinity,
                      child: _foodImage == null
                          ? const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('Choose Picture'),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  _foodImage != null
                                      ? Image.file(
                                          _foodImage!,
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                        )
                                      : Image.network(
                                          _profileImage!,
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                        ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      path.basename(_foodImage!.path),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 70,
                    child: CustomBtn(
                        text: 'Save',
                        onPressed: () {
                          addMeal();
                          //Navigator.pop(context);
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
