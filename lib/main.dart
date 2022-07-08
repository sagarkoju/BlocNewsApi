import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapi/app_setup/bloc_observer.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/core/theme/theme_colors.dart';
import 'package:newsapi/feature/apple_article/application/switch/switch_bloc/switch_bloc.dart';

import 'package:newsapi/feature/apple_article/presentation/article_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

  BlocOverrides.runZoned(
    () {
      runApp(
        const MyApp(),
      );
    },
    blocObserver: ArticleBlocObserver(),
  );
}

Future<void> initApp() async {
  initDependencyInjection();
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwitchBloc, SwitchState>(
      bloc: inject<SwitchBloc>(),
      builder: (context, state) {
        return MaterialApp(
          theme: state.switchValue
              ? AppThemes.appThemeData[AppTheme.darkTheme]
              : AppThemes.appThemeData[AppTheme.lightTheme],
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            final scale = mediaQueryData.textScaleFactor.clamp(0.8, 1.2);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
              child: child!,
            );
          },
          home: const ArticleScreen(),
        );
      },
    );
  }
}
