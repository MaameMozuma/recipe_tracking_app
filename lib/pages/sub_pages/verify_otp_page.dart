import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:team_proj_leanne/services/add_user.dart';

import '../widgets/form_buttons.dart';

const Color accentDarkGreenColor = Color(0xFF115C49);
const Color accentYellowColor = Color(0xFFFFB612);
const Color accentOrangeColor = Color(0xFFEA7A3B);

Future<bool> verifyAnOTP(String OTP, String ContactNumber) async {
  Future<bool> verified = verifyOTP(OTP, ContactNumber);
  return verified;
}

class VerifyOTP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    final pageWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Builder(builder: (context) {
            return const Text(
              'VerifyOTP',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            );
          }),
          OtpTextField(
            numberOfFields: 6,
            borderColor: Color(0xFF512DA8),
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Verification Code"),
                      content: Text('Code entered is $verificationCode'),
                    );
                  });
            }, // end onSubmit
          ),
          FormButton(
              height: pageHeight * 0.09,
              width: pageWidth * 0.87,
              content: 'Verify'),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
