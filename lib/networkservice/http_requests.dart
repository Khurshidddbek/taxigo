import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HttpRequests {
  static final dio = Dio();

  static Future<String?> get(String api, Map<String, dynamic> params) async {
    try {
      final response = await dio.get(api, queryParameters: params);
      if (response.statusCode == 200) return response.toString();
    } catch (e) {
      // #TODO: something
      debugPrint("HttpRequest.get() error: $e");
      return null;
    }
    return null;
  }
}
