import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/core/theme/component/widget/vertical_spacing.dart';
import 'package:newsapi/feature/apple_article/application/switch/switch_bloc/switch_bloc.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/newspaper.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                  const VerticalSpacing(20),
                  Flexible(
                    child: Text(
                      'News app',
                      style: GoogleFonts.lobster(
                          textStyle: const TextStyle(
                              fontSize: 20, letterSpacing: 0.6)),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalSpacing(20),
            ListTilesWidget(
              label: "Home",
              icon: IconlyBold.home,
              fct: () {
                // Navigator.pushReplacement(
                //   context,
                //   PageTransition(
                //       type: PageTransitionType.rightToLeft,
                //       child: const HomeScreen(),
                //       inheritTheme: true,
                //       ctx: context),
                // );
              },
            ),
            ListTilesWidget(
              label: "Bookmark",
              icon: IconlyBold.bookmark,
              fct: () {
                // Navigator.pushReplacement(
                //   context,
                //   PageTransition(
                //       type: PageTransitionType.rightToLeft,
                //       child: const BookmarkScreen(),
                //       inheritTheme: true,
                //       ctx: context),
                // );
              },
            ),
            const Divider(
              thickness: 5,
            ),
            BlocBuilder<SwitchBloc, SwitchState>(
              bloc: inject<SwitchBloc>(),
              builder: (context, state) {
                return SwitchListTile(
                  secondary: Icon(
                    state.switchValue ? Icons.dark_mode : Icons.light_mode,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: state.switchValue
                      ? const Text(
                          'Dark',
                          style: TextStyle(fontSize: 20),
                        )
                      : const Text(
                          'Light',
                          style: TextStyle(fontSize: 20),
                        ),
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
          ],
        ),
      ),
    );
  }
}

class ListTilesWidget extends StatelessWidget {
  const ListTilesWidget({
    Key? key,
    required this.label,
    required this.fct,
    required this.icon,
  }) : super(key: key);
  final String label;
  final Function fct;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 20),
      ),
      onTap: () {
        fct();
      },
    );
  }
}
