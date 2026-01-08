import 'package:dio/dio.dart';
import 'package:app_banners_asiste/core/constants.dart';
import '../../domain/models/banner_model.dart';
import '../../core/services/remote/api_service.dart';

class BannerRepositoryImpl {
  static final BannerRepositoryImpl _instance =
      BannerRepositoryImpl._internal();
  factory BannerRepositoryImpl() => _instance;
  BannerRepositoryImpl._internal();

  final ApiService _apiService = ApiService();

  Future<List<BannerModel>> getBanners(String blobName) async {
    try {
      if (blobName == "interno") {
        blobName = Constants.bannerInterno;
      } else if (blobName == "externo") {
        blobName = Constants.bannerExterno;
      }

      final response = await _apiService.getRequest(
        "/read/",
        params: {'blobName': blobName},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => BannerModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> uploadBanner({
    required String title,
    required String imagePath,
    required String targetUrl,
    required bool external,
    String bodyText = "",
    String targetPage = "",
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'Title': title,
        'Body': bodyText,
        'Created': DateTime.now().toIso8601String(),
        'GoToItemTitle': title,
        'GoToItemURL': targetUrl,
        'GoToItemOpenExternal': external.toString(),
        'GoToItemTargetPageFlutter': targetPage,
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });

      final response = await _apiService.postRequest("/upload", formData);

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
