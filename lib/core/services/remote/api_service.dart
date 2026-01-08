import 'dart:io';
import 'package:app_banners_asiste/core/constants.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
//import 'package:dio/io.dart';
//import 'package:flutter/foundation.dart';


class ApiService {
  String baseUrl = Constants.apiBaseUrl;

  late final Dio? _dio;

  static final ApiService _singleton = ApiService._internal();

  factory ApiService() {
    return _singleton;
  }

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,

        headers: {'Content-Type': 'application/json'},
      ),
    );

    // 👇 Saltar validación SSL SOLO para desarrollo

    final adapter = IOHttpClientAdapter();

    // if (kDebugMode) {

    adapter.createHttpClient = () {
      final client = HttpClient();

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      return client;
    };

    // }

    _dio?.httpClientAdapter = adapter;

    //_dio?.interceptors.add(AuthInterceptor());

    //_dio?.interceptors.add(DioLoggerInterceptor());

    /*_dio?.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,

        requestBody: true,

        responseBody: true,

        responseHeader: false,

        error: true,

        compact: true,

        maxWidth: 90,

        enabled: kDebugMode,
      ),
    );*/
  }

  Future<Response> getRequest(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    try {
      return await _dio!.get(endpoint, queryParameters: params);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> downloadJson(String url) async {
    try {
      final response = await Dio().get(url);

      return Response(
        requestOptions: RequestOptions(path: url),

        data: response.data,

        statusCode: response.statusCode,

        statusMessage: response.statusMessage,

        headers: response.headers,

        isRedirect: response.isRedirect,

        redirects: response.redirects,

        extra: response.extra,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postRequest(String endpoint, dynamic data) async {
    try {
      return await _dio!.post(endpoint, data: data);
    } catch (e) {
      rethrow;
    }
  }
}
