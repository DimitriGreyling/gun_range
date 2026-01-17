import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuExpandedController extends Notifier<bool> {
  @override
  bool build() => true; // start expanded

  void toggle() => state = !state;
  void expand() => state = true;
  void collapse() => state = false;
}

final menuExpandedProvider =
    NotifierProvider<MenuExpandedController, bool>(MenuExpandedController.new);