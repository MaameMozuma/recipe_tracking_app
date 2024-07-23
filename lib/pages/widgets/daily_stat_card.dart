import 'package:flutter/material.dart';

class DailyStatCard extends StatelessWidget {
  final IconData icon;
  const DailyStatCard({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    double progress = 1;

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
        Icon(
          icon,
          size: 35,
        )
      ],
    );
  }
}
