import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/range.dart';
import '../data/repositories/range_repository.dart';

class RangeState {
  final List<Range> ranges;
  final bool isLoading;
  final String? error;

  const RangeState({
    this.ranges = const [],
    this.isLoading = false,
    this.error,
  });

  RangeState copyWith({
    List<Range>? ranges,
    bool? isLoading,
    String? error,
  }) {
    return RangeState(
      ranges: ranges ?? this.ranges,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RangeViewModel extends StateNotifier<RangeState> {
  final RangeRepository _rangeRepository;

  RangeViewModel(this._rangeRepository) : super(const RangeState());

  Future<void> fetchRanges() async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(Duration(seconds: 10));
    try {
      final ranges = await _rangeRepository.getRanges();
      state = state.copyWith(isLoading: false, ranges: ranges);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() => fetchRanges();
}
