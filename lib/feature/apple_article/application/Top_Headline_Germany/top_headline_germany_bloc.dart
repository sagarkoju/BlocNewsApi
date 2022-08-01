import 'package:bloc/bloc.dart';

import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/article_repository.dart';

part 'top_headline_germany_event.dart';
part 'top_headline_germany_state.dart';

class TopHeadlineGermanyBloc
    extends Bloc<TopHeadlineGermanyEvent, TopHeadlineGermanyState> {
  final IArticleRepository homeRepository;
  TopHeadlineGermanyBloc({required this.homeRepository})
      : super(TopHeadlineForGermanyInitialState()) {
    on<TopHeadlinesForGermanyStart>(
      (event, emit) async {
        emit(TopHeadlineForGermanyLoadingState());
        final response = await homeRepository.topHeadlinesForUs(
          category: 'business',
          country: 'de',
        );
        response.fold(
          (topheadlinelist) {
            emit(TopHeadlineForGermanyLoadedState(
                topHeadlineForGermanyResponse: topheadlinelist));
          },
          (failure) {
            emit(TopHeadlineForGermanyErrorState(errorMessage: failure.reason));
          },
        );
      },
    );
  }
}
