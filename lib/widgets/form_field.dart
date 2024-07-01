import 'package:flutter/material.dart';

class SignUpFormField extends StatelessWidget {
  final String Placeholder;
  final TextEditingController Controller;
  final bool ObscureDetail;
  final double Height;
  final double Width;
  final double FontSize;
  final Color FontColor;
  SignUpFormField(
      {required this.Placeholder,
      required this.Controller,
      required this.ObscureDetail,
      required this.Height,
      required this.Width,
      required this.FontSize,
      required this.FontColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Width,
        height: Height,
        child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(fontSize: FontSize, color: FontColor),
            obscureText: ObscureDetail,
            decoration: InputDecoration(
                hintText: Placeholder,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(120, 82, 174, 1))),
                fillColor: Colors.transparent)));
  }
}
