class BannerModel {
  final String title;
  final String imageUrl;
  final String url;
  final bool openExternal;

  BannerModel({
    required this.title,
    required this.imageUrl,
    required this.url,
    required this.openExternal,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> goToItem = json['GoToItem'] ?? {};
    return BannerModel(
      title: json['Title'] ?? '',
      imageUrl: json['ImageUrl'] ?? '',
      url: goToItem['URL'] ?? 'N/A',
      openExternal: goToItem['OpenExternal'] ?? true,
    );
  }
}