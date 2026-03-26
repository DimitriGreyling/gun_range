import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/data/repositories/range_repository.dart';
import 'package:gun_range_app/viewmodels/range_vm.dart';

class RangesState {
  final bool? isLoading;
  final List<Range>? foundRanges;

  RangesState({
    this.isLoading = false,
    this.foundRanges,
  });

  RangesState copyWith({
    bool? isLoading,
    List<Range>? foundRanges,
  }) =>
      RangesState(
        foundRanges: foundRanges ?? this.foundRanges,
        isLoading: isLoading ?? this.isLoading,
      );
}

class RangesVm extends StateNotifier<RangesState> {
  final RangeRepository rangeRepository;

  RangesVm({
    required this.rangeRepository,
  }) : super(RangesState());

  Future<void> searchRanges({
    String? activityId,
    String? location,
    DateTime? availableDate,
  }) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(Duration(seconds: 10));
    final result = await rangeRepository.searchRanges(
      activityId: activityId,
      availableDate: availableDate,
      location: location,
    );

    state = state.copyWith(isLoading: false, foundRanges: result);
  }
}
