import 'package:app_banners_asiste/domain/repositories/banner_repository.dart';
import '../../domain/models/banner_model.dart';


class BannerRepositoryImpl implements BannerRepository {
  BannerRepositoryImpl._internal();
  static final BannerRepositoryImpl _instance = BannerRepositoryImpl._internal();
  factory BannerRepositoryImpl() => _instance;

  @override
  Future<List<BannerModel>> getBanners(String type) async {
    if (type == "interno") {
      final List<Map<String, dynamic>> internoJson = [
        {
          "Title": "Banner Actualización de contraseña",
          "ImageUrl": "https://pmxsstastdgmnh001.blob.core.windows.net/asiste/content/noticias/contrasen%CC%83a_app%20asiste-banner.jpg",
        },
        {
          "Title": "Login Asiste",
          "ImageUrl": "https://pmxsstastdgmnh001.blob.core.windows.net/asiste/content/noticias/BannerContrasena.jpg",
        },
        {
          "Title": "Banner atención personas jubiladas",
          "ImageUrl": "https://pmxsstastdgmnh001.blob.core.windows.net/asiste/content/noticias/Banner-App-Pemex-ASISTE-2023.jpg",
        }
      ];
      return internoJson.map((e) => BannerModel.fromJson(e)).toList();
    } else {
      final List<Map<String, dynamic>> externoJson = [
        {
          "Title": "Banner Declaración Anual 2025",
          "ImageUrl": "https://pmxsstastdgmnh001.blob.core.windows.net/asiste/content/noticias/V2-Dec-Anual-2025.jpg",
        },
        {
          "Title": "Banner Inclusión y Derechos Humanos",
          "ImageUrl": "https://pmxsstastdgmnh001.blob.core.windows.net/asiste/content/noticias/Banner-app-Asiste-Inclusio%CC%81n-y-Derechos-Humanos.jpg",
        },
        {
          "Title": "Banner CFDI",
          "ImageUrl": "https://pmxsstastdgmnh001.blob.core.windows.net/asiste/content/noticias/BienestarPetrolero.jpg",
        },
        {
          "Title": "Banner-Pemex Cumple-Conflicto de intereses",
          "ImageUrl": "https://pmxsstastdgmnh001.blob.core.windows.net/asiste/content/noticias/PC25-Conflicto-Interes-Banner.jpg",
        }
      ];
      return externoJson.map((e) => BannerModel.fromJson(e)).toList();
    }
  }
}