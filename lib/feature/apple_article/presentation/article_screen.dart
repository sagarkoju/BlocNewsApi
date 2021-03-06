import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/core/service/utils.dart';
import 'package:newsapi/core/theme/component/widget/article_apple_news.dart';
import 'package:newsapi/core/theme/component/widget/carasoul_dot_widget.dart';
import 'package:newsapi/core/theme/component/widget/custom_shimmer.dart';
import 'package:newsapi/core/theme/component/widget/drawerWidget.dart';
import 'package:newsapi/feature/apple_article/application/Top_Headline/top_headline/top_headline_bloc.dart';
import 'package:newsapi/feature/apple_article/application/article_bloc/article_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapi/feature/apple_article/presentation/article_detail.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  void initState() {
    // inject<TopHeadlineBloc>().add(TopHeadlinesStart());

    super.initState();
  }

  int current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    final color = Utils().getColor;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'News Api',
          style: GoogleFonts.lobster(
            textStyle: TextStyle(
              color: color,
              fontSize: 20,
              letterSpacing: 0.6,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ArticleBloc, ArticleState>(
              bloc: inject<ArticleBloc>(),
              builder: (context, state) {
                if (state is ArticleLoadingState) {
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

                if (state is ArticleLoadedState) {
                  return CarouselSlider(
                    items: state.articleResponse.articles
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  child: Stack(
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: double.infinity,
                                        imageUrl: e.urlToImage ?? '',
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
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(200, 0, 0, 0),
                                                Color.fromARGB(0, 0, 0, 0)
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Text(
                                            e.author ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Top Headline',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: color,
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                height: 100,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
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
                            itemCount:
                                state.topHeadlineResponse.articles.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final data =
                                  state.topHeadlineResponse.articles[index];
                              // final e = data.source!.name.split(' ').last;
                              return Container(
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 0.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NewsDetailsScreen(
                                                  article: data,
                                                )));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              backgroundImage: NetworkImage(data
                                                      .urlToImage ??
                                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLZJ9wqf6DCyzDcpwQIPuk50hogm0jaebmpQ&usqp=CAU'),
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
                                              color: color,
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Text(
                'Hot News',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: color,
                    ),
              ),
            ),
            const ArticleAppleNewsWidget(),
          ],
        ),
      ),
    );
  }
}
