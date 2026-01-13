import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/range_repository.dart';
import '../data/models/range.dart';

class RangeState {
  final List<Range> ranges;
  final bool isLoading;
  final String? error;
  const RangeState({this.ranges = const [], this.isLoading = false, this.error});

  RangeState copyWith({List<Range>? ranges, bool? isLoading, String? error}) => RangeState(
        ranges: ranges ?? this.ranges,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class RangeViewModel extends StateNotifier<RangeState> {
  final RangeRepository _rangeRepository;
  RangeViewModel(this._rangeRepository) : super(const RangeState());

  Future<void> fetchRanges() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final ranges = await _rangeRepository.getRanges();
      state = state.copyWith(isLoading: false, ranges: ranges);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
