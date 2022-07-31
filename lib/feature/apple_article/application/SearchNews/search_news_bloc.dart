import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/article_repository.dart';

part 'search_news_event.dart';
part 'search_news_state.dart';

class SearchNewsBloc extends Bloc<SearchNewsEvent, SearchNewsState> {
  final IArticleRepository homeRepository;
  SearchNewsBloc({required this.homeRepository})
      : super(SearchNewsInitialState()) {
    on<SeachNewsEventsForArticle>((event, emit) async {
      if (event.auther.isEmpty) {
        emit(SearchNewsInitialState());
      } else {
        emit(SearchNewsLoadingState());
        final response = await homeRepository.getArticle(
            q: event.auther,
            to: DateTime.parse('2022-07-31'),
            from: DateTime.parse('2022-07-31'),
            sortBy: 'popularity');
        response.fold((moviesReponse) {
          emit(SearchNewsLoadedState(searchResponse: moviesReponse));
        }, (failure) {
          emit(SearchNewsErrorState(errorMessage: failure.reason));
        });
      }
    });
  }
}
