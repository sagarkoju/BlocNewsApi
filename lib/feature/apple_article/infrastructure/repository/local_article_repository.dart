import 'package:hive/hive.dart';
import 'package:newsapi/app_setup/hive/hive_box.dart';
import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';

abstract class ILocalArticleRepository {
  Future<void> cacheArticle({required ArticleResponse articleResponse});
  Future<ArticleResponse?> getArticle();
  Future<void> cacheArticleForTopHeadlineGermany(
      {required ArticleResponse articleResponse});
  Future<ArticleResponse?> getArticleForTopHeadlineGermany();
  Future<void> cacheArticleForTopHeadlineUs(
      {required ArticleResponse articleResponse});
  Future<ArticleResponse?> getArticleForTopHeadlineUs();
  Future<void> cacheArticleForCategory(
      {required ArticleResponse articleResponse});
  Future<ArticleResponse?> getArticleForCategory();
}

class LocalHomeRepository implements ILocalArticleRepository {
  @override
  Future<void> cacheArticle({required ArticleResponse articleResponse}) async {
    final popularArticleHiveBox =
        await Hive.openLazyBox<ArticleResponse>(HiveBox.getResponseNewsBox);
    popularArticleHiveBox.put('popularArticle', articleResponse);
  }

  @override
  Future<ArticleResponse?> getArticle() async {
    try {
      final popularArticleHiveBox =
          await Hive.openLazyBox<ArticleResponse>(HiveBox.getResponseNewsBox);

      final data = popularArticleHiveBox.isNotEmpty
          ? await popularArticleHiveBox.get('popularArticle')
          : null;

      return data;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheArticleForTopHeadlineGermany(
      {required ArticleResponse articleResponse}) async {
    final popularArticleHiveBox =
        await Hive.openLazyBox<ArticleResponse>(HiveBox.getResponseNewsBox);
    popularArticleHiveBox.put('popularArticleForGermany', articleResponse);
  }

  @override
  Future<void> cacheArticleForTopHeadlineUs(
      {required ArticleResponse articleResponse}) async {
    final popularArticleHiveBox =
        await Hive.openLazyBox<ArticleResponse>(HiveBox.getResponseNewsBox);
    popularArticleHiveBox.put('popularArticleForUS', articleResponse);
  }

  @override
  Future<ArticleResponse?> getArticleForTopHeadlineGermany() async {
    try {
      final popularArticleHiveBox =
          await Hive.openLazyBox<ArticleResponse>(HiveBox.getResponseNewsBox);

      final data = popularArticleHiveBox.isNotEmpty
          ? await popularArticleHiveBox.get('popularArticleForGermany')
          : null;

      return data;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ArticleResponse?> getArticleForTopHeadlineUs() async {
    try {
      final popularArticleHiveBox =
          await Hive.openLazyBox<ArticleResponse>(HiveBox.getResponseNewsBox);

      final data = popularArticleHiveBox.isNotEmpty
          ? await popularArticleHiveBox.get('popularArticleForUS')
          : null;

      return data;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheArticleForCategory(
      {required ArticleResponse articleResponse}) async {
    final popularArticleHiveBox =
        await Hive.openLazyBox<ArticleResponse>(HiveBox.getResponseNewsBox);
    popularArticleHiveBox.put('popularArticleForCategory', articleResponse);
  }

  @override
  Future<ArticleResponse?> getArticleForCategory() async {
    try {
      final popularArticleHiveBox =
          await Hive.openLazyBox<ArticleResponse>(HiveBox.getResponseNewsBox);

      final data = popularArticleHiveBox.isNotEmpty
          ? await popularArticleHiveBox.get('popularArticleForCategory')
          : null;

      return data;
    } catch (e) {
      return null;
    }
  }
}
