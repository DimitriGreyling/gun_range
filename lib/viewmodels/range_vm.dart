import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/event.dart';
import 'package:gun_range_app/data/models/favorite.dart';
import 'package:gun_range_app/data/models/popup_position.dart';
import 'package:gun_range_app/data/repositories/event_repository.dart';
import 'package:gun_range_app/data/repositories/favorite_repository.dart';
import 'package:gun_range_app/domain/services/errors_exception_service.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/range.dart';
import '../data/repositories/range_repository.dart';

class RangeState {
  final List<Range> ranges;
  final List<Event> events;
  final bool isLoadingRanges;
  final bool isLoadingEvents;

  final String? error;

  const RangeState({
    this.ranges = const [],
    this.events = const [],
    this.isLoadingRanges = false,
    this.isLoadingEvents = false,
    this.error,
  });

  RangeState copyWith({
    List<Range>? ranges,
    List<Event>? events,
    bool? isLoadingRanges,
    bool? isLoadingEvents,
    String? error,
  }) {
    return RangeState(
      ranges: ranges ?? this.ranges,
      isLoadingRanges: isLoadingRanges ?? this.isLoadingRanges,
      isLoadingEvents: isLoadingEvents ?? this.isLoadingEvents,
      error: error,
      events: events ?? this.events,
    );
  }
}

class RangeViewModel extends StateNotifier<RangeState> {
  final RangeRepository _rangeRepository;
  final EventRepository _eventRepository;
  final FavoriteRepository _favoriteRepository;

  RangeViewModel(
      this._rangeRepository, this._eventRepository, this._favoriteRepository)
      : super(const RangeState());

  Future<void> fetchRanges() async {
    state = state.copyWith(isLoadingRanges: true, error: null);
    try {
      final ranges = await _rangeRepository.getRanges();
      state = state.copyWith(isLoadingRanges: false, ranges: ranges);
    } catch (e) {
      state = state.copyWith(isLoadingRanges: false, error: e.toString());
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<void> fetchEvents() async {
    state = state.copyWith(isLoadingEvents: true, error: null);
    try {
      final events = await _eventRepository.getEvents();
      state = state.copyWith(isLoadingEvents: false, events: events);
    } catch (e) {
      state = state.copyWith(isLoadingEvents: false, error: e.toString());
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<void> refresh() => fetchRanges();

  Future<void> addFavorite(String userId, String rangeId) async {
    try {
      await _favoriteRepository.addFavorite(userId, rangeId);
      GlobalPopupService.showSuccess(
        title: 'Success',
        message: 'Added to favorites',
        position: PopupPosition.bottomRight,
      );

      refresh();
    } catch (e) {
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<void> removeFavorite(String userId, String rangeId) async {
    try {
      await _favoriteRepository.removeFavorite(userId, rangeId);
      GlobalPopupService.showSuccess(
        title: 'Success',
        message: 'Removed from favorites',
        position: PopupPosition.bottomRight,
      );

      refresh();
    } catch (e) {
      ErrorsExceptionService.handleException(e);
    }
  }

  User? getCurrentUser() {
    final supabase = Supabase.instance.client;
    return supabase.auth.currentUser;
  }
}
