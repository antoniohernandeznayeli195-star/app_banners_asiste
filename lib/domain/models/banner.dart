import 'package:app_banners_asiste/domain/models/go_to_item.dart';

class Banner {
  String? title;
  String? caption;
  String? body;
  String? created;
  String? backgroundColor;
  double? backgroundHeight;
  String? imageUrl;
  double? imageWidth;
  double? imageHeight;
  String? imageHorizontalOptions;
  String? imageVerticalOptions;
  String? imageAspect;
  GoToItem? goToItem;
  String? goToSection;

  bool? isVideo;
  String? videoUrl;

  Banner(
      {this.title,
        this.caption,
        this.body,
        this.created,
        this.backgroundColor,
        this.backgroundHeight,
        this.imageUrl,
        this.imageWidth,
        this.imageHeight,
        this.imageHorizontalOptions,
        this.imageVerticalOptions,
        this.imageAspect,
        this.goToItem,
        this.isVideo,
        this.videoUrl,
        this.goToSection});

  Banner.fromJson(Map<String, dynamic> json) {

    title = json['Title'];
    caption = json['Caption'];
    body = json['Body'];
    created = json['Created'];
    backgroundColor = json['BackgroundColor'];
    backgroundHeight = json['BackgroundHeight'];
    imageUrl = json['ImageUrl'];
    imageWidth = json['ImageWidth'];
    imageHeight = json['ImageHeight'];
    imageHorizontalOptions = json['ImageHorizontalOptions'];
    imageVerticalOptions = json['ImageVerticalOptions'];
    imageAspect = json['ImageAspect'];
    goToItem = json['GoToItem'] != null
        ? GoToItem.fromJson(json['GoToItem'])
        : null;
    isVideo = json['IsVideo'];
    videoUrl = json['VideoUrl'];
    goToSection = json['GoToSection'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['Caption'] = this.caption;
    data['Body'] = this.body;
    data['Created'] = this.created;
    data['BackgroundColor'] = this.backgroundColor;
    data['BackgroundHeight'] = this.backgroundHeight;
    data['ImageUrl'] = this.imageUrl;
    data['ImageWidth'] = this.imageWidth;
    data['ImageHeight'] = this.imageHeight;
    data['ImageHorizontalOptions'] = this.imageHorizontalOptions;
    data['ImageVerticalOptions'] = this.imageVerticalOptions;
    data['ImageAspect'] = this.imageAspect;
    if (this.goToItem != null) {
      data['GoToItem'] = this.goToItem!.toJson();
    }
    data['IsVideo'] = this.isVideo;
    data['VideoUrl'] = this.videoUrl;
    data['GoToSection'] = this.goToSection;
    return data;
  }
}