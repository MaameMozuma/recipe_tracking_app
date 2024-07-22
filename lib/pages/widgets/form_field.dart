import 'package:flutter/material.dart';

class SignUpFormField extends StatelessWidget {
  final String Placeholder;
  final TextEditingController Controller;
  final bool ObscureDetail;
  final double Height;
  final double Width;
  final double FontSize;
  final Color FontColor;
  final dynamic Validator;

  SignUpFormField({
    required this.Placeholder,
    required this.Controller,
    required this.ObscureDetail,
    required this.Height,
    required this.Width,
    required this.FontSize,
    required this.FontColor,
    this.Validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Width,
        height: Height,
        child: TextFormField(
            validator: Validator,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(fontSize: FontSize, color: FontColor),
            obscureText: ObscureDetail,
            decoration: InputDecoration(
                errorStyle: TextStyle(color: Color.fromRGBO(120, 82, 174, 1)),
                hintText: Placeholder,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(120, 82, 174, 1))),
                fillColor: Colors.transparent)));
  }
}

class SignUpFormFieldNumber extends StatelessWidget {
  final String Placeholder;
  final TextEditingController Controller;
  final bool ObscureDetail;
  final double Height;
  final double Width;
  final double FontSize;
  final Color FontColor;

  SignUpFormFieldNumber({
    required this.Placeholder,
    required this.Controller,
    required this.ObscureDetail,
    required this.Height,
    required this.Width,
    required this.FontSize,
    required this.FontColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Width,
        height: Height,
        child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(fontSize: FontSize, color: FontColor),
            obscureText: ObscureDetail,
            decoration: InputDecoration(
                errorStyle: TextStyle(color: Color.fromRGBO(120, 82, 174, 1)),
                hintText: Placeholder,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(120, 82, 174, 1))),
                fillColor: Colors.transparent)));
  }
}

class SignUpFormFieldPassword extends StatefulWidget {
  final String Placeholder;
  final TextEditingController Controller;
  final double Height;
  final double Width;
  final double FontSize;
  final Color FontColor;
  final dynamic Validator;

  SignUpFormFieldPassword(
      {super.key,
      required this.Placeholder,
      required this.Controller,
      required this.Height,
      required this.Width,
      required this.FontSize,
      required this.FontColor,
      this.Validator});

  @override
  State<SignUpFormFieldPassword> createState() =>
      SignUpFormFieldPasswordState();
}

class SignUpFormFieldPasswordState extends State<SignUpFormFieldPassword> {
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.Width,
        height: widget.Height,
        child: TextFormField(
            validator: widget.Validator,
            textAlignVertical: TextAlignVertical.center,
            style:
                TextStyle(fontSize: widget.FontSize, color: widget.FontColor),
            obscureText: _obscureText,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Color.fromRGBO(120, 82, 174, 1)),
                    onPressed: () {
                      _toggle();
                    }),
                errorStyle:
                    const TextStyle(color: Color.fromRGBO(120, 82, 174, 1)),
                hintText: widget.Placeholder,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(120, 82, 174, 1))),
                fillColor: Colors.transparent)));
  }
}
