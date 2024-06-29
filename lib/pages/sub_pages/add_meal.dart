import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_proj_leanne/pages/widgets/custom_btn.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  List<TextEditingController> itemControllers = [];
  List<TextEditingController> qtyControllers = [];
  File? _foodImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _foodImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
            const LabeledTextField(
                label: 'Meal Name',
                placeholder: 'Enter the name of the meal',
                readOnly: false),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: LabeledTextField(
                    label: 'Time',
                    placeholder: '00 hours',
                    readOnly: false,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: LabeledTextField(
                    label: '',
                    placeholder: '00 minutes',
                    readOnly: false,
                    keyboardType: TextInputType.number,
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
                                  color:
                                      const Color.fromRGBO(120, 82, 174, 1.0)),
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
                                        Image.file(
                                          _foodImage!,
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
                                print('button pressed!');
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
