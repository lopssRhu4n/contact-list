import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioHttpAdapter {
  final _customDio = Dio();
  bool wasInstanciated = false;

  Dio get dio => _customDio;

  DioHttpAdapter() {
    if (!wasInstanciated) {
      try {
        _customDio.options.headers['Content-Type'] = 'Application/json';
        _customDio.options.headers['X-Parse-Application-Id'] =
            dotenv.get('APPLICATION_ID');
        _customDio.options.headers['X-Parse-REST-API-Key'] =
            dotenv.get('REST_API_KEY');
        _customDio.options.baseUrl = dotenv.get('API_BASE_URL');
      } catch (_) {
        debugPrint('Error while loading environment');
        exit(1);
      }
    }
  }
}
