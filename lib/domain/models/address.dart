class Address {
  double latitude;
  double longitude;
  String? placeName;
  String? placeId;
  String? placeFormattedName;

  Address({
    required this.latitude,
    required this.longitude,
    this.placeName,
    this.placeId,
    this.placeFormattedName,
  });
}

class TashkentLocation extends Address {
  TashkentLocation({
    super.latitude = 41.311081,
    super.longitude = 69.240562,
  });
}
