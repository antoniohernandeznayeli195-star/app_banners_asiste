import 'package:app_banners_asiste/domain/models/banner_model.dart';

abstract class BannerRepository {
  Future<List<BannerModel>> getBanners(String type);
}