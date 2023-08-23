import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:taxigo/domain/models/search_area.dart';

class QueryParameters {
  static Map<String, dynamic> searchPlaceByText({
    required String text,
    SearchArea? searchArea,
  }) =>
      {
        "apikey": dotenv.env['ORG_SEARCH_API_KEY']!,
        "text": text,
        "lang": "en_US",
        if (searchArea != null)
          "bbox":
              "${"${searchArea.lowerLeftLongitude},${searchArea.lowerLeftLatitude}~${searchArea.upperRightLongitude}"},${searchArea.upperRightLatitude}",
      };

  static Map<String, dynamic> directionDetails() => {'geometries': 'polyline'};
}
