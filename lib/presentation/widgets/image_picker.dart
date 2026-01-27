import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/providers/file_picker_provider.dart';

class ImagePickerWidget extends ConsumerStatefulWidget {
  final void Function(File? image)? onImagePicked;

  const ImagePickerWidget({super.key, this.onImagePicked});

  @override
  ConsumerState<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends ConsumerState<ImagePickerWidget> {
  // File? _image;
  // bool _isLoading = false;



  @override
  Widget build(BuildContext context) {
    //VIEWMODEL LOGIC HERE
    final viewModel = ref.watch(filePickerProvider.notifier);
    final state = ref.watch(filePickerProvider);

    return Column(
      children: [
        if (state.isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          )
        else
          state.selectedFiles.isNotEmpty
              ? Image.file(state.selectedFiles.first, height: 150)
              : const Icon(Icons.image, size: 150, color: Colors.grey),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_camera),
              label: const Text('Camera'),
              onPressed: state.isLoading ? null : state.isLoading ? null : viewModel.pickImageFiles,
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
              onPressed: state.isLoading ? null : state.isLoading ? null : viewModel.pickImageFiles,
            ),
          ],
        ),
      ],
    );
  }
}