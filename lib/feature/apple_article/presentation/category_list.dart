import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/core/service/date_extension.dart';
import 'package:newsapi/core/theme/component/widget/custom_shimmer.dart';
import 'package:newsapi/feature/apple_article/application/CategoryNews/category_news_bloc.dart';
import 'package:newsapi/feature/apple_article/presentation/article_detail.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({
    Key? key,
    required this.color,
    required this.categoryName,
  }) : super(key: key);

  final Color color;
  final String categoryName;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  void initState() {
    inject<CategoryNewsBloc>()
        .add(CategoryEventsForArticle(categoryName: widget.categoryName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName.toUpperCase()} NEWS'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<CategoryNewsBloc, CategoryNewsState>(
              bloc: inject<CategoryNewsBloc>(),
              builder: (context, state) {
                if (state is CategoryLoadingState) {
                  return const _ArticleLoadingState();
                }

                if (state is CategoryLoadedState) {
                  final data = state.articleResponse;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                                color: const Color(0xff262837),
                                borderRadius: BorderRadius.circular(4)),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xff262837),
                                  radius: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      height: 80,
                                      width: double.infinity,
                                      imageUrl: data.urlToImage ??
                                          'https://thumbs.dreamstime.com/b/live-breaking-news-television-broadcast-globe-gradient-blue-background-illustration-panorama-185818606.jpg',
                                      progressIndicatorBuilder:
                                          (BuildContext ctx, String image,
                                              DownloadProgress progress) {
                                        return Container(
                                          color: const Color(0xff201D2C)
                                              .withOpacity(
                                                  progress.progress ?? 1.0),
                                        );
                                      },
                                      errorWidget: (context, _, error) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.author ?? data.source!.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(color: widget.color),
                                        maxLines: 2,
                                      ),
                                      Text(
                                        'Publish on : ${data.publishedAt.articleEventDate()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: widget.color),
                                        maxLines: 1,
                                      ),
                                      Text(
                                        data.content ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: widget.color),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }
                if (state is CategoryLoadedStateErrorState) {
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
            )
          ],
        ),
      ),
    );
  }
}

class _ArticleLoadingState extends StatelessWidget {
  const _ArticleLoadingState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return CustomShimmer(
            baseColor: const Color(0xff262837),
            highlightColor: Colors.grey.shade100,
            widget: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              height: 100,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          );
        });
  }
}
