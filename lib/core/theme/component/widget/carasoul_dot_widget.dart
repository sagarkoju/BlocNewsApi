import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/core/theme/component/widget/custom_shimmer.dart';
import 'package:newsapi/feature/apple_article/application/Top_Headline_Germany/top_headline_germany_bloc.dart';

class CarasoulDotWidget extends StatelessWidget {
  const CarasoulDotWidget({
    Key? key,
    required CarouselController controller,
    required this.current,
  })  : _controller = controller,
        super(key: key);

  final CarouselController _controller;
  final int current;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopHeadlineGermanyBloc, TopHeadlineGermanyState>(
      bloc: inject<TopHeadlineGermanyBloc>(),
      builder: (context, state) {
        if (state is TopHeadlineForGermanyLoadingState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 25,
                  width: 250,
                  child: ListView.builder(
                    itemCount: 15,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ((context, index) {
                      return CustomShimmer(
                        baseColor: const Color(0xff262837),
                        highlightColor: Colors.grey.shade100,
                        widget: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          // padding: const EdgeInsets.symmetric(
                          //   horizontal: 8,
                          // ),

                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        }
        if (state is TopHeadlineForGermanyLoadedState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: state.topHeadlineForGermanyResponse.articles
                .asMap()
                .entries
                .map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                            .withOpacity(current == entry.key ? 0.9 : 0.4),
                      ),
                    ),
                  );
                })
                .take(10)
                .toList(),
          );
        }
        return const SizedBox();
      },
    );
  }
}
