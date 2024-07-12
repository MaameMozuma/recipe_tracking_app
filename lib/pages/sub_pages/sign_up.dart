import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/sub_pages/login.dart';
import 'package:team_proj_leanne/pages/widgets/form_buttons.dart';
import 'package:team_proj_leanne/pages/widgets/form_field.dart';
import 'package:team_proj_leanne/services/add_user.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  SignupPageState createState() {
    return SignupPageState();
  }
}

class SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final myUsernameController = TextEditingController();
  final myHeightController = TextEditingController();
  final myWeightController = TextEditingController();
  final myDOBController = TextEditingController();
  final myEmailController = TextEditingController();
  final myPasswordController = TextEditingController();
  final myConfirmPasswordController = TextEditingController();
  final myPhoneNumController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myUsernameController.dispose();
    myEmailController.dispose();
    myPasswordController.dispose();
    myConfirmPasswordController.dispose();
    myPhoneNumController.dispose();
    myDOBController.dispose();
    myHeightController.dispose();
    myWeightController.dispose();
    super.dispose();
  }

  Future<bool> submitData() async {
    Future<bool> created = addUser(
      myUsernameController.text,
      myEmailController.text,
      myPasswordController.text,
      myHeightController.text,
      myWeightController.text,
      myDOBController.text,
      myPhoneNumController.text,
    );
    return created;
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
              Navigator.of(context).pop();
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
                  "Sign Up Now",
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
                                  ObscureDetail: false)),
                          Padding(
                              padding: EdgeInsets.all(pageHeight * 0.02),
                              child: SignUpFormField(
                                FontColor: Color.fromRGBO(173, 172, 172, 1),
                                FontSize: 15,
                                Width: pageWidth * 0.87,
                                Height: pageHeight * 0.07,
                                Placeholder: 'Email',
                                Controller: myEmailController,
                                ObscureDetail: false,
                              )),
                          Padding(
                            padding: EdgeInsets.all(pageHeight * 0.02),
                            child: SignUpFormField(
                                FontColor: Color.fromRGBO(173, 172, 172, 1),
                                FontSize: 15,
                                Width: pageWidth * 0.87,
                                Height: pageHeight * 0.07,
                                Placeholder: 'Phone Number',
                                Controller: myPhoneNumController,
                                ObscureDetail: false),
                          ),
                          Padding(
                            padding: EdgeInsets.all(pageHeight * 0.02),
                            child: SignUpFormField(
                                FontColor: Color.fromRGBO(173, 172, 172, 1),
                                FontSize: 15,
                                Width: pageWidth * 0.87,
                                Height: pageHeight * 0.07,
                                Placeholder: 'Height in cm',
                                Controller: myHeightController,
                                ObscureDetail: false),
                          ),
                          Padding(
                            padding: EdgeInsets.all(pageHeight * 0.02),
                            child: SignUpFormField(
                                FontColor: Color.fromRGBO(173, 172, 172, 1),
                                FontSize: 15,
                                Width: pageWidth * 0.87,
                                Height: pageHeight * 0.07,
                                Placeholder: 'Weight in Kg',
                                Controller: myWeightController,
                                ObscureDetail: false),
                          ),
                          Padding(
                            padding: EdgeInsets.all(pageHeight * 0.02),
                            child: SignUpFormField(
                                FontColor: Color.fromRGBO(173, 172, 172, 1),
                                FontSize: 15,
                                Width: pageWidth * 0.87,
                                Height: pageHeight * 0.07,
                                Placeholder: 'DOB',
                                Controller: myDOBController,
                                ObscureDetail: false),
                          ),
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
                          Padding(
                            padding: EdgeInsets.all(pageHeight * 0.02),
                            child: SignUpFormField(
                                FontColor: Color.fromRGBO(173, 172, 172, 1),
                                FontSize: 15,
                                Width: pageWidth * 0.87,
                                Height: pageHeight * 0.07,
                                Placeholder: 'Confirm Password',
                                Controller: myConfirmPasswordController,
                                ObscureDetail: true),
                          ),
                          FormButton(
                              height: pageHeight * 0.09,
                              width: pageWidth * 0.87,
                              content: 'Register',
                              route: LoginPage()),
                          const SizedBox(
                            height: 16,
                          )
                        ]))
              ])
        ]));
  }
}
