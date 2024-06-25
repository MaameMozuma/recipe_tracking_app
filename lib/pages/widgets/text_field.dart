import 'package:flutter/material.dart';

class LabeledTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final bool readOnly;

  const LabeledTextField({super.key, 
    required this.label,
    required this.placeholder,
    required this.readOnly,
  });

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.placeholder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 5.0,),
        TextField(
          readOnly: widget.readOnly,
          controller: _controller,
          onChanged: (value) {
            _controller.text = value;
          },
          style: TextStyle(
            color: widget.readOnly ? Colors.grey : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: widget.placeholder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color.fromRGBO(120, 82, 174, 1.0))
            ),
            enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color.fromRGBO(120, 82, 174, 1.0)), // Enabled border color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color.fromRGBO(120, 82, 174, 1.0), width: 2.0), // Focused border color and width
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.red, width: 2.0), // Error border color and width
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color.fromRGBO(120, 82, 174, 1.0), width: 0.0), // Focused border color and width
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          ),
        ),
        const SizedBox(height: 10.0,)
      ],
    );
  }

  String getText() {
    return _controller.text;
  }
}