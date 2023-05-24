import 'package:firebase_database/firebase_database.dart';
import 'package:taxigo/domain/models/address.dart';
import 'package:taxigo/domain/models/user.dart';

class RideRepository {
  static Future<void> createRideRequest({
    required User currentUser,
    required Address pickup,
    required Address destination,
  }) async {
    final ref = FirebaseDatabase.instance.ref().child('rideRequest').push();

    final rideParams = {
      "created_at": DateTime.now().toUtc().toString(),
      "rider_name": currentUser.fullName,
      "rider_phone": currentUser.phone,
      "pickup_address": pickup.toMap(),
      "destination_address": destination.toMap(),
    };

    await ref.set(rideParams);
  }
}
