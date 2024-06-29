import 'package:flutter/material.dart';

class DailyStatCard extends StatelessWidget {
  const DailyStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    double progress = 0.7;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: const Color.fromARGB(255, 230, 230, 250),
            valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 120, 82, 174)),
          ),
        ),
        Icon(Icons.fire_extinguisher, size: 35,)
      ],
    );
  }
}
