import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/sub_pages/login.dart';
import 'package:team_proj_leanne/pages/sub_pages/sign_up.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    final pageWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
            height: pageHeight,
            width: pageWidth,
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.only(
                    left: 16.0, right: 16.0, top: pageHeight * 0.14),
                child: ListView(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/landing_lady.png",
                            height: pageHeight * 0.42, width: pageWidth * 0.82),
                        SizedBox(height: pageHeight * 0.01),
                        Text(
                          'Your Smart Path to',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: pageWidth * 0.07),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  style: TextStyle(
                                      color:
                                          const Color.fromRGBO(120, 82, 174, 1),
                                      fontSize: pageWidth * 0.07,
                                      fontWeight: FontWeight.bold),
                                  text: 'Healthy '),
                              TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: pageWidth * 0.07,
                                      fontWeight: FontWeight.bold),
                                  text: 'Eating'),
                            ],
                          ),
                        ),
                        SizedBox(height: pageHeight * 0.05),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                            fixedSize: WidgetStateProperty.all<Size>(Size(
                              pageWidth * 0.87,
                              pageHeight * 0.09,
                            )), // Button width and height
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.transparent;
                                }
                                return const Color.fromRGBO(230, 230, 250, 1);
                              },
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: pageHeight * 0.03),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()),
                            );
                          },
                          child: Text(
                            "Register",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: const Color.fromRGBO(120, 81, 169, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: pageWidth * 0.05),
                          ),
                        ),
                      ])
                ]))));
  }
}
