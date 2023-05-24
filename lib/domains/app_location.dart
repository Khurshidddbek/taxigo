import 'package:taxigo/domain/models/address.dart' as address;
import 'package:taxigo/domain/models/direction_details.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

abstract class AppLocation {
  Future<bool> checkPermission();

  Future<bool> requestPermission();

  Future<address.Address> getCurrentLocation();

  Future<GeocodeResponse?> getAddressByCordinates(address.Address location);

  Future<DirectionDetails?> getDirectionDetails(
      address.Address start, address.Address end);
}
