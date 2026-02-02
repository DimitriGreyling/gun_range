import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RangeDetailWeb extends ConsumerStatefulWidget {
  final String? rangeId;
  const RangeDetailWeb({super.key, this.rangeId});

  @override
  ConsumerState<RangeDetailWeb> createState() => _RangeDetailWebState();
}

class _RangeDetailWebState extends ConsumerState<RangeDetailWeb> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

      ],
    );
  }
}
