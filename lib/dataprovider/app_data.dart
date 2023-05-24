import 'package:flutter/material.dart';
import 'package:taxigo/domain/models/address.dart';
import 'package:taxigo/domain/models/search_area.dart';

class AppState extends ChangeNotifier {
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
