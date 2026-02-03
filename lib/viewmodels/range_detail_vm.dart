import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/data/repositories/range_repository.dart';

class RangeDetailState {
  Range? range;
  bool isLoading;
  String? error;
  RangeDetailState({
    this.range,
    this.isLoading = false,
    this.error,
  });

  RangeDetailState copyWith({
    Range? range,
    bool? isLoading,
    String? error,
  }) {
    return RangeDetailState(
      range: range ?? this.range,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RangeDetailVm  extends StateNotifier<RangeDetailState> {
  final RangeRepository _rangeRepository;

  RangeDetailVm(this._rangeRepository) : super(RangeDetailState());

  Future<Range?> fetchRangeDetail(String rangeId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final range = await _rangeRepository.getRangeById(rangeId);
      state = state.copyWith(isLoading: false, range: range);
      return range;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}
