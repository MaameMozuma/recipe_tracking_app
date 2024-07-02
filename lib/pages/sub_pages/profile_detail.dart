import 'package:flutter/material.dart';

class ProfileDetail extends StatelessWidget {
  final String Maintext;
  final String SummaryText;
  final Icon IconDetails;

  ProfileDetail(
      {required this.Maintext,
      required this.SummaryText,
      required this.IconDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(Maintext,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(child: IconDetails
                    //Icon(Icon, size: 30),
                    ),
                TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    text: SummaryText),
              ],
            ),
          ),
        ]);
  }
}