import 'package:flutter/material.dart';
import '../../domain/models/banner_model.dart';
import '../../data/repositories_impletation/banner_repository_implemetation.dart';
import '../../core/constants.dart';
import '../../core/services/remote/api_service.dart';

class BannerProvider extends ChangeNotifier {
  static final BannerProvider _instance = BannerProvider._internal();
  factory BannerProvider() => _instance;
  BannerProvider._internal();

  final _repository = BannerRepositoryImpl();
  final _apiService = ApiService();

  List<BannerModel> _banners = [];
  bool _isLoading = false;
  String _currentType = "interno";

  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadBanners(String type) async {
    _setLoading(true);
    _currentType = type;
    _banners = await _repository.getBanners(type);
    _setLoading(false);
  }

  Future<void> saveBannersToApi() async {
    _setLoading(true);
    try {
      final List<Map<String, dynamic>> data = _banners
          .map((b) => b.toJson())
          .toList();
      final String blobPath = (_currentType == "interno")
          ? Constants.bannerInterno
          : Constants.bannerExterno;

      await _apiService.putRequest(
        "/update",
        params: {'blobName': blobPath},
        data: data,
      );
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> confirmAddBanner(BannerModel banner, {int? index}) async {
    if (index != null && index <= _banners.length) {
      _banners.insert(index, banner);
    } else {
      _banners.add(banner);
    }
    notifyListeners();
    await saveBannersToApi();
  }

  Future<void> updateBanner(
    BannerModel oldBanner,
    BannerModel newBanner,
  ) async {
    final index = _banners.indexOf(oldBanner);
    if (index != -1) {
      _banners[index] = newBanner;
      notifyListeners();
      await saveBannersToApi();
    }
  }

  Future<void> removeBanner(BannerModel banner) async {
    _banners.remove(banner);
    notifyListeners();
    await saveBannersToApi();
  }

  void reorderBanners(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex -= 1;
    final item = _banners.removeAt(oldIndex);
    _banners.insert(newIndex, item);
    notifyListeners();
    await saveBannersToApi();
  }

  Future<String?> uploadTempImage(String path) async {
    return await _repository.uploadImageOnly(path);
  }
}
