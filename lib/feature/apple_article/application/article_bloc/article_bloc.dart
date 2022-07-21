import 'package:bloc/bloc.dart';
import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';

import 'package:newsapi/feature/apple_article/infrastructure/repository/article_repository.dart';
part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvents, ArticleState> {
  ArticleBloc({
    required this.homeRepository,
  }) : super(ArticleInitial()) {
    on<ArticleStart>(
      (event, emit) async {
        emit(ArticleLoadingState());
        final response = await homeRepository.getArticle(
            q: 'apple',
            to: DateTime.parse('2022-07-20'),
            from: DateTime.parse('2022-07-20'),
            sortBy: 'popularity');
        response.fold(
          (articleList) {
            emit(ArticleLoadedState(articleResponse: articleList));
          },
          (failure) {
            emit(ArticleErrorState(errorMessage: failure.reason));
          },
        );
      },
    );
  }
  final IArticleRepository homeRepository;
}
