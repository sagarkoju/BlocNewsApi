part of 'top_headline_bloc.dart';

class TopHeadlineState {
  const TopHeadlineState();
}

class TopHeadlineInitialState extends TopHeadlineState {}

class TopHeadlineLoadingState extends TopHeadlineState {}

class TopHeadlineLoadedState extends TopHeadlineState {
  final ArticleResponse articleResponse;
  TopHeadlineLoadedState({
    required this.articleResponse,
  });
}

class TopHeadlineErrorState extends TopHeadlineState {
  final String errorMessage;
  TopHeadlineErrorState({
    required this.errorMessage,
  });
}
