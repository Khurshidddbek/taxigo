class SearchedAddress {
  String name;
  String description;
  String id;
  String address;
  double coordinateLongitude;
  double coordinateLatitude;
  String? categoryClass;
  String? categoryName;

  SearchedAddress({
    required this.name,
    required this.description,
    required this.id,
    required this.address,
    required this.coordinateLongitude,
    required this.coordinateLatitude,
    this.categoryClass,
    this.categoryName,
  });
}
