import 'package:taxigo/domain/models/address.dart';

class Apis {
  static const searchPlaceByText = "https://search-maps.yandex.ru/v1/";

  static String directionDetails(Address start, Address end) =>
      "https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}";
}
