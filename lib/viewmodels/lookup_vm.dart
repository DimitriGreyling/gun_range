import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/v2/lookup_model.dart';
import 'package:gun_range_app/data/repositories/lookup_repository.dart';

class LookupState {
  final bool isLoading;
  final List<LookupModel>? lookups;

  const LookupState({this.isLoading = false, this.lookups});

  LookupState copyWith({
    bool? isLoading,
    List<LookupModel>? lookups,
  }) =>
      LookupState(
        isLoading: isLoading ?? this.isLoading,
        lookups: lookups ?? this.lookups,
      );
}

class LookupVm extends StateNotifier<LookupState> {
  final LookupRepository _lookupRepository;

  LookupVm(this._lookupRepository) : super(const LookupState());

  Future<void> getLookupsByListValue({
    required String listValue,
  }) async {
    if (state.lookups != null && state.lookups!.isNotEmpty) {
      return;
    }

    state = state.copyWith(isLoading: true);
    final lookups =
        await _lookupRepository.getLookupsByListValue(listvalue: listValue);

    state = state.copyWith(isLoading: false, lookups: lookups);
  }
}
