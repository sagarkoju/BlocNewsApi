import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:newsapi/app_setup/app_endpoint/app_endpoint.dart';
import 'package:newsapi/core/theme/failure.dart';
import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';

abstract class IArticleRepository {
  //get the list of article of apple All articles mentioning Apple from yesterday, sorted by popular publishers first
  Future<Either<ArticleResponse, Failure>> getArticle({
    required String q,
    required String sortBy,
    required String from,
    required String to,
  });
  // Future<Either<ArticleResponse, Failure>> topHeadlines({
  //   required String country,
  //   required String category,
  // });
}

class ArticleRepository implements IArticleRepository {
  ArticleRepository({
    required this.dio,
  });
  final Dio dio;

  @override
  Future<Either<ArticleResponse, Failure>> getArticle({
    required String q,
    required String sortBy,
    required String from,
    required String to,
  }) async {
    try {
      final query = {
        'q': q,
        'sortBy': sortBy,
        'from': from,
        'to': to,
        // 'apiKey': 'ca56a4c0d027426a868d37a343508228',
      };

      final response = await dio.get<Map<String, dynamic>>(
        NewsApi.getNews,
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

  // @override
  // Future<Either<ArticleResponse, Failure>> topHeadlines({
  //   required String country,
  //   required String category,
  // }) async {
  //   try {
  //     final query = {
  //       'country': country,
  //       'category': category,
  //       // 'apiKey': 'ca56a4c0d027426a868d37a343508228',
  //     };

  //     final response = await dio.get<Map<String, dynamic>>(
  //       NewsApi.getTopHeadLines,
  //       queryParameters: query,
  //     );
  //     final json = Map<String, dynamic>.from(response.data!);
  //     final result = ArticleResponse.fromJson(json);
  //     return Left(result);
  //   } on DioError catch (e) {
  //     return Right(e.toFailure);
  //   } catch (e) {
  //     return Right(Failure.fromException());
  //   }
  // }
}
