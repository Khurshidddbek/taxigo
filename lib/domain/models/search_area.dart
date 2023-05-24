/// An alternative way to specify the search scope (see ll+spn).
///
/// The boundaries of the search area are specified in
/// the form of geographic coordinates (in the sequence "longitude, latitude")
/// of the lower left and upper right corners of the area.

class SearchArea {
  double lowerLeftLongitude;
  double lowerLeftLatitude;
  double upperRightLongitude;
  double upperRightLatitude;

  SearchArea({
    required this.lowerLeftLongitude,
    required this.lowerLeftLatitude,
    required this.upperRightLongitude,
    required this.upperRightLatitude,
  });
}
