import 'package:bloc/bloc.dart';
import 'package:newsapi/feature/apple_article/infrastructure/entities/article.dart';
import 'package:newsapi/feature/apple_article/infrastructure/repository/article_repository.dart';

part 'category_news_event.dart';
part 'category_news_state.dart';

class CategoryNewsBloc extends Bloc<CategoryNewsEvent, CategoryNewsState> {
  final IArticleRepository homeRepository;
  CategoryNewsBloc({required this.homeRepository}) : super(CategoryInitial()) {
    on<CategoryEventsForArticle>((event, emit) async {
      if (event.categoryName.isEmpty) {
        emit(CategoryInitial());
      } else {
        emit(CategoryLoadingState());
        final response = await homeRepository.topCategory(
          categoryName: event.categoryName,
          country: 'us',
        );
        response.fold(
          (topheadlinelist) async {
            emit(CategoryLoadedState(articleResponse: topheadlinelist));
          },
          (failure) {
            emit(CategoryLoadedStateErrorState(errorMessage: failure.reason));
          },
        );
      }
    });
  }
}
