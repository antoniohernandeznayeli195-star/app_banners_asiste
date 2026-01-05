import 'package:flutter/material.dart';
import '../../domain/models/banner_model.dart';
import '../../data/repositories_impletation/banner_repository_implemetation.dart';

class BannerProvider extends ChangeNotifier {
  static final BannerProvider _instance = BannerProvider._internal();
  factory BannerProvider() => _instance;
  BannerProvider._internal();

  final _repository = BannerRepositoryImpl();
  List<BannerModel> _banners = [];
  bool _isLoading = false;

  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;

  Future<void> loadBanners(String type) async {
    _isLoading = true;
    notifyListeners();
    _banners = await _repository.getBanners(type);
    _isLoading = false;
    notifyListeners();
  }

  void addBannerCustom({
    required String title,
    required String path,
    required String url,
    required bool external,
  }) {
    _banners.insert(0, BannerModel(
      title: title,
      imageUrl: path,
      url: url,
      openExternal: external,
    ));
    notifyListeners();
  }

  void reorderBanners(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final item = _banners.removeAt(oldIndex);
    _banners.insert(newIndex, item);
    notifyListeners();
  }

  void removeBanner(BannerModel banner) {
    _banners.remove(banner);
    notifyListeners();
  }

  void updateBanner(BannerModel oldBanner, BannerModel newBanner) {
    final index = _banners.indexOf(oldBanner);
    if (index != -1) {
      _banners[index] = newBanner;
      notifyListeners();
    }
  }
}