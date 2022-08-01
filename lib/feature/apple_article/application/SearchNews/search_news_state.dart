part of 'search_news_bloc.dart';


class SearchNewsState {}

class SearchNewsInitialState extends SearchNewsState {}

class SearchNewsLoadingState extends SearchNewsState {}

class SearchNewsLoadedState extends SearchNewsState {
  final ArticleResponse searchResponse;
  SearchNewsLoadedState({
    required this.searchResponse,
  });
}

class SearchNewsErrorState extends SearchNewsState {
  final String errorMessage;
  SearchNewsErrorState({
    required this.errorMessage,
  });
}
