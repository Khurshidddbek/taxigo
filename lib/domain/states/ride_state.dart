import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxigo/dataprovider/app_data.dart';
import 'package:taxigo/domain/repositories/ride_repository.dart';
import 'package:taxigo/domain/states/profile_state.dart';

class RideState extends ChangeNotifier {
  // API ======================================================================
  Future<bool> createRideRequest(BuildContext context) async {
    try {
      final profileState = context.read<ProfileState>();
      final appState = context.read<AppState>();

      await RideRepository.createRideRequest(
        currentUser: profileState.user!,
        pickup: appState.currentLocation!,
        destination: appState.currentLocation!,
      );

      return true;
    } catch (e) {
      debugPrint("RideState.createRideRequest() error: $e");
      return false;
    }
  }
}
