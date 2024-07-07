import 'package:flutter/material.dart';

class MyTheme {
  static Color primaryLight = Color(0xff3660D9);
  static Color blueGrey = Color(0xff32384AFF);
  static Color primaryDark = Color(0xff121212);
  static Color secondaryDark = Color(0xff1B1B1B);
  static Color whiteColor = Colors.white;
  static Color blackColor = Colors.black;
  static Color redColor = Color(0xffFF5353);
  static Color greenColor = Color(0xff40B567);
  static Color lightGreenColor = Color(0xffAAF0C1);
  static Color orangeColor = Color(0xffFF7A00);
  static Color purpleColor = Color(0xff4700A1);
  static Color darkBlueColor = Color(0xff00289C);
  static Color lightBlueColor = Color(0xff507DFF);
  static Color selectedIconBlueColor = Color(0xffB4C9FF);
  static Color lightPinkColor = Color(0xffD9D5FF);
  static Color backgroundButtonColor = Color(0xffD3DEFF);
  static Color turquoiseColor = Color(0xff39AEB7);
  static Color lightTurquoiseColor = Color(0xff50BACB);
  static Color darkTurquoiseColor = Color(0xff3E9C92);
  static Color darkPinkColor = Color(0xff485883);


  static ThemeData LightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    primaryColor: primaryLight,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: blackColor,
        fontFamily: 'El Messiri',
      ),
      titleMedium: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        color: blackColor,
        fontFamily: 'El Messiri',
      ),
      titleSmall: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w400,
        color: blackColor,
        fontFamily: 'El Messiri',
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: primaryLight,
      type: BottomNavigationBarType.shifting,
      landscapeLayout: BottomNavigationBarLandscapeLayout.linear,



    ),
  );

  static ThemeData DarkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    primaryColor: primaryDark,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: blackColor,
        fontFamily: 'El Messiri',
      ),
      titleMedium: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        color: blackColor,
        fontFamily: 'El Messiri',
      ),
      titleSmall: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w400,
        color: blackColor,
        fontFamily: 'El Messiri',
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: selectedIconBlueColor,
      unselectedItemColor: primaryLight,
    ),
  );
}
