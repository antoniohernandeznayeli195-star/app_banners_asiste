import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../../domain/models/banner_model.dart';
import '../../core/services/remote/api_service.dart';

class BannerRepositoryImpl {
  static final BannerRepositoryImpl _instance =
      BannerRepositoryImpl._internal();
  factory BannerRepositoryImpl() => _instance;
  BannerRepositoryImpl._internal();

  final ApiService _apiService = ApiService();

  Future<List<BannerModel>> getBanners(String type) async {
    try {
      String blobName = (type == "interno")
          ? Constants.bannerInterno
          : Constants.bannerExterno;

      final response = await _apiService.getRequest(
        "/read/",
        params: {'blobName': blobName},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => BannerModel.fromJson(json)).toList();
      }
      return [];
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

      final response = await _apiService.postRequest(Constants.post, formData);

      if ((response.statusCode == 201 || response.statusCode == 200) &&
          response.data['imageUrl'] != null) {
        return response.data['imageUrl'].toString();
      }
      throw Exception('Error al subir imagen');
    } catch (e) {
      throw Exception('Fallo en la subida: $e');
    }
  }

  Future<bool> putBanners(String blobName, List<BannerModel> banners) async {
    try {
      final List<Map<String, dynamic>> data = banners
          .map((b) => b.toJson())
          .toList();

      final response = await _apiService.putRequest(
        "/update",
        params: {'blobName': blobName},
        data: data,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error al actualizar banners en el servidor: $e');
    }
  }
}
