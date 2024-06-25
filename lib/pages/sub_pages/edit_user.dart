import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_proj_leanne/pages/widgets/custom_btn.dart';
import 'dart:io';
import 'package:team_proj_leanne/pages/widgets/header.dart';
import 'package:team_proj_leanne/pages/widgets/text_field.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  File? _profileImage;

  Future<void> _pickImage() async{
    final picker = ImagePicker();
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (PickedFile != null){
      setState(() {
        _profileImage = File(PickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
        children: [
          HeaderWidget(
            profileImage: _profileImage,
            onPickImage: _pickImage
          ),
          const SizedBox(height: 80,),
          SizedBox(
            width: screenWidth * 0.9,
            child: const LabeledTextField(
            label: 'Full Name',
            placeholder: 'Enter your full name',
            readOnly: false
          ),
          ),
          const SizedBox(height: 10,),
          SizedBox(
            width: screenWidth * 0.9,
            child: const LabeledTextField(
            label: 'Email',
            placeholder: 'Enter email',
            readOnly: true
          ),
          ),
          const SizedBox(height: 10,),
          SizedBox(
            width: screenWidth * 0.9,
            child: const LabeledTextField(
            label: 'Phone Number',
            placeholder: 'Enter phone',
            readOnly: true
          ),
          ),
          const SizedBox(height: 10,),
          SizedBox(
            width: screenWidth * 0.9,
            child: const LabeledTextField(
            label: 'Location',
            placeholder: 'Enter location',
            readOnly: true
          ),
          ),
          const SizedBox(height: 20,),
          SizedBox(
            width: screenWidth * 0.9,
            height: 70,
            child: CustomBtn(
            text: 'Save', 
            onPressed: (){print('button pressed!');}
            ),
          ),
        ],),
      ),
    );
  }
}