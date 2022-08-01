import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:newsapi/app_setup/hive/hive_box.dart';

part 'article.g.dart';
part 'article.freezed.dart';

@freezed
@HiveType(typeId: HiveBox.getResponseNewsBoxId)
class ArticleResponse with _$ArticleResponse {
  const factory ArticleResponse({
    @HiveField(0) @Default(<Article>[]) List<Article> articles,
  }) = _ArticleResponse;

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleResponseFromJson(json);
}

@freezed
@HiveType(typeId: HiveBox.getSourceBoxId)
class Source with _$Source {
  const factory Source({
    @HiveField(0) String? id,
    @HiveField(1) required String name,
  }) = _Source;
  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
}

@freezed
@HiveType(typeId: HiveBox.getNewsBoxId)
class Article with _$Article {
  const factory Article({
    @HiveField(0) Source? source,
    @HiveField(1) String? author,
    @HiveField(2) required String title,
    @HiveField(3) String? description,
    @HiveField(4) required String url,
    @HiveField(5) String? urlToImage,
    @HiveField(6) required String publishedAt,
    @HiveField(7) String? content,
  }) = _Article;
  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
