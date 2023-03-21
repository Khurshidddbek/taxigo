import 'dart:convert';

import 'package:taxigo/datamodels/searched_address.dart';

class Parser {
  static List<SearchedAddress> searchPlaceByText(String responseBody) {
    final parsed = json.decode(responseBody);
    List<SearchedAddress> searchedLocations = [];
    for (var feature in parsed['features']) {
      SearchedAddress searchedLocation = SearchedAddress(
          name: feature['properties']['name'],
          description: feature['properties']['description'],
          id: feature['properties']['CompanyMetaData']['id'].toString(),
          address: feature['properties']['CompanyMetaData']['address'],
          coordinateLongitude: feature['geometry']['coordinates'][0],
          coordinateLatitude: feature['geometry']['coordinates'][1],
          categoryClass: feature['properties']['CompanyMetaData']['Categories']
              [0]['class'],
          categoryName: feature['properties']['CompanyMetaData']['Categories']
              [0]['name']);
      searchedLocations.add(searchedLocation);
    }
    return searchedLocations;
  }
}
