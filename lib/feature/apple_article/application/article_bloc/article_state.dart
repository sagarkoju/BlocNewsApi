part of 'article_bloc.dart';

abstract class ArticleState {
  const ArticleState();
}

class ArticleInitial extends ArticleState {}

class ArticleLoadingState extends ArticleState {}

class ArticleLoadedState extends ArticleState {
  final ArticleResponse articleResponse;
  ArticleLoadedState({
    required this.articleResponse,
  });
}

class ArticleErrorState extends ArticleState {
  final String errorMessage;
  ArticleErrorState({
    required this.errorMessage,
  });
}
