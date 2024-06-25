import 'package:flutter/material.dart';
import 'dart:io';

class HeaderWidget extends StatelessWidget {
  final File? profileImage;
  final VoidCallback onPickImage;

  const HeaderWidget({super.key,
  required this.profileImage,
  required this.onPickImage
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(230, 230, 250, 1.0),
      padding: const EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
                onPressed: (){
                Navigator.pop(context);
                }, icon: const Icon(Icons.arrow_back, color: Colors.black)
              ),
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
                    width: 100, // Adjust based on CircleAvatar radius
                    height: 100, // Adjust based on CircleAvatar radius
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromRGBO(230, 230, 250, 1.0), // Border color
                        width: 8.0, // Border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color.fromRGBO(237, 234, 234, 1.0),
                      backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                      child: profileImage == null
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
                child: ElevatedButton(onPressed: onPickImage,
                child: const Text('Change Profile Picture',
                style: TextStyle(color: Colors.black),)))
            ],
          ),
          ),
        ],
      ),
    );
  }
}