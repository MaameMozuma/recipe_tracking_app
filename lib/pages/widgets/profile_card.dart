import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 190,
      child: Card(
        color: const Color.fromARGB(255, 249, 249, 252),
        elevation: 5,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.grey, // Color of the border
            width: 1, // Width of the border
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assist_walker),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Total Calories', style: TextStyle(fontSize: 15),)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '500',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                    ),
                    TextSpan(
                      text: ' steps',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
