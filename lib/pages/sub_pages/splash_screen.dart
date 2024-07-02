import 'dart:async';
import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/sub_pages/landing_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LandingPage())));
  }

  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    final pageWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:
            const BoxDecoration(color: Color.fromRGBO(230, 230, 250, 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: pageHeight * 0.16,
                  width: pageWidth * 0.36,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: null /* add child content here */,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: pageWidth * 0.07,
                              fontWeight: FontWeight.bold),
                          text: 'Nutri'),
                      TextSpan(
                          style: TextStyle(
                              color: const Color.fromRGBO(120, 82, 174, 1),
                              fontSize: pageWidth * 0.07,
                              fontWeight: FontWeight.bold),
                          text: 'Pal'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
