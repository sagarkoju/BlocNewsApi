import 'package:hive/hive.dart';
import 'package:newsapi/app_setup/hive/hive_box.dart';
import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';

abstract class ILocalArticleRepository {
  Future<void> cacheArticle({required ArticleResponse articleResponse});
  Future<ArticleResponse?> getArticle();
}

class LocalHomeRepository implements ILocalArticleRepository {
  @override
  Future<void> cacheArticle({required ArticleResponse articleResponse}) async {
    final popularArticleHiveBox =
        await Hive.openLazyBox<ArticleResponse>(HiveBox.getResponseNewsBox);
    popularArticleHiveBox.put('popularMovies', articleResponse);
  }

  @override
  Future<ArticleResponse?> getArticle() async {
    try {
      final popularArticleHiveBox =
          await Hive.openLazyBox<ArticleResponse>(HiveBox.getResponseNewsBox);

      final data = popularArticleHiveBox.isNotEmpty
          ? await popularArticleHiveBox.get('popularMovies')
          : null;

      return data;
    } catch (e) {
      return null;
    }
  }
}
