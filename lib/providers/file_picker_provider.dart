import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/viewmodels/file_picker_vm.dart';

final filePickerProvider = StateNotifierProvider<FilePickerVm, FilePickerState>(
   (ref) => FilePickerVm(),
 );