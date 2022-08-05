import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/core/Helper/data.dart';
import 'package:newsapi/core/service/utils.dart';
import 'package:newsapi/core/theme/component/widget/article_apple_news.dart';
import 'package:newsapi/core/theme/component/widget/carasoul_dot_widget.dart';
import 'package:newsapi/core/theme/component/widget/custom_shimmer.dart';
import 'package:newsapi/feature/apple_article/application/Top_Headline_Germany/top_headline_germany_bloc.dart';
import 'package:newsapi/feature/apple_article/application/Top_Headline_US/top_headline/top_headline_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapi/feature/apple_article/application/switch/switch_bloc/switch_bloc.dart';
import 'package:newsapi/feature/apple_article/presentation/article_detail.dart';
import 'package:newsapi/feature/apple_article/presentation/category_list.dart';
import 'package:newsapi/feature/apple_article/presentation/search_news.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  List<Category> categoryName = [];
  @override
  void initState() {
    categoryName = List.of(categoriesName);
    // inject<ArticleBloc>().add(ArticleStart(fromRemote: false));

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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchScreen(
                              color: color,
                            )));
              },
              icon: Icon(
                IconlyLight.search,
                color: color,
              )),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: BlocBuilder<SwitchBloc, SwitchState>(
              bloc: inject<SwitchBloc>(),
              builder: (context, state) {
                return CupertinoSwitch(
                  activeColor: color,
                  value: state.switchValue,
                  onChanged: (value) {
                    setState(() {
                      value
                          ? inject<SwitchBloc>().add(SwitchOnEvent())
                          : inject<SwitchBloc>().add(SwitchOffEvent());
                    });
                  },
                );
              },
            ),
          )
        ],
      ),
      // drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                timeUntil(DateTime.parse(
                                                    e.publishedAt)),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Category',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: color,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: SizedBox(
                height: 30,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoryName.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryList(
                                        color: color,
                                        categoryName: categoryName[index]
                                            .categoryName
                                            .toLowerCase(),
                                      )));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey,
                          ),
                          child: Text(
                            categoryName[index].categoryName,
                            style: Theme.of(context).textTheme.button?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.08,
                                ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
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
                                    const EdgeInsets.symmetric(horizontal: 3),
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
            ArticleAppleNewsWidget(
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
