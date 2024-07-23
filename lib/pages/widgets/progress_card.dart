import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final String mainText;
  final String subText;
  final String type;
  const ProgressCard({super.key, required this.mainText, required this.subText, required this.type});

  @override
  Widget build(BuildContext context) {
    double progress = 1; // 70% progress for example

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
            SizedBox(
              width: 135,
              // height: 30,
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Color.fromARGB(255, 120, 82, 174),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      type,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                    backgroundColor: const Color.fromARGB(255, 230, 230, 250),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 120, 82, 174)),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      mainText,
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    Text(
                      subText.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
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
