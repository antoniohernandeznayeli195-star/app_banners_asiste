class BannerModel {
  final String title;
  final String imageUrl;

  BannerModel({required this.title, required this.imageUrl});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      title: json['Title'] != null && json['Title'].toString().isNotEmpty 
          ? json['Title'] 
          : (json['GoToItem'] != null ? json['GoToItem']['Title'] : 'Sin título'),
      imageUrl: json['ImageUrl'] ?? '',
    );
  }
}