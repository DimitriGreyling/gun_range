import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/event_repository.dart';
import '../data/models/event.dart';

class EventState {
  final List<Event> events;
  final bool isLoading;
  final String? error;
  const EventState({this.events = const [], this.isLoading = false, this.error});

  EventState copyWith({List<Event>? events, bool? isLoading, String? error}) => EventState(
        events: events ?? this.events,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class EventViewModel extends StateNotifier<EventState> {
  final EventRepository _eventRepository;
  EventViewModel(this._eventRepository) : super(const EventState());

  Future<void> fetchEvents() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final events = await _eventRepository.getEvents();
      state = state.copyWith(isLoading: false, events: events);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
