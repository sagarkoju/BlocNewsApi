// ignore_for_file: unnecessary_string_interpolations

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:newsapi/app_setup/app_endpoint/app_endpoint.dart';
import 'package:newsapi/core/theme/failure.dart';
import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/local_article_repository.dart';

abstract class IArticleRepository {
  //get the list of article of apple All articles mentioning Apple from yesterday, sorted by popular publishers first
  Future<Either<ArticleResponse, Failure>> getArticle({
    required String q,
    required String sortBy,
    required DateTime from,
    required DateTime to,
    required bool fromRemote,
    CancelToken? cancelToken,
  });
  Future<Either<ArticleResponse, Failure>> topHeadlinesForUs({
    required String country,
    required String category,
    required bool fromRemote,
  });

  Future<Either<ArticleResponse, Failure>> topHeadlinesForGermany({
    required String country,
    required String category,
    required bool fromRemote,
  });
  Future<Either<ArticleResponse, Failure>> topCategory({
    required String country,
    required String categoryName,
  });
  Future<Either<ArticleResponse, Failure>> searchArticle({
    required String q,
    required String sortBy,
    required DateTime from,
    required DateTime to,
  });
}

class ArticleRepository implements IArticleRepository {
  ArticleRepository({
    required this.dio,
    required this.iLocalArticleRepository,
  });
  final Dio dio;
  final ILocalArticleRepository iLocalArticleRepository;
  @override
  Future<Either<ArticleResponse, Failure>> getArticle({
    required String q,
    required String sortBy,
    required DateTime from,
    required DateTime to,
    CancelToken? cancelToken,
    required bool fromRemote,
  }) async {
    try {
      if (fromRemote) {
        final query = {
          'q': q,
          'sortBy': sortBy,
          'from': from,
          'to': to,
          'apiKey': 'ca56a4c0d027426a868d37a343508228',
        };
        final response = await dio.get<Map<String, dynamic>>(
          NewsApi.getNews,
          queryParameters: query,
        );
        final json = Map<String, dynamic>.from(response.data!);
        final result = ArticleResponse.fromJson(json);

        await iLocalArticleRepository.cacheArticle(articleResponse: result);
        return Left(result);
      } else {
        final localDataResponse = await iLocalArticleRepository.getArticle();
        if (localDataResponse != null) {
          return Left(localDataResponse);
        } else {
          final query = {
            'q': q,
            'sortBy': sortBy,
            'from': from,
            'to': to,
            'apiKey': 'ca56a4c0d027426a868d37a343508228',
          };
          final response = await dio.get<Map<String, dynamic>>(
            NewsApi.getNews,
            queryParameters: query,
          );
          final json = Map<String, dynamic>.from(response.data!);
          final result = ArticleResponse.fromJson(json);
          await iLocalArticleRepository.cacheArticle(articleResponse: result);
          return Left(result);
        }
      }
    } on DioError catch (e) {
      return Right(e.toFailure);
    } catch (e) {
      return Right(Failure.fromException());
    }
  }

  @override
  Future<Either<ArticleResponse, Failure>> topHeadlinesForUs({
    required String country,
    required String category,
    required bool fromRemote,
  }) async {
    try {
      if (fromRemote) {
        final query = {
          'country': country,
          'category': category,
          'apiKey': 'ca56a4c0d027426a868d37a343508228',
        };

        final response = await dio.get<Map<String, dynamic>>(
          NewsApi.getTopHeadLinesForUs,
          queryParameters: query,
        );
        final json = Map<String, dynamic>.from(response.data!);
        final result = ArticleResponse.fromJson(json);
        await iLocalArticleRepository.cacheArticleForTopHeadlineUs(
            articleResponse: result);
        return Left(result);
      } else {
        final localDataResponse =
            await iLocalArticleRepository.getArticleForTopHeadlineUs();
        if (localDataResponse != null) {
          return Left(localDataResponse);
        } else {
          final query = {
            'country': country,
            'category': category,
            'apiKey': 'ca56a4c0d027426a868d37a343508228',
          };

          final response = await dio.get<Map<String, dynamic>>(
            NewsApi.getTopHeadLinesForUs,
            queryParameters: query,
          );
          final json = Map<String, dynamic>.from(response.data!);
          final result = ArticleResponse.fromJson(json);
          await iLocalArticleRepository.cacheArticleForTopHeadlineUs(
              articleResponse: result);
          return Left(result);
        }
      }
    } on DioError catch (e) {
      return Right(e.toFailure);
    } catch (e) {
      return Right(Failure.fromException());
    }
  }

  @override
  Future<Either<ArticleResponse, Failure>> topHeadlinesForGermany({
    required String country,
    required String category,
    required bool fromRemote,
  }) async {
    try {
      if (fromRemote) {
        final query = {
          'country': country,
          'category': category,
          'apiKey': 'ca56a4c0d027426a868d37a343508228',
        };

        final response = await dio.get<Map<String, dynamic>>(
          NewsApi.getTopHeadLinesForGermany,
          queryParameters: query,
        );
        final json = Map<String, dynamic>.from(response.data!);

        final result = ArticleResponse.fromJson(json);
        await iLocalArticleRepository.cacheArticleForTopHeadlineGermany(
            articleResponse: result);

        return Left(result);
      } else {
        final localNews =
            await iLocalArticleRepository.getArticleForTopHeadlineGermany();
        if (localNews != null) {
          return Left(localNews);
        } else {
          final query = {
            'country': country,
            'category': category,
            'apiKey': 'ca56a4c0d027426a868d37a343508228',
          };

          final response = await dio.get<Map<String, dynamic>>(
            NewsApi.getTopHeadLinesForGermany,
            queryParameters: query,
          );
          final json = Map<String, dynamic>.from(response.data!);

          final result = ArticleResponse.fromJson(json);
          await iLocalArticleRepository.cacheArticleForTopHeadlineGermany(
              articleResponse: result);

          return Left(result);
        }
      }
    } on DioError catch (e) {
      return Right(e.toFailure);
    } catch (e) {
      return Right(Failure.fromException());
    }
  }

  @override
  Future<Either<ArticleResponse, Failure>> searchArticle(
      {required String q,
      required String sortBy,
      required DateTime from,
      required DateTime to}) async {
    try {
      final query = {
        'q': q,
        'sortBy': sortBy,
        'from': from,
        'to': to,
        'apiKey': 'ca56a4c0d027426a868d37a343508228',
      };

      final response = await dio.get<Map<String, dynamic>>(
        NewsApi.searchNews,
        queryParameters: query,
      );
      final json = Map<String, dynamic>.from(response.data!);
      final result = ArticleResponse.fromJson(json);
      return Left(result);
    } on DioError catch (e) {
      return Right(e.toFailure);
    } catch (e) {
      return Right(Failure.fromException());
    }
  }

  @override
  Future<Either<ArticleResponse, Failure>> topCategory(
      {required String country, required String categoryName}) async {
    try {
      final query = {
        'country': country,
        'category': '$categoryName',
        'apiKey': 'ca56a4c0d027426a868d37a343508228',
      };

      final response = await dio.get<Map<String, dynamic>>(
        NewsApi.getTopCategory,
        queryParameters: query,
      );
      final json = Map<String, dynamic>.from(response.data!);

      final result = ArticleResponse.fromJson(json);

      return Left(result);
    } on DioError catch (e) {
      return Right(e.toFailure);
    } catch (e) {
      return Right(Failure.fromException());
    }
  }
}
