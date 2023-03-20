import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxigo/datamodels/address.dart' as address;
import 'package:taxigo/domains/app_location.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

class LocationService implements AppLocation {
  final defLocation = address.TashkentLocation();
  final YandexGeocoder geocoder =
      YandexGeocoder(apiKey: "4f514936-fdfb-45af-8450-126838bdc0c9");

  @override
  Future<bool> checkPermission() {
    return Geolocator.checkPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((e) {
      debugPrint("LocationService.requestPermission() Error: $e");
      return false;
    });
  }

  @override
  Future<address.Address> getCurrentLocation() async {
    return Geolocator.getCurrentPosition().then((value) {
      return address.Address(
          latitude: value.latitude, longitude: value.longitude);
    }).catchError((e) {
      debugPrint("LocationService.getCurrentLocation() Error: $e");
      return address.TashkentLocation();
    });
  }

  @override
  Future<bool> requestPermission() {
    return Geolocator.requestPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((e) {
      debugPrint("LocationService.requestPermission() Error: $e");
      return false;
    });
  }

  @override
  Future<GeocodeResponse?> getAddressByCordinates(
      address.Address location) async {
    try {
      final GeocodeResponse geocodeFromPoint =
          await geocoder.getGeocode(GeocodeRequest(
        geocode: PointGeocode(
          latitude: location.latitude,
          longitude: location.longitude,
        ),
        lang: Lang.enEn,
      ));
      return geocodeFromPoint;
    } catch (e) {
      debugPrint("LocationService.getAddressByCordinates() Error: $e");
      return null;
    }
  }
}
