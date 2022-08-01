// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'article_bloc.dart';

abstract class ArticleEvents {
  const ArticleEvents();
}

class ArticleStart extends ArticleEvents {
  final bool? fromRemote;
  ArticleStart({
    this.fromRemote,
  });
}
