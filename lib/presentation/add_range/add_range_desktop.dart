import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/presentation/widgets/image_picker.dart';

class AddRangeDesktop extends ConsumerStatefulWidget {
  const AddRangeDesktop({super.key});

  @override
  ConsumerState<AddRangeDesktop> createState() => _AddRangeDesktopState();
}

class _AddRangeDesktopState extends ConsumerState<AddRangeDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Text('Add Range Desktop View'),
          ImagePickerWidget(),
        ],
      ),
    );
  }
}
