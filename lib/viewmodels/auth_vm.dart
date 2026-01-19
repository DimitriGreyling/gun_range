import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/repositories/profile_repository.dart';
import 'package:gun_range_app/domain/services/errors_exception_service.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/repositories/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final String? userId;
  const AuthState({this.isLoading = false, this.error, this.userId});

  AuthState copyWith({bool? isLoading, String? error, String? userId}) =>
      AuthState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
        userId: userId ?? this.userId,
      );
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;
  AuthViewModel(this._authRepository, this._profileRepository)
      : super(const AuthState());

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await signOut();
    try {
      final userId = await _authRepository.signIn(email, password);

      if (userId != null) {
        final profileInformation = await _profileRepository.getMyProfile();
        log('User profile loaded: ${profileInformation.toString()}');
      }

      state = state.copyWith(isLoading: false, userId: userId);
    } catch (e) {
      log('Sign in error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<void> register(
      String email, String password, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userId = await _authRepository.register(email, password, data);

      if (isJsonDecodable(userId)) {
        log('Registered user ID is not valid: $userId');
        throw Exception(userId);
      }

      state = state.copyWith(isLoading: false, userId: userId);
    } catch (e) {
      log('Registration error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = const AuthState();
  }

  bool isJsonDecodable(String input) {
    try {
      jsonDecode(input); // returns dynamic
      return true;
    } on FormatException {
      return false;
    }
  }
}
