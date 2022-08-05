import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/core/service/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapi/feature/apple_article/application/switch/switch_bloc/switch_bloc.dart';
import 'package:newsapi/feature/apple_article/presentation/AppleNews/apple_news.dart';
import 'package:newsapi/feature/apple_article/presentation/Category/category_news.dart';
import 'package:newsapi/feature/apple_article/presentation/TopHeadlineGermany/germany_news.dart';
import 'package:newsapi/feature/apple_article/presentation/TopHeadlineUS/us_news.dart';
import 'package:newsapi/feature/apple_article/presentation/search_news.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
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
            const TopHeadLineForGermany(),
            CategoryNews(
              color: color,
            ),
            TopHeadlineForUs(
              color: color,
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
}
