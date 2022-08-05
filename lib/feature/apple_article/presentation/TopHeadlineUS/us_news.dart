import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/core/theme/component/widget/custom_shimmer.dart';
import 'package:newsapi/feature/apple_article/application/Top_Headline_US/top_headline/top_headline_bloc.dart';
import 'package:newsapi/feature/apple_article/presentation/article_detail.dart';

class TopHeadlineForUs extends StatefulWidget {
  const TopHeadlineForUs({Key? key, required this.color}) : super(key: key);
  final Color color;
  @override
  State<TopHeadlineForUs> createState() => _TopHeadlineForUsState();
}

class _TopHeadlineForUsState extends State<TopHeadlineForUs> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            'Top Headline',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: widget.color,
                ),
          ),
        ),
        BlocBuilder<TopHeadlineBloc, TopHeadlineState>(
          bloc: inject<TopHeadlineBloc>(),
          builder: (context, state) {
            if (state is TopHeadlineLoadingState) {
              return SizedBox(
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CustomShimmer(
                          baseColor: const Color(0xff262837),
                          highlightColor: Colors.grey.shade100,
                          widget: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                // borderRadius: BorderRadius.circular(5),
                                shape: BoxShape.circle),
                          ),
                        );
                      }),
                ),
              );
            }
            if (state is TopHeadlineLoadedState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.topHeadlineResponse.articles.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data =
                              state.topHeadlineResponse.articles[index];
                          // final e = data.source!.name.split(' ').last;
                          return Container(
                            padding:
                                const EdgeInsets.only(top: 10.0, right: 0.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsDetailsScreen(
                                              article: data,
                                            )));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: data.source?.id ?? '',
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5.0,
                                              spreadRadius: 1.0,
                                              offset: Offset(
                                                1.0,
                                                1.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              data.urlToImage ?? ''),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 90,
                                      child: Text(
                                        data.source!.name,
                                        // overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height: 1.4,
                                          color: widget.color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }
            if (state is TopHeadlineErrorState) {
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
        ),
      ],
    );
  }
}
