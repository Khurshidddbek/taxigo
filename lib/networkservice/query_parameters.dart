import 'package:taxigo/domain/models/search_area.dart';
import 'package:taxigo/networkservice/api_keys.dart';

class QueryParameters {
  static Map<String, dynamic> searchPlaceByText({
    required String text,
    SearchArea? searchArea,
  }) =>
      {
        "apikey": ApiKeys.organizationSearchAPIKey,
        "text": text,
        "lang": "en_US",
        if (searchArea != null)
          "bbox":
              "${"${searchArea.lowerLeftLongitude},${searchArea.lowerLeftLatitude}~${searchArea.upperRightLongitude}"},${searchArea.upperRightLatitude}",
      };

  static Map<String, dynamic> directionDetails() => {'geometries': 'polyline'};
}
