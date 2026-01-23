import 'dart:io';
import 'package:app_banners_asiste/core/constants.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

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

    final adapter = IOHttpClientAdapter();

    adapter.createHttpClient = () {
      final client = HttpClient();

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      return client;
    };

    _dio?.httpClientAdapter = adapter;
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

  Future<Response> putRequest(
    String endpoint, {
    Map<String, dynamic>? params,
    dynamic data,
  }) async {
    try {
      return await _dio!.put(endpoint, queryParameters: params, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postRequest(String endpoint, dynamic data) async {
    try {
      return await _dio!.post(
        endpoint,
        data: data,
        options: Options(
          contentType: (data is FormData)
              ? 'multipart/form-data'
              : 'application/json',
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> uploadImage(String endpoint, File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });
      return await _dio!.post(endpoint, data: formData);
    } catch (e) {
      rethrow;
    }
  }
}
