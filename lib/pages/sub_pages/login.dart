import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/sub_pages/sign_up.dart';
import 'package:team_proj_leanne/pages/widgets/form_field.dart';
import 'package:team_proj_leanne/services/login_user.dart';

import '../widgets/custom_bottom_nav_bar.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final myUsernameController = TextEditingController();
  final myPasswordController = TextEditingController();

  @override
  void dispose() {
    myUsernameController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }

  // Future<bool> submitData() async {
  //   return await loginUser(
  //       myUsernameController.text, myPasswordController.text);
  // }

  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    final pageWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: ListView(children: [
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                height: pageHeight * 0.16,
                width: pageWidth * 0.36,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.contain,
                  ),
                ),
                child: null),
            // Image.asset(
            //   "assets/images/logo.png",
            // ),
            Text(
              "Let’s Sign You In",
              style: TextStyle(
                fontSize: pageWidth * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Please enter your details",
              style: TextStyle(
                  fontSize: pageWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(173, 172, 172, 1)),
            ),
            Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(pageHeight * 0.02),
                          child: SignUpFormField(
                            FontColor: Color.fromRGBO(173, 172, 172, 1),
                            FontSize: 15,
                            Width: pageWidth * 0.87,
                            Height: pageHeight * 0.07,
                            Placeholder: 'Username',
                            Controller: myUsernameController,
                            ObscureDetail: false,
                          )),
                      Padding(
                        padding: EdgeInsets.all(pageHeight * 0.02),
                        child: SignUpFormFieldPassword(
                          FontColor: const Color.fromRGBO(173, 172, 172, 1),
                          FontSize: 15,
                          Width: pageWidth * 0.87,
                          Height: pageHeight * 0.07,
                          Placeholder: 'Password',
                          Controller: myPasswordController,
                        ),
                      ),
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
                        onPressed: () async {
                          bool success = await loginUser(
                              myUsernameController.text,
                              myPasswordController.text);
                          if (success) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const customBottomNavigationBar(
                                            initialPageIndex: 0)));
                          } else {
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                      content: Text("Login Failed"));
                                });
                          }
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: pageWidth * 0.05,
                                    fontWeight: FontWeight.bold),
                                text: "Don't Have an account yet? "),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignupPage()),
                                      ),
                                style: TextStyle(
                                    color:
                                        const Color.fromRGBO(120, 82, 174, 1),
                                    fontSize: pageWidth * 0.05,
                                    fontWeight: FontWeight.bold),
                                text: 'Sign Up'),
                          ],
                        ),
                      ),
                    ]))
          ])
    ]));
  }
}
