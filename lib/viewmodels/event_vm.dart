import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/favorite.dart';
import 'package:gun_range_app/data/models/popup_position.dart';
import 'package:gun_range_app/data/repositories/favorite_repository.dart';
import 'package:gun_range_app/domain/services/errors_exception_service.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/repositories/event_repository.dart';
import '../data/models/event.dart';

class EventState {
  final List<Event> events;
  final bool isLoadingEvents;
  final List<Favorite> eventFavorites;
  final String? error;

  const EventState(
      {this.events = const [],
      this.isLoadingEvents = false,
      this.eventFavorites = const [],
      this.error});

  EventState copyWith(
          {List<Event>? events,
          bool? isLoadingEvents,
          List<Favorite>? eventFavorites,
          String? error}) =>
      EventState(
        events: events ?? this.events,
        isLoadingEvents: isLoadingEvents ?? this.isLoadingEvents,
        eventFavorites: eventFavorites ?? this.eventFavorites,
        error: error,
      );
}

class EventViewModel extends StateNotifier<EventState> {
  final EventRepository _eventRepository;
  final FavoriteRepository _favoriteRepository;

  EventViewModel(this._eventRepository, this._favoriteRepository)
      : super(const EventState());

  Future<void> fetchEvents() async {
    state = state.copyWith(isLoadingEvents: true, error: null);
    try {
      final events = await _eventRepository.getEvents();
      final favorites = await fetchUserFavorites(getCurrentUser()?.id ?? '');
      state = state.copyWith(
          isLoadingEvents: false, events: events, eventFavorites: favorites);
    } catch (e) {
      state = state.copyWith(isLoadingEvents: false, error: e.toString());
      ErrorsExceptionService.handleException(e);
    }
  }

  User? getCurrentUser() {
    final supabase = Supabase.instance.client;
    return supabase.auth.currentUser;
  }

  Future<void> refresh() => fetchEvents();

  Future<void> addEventFavorite(String userId, String eventId) async {
    try {
      await _favoriteRepository.addEventFavorite(userId, eventId);
    } catch (e) {
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<void> removeEventFavorite(String userId, String eventId) async {
    try {
      await _favoriteRepository.removeEventFavorite(userId, eventId);
    } catch (e) {
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<List<Favorite>> fetchUserFavorites(String userId) async {
    try {
      final favorites = await _favoriteRepository.getFavoritesByUserId(userId);
      return favorites;
    } catch (e) {
      ErrorsExceptionService.handleException(e);
      return [];
    }
  }

  Future<bool> isEventFavorite(String userId, Event event) async {
    final favorites = await fetchUserFavorites(userId);
    final isFavorite = favorites.any((fav) => fav.eventId == event.id);
    event.nspIsFavorite = isFavorite;
    state = state.copyWith(events: state.events);
    return isFavorite;
  }

  Future<void> toggleFavorite(String userId, Event event) async {
    try {
      final favorites = await fetchUserFavorites(userId);
      final isFavorite = favorites.any((fav) => fav.eventId == event.id);

      if (isFavorite == false) {
        addEventFavorite(userId, event.id!);
        event.nspIsFavorite = true;
        state = state.copyWith(events: state.events);
        return;
      } else {
        removeEventFavorite(userId, event.id!);
        event.nspIsFavorite = false;
        state = state.copyWith(events: state.events);
        return;
      }
    } catch (e) {
      ErrorsExceptionService.handleException(e);
    }
  }
}
