import 'package:bloc/bloc.dart';
import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/article_repository.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/local_article_repository.dart';

part 'search_news_event.dart';
part 'search_news_state.dart';

class SearchNewsBloc extends Bloc<SearchNewsEvent, SearchNewsState> {
  final IArticleRepository homeRepository;
  final ILocalArticleRepository localArticleRepository;
  SearchNewsBloc(
      {required this.homeRepository, required this.localArticleRepository})
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
            fromRemote: true,
            sortBy: 'popularity');
        response.fold((articleResponse) async {
          emit(SearchNewsLoadedState(searchResponse: articleResponse));
          await localArticleRepository.cacheArticle(
              articleResponse: articleResponse);
        }, (failure) {
          emit(SearchNewsErrorState(errorMessage: failure.reason));
        });
      }
    });
  }
}
