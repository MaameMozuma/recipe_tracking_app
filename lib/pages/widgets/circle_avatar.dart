import 'package:flutter/material.dart';

class MyCircleAvatar extends StatelessWidget {
  final String imageUrl;
  const MyCircleAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0, // The size of the outer container
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 2.0, // Border width
        ),
      ),
      child: ClipOval(
        child: Center(
          child: Container(
            width: 30.0, // Size of the inner image
            height: 30.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              
            ),
            child: Image.network(imageUrl, fit: BoxFit.contain,),
          ),
        ),
      ),
    );
  }
}
