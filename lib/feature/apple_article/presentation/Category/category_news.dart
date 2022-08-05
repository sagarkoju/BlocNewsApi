import 'package:flutter/material.dart';
import 'package:newsapi/core/Helper/data.dart';
import 'package:newsapi/core/service/utils.dart';
import 'package:newsapi/feature/apple_article/presentation/category_list.dart';

class CategoryNews extends StatefulWidget {
  const CategoryNews({Key? key, required this.color}) : super(key: key);
  final Color color;
  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<Category> categoryName = [];
  @override
  void initState() {
    categoryName = List.of(categoriesName);
    // inject<ArticleBloc>().add(ArticleStart(fromRemote: false));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Category',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: widget.color,
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
                                    color: widget.color,
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
      ],
    );
  }
}
