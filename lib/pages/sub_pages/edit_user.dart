import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_proj_leanne/controllers/user_controller.dart';
import 'package:team_proj_leanne/model/user_profile.dart';
import '/pages/widgets/custom_btn.dart';
import '/pages/widgets/text_field.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  String? _profileImage;
  File? _image;
  late Future<UserProfile> _futureProfile;
  final UserController _userController = UserController();

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();


    bool _validateInputs(String height, String weight) {
    // Check if height and weight are empty
    if (height.isEmpty || weight.isEmpty) {
      return false;
    }

    // Check if height and weight are valid numbers
    final heightValue = double.tryParse(height);
    final weightValue = double.tryParse(weight);

    if (heightValue == null || weightValue == null) {
      return false;
    }

    return true;
  }

Future<void> _saveProfile(String telno, BuildContext context) async {
    final height = _heightController.text;
    final weight = _weightController.text;

    if (_validateInputs(height, weight)) {
      var isUpdateSuccessful = await _userController.editUser({
        "phone_number": telno,
        "height": height,
        "weight": weight,
        "profile_pic_url": _profileImage ?? "",
      });

      if (isUpdateSuccessful) {
        _showSaveConfirmDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User details could not be updated!'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid height and weight.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _futureProfile = _userController.getUserStatistics();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      final profilePicUrl = await _uploadImage();
      if (profilePicUrl != null) {
        setState(() {
          _profileImage = profilePicUrl;
        });
      }
    }
  }

  Future<String?> _uploadImage() async {
    if (_image == null) return "";

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.png');
      final uploadTask = imagesRef.putFile(_image!);

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

  Future<void> _showSaveConfirmDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Changes Saved'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your changes have been saved'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
        future: _futureProfile,
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
            final profile = snapshot.data!;

            // Only set _profileImage if it hasn't been set already
            // ignore: prefer_conditional_assignment
            if (_profileImage == null) {
              _profileImage = profile.profile_pic_url ?? '';
            }

            _heightController.text = profile.height ?? '';
            _weightController.text = profile.weight ?? '';

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: const Color.fromRGBO(230, 230, 250, 1.0),
                      padding: const EdgeInsets.only(
                          top: 30, bottom: 10, left: 10, right: 16),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.black)),
                          ),
                          const Center(
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: 40,
                                  left: 10,
                                  child: Container(
                                    width:
                                        100, // Adjust based on CircleAvatar radius
                                    height:
                                        100, // Adjust based on CircleAvatar radius
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            230, 230, 250, 1.0), // Border color
                                        width: 8.0, // Border width
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: const Color.fromRGBO(
                                          237, 234, 234, 1.0),
                                      backgroundImage: _profileImage != ""
                                          ? NetworkImage(_profileImage!)
                                          : null,
                                      child: _profileImage == "" || _profileImage == null || _profileImage!.isEmpty
                                          ? const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.black,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 35,
                                    left: 115,
                                    child: ElevatedButton(
                                        onPressed: _pickImage,
                                        child: const Text(
                                          'Change Profile Picture',
                                          style: TextStyle(color: Colors.black),
                                        )))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          SizedBox(
                            child: LabeledTextField(
                                label: 'Full Name',
                                placeholder: profile.username,
                                readOnly: true),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            child: LabeledTextField(
                                label: 'Email',
                                placeholder: profile.email,
                                readOnly: true),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            child: LabeledTextField(
                                label: 'Phone Number',
                                placeholder: profile.telno,
                                readOnly: true),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: LabeledTextField(
                                  label: 'Height',
                                  placeholder: 'Enter height',
                                  readOnly: false,
                                  keyboardType: TextInputType.number,
                                  controller: _heightController,
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: LabeledTextField(
                                  label: 'Weight',
                                  placeholder: 'Enter weight',
                                  readOnly: false,
                                  keyboardType: TextInputType.number,
                                  initialValue: profile.weight,
                                  controller: _weightController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 70,
                            child: CustomBtn(
                                text: 'Save',
                                onPressed: () {
                                  _saveProfile(profile.telno, context);
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: Text('No data')),
            );
          }
        });
  }
}
