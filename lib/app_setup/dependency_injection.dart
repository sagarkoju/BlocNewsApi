import 'package:get_it/get_it.dart';
import 'package:newsapi/app_setup/dio/dio_client.dart';
import 'package:newsapi/feature/apple_article/application/SearchNews/search_news_bloc.dart';
import 'package:newsapi/feature/apple_article/application/Top_Headline_Germany/top_headline_germany_bloc.dart';

import 'package:newsapi/feature/apple_article/application/Top_Headline_US/top_headline/top_headline_bloc.dart';
import 'package:newsapi/feature/apple_article/application/article_bloc/article_bloc.dart';
import 'package:newsapi/feature/apple_article/application/switch/switch_bloc/switch_bloc.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/article_repository.dart';

GetIt inject = GetIt.instance;

void initDependencyInjection() {
  registerClient();

  registerRepository();

  registerBloc();
}

//register the network client
void registerClient() {
  inject.registerSingleton(dioClient());
}

//register all the repository
void registerRepository() {
  inject.registerLazySingleton<IArticleRepository>(
    () => ArticleRepository(
      dio: inject(),
    ),
  );
}

//register all the blocs
void registerBloc() {
  inject
    ..registerLazySingleton(
      () => ArticleBloc(
        homeRepository: inject(),
      )..add(ArticleStart()),
    )
    ..registerLazySingleton(
      () => SwitchBloc(),
    )
    ..registerLazySingleton(
      () => TopHeadlineBloc(
        homeRepository: inject(),
      )..add(TopHeadlinesStart()),
    )
    ..registerLazySingleton(
      () => TopHeadlineGermanyBloc(
        homeRepository: inject(),
      )..add(TopHeadlinesForGermanyStart()),
    )
    ..registerLazySingleton(
      () => SearchNewsBloc(
        homeRepository: inject(),
      ),
    );
}
