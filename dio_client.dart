import 'package:dio/dio.dart';
import 'package:dio/io.dart'; // For IOHttpClientAdapter
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io' show HttpClient;

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio();

    // Only apply certificate override on non-web platforms
    if (!kIsWeb) {
      dio.httpClientAdapter = IOHttpClientAdapter()
        ..createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        };
    }
  }
}
