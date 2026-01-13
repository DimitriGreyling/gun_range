import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final String? userId;
  const AuthState({this.isLoading = false, this.error, this.userId});

  AuthState copyWith({bool? isLoading, String? error, String? userId}) => AuthState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
        userId: userId ?? this.userId,
      );
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  AuthViewModel(this._authRepository) : super(const AuthState());

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userId = await _authRepository.signIn(email, password);
      state = state.copyWith(isLoading: false, userId: userId);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = const AuthState();
  }
}
