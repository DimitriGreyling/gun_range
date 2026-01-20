import 'package:gun_range_app/data/models/popup_position.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorsExceptionService {
  static void handleException(dynamic e) {
    switch (e.runtimeType) {
      case AuthApiException _:
        final authException = e as AuthApiException;
        GlobalPopupService.showError(
          title: 'Authentication Error',
          message: _camelCaseString(authException.message),
          position: PopupPosition.center,
        );
      case PostgrestException _:
        final postgrestException = e as PostgrestException;
        GlobalPopupService.showError(
          title: 'Database Error',
          message: _camelCaseString(postgrestException.message),
          position: PopupPosition.center,
        );
      case Exception:
        GlobalPopupService.showError(
          title: 'Error',
          message: _camelCaseString(e.toString()),
          position: PopupPosition.center,
        );
      case AuthRetryableFetchException _:
        final retryableException = e as AuthRetryableFetchException;
        GlobalPopupService.showError(
          title: 'Network Error',
          message: _camelCaseString(retryableException.message),
          position: PopupPosition.center,
        );
      default:
        GlobalPopupService.showError(
          title: 'Error',
          message: e.toString(),
          position: PopupPosition.center,
        );
    }
  }

  static String _camelCaseString(String input) {
    try {
      return input.split(' ').map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');
    } catch (e) {
      return input;
    }
  }
}
