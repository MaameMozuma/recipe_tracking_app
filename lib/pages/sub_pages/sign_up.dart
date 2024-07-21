import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_proj_leanne/pages/sub_pages/verify_otp_page.dart';
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
  bool _isEmailValid = false;
  final _formKey = GlobalKey<FormState>();
  final myUsernameController = TextEditingController();
  final myHeightController = TextEditingController();
  final myWeightController = TextEditingController();
  final myEmailController = TextEditingController();
  final myPasswordController = TextEditingController();
  final myConfirmPasswordController = TextEditingController();
  final myPhoneNumController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void dispose() {
    myUsernameController.dispose();
    myEmailController.dispose();
    myPasswordController.dispose();
    myConfirmPasswordController.dispose();
    myPhoneNumController.dispose();
    myHeightController.dispose();
    myWeightController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<bool> submitData() async {
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text("Verification Code"),
    //         content: Text('Code entered is $verificationCode'),
    //       );
    //     });
    Future<bool> created = addUser(
      myUsernameController.text,
      myEmailController.text,
      myPasswordController.text,
      myHeightController.text,
      myWeightController.text,
      '233${myPhoneNumController.text}',
      dateController.text,
    );
    return created;
  }

  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    final pageWidth = MediaQuery.of(context).size.width;
    supportedLocales:
    const [Locale("gh")];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
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
                    child: null),
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
                      color: const Color.fromRGBO(173, 172, 172, 1)),
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
                                  Validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field can not be empty';
                                    }
                                    return null;
                                  },
                                  FontColor:
                                      const Color.fromRGBO(173, 172, 172, 1),
                                  FontSize: 15,
                                  Width: pageWidth * 0.87,
                                  Height: pageHeight * 0.07,
                                  Placeholder: 'Username',
                                  Controller: myUsernameController,
                                  ObscureDetail: false)),
                          Padding(
                              padding: EdgeInsets.all(pageHeight * 0.02),
                              child: SizedBox(
                                  width: pageWidth * 0.87,
                                  height: pageHeight * 0.07,
                                  child: TextFormField(
                                    controller: myEmailController,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color:
                                            Color.fromRGBO(173, 172, 172, 1)),
                                    decoration: InputDecoration(
                                        errorText: _isEmailValid
                                            ? null
                                            : 'Enter a valid email address',
                                        hintText: 'Email Address',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color.fromRGBO(
                                                    120, 82, 174, 1))),
                                        fillColor: Colors.transparent),
                                    onChanged: (value) {
                                      setState(() {
                                        _isEmailValid =
                                            EmailValidator.validate(value);
                                      });
                                    },
                                  ))),
                          Padding(
                              padding: EdgeInsets.all(pageHeight * 0.02),
                              child: SizedBox(
                                  width: pageWidth * 0.87,
                                  height: pageHeight * 0.07,
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field can not be empty';
                                        }
                                        return null;
                                      },
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromRGBO(173, 172, 172, 1)),
                                      controller:
                                          dateController, //editing controller of this TextField
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      120, 82, 174, 1))),
                                          icon: const Icon(Icons.calendar_today,
                                              color: Color.fromRGBO(
                                                  120, 82, 174, 1)),
                                          hintText: "Select Date of Birth"),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime(2000),
                                                firstDate: DateTime(1920),
                                                lastDate: DateTime(2004));
                                        if (pickedDate != null) {
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          setState(() {
                                            dateController.text = formattedDate;
                                          });
                                        } else {
                                          print("Date is not selected");
                                        }
                                      }))),
                          Padding(
                              padding: EdgeInsets.all(pageHeight * 0.02),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: pageWidth * 0.275,
                                      height: pageHeight * 0.07,
                                      child: const CountryCodePicker(
                                        onChanged: print,
                                        hideMainText: true,
                                        showFlagMain: true,
                                        showFlag: false,
                                        initialSelection: 'GH',
                                        hideSearch: true,
                                        showCountryOnly: true,
                                        showOnlyCountryWhenClosed: true,
                                        alignLeft: true,
                                      ),
                                    ),
                                    SignUpFormFieldNumber(
                                        FontColor: const Color.fromRGBO(
                                            173, 172, 172, 1),
                                        FontSize: 15,
                                        Width: pageWidth * 0.54,
                                        Height: pageHeight * 0.07,
                                        Placeholder:
                                            'e.g 22245678901, (omit first zero)',
                                        Controller: myPhoneNumController,
                                        ObscureDetail: false)
                                  ])),
                          Padding(
                              padding: EdgeInsets.all(pageHeight * 0.02),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SignUpFormFieldNumber(
                                        FontColor: const Color.fromRGBO(
                                            173, 172, 172, 1),
                                        FontSize: 15,
                                        Width: pageWidth * 0.40,
                                        Height: pageHeight * 0.07,
                                        Placeholder: 'Height in cm',
                                        Controller: myHeightController,
                                        ObscureDetail: false),
                                    SignUpFormFieldNumber(
                                        FontColor: const Color.fromRGBO(
                                            173, 172, 172, 1),
                                        FontSize: 15,
                                        Width: pageWidth * 0.40,
                                        Height: pageHeight * 0.07,
                                        Placeholder: 'Weight in Kg',
                                        Controller: myWeightController,
                                        ObscureDetail: false),
                                  ])),
                          Padding(
                            padding: EdgeInsets.all(pageHeight * 0.02),
                            child: SignUpFormField(
                                FontColor:
                                    const Color.fromRGBO(173, 172, 172, 1),
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
                                Validator: (value) {
                                  if (myPasswordController.text !=
                                      myConfirmPasswordController.text) {
                                    return 'Passwords Do not Match';
                                  }
                                  return null;
                                },
                                FontColor:
                                    const Color.fromRGBO(173, 172, 172, 1),
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
                            action: _formKey.currentState != null &&
                                    _formKey.currentState!.validate()
                                ? () async {
                                    if (await submitData() == true) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VerifyOTP()),
                                      );
                                    }
                                  }
                                : null,
                          ),
                          const SizedBox(
                            height: 16,
                          )
                        ]))
              ])
        ]));
  }
}
