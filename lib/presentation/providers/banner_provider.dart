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
  String? _url ;
  String? get url => _url;

  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;

  Future<void> loadBanners(String type) async {
    _isLoading = true;
    notifyListeners();
    _banners = await _repository.getBanners(type);
    _isLoading = false;
    notifyListeners();
  }

    uploadTempImage(String path) async {
    _isLoading = true;
    notifyListeners();
    try {
      final imageUrl = await _repository.uploadImageOnly(path);
      _isLoading = false;
      notifyListeners();
      return imageUrl;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e.toString());
      rethrow;
    }
    
  }

  Future<void> confirmAddBanner(BannerModel banner, {int? index}) async {
    _isLoading = true;
    notifyListeners();

    if (index != null && index <= _banners.length) {
      _banners.insert(index, banner);
    } else {
      _banners.add(banner);
    }

    final success = await _repository.saveFullBanner(banner);
    
    if (success) {
      await loadBanners("interno");
    }
    _isLoading = false;
    notifyListeners();
  }

  void reorderBanners(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final item = _banners.removeAt(oldIndex);
    _banners.insert(newIndex, item);
    notifyListeners();
  }

  Future<void> removeBanner(BannerModel banner) async {
    final success = await _repository.removeBanner(banner.title);
    if (success) {
      _banners.remove(banner);
      notifyListeners();
    }
  }

  void updateBanner(BannerModel oldBanner, BannerModel newBanner) {
    final index = _banners.indexOf(oldBanner);
    if (index != -1) {
      _banners[index] = newBanner;
      notifyListeners();
    }
  }
}