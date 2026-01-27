import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/domain/services/errors_exception_service.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';

class FilePickerState {
  bool isLoading;
  List<File> selectedFiles;

  FilePickerState({this.isLoading = false, this.selectedFiles = const []});

  FilePickerState copyWith({
    bool? isLoading,
    List<File>? selectedFiles,
  }) {
    return FilePickerState(
      isLoading: isLoading ?? this.isLoading,
      selectedFiles: selectedFiles ?? this.selectedFiles,
    );
  }
}

class FilePickerVm extends StateNotifier<FilePickerState> {
  FilePickerVm() : super(FilePickerState());

  Future<void> pickImageFiles() async {
    try {
      state = state.copyWith(isLoading: true);
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        File file = File(result.files.single.path!);
  
        state = state.copyWith(
          selectedFiles: [...state.selectedFiles, file],
          isLoading: false,
        );
      }else{
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false,selectedFiles: []);
      ErrorsExceptionService.handleException(e);
    }
  }
}
