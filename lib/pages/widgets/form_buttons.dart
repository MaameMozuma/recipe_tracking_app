import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final double height;
  final double width;
  final String content;
  final Widget? route;
  final VoidCallback? action;

  FormButton({
    required this.height,
    required this.width,
    required this.content,
    this.route,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
        fixedSize: MaterialStateProperty.all<Size>(
            Size(width, height)), // Button width and height
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.transparent;
            }
            return const Color.fromRGBO(230, 230, 250, 1);
          },
        ),
      ),
      onPressed: () {
        if (action != null) {
          action!();
        } 
        else if (route != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => route!),
          );
        }
      },
      child: Text(
        content,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
      ),
    );
  }
}
