import 'package:bloc/bloc.dart';

import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/article_repository.dart';

part 'top_headline_event.dart';
part 'top_headline_state.dart';

class TopHeadlineBloc extends Bloc<TopHeadlineEvent, TopHeadlineState> {
  TopHeadlineBloc({required this.homeRepository})
      : super(TopHeadlineInitialState()) {
    on<TopHeadlinesStart>(
      (event, emit) async {
        emit(TopHeadlineLoadingState());
        final response = await homeRepository.topHeadlines(
          category: 'business',
          country: 'us',
        );
        response.fold(
          (topheadlinelist) {
            emit(TopHeadlineLoadedState(topHeadlineResponse: topheadlinelist));
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
