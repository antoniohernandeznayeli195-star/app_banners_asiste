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

  Future<String?> uploadImageOnly(String imagePath) async {
    try {
      String fileName = imagePath.split('/').last;

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath, filename: fileName),
      });

      final response = await _apiService.postRequest(
        Constants.post, 
        formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data['imageUrl'] != null) {
          return response.data['imageUrl'].toString();
        } else {
          throw Exception('El servidor no devolvió la URL de la imagen.');
        }
      }

      throw Exception('Error del servidor: Código ${response.statusCode}');
    } catch (e) {
      if (e is DioException) {
        throw Exception('Error de red: ${e.message}');
      }
      throw Exception('Fallo inesperado: ${e.toString()}');
    }
  }

  Future<bool> saveFullBanner(BannerModel banner) async {
    try {
      final response = await _apiService.postRequest("/save", {
        'Title': banner.title,
        'ImageUrl': banner.imageUrl,
        'GoToItemURL': banner.url,
        'GoToItemOpenExternal': banner.openExternal.toString(),
        'Body': banner.body,
        'CreatedId': banner.createdId,
        'GoToItemTitle': banner.goToTitle,
        'GoToItemTargetPageFlutter': banner.targetPageFlutter,
      });
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeBanner(String title) async {
    try {
      final response = await _apiService.getRequest(
        "/delete",
        params: {'title': title},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
