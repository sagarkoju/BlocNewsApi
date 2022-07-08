import 'package:flutter/material.dart';

// //Light theme
// Color lightScaffoldColor = const Color(0xFFF5F5F5);
// Color lightCardColor = const Color(0xFFFfFFFf); //F0FFFF
// Color lightBackgroundColor = const Color(0xFFD0E8F2);
// Color lightIconsColor = const Color(0xFF79A3B1);
// //  Color lightTextColor = const Color(0xff324558);
// //Dark theme
// Color darkScaffoldColor = const Color(0xFF1A1A2E);
// Color darkCardColor = const Color(0xFF001429);
// Color darkBackgroundColor = const Color(0xFF0F3460);
// Color darkIconsColor = const Color(0xFFE94560);

enum AppTheme {
  darkTheme,
  lightTheme,
}

class AppThemes {
  static final appThemeData = {
    AppTheme.darkTheme: ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF212121),
      dividerColor: Colors.black54,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
      textTheme: const TextTheme(
        subtitle1: TextStyle(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.grey, unselectedItemColor: Colors.white),
    ),

    //
    //

    AppTheme.lightTheme: ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.white,
      brightness: Brightness.light,
      backgroundColor: const Color(0xFFE5E5E5),
      dividerColor: const Color(0xff757575),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black),
        ),
      ),
      textTheme: const TextTheme(
        subtitle1: TextStyle(color: Colors.black),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.grey,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white),
    ),
  };
}
