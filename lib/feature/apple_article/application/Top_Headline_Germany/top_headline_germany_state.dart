part of 'top_headline_germany_bloc.dart';

@freezed
class TopHeadlineGermanyState {}

class TopHeadlineForGermanyInitialState extends TopHeadlineGermanyState {}

class TopHeadlineForGermanyLoadingState extends TopHeadlineGermanyState {}

class TopHeadlineForGermanyLoadedState extends TopHeadlineGermanyState {
  final ArticleResponse topHeadlineForGermanyResponse;
  TopHeadlineForGermanyLoadedState({
    required this.topHeadlineForGermanyResponse,
  });
}

class TopHeadlineForGermanyErrorState extends TopHeadlineGermanyState {
  final String errorMessage;
  TopHeadlineForGermanyErrorState({
    required this.errorMessage,
  });
}
