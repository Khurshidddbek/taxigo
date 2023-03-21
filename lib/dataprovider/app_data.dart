import 'package:flutter/material.dart';
import 'package:taxigo/datamodels/address.dart';
import 'package:taxigo/datamodels/search_area.dart';

class AppData extends ChangeNotifier {
  Address? currentLocation;
  SearchArea? searchArea;

  void updateCurrentLocation(Address location) {
    currentLocation = location;
    notifyListeners();
  }

  void updateSearchArea(SearchArea newSearchArea) {
    searchArea = newSearchArea;
    notifyListeners();
  }
}
