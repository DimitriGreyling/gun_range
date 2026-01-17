import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/event.dart';
import 'package:gun_range_app/data/repositories/event_repository.dart';
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

  RangeViewModel(this._rangeRepository, this._eventRepository)
      : super(const RangeState());

  Future<void> fetchRanges() async {
    state = state.copyWith(isLoadingRanges: true, error: null);
    await Future.delayed(Duration(seconds: 10));
    try {
      final ranges = await _rangeRepository.getRanges();
      state = state.copyWith(isLoadingRanges: false, ranges: ranges);
    } catch (e) {
      state = state.copyWith(isLoadingRanges: false, error: e.toString());
    }
  }

  Future<void> fetchEvents() async {
    state = state.copyWith(isLoadingEvents: true, error: null);
    await Future.delayed(Duration(seconds: 10));
    try {
      final events = await _eventRepository.getEvents();
      state = state.copyWith(isLoadingEvents: false, events: events);
    } catch (e) {
      state = state.copyWith(isLoadingEvents: false, error: e.toString());
    }
  }

  Future<void> refresh() => fetchRanges();
}
