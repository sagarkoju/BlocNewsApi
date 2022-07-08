import 'package:freezed_annotation/freezed_annotation.dart';

part 'article.g.dart';
part 'article.freezed.dart';

@freezed
class ArticleResponse with _$ArticleResponse {
  const factory ArticleResponse({
    @Default(<Article>[]) List<Article> articles,
  }) = _ArticleResponse;

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleResponseFromJson(json);
}

@freezed
class Source with _$Source {
  const factory Source({
    String? id,
    required String name,
  }) = _Source;
  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
}

@freezed
class Article with _$Article {
  const factory Article({
    Source? source,
    String? author,
    required String title,
    String? description,
    required String url,
    String? urlToImage,
    required String publishedAt,
    required String content,
  }) = _Article;
  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
