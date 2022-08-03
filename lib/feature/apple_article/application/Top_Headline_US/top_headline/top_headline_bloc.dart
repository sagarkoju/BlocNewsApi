import 'package:bloc/bloc.dart';

import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/article_repository.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/local_article_repository.dart';

part 'top_headline_event.dart';
part 'top_headline_state.dart';

class TopHeadlineBloc extends Bloc<TopHeadlineEvent, TopHeadlineState> {
  final ILocalArticleRepository localArticleRepository;
  TopHeadlineBloc(
      {required this.homeRepository, required this.localArticleRepository})
      : super(TopHeadlineInitialState()) {
    on<TopHeadlinesStart>(
      (event, emit) async {
        emit(TopHeadlineLoadingState());
        final response = await homeRepository.topHeadlinesForUs(
          category: 'business',
          country: 'us',
          fromRemote: false,
        );
        response.fold(
          (topheadlinelist) async {
            emit(TopHeadlineLoadedState(topHeadlineResponse: topheadlinelist));
            await localArticleRepository.cacheArticle(
                articleResponse: topheadlinelist);
          },
          (failure) {
            emit(TopHeadlineErrorState(errorMessage: failure.reason));
          },
        );
      },
    );
  }
  final IArticleRepository homeRepository;
}
