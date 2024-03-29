class DirectionDetails {
  String encodedPoints;
  double durationInSeconds;
  double distanceInMeters;

  DirectionDetails({
    required this.encodedPoints,
    required this.durationInSeconds,
    required this.distanceInMeters,
  });

  double get distanceInKilometers => distanceInMeters / 1000;
}
