import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/core/theme/component/widget/carasoul_dot_widget.dart';
import 'package:newsapi/core/theme/component/widget/custom_shimmer.dart';
import 'package:newsapi/feature/apple_article/application/Top_Headline_Germany/top_headline_germany_bloc.dart';
import 'package:newsapi/feature/apple_article/presentation/article_detail.dart';
import 'package:timeago/timeago.dart' as timeago;

class TopHeadLineForGermany extends StatefulWidget {
  const TopHeadLineForGermany({Key? key}) : super(key: key);

  @override
  State<TopHeadLineForGermany> createState() => _TopHeadLineForGermanyState();
}

class _TopHeadLineForGermanyState extends State<TopHeadLineForGermany> {
  int current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<TopHeadlineGermanyBloc, TopHeadlineGermanyState>(
          bloc: inject<TopHeadlineGermanyBloc>(),
          builder: (context, state) {
            if (state is TopHeadlineForGermanyLoadingState) {
              return CustomShimmer(
                baseColor: const Color(0xff262837),
                highlightColor: Colors.grey.shade100,
                widget: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            }

            if (state is TopHeadlineForGermanyLoadedState) {
              return CarouselSlider(
                items: state.topHeadlineForGermanyResponse.articles
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewsDetailsScreen(
                                        article: e,
                                      )));
                        },
                        child: Container(
                          decoration:
                              const BoxDecoration(color: Color(0xff262837)),
                          margin: const EdgeInsets.all(10),
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Stack(
                                children: <Widget>[
                                  CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: double.infinity,
                                    imageUrl: e.urlToImage ?? '',
                                    progressIndicatorBuilder: (BuildContext ctx,
                                        String image,
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
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          stops: const [0.1, 0.9],
                                          colors: [
                                            Colors.black.withOpacity(0.9),
                                            Colors.white.withOpacity(0.0)
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            e.source?.name ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            timeUntil(
                                                DateTime.parse(e.publishedAt)),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    )
                    .toList()
                    .take(10)
                    .toList(),
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2,
                    onPageChanged: (index, e) {
                      setState(() {
                        current = index;
                      });
                    }),
              );
            }
            return const SizedBox();
          },
        ),
        CarasoulDotWidget(controller: _controller, current: current),
      ],
    );
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
