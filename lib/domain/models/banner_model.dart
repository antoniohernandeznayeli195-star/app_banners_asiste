class BannerModel {
  final String title;
  final String imageUrl;
  final String identifier;
  final bool openExternal;
  final String url;

  BannerModel({
    required this.title,
    required this.imageUrl,
    required this.identifier,
    required this.openExternal,
    required this.url,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    final goToItem = json['GoToItem'] ?? {};
    return BannerModel(
      title: json['Title'] != null && json['Title'].toString().isNotEmpty 
          ? json['Title'] 
          : (goToItem['Title'] ?? 'Sin título'),
      imageUrl: json['ImageUrl'] ?? '',
      identifier: goToItem['Identifier'] ?? 'N/A',
      openExternal: goToItem['OpenExternal'] ?? false,
      url: goToItem['URL'] ?? 'N/A',
    );
  }
}