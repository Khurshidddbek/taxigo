import 'package:taxigo/datamodels/address.dart' as address;
import 'package:yandex_geocoder/yandex_geocoder.dart';

abstract class AppLocation {
  Future<bool> checkPermission();

  Future<bool> requestPermission();

  Future<address.Address> getCurrentLocation();

  Future<GeocodeResponse?> getAddressByCordinates(address.Address location);
}
