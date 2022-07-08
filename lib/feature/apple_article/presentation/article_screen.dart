import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/core/theme/component/widget/custom_shimmer.dart';
import 'package:newsapi/core/theme/component/widget/drawerWidget.dart';
import 'package:newsapi/feature/apple_article/application/article_bloc/article_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

@override
void initState() {}

class _ArticleScreenState extends State<ArticleScreen> {
  int current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black45,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'News Api',
          style: GoogleFonts.lobster(
            textStyle: const TextStyle(
              color: Colors.grey,
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
          children: [
            BlocBuilder<ArticleBloc, ArticleState>(
              bloc: inject<ArticleBloc>(),
              builder: (context, state) {
                if (state is ArticleLoadedState) {
                  return CarouselSlider(
                    items: state.articleResponse.articles
                        .map(
                          (e) => Container(
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
                                          e.title,
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
            BlocBuilder<ArticleBloc, ArticleState>(
              bloc: inject<ArticleBloc>(),
              builder: (context, state) {
                if (state is ArticleLoadingState) {
                  return const _ArticleLoadingState();
                }

                if (state is ArticleLoadedState) {
                  final data = state.articleResponse;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.articles.length,
                      itemBuilder: (context, index) {
                        final data = state.articleResponse.articles[index];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                                imageUrl: data.urlToImage ?? '',
                                progressIndicatorBuilder: (BuildContext ctx,
                                    String image, DownloadProgress progress) {
                                  return Container(
                                    color: const Color(0xff201D2C)
                                        .withOpacity(progress.progress ?? 1.0),
                                  );
                                },
                                errorWidget: (context, _, error) {
                                  return const Icon(Icons.error);
                                },
                              ),
                              const SizedBox(height: 8.0),
                              Container(
                                margin: const EdgeInsets.all(08),
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Text(
                                  data.source?.name ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(data.title),
                              ),
                            ],
                          ),
                        );
                      });
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
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return CustomShimmer(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            widget: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                ),
                width: MediaQuery.of(context).size.width,
              ),
            ),
          );
        });
  }
}
