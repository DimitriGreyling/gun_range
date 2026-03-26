import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopBarState {
  const TopBarState({
    this.isMobileMenuOpen = false,
    this.isSearchOpen = false,
  });

  final bool isMobileMenuOpen;
  final bool isSearchOpen;

  TopBarState copyWith({
    bool? isMobileMenuOpen,
    bool? isSearchOpen,
  }) {
    return TopBarState(
      isMobileMenuOpen: isMobileMenuOpen ?? this.isMobileMenuOpen,
      isSearchOpen: isSearchOpen ?? this.isSearchOpen,
    );
  }
}


class TopBarViewModel extends StateNotifier<TopBarState> {
  TopBarViewModel() : super(const TopBarState());

  void toggleMobileMenu() {
    state = state.copyWith(
      isMobileMenuOpen: !state.isMobileMenuOpen,
    );
  }

  void closeMobileMenu() {
    state = state.copyWith(isMobileMenuOpen: false);
  }

  void toggleSearch() {
    state = state.copyWith(
      isSearchOpen: !state.isSearchOpen,
    );
  }

  void closeSearch() {
    state = state.copyWith(isSearchOpen: false);
  }
}