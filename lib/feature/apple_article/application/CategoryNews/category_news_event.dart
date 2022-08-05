part of 'category_news_bloc.dart';

class CategoryNewsEvent {}

class CategoryEventsForArticle extends CategoryNewsEvent {
  final String categoryName;
  CategoryEventsForArticle({
    required this.categoryName,
  });
}
