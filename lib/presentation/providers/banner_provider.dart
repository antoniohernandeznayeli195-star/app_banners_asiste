import 'package:app_banners_asiste/data/repositories_impletation/banner_repository_implemetation.dart';
import 'package:app_banners_asiste/domain/models/banner_model.dart';
import 'package:flutter/material.dart';

class BannerProvider extends ChangeNotifier {
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

  void addBanner(String title, String path) {
    _banners.insert(0, BannerModel(title: title, imageUrl: path));
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
}