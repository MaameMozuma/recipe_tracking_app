import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/sub_pages/login.dart';
import 'package:team_proj_leanne/pages/sub_pages/sign_up.dart';
import 'package:team_proj_leanne/pages/widgets/form_buttons.dart';

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
                                      color: Color.fromRGBO(120, 82, 174, 1),
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
                        FormButton(
                            height: pageHeight * 0.09,
                            width: pageWidth * 0.87,
                            content: 'Log In',
                            route: LoginPage()),
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
                                color: Color.fromRGBO(120, 81, 169, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: pageWidth * 0.05),
                          ),
                        ),
                      ])
                ]))));
  }
}