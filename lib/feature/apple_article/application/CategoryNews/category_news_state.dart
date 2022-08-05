part of 'category_news_bloc.dart';

class CategoryNewsState {}

class CategoryInitial extends CategoryNewsState {}

class CategoryLoadingState extends CategoryNewsState {}

class CategoryLoadedState extends CategoryNewsState {
  final ArticleResponse articleResponse;
  CategoryLoadedState({
    required this.articleResponse,
  });
}

class CategoryLoadedStateErrorState extends CategoryNewsState {
  final String errorMessage;
  CategoryLoadedStateErrorState({
    required this.errorMessage,
  });
}
