import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomBtn({super.key,
  required this.text,
  required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(230, 230, 250, 1.0),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Adjusted border radius for responsiveness
                  ),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
      ),
    );
  }
}