import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    double progress = 0.7; // 70% progress for example

    return Card(
      color: const Color.fromARGB(255, 249, 249, 252),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey, // Color of the border
          width: 1, // Width of the border
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 135,
              // height: 30,
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Color.fromARGB(255, 120, 82, 174),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Steps',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8.0,
                    backgroundColor: Color.fromARGB(255, 230, 230, 250),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 120, 82, 174)),
                  ),
                ),
                const Column(
                  children: [
                    Text(
                      '561',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Text(
                      'steps',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 120, 82, 174),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
