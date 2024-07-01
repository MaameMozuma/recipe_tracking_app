import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final double height;
  final String title;
  final Color barColor;
  final Color FontColor;
  final double FontSize;
  CustomAppBar({
    required this.height,
    required this.title,
    required this.barColor,
    required this.FontColor,
    required this.FontSize,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Column(
        children: [
          Text('My Profile',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: FontColor,
                  fontSize: FontSize)),
        ],
      ),
      toolbarHeight: height,
      backgroundColor: barColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Navigate back to the previous screen by popping the current route
          Navigator.of(context).pop();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.edit_calendar, color: Colors.black),
          onPressed: () {
            // do something
          },
        )
      ],
    );
  }
}
