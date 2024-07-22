import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerInput extends StatefulWidget {
  const ImagePickerInput({super.key});

  @override
  _ImagePickerInputState createState() => _ImagePickerInputState();
}

class _ImagePickerInputState extends State<ImagePickerInput> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: _pickImage,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Icons.file_upload),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    _selectedImage != null
                        ? _selectedImage!.path.split('/').last
                        : 'Choose File',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                if (_selectedImage != null)
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: _removeImage,
                  ),
              ],
            ),
          ),
        ),
        if (_selectedImage != null) ...[
          SizedBox(height: 16.0),
          Image.file(_selectedImage!),
        ],
      ],
    );
  }
}
