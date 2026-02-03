import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/event.dart';
import 'package:gun_range_app/data/models/favorite.dart';
import 'package:gun_range_app/data/models/popup_position.dart';
import 'package:gun_range_app/data/repositories/favorite_repository.dart';
import 'package:gun_range_app/data/repositories/photo_repository.dart';
import 'package:gun_range_app/domain/services/errors_exception_service.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/range.dart';
import '../data/repositories/range_repository.dart';

class RangeState {
  final List<Range> ranges;
  final bool isLoadingRanges;
  final List<Favorite> rangeFavorites;

  final String? error;

  const RangeState({
    this.ranges = const [],
    this.isLoadingRanges = false,
    this.rangeFavorites = const [],
    this.error,
  });

  RangeState copyWith({
    List<Range>? ranges,
    List<Event>? events,
    bool? isLoadingRanges,
    bool? isLoadingEvents,
    List<Favorite>? favorites,
    String? error,
  }) {
    return RangeState(
      ranges: ranges ?? this.ranges,
      isLoadingRanges: isLoadingRanges ?? this.isLoadingRanges,
      error: error,
      rangeFavorites: favorites ?? this.rangeFavorites,
    );
  }
}

class RangeViewModel extends StateNotifier<RangeState> {
  final RangeRepository _rangeRepository;
  final FavoriteRepository _favoriteRepository;
  final PhotoRepository _photoRepository;

  RangeViewModel(
      this._rangeRepository, this._favoriteRepository, this._photoRepository)
      : super(const RangeState());

  Future<void> fetchRanges() async {
    state = state.copyWith(isLoadingRanges: true, error: null);
    try {
      final ranges = await _rangeRepository.getRanges();
      final favorites = await fetchUserFavorites(getCurrentUser()?.id ?? '');

      state = state.copyWith(
          isLoadingRanges: false, ranges: ranges, favorites: favorites);
    } catch (e) {
      state = state.copyWith(isLoadingRanges: false, error: e.toString());
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<void> refresh() => fetchRanges();

  Future<void> addRangeFavorite(String userId, String rangeId) async {
    try {
      await _favoriteRepository.addRangeFavorite(userId, rangeId);
    } catch (e) {
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<void> removeRangeFavorite(String userId, String rangeId) async {
    try {
      await _favoriteRepository.removeRangeFavorite(userId, rangeId);
    } catch (e) {
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<List<Favorite>> fetchUserFavorites(String userId) async {
    try {
      if (userId.isEmpty || userId == '') return [];

      final favorites = await _favoriteRepository.getFavoritesByUserId(userId);
      return favorites;
    } catch (e) {
      ErrorsExceptionService.handleException(e);
      return [];
    }
  }

  Future<bool> isRangeFavorite(String userId, Range range) async {
    final favorites = await fetchUserFavorites(userId);
    final isFavorite = favorites.any((fav) => fav.rangeId == range.id);
    range.nspIsFavorite = isFavorite;
    // state = state.copyWith(ranges: state.ranges);

    return isFavorite;
  }

  Future<void> toggleFavorite(String userId, Range range) async {
    try {
      final favorites = await fetchUserFavorites(userId);
      final isFavorite = favorites.any((fav) => fav.rangeId == range.id);

      if (isFavorite == false) {
        addRangeFavorite(userId, range.id!);
        range.nspIsFavorite = true;
        state = state.copyWith(ranges: state.ranges);
        return;
      } else {
        removeRangeFavorite(userId, range.id!);
        range.nspIsFavorite = false;
        state = state.copyWith(ranges: state.ranges);
        return;
      }
    } catch (e) {
      ErrorsExceptionService.handleException(e);
    }
  }

  User? getCurrentUser() {
    final supabase = Supabase.instance.client;
    return supabase.auth.currentUser;
  }

  Future<void> getRangeDetails(String rangeId) async {
    try {
      final rangeDetails = await _rangeRepository.getRangeById(rangeId);

      if (rangeDetails == null) {
        throw Exception('Range not found');
      }

      final photos = _photoRepository.getPhotoUrlsByRangeId(rangeId);

      rangeDetails.nspPhotoUrls = await photos;
    } catch (e) {
      ErrorsExceptionService.handleException(e);
    }
  }
}
