import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/core/service/utils.dart';
import 'package:newsapi/core/theme/component/widget/custom_shimmer.dart';
import 'package:newsapi/feature/apple_article/application/article_bloc/article_bloc.dart';
import 'package:newsapi/feature/apple_article/presentation/article_detail.dart';

class ArticleAppleNewsWidget extends StatelessWidget {
  const ArticleAppleNewsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Utils().getColor;
    return BlocBuilder<ArticleBloc, ArticleState>(
      bloc: inject<ArticleBloc>(),
      builder: (context, state) {
        if (state is ArticleLoadingState) {
          return const _ArticleLoadingState();
        }

        if (state is ArticleLoadedState) {
          final data = state.articleResponse;
          return SizedBox(
            height: 250,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data.articles.length,
                itemBuilder: (context, index) {
                  final data = state.articleResponse.articles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewsDetailsScreen(
                                    article: data,
                                  )));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                        15,
                      )),
                      child: SizedBox(
                        height: 250,
                        width: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: SizedBox(
                                height: 200,
                                width: 180,
                                child: CachedNetworkImage(
                                  imageUrl: data.urlToImage ?? '',
                                  fit: BoxFit.fill,
                                  progressIndicatorBuilder: (BuildContext ctx,
                                      String image, DownloadProgress progress) {
                                    return Container(
                                      width: 160,
                                      height: 180,
                                      color:
                                          const Color(0xff201D2C).withOpacity(
                                        progress.progress ?? 1.0,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Center(
                                child: Text(
                                  data.source?.name ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: color,
                                      ),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        }
        if (state is ArticleErrorState) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                state.errorMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _ArticleLoadingState extends StatelessWidget {
  const _ArticleLoadingState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return CustomShimmer(
              baseColor: const Color(0xff262837),
              highlightColor: Colors.grey.shade100,
              widget: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                height: 160,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            );
          }),
    );
  }
}
