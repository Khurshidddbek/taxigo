import 'package:flutter/material.dart';
import 'package:taxigo/datamodels/address.dart';
import 'package:taxigo/datamodels/search_area.dart';

class AppData extends ChangeNotifier {
  Address? currentLocation;
  Address? searchedLocation;
  SearchArea? searchArea;

  void updateCurrentLocation(Address location) {
    currentLocation = location;
    notifyListeners();
  }

  void updateSearchArea(SearchArea newSearchArea) {
    searchArea = newSearchArea;
    notifyListeners();
  }

  void updateSearchedLocation(Address location) {
    searchedLocation = location;
    notifyListeners();
  }
}
