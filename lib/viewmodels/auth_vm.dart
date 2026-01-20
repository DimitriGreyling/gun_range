import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/data/models/popup_position.dart';
import 'package:gun_range_app/data/repositories/profile_repository.dart';
import 'package:gun_range_app/domain/services/errors_exception_service.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/repositories/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final String? userId;
  final String? userFullName;

  const AuthState(
      {this.isLoading = false, this.error, this.userId, this.userFullName});

  AuthState copyWith(
          {bool? isLoading,
          String? error,
          String? userId,
          String? userFullName}) =>
      AuthState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
        userId: userId ?? this.userId,
        userFullName: userFullName ?? this.userFullName,
      );
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;
  AuthViewModel(this._authRepository, this._profileRepository)
      : super(const AuthState());

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      if (_authRepository.supabase.auth.currentUser != null) {
        await signOut();
      }
      final userId = await _authRepository.signIn(email, password);

      String? fullName;

      final profileInformation = await _profileRepository.getMyProfile();
      if (profileInformation != null) {
        fullName = profileInformation.fullName;
      }

      log('User profile loaded: $profileInformation');

      if (fullName != null) {
        GlobalPopupService.showSuccess(
          title: 'Login Successful',
          message:
              'Hi there, $fullName! Welcome back.',
          position: PopupPosition.bottomRight,
        );
      } else {
        GlobalPopupService.showSuccess(
          title: 'Login Successful',
          message: 'You have been logged in successfully.',
          position: PopupPosition.bottomRight,
        );
      }

      GoRouter.of(context).go('/home');

      state = state.copyWith(
          isLoading: false, userId: userId, userFullName: fullName);
    } catch (e) {
      log('Sign in error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<void> register(
      String email, String password, Map<String, dynamic> data) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final userId = await _authRepository.register(email, password, data);

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
