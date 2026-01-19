import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MenuExpandedController extends Notifier<bool> {
  static const _storage = FlutterSecureStorage();
  static const _key = 'menuExpanded';

  @override
  bool build() {
    // Default while we load persisted value
    unawaited(_restore());
    return true;
  }

  Future<void> _restore() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return;
    state = raw == 'true';
  }

  Future<void> _persist() => _storage.write(key: _key, value: '$state');

  void toggle() {
    state = !state;
    unawaited(_persist());
  }

  void expand() {
    state = true;
    unawaited(_persist());
  }

  void collapse() {
    state = false;
    unawaited(_persist());
  }
}

final menuExpandedProvider =
    NotifierProvider<MenuExpandedController, bool>(MenuExpandedController.new);