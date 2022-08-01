import 'package:hive/hive.dart';
import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';

class HiveAdapter {
  /// Register all hive adapters inside this init function
  static void init() {
    Hive
      ..registerAdapter(ArticleResponseAdapter())
      ..registerAdapter(SourceAdapter())
      ..registerAdapter(ArticleAdapter());
  }
}
