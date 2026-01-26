import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/viewmodels/add_range_vm.dart';
import 'package:gun_range_app/presentation/widgets/image_picker.dart';

class AddRangeDesktop extends ConsumerWidget {
  const AddRangeDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(addRangeVmProvider);

    return Scaffold(
      body: Column(
        children: [
          Text('Add Range Desktop View'),
          Expanded(
            child: PageView(
              controller: PageController(initialPage: vm.currentPage),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Page 1: Basic Info
                Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Range Name'),
                      onChanged: vm.setRangeName,
                    ),
                    ElevatedButton(
                      onPressed: vm.nextPage,
                      child: const Text('Next'),
                    ),
                  ],
                ),
                // Page 2: Location
                Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Location'),
                      onChanged: vm.setLocation,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: vm.previousPage,
                          child: const Text('Back'),
                        ),
                        ElevatedButton(
                          onPressed: vm.nextPage,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
                // Page 3: Image Picker
                Column(
                  children: [
                    const ImagePickerWidget(),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: vm.previousPage,
                          child: const Text('Back'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Submit logic here
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}