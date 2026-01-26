import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(File? image)? onImagePicked;

  const ImagePickerWidget({Key? key, this.onImagePicked}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      widget.onImagePicked?.call(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _image != null
            ? Image.file(_image!, height: 150)
            : const Icon(Icons.image, size: 150, color: Colors.grey),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_camera),
              label: const Text('Camera'),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ],
    );
  }
}