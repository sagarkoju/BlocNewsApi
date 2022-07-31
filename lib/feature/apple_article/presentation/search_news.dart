import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/core/service/date_extension.dart';
import 'package:newsapi/core/theme/component/widget/custom_shimmer.dart';
import 'package:newsapi/feature/apple_article/application/SearchNews/search_news_bloc.dart';
import 'package:newsapi/feature/apple_article/application/article_bloc/article_bloc.dart';
import 'package:newsapi/feature/apple_article/presentation/article_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.color}) : super(key: key);
  final Color color;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    // final color = Utils().getColor;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
              child: Text(
                'Find your favourite News..',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                onChanged: (value) {
                  inject<SearchNewsBloc>()
                      .add(SeachNewsEventsForArticle(auther: value));
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Enter a title..',
                  hintStyle: const TextStyle(color: Colors.white),
                  fillColor: const Color(0xff262837),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                        style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                        style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchNewsBloc, SearchNewsState>(
                bloc: inject<SearchNewsBloc>(),
                builder: (context, state) {
                  if (state is SearchNewsLoadingState) {
                    return const _ArticleLoadingState();
                  }

                  if (state is SearchNewsLoadedState) {
                    final data = state.searchResponse;
                    return data.articles.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.articles.length,
                            itemBuilder: (context, index) {
                              final data = state.searchResponse.articles[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewsDetailsScreen(
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
                                        backgroundColor:
                                            const Color(0xff262837),
                                        radius: 40,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            height: 80,
                                            width: double.infinity,
                                            imageUrl: data.urlToImage ?? '',
                                            progressIndicatorBuilder:
                                                (BuildContext ctx, String image,
                                                    DownloadProgress progress) {
                                              return Container(
                                                color: const Color(0xff201D2C)
                                                    .withOpacity(
                                                        progress.progress ??
                                                            1.0),
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
                                              data.author ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                      color: widget.color),
                                              maxLines: 2,
                                            ),
                                            Text(
                                              'Publish on : ${data.publishedAt.articleEventDate()}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: widget.color),
                                              maxLines: 1,
                                            ),
                                            Text(
                                              data.content ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color: widget.color),
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
                            })
                        : Center(
                            child: Text(
                            'No Article found.',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(color: Colors.white),
                          ));
                  }
                  if (state is SearchNewsErrorState) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          state.errorMessage,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: widget.color,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
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
    return SizedBox(
      height: 150,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
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
