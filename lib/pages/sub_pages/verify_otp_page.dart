import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:team_proj_leanne/pages/sub_pages/login.dart';
import 'package:team_proj_leanne/services/add_user.dart';

const Color accentDarkGreenColor = Color(0xFF115C49);
const Color accentYellowColor = Color(0xFFFFB612);
const Color accentOrangeColor = Color(0xFFEA7A3B);

// Future<bool> verifyAnOTP(
//   String OTP,
//   String ContactNumber,
// ) async {
//   bool verified = await verifyOTP(OTP, ContactNumber);
//   return verified;
// }

class VerifyOTPPage extends StatelessWidget {
  final String ContactNumber;
  final String username;
  final String height;
  final String weight;
  final String dob;
  final String email;
  final String password;

  VerifyOTPPage(
      {required this.ContactNumber,
      required this.username,
      required this.height,
      required this.weight,
      required this.dob,
      required this.email,
      required this.password});

  // Future<bool> submitData() async {
  //   bool created = await addUser(
  //       username, email, '233$ContactNumber', password, height, weight, dob);
  //   return created;
  // }

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
              'Enter the OTP We Sent You',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            );
          }),
          OtpTextField(
            numberOfFields: 6,
            borderColor: const Color(0xFF512DA8),
            showFieldAsBox: true,
            onCodeChanged: (String code) {},
            onSubmit: (String verificationCode) async {
              bool status = await verifyOTP(verificationCode, ContactNumber);
              if (status) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Verified'),
                    duration: Duration(seconds: 2),
                  ),
                );
                bool created = await addUser(username, email,
                    '233$ContactNumber', password, height, weight, dob);
                if (created) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                } else {
                  showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text('Could not submit data'),
                        );
                      });
                }
              } else {
                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text('Wrong OTP'),
                      );
                    });
              }
            }, // end onSubmit
          ),
          ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
              fixedSize: WidgetStateProperty.all<Size>(Size(
                pageWidth * 0.87,
                pageHeight * 0.09,
              )), // Button width and height
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.transparent;
                  }
                  return const Color.fromRGBO(230, 230, 250, 1);
                },
              ),
            ),
            onPressed: () async {
              bool confirmation = await sendOTP(ContactNumber);
              if (confirmation) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('OTP Resent'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text(
              'Resend OTP',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
