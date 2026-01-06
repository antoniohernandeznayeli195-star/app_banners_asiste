class BannerModel {
  final String title;
  final String imageUrl;
  final String url;
  final bool openExternal;
  final String body;
  final String createdId;
  final String goToTitle;
  final String targetPageFlutter;

  BannerModel({
    required this.title,
    required this.imageUrl,
    required this.url,
    required this.openExternal,
    required this.body,
    required this.createdId,
    required this.goToTitle,
    required this.targetPageFlutter,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> goToItem = json['GoToItem'] ?? {};
    return BannerModel(
      title: json['Title'] ?? '',
      imageUrl: json['ImageUrl'] ?? '',
      body: json['Body'] ?? '',
      createdId: json['Created'] ?? '',
      goToTitle: goToItem['Title'] ?? '',
      url: goToItem['URL'] ?? '',
      targetPageFlutter: goToItem['TargetPageFlutter'] ?? '',
      openExternal: goToItem['OpenExternal'] ?? true,
    );
  }
}