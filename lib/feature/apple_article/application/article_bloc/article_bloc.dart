import 'package:bloc/bloc.dart';
import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';

import 'package:newsapi/feature/apple_article/infrastructure/repository/article_repository.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/local_article_repository.dart';
part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvents, ArticleState> {
  ArticleBloc({
    required this.homeRepository,
    required this.localArticleRepository,
  }) : super(ArticleInitial()) {
    on<ArticleStart>(
      (event, emit) async {
        emit(ArticleLoadingState());
        final response = await homeRepository.getArticle(
            q: 'apple',
            fromRemote: true,
            to: DateTime.parse('2022-07-31'),
            from: DateTime.parse('2022-07-31'),
            sortBy: 'popularity');
        response.fold(
          (articleList) async {
            emit(ArticleLoadedState(articleResponse: articleList));
            await localArticleRepository.cacheArticle(
                articleResponse: articleList);
          },
          (failure) {
            emit(ArticleErrorState(errorMessage: failure.reason));
          },
        );
      },
    );
  }
  final IArticleRepository homeRepository;
  final ILocalArticleRepository localArticleRepository;
}
