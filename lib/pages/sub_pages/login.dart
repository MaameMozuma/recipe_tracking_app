import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/widgets/custom_bottom_nav_bar.dart';
import 'package:team_proj_leanne/pages/widgets/form_buttons.dart';
import 'package:team_proj_leanne/pages/widgets/form_field.dart';
import 'package:team_proj_leanne/services/login_user.dart';

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

  Future<bool> submitData() async {
    Future<bool> status =
        loginUser(myUsernameController.text, myPasswordController.text);
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    final pageWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the previous screen by popping the current route
              Navigator.pop(context);
            },
          ),
        ),
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
                  child: null /* add child content here */,
                ),
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
                            child: SignUpFormField(
                                FontColor: Color.fromRGBO(173, 172, 172, 1),
                                FontSize: 15,
                                Width: pageWidth * 0.87,
                                Height: pageHeight * 0.07,
                                Placeholder: 'Password',
                                Controller: myPasswordController,
                                ObscureDetail: true),
                          ),
                          FormButton(
                              height: pageHeight * 0.09,
                              width: pageWidth * 0.87,
                              content: 'Log In',
                              route: const customBottomNavigationBar(
                                  initialPageIndex: 0)),
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
                                    style: TextStyle(
                                        color: Color.fromRGBO(120, 82, 174, 1),
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
