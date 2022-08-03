import 'package:bloc/bloc.dart';

import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/article_repository.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/local_article_repository.dart';

part 'top_headline_germany_event.dart';
part 'top_headline_germany_state.dart';

class TopHeadlineGermanyBloc
    extends Bloc<TopHeadlineGermanyEvent, TopHeadlineGermanyState> {
  final IArticleRepository homeRepository;
  final ILocalArticleRepository iLocalArticleRepository;
  TopHeadlineGermanyBloc(
      {required this.homeRepository, required this.iLocalArticleRepository})
      : super(TopHeadlineForGermanyInitialState()) {
    on<TopHeadlinesForGermanyStart>(
      (event, emit) async {
        emit(TopHeadlineForGermanyLoadingState());
        final response = await homeRepository.topHeadlinesForGermany(
          category: 'business',
          country: 'de',
          fromRemote: false,
        );
        response.fold(
          (topheadlinelist) async {
            emit(TopHeadlineForGermanyLoadedState(
                topHeadlineForGermanyResponse: topheadlinelist));
            await iLocalArticleRepository.cacheArticle(
                articleResponse: topheadlinelist);
          },
          (failure) {
            emit(TopHeadlineForGermanyErrorState(errorMessage: failure.reason));
          },
        );
      },
    );
  }
}
