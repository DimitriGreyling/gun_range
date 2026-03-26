import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gun_range_app/core/constants/general_constants.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/data/repositories/range_repository.dart';
import 'package:gun_range_app/viewmodels/range_vm.dart';
import 'package:location/location.dart';

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

    final result = await rangeRepository.searchRanges(
      activityId: activityId,
      availableDate: availableDate,
      location: location,
    );

    // await getLocationState(result);

    state = state.copyWith(isLoading: false, foundRanges: result);
  }

  Future<String?> getLocationState(Range range) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final currentPosition = await Geolocator.getCurrentPosition();

    final distanceInMeters =
        _getDistanceInMeters(userPosition: currentPosition, range: range);
    final double distanceInKilometers =
        (distanceInMeters ?? 0) / GeneralConstants.metersToKilometers;

    range.nspDistanceInKilometers = distanceInKilometers.ceilToDouble();
  }

  double? _getDistanceInMeters({
    required Position userPosition,
    required Range range,
  }) {
    if (range.latitude == null || range.longitude == null) {
      return null;
    }

    return Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      range.latitude!,
      range.longitude!,
    );
  }
}
