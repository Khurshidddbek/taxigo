import 'package:flutter/material.dart';
import 'package:taxigo/datamodels/address.dart';

class AppData extends ChangeNotifier {
  Address? currentLocation;

  void updateCurrentLocation(Address location) {
    currentLocation = location;
    notifyListeners();
  }
}
