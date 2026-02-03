import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/paged_items.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/data/models/review.dart';
import 'package:gun_range_app/data/repositories/range_repository.dart';
import 'package:gun_range_app/data/repositories/review_repository.dart';

class RangeDetailState {
  Range? range;
  bool isLoading;
  bool isLoadingReviews;
  String? error;
  PagedItems? reviews;

  RangeDetailState({
    this.range,
    this.isLoading = false,
    this.isLoadingReviews = false,
    this.error,
    this.reviews,
  });

  RangeDetailState copyWith({
    Range? range,
    bool? isLoading,
    bool? isLoadingReviews,
    String? error,
    PagedItems? reviews,
  }) {
    return RangeDetailState(
      range: range ?? this.range,
      isLoading: isLoading ?? this.isLoading,
      isLoadingReviews: isLoadingReviews ?? this.isLoadingReviews,
      error: error,
      reviews: reviews ?? this.reviews,
    );
  }
}

class RangeDetailVm extends StateNotifier<RangeDetailState> {
  final RangeRepository _rangeRepository;
  final ReviewRepository _reviewRepository;

  RangeDetailVm(this._rangeRepository, this._reviewRepository)
      : super(RangeDetailState());

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

  Future<PagedItems?> fetchReviews({
    required String rangeId,
    required int page,
    int pageSize = 10,
  }) async {
    state = state.copyWith(isLoadingReviews: true, error: null);
    try {
      final reviews = await _reviewRepository.getReviewsByRangeId(
        rangeId: rangeId,
        page: page,
        pageSize: pageSize,
      );
      state = state.copyWith(isLoadingReviews: false, reviews: reviews);
      return reviews;
    } catch (e) {
      state = state.copyWith(isLoadingReviews: false, error: e.toString());
      rethrow;
    }
  }
}
