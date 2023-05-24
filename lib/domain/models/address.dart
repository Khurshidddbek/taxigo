// ignore_for_file: public_member_api_docs, sort_constructors_first

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'placeName': placeName,
      'placeId': placeId,
      'placeFormattedName': placeFormattedName,
    };
  }
}

class TashkentLocation extends Address {
  TashkentLocation({
    super.latitude = 41.311081,
    super.longitude = 69.240562,
  });
}
