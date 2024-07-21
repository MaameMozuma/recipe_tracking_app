import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final double height;
  final double width;
  final String content;
  final dynamic route;
  final dynamic action;
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
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
        fixedSize: WidgetStateProperty.all<Size>(
            Size(width, height)), // Button width and height
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.transparent;
            }
            return const Color.fromRGBO(230, 230, 250, 1);
          },
        ),
      ),
      onPressed: () {
        action();
      },
      child: Text(
        content,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
      ),
    );
  }
}
