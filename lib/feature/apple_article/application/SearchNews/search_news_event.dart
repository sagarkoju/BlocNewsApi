// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_news_bloc.dart';

abstract class SearchNewsEvent {}

class SeachNewsEventsForArticle extends SearchNewsEvent {
  final String auther;
  SeachNewsEventsForArticle({
    required this.auther,
  });
}
