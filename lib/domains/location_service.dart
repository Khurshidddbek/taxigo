import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxigo/domain/models/address.dart' as address;
import 'package:taxigo/domain/models/direction_details.dart';
import 'package:taxigo/domains/app_location.dart';
import 'package:taxigo/networkservice/apis.dart';
import 'package:taxigo/networkservice/http_requests.dart';
import 'package:taxigo/networkservice/query_parameters.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

class LocationService implements AppLocation {
  final defLocation = address.TashkentLocation();
  final YandexGeocoder geocoder =
      YandexGeocoder(apiKey: dotenv.env['YANDEX_GEOCODER_API_KEY']!);

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

  @override
  Future<DirectionDetails?> getDirectionDetails(
      address.Address start, address.Address end) async {
    try {
      final response = await HttpRequests.get(
        Apis.directionDetails(start, end),
        QueryParameters.directionDetails(),
      );
      final data = jsonDecode(response.toString());

      return DirectionDetails(
        encodedPoints: data['routes'][0]['geometry'],
        durationInSeconds:
            double.parse(data['routes'][0]['duration'].toString()),
        distanceInMeters:
            double.parse(data['routes'][0]['distance'].toString()),
      );
    } catch (e) {
      debugPrint("LocationService.getDirectionDetails() Error: $e");
      return null;
    }
  }
}
