import 'dart:convert';
//import 'package:app_banners_asiste/domain/models/banner_model.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/banner_model.dart';

class BannerRepositoryImpl {
  static final BannerRepositoryImpl _instance = BannerRepositoryImpl._internal();
  factory BannerRepositoryImpl() => _instance;
  BannerRepositoryImpl._internal();

  final String _apiUrl = "https://pushapipmx.azurewebsites.net/api/blob-json";

  Future<List<BannerModel>> getBanners(String blobName) async {
    try {
      blobName = "content/menu/news.qa.json";
      final response = await http.get(Uri.parse("$_apiUrl/read/?blobName=$blobName"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => BannerModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      return [];
    }
  }
}