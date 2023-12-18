import 'package:equatable/equatable.dart';
import 'package:smat_crow/utils2/constants.dart';

class NewsEntity extends Equatable {
  final String? source;
  final String? title;
  final String? subtitle;
  final String? url;
  final String? time;
  final String? imageUrl;
  final String? category;

  const NewsEntity({
    this.source,
    this.title,
    this.subtitle,
    this.time,
    this.url,
    this.imageUrl,
    this.category,
  });

  factory NewsEntity.fromJson(Map<String, dynamic> json) {
    return NewsEntity(
      source: json[NewsConst.source],
      title: json[NewsConst.title],
      url: json[NewsConst.url],
      imageUrl: json[NewsConst.imageUrl],
      category: json[NewsConst.category],
    );
  }

  @override
  List<Object?> get props => [source, title, url, imageUrl, category];
}
