import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/feature/apple_article/application/article_bloc/article_bloc.dart';

class CarasoulDotWidget extends StatelessWidget {
  const CarasoulDotWidget({
    Key? key,
    required CarouselController controller,
    required this.current,
  })  : _controller = controller,
        super(key: key);

  final CarouselController _controller;
  final int current;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleBloc, ArticleState>(
      bloc: inject<ArticleBloc>(),
      builder: (context, state) {
        if (state is ArticleLoadedState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: state.articleResponse.articles
                .asMap()
                .entries
                .map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                            .withOpacity(current == entry.key ? 0.9 : 0.4),
                      ),
                    ),
                  );
                })
                .take(10)
                .toList(),
          );
        }
        return const SizedBox();
      },
    );
  }
}
