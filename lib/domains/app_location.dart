import 'package:taxigo/domains/app_lat_long.dart';

abstract class AppLocation {
  Future<bool> checkPermission();

  Future<bool> requestPermission();

  Future<AppLatLong> getCurrentLocation();

  Future<String> getAddressByCordinates(AppLatLong location);
}
