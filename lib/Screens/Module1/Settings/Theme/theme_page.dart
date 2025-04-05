import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0XFFFFFFFF),
    onBackground: Color(0XFFF9FFF9),
    primary: Color(0XFF0EA102),
    onPrimary: Color(0XFF000000),
    secondary: Color(0XFF2A2727),
    tertiary: Color(0XFFEEEEEE),
    onTertiary: Color(0XFF02A155),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0XFFFFFFFF),
    elevation: 0.0,
    titleTextStyle: TextStyle(
      fontSize: textScalarMain!.scale(24),
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    surfaceTintColor: const Color(0XFFFFFFFF),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: textScalarMain!.scale(24),
      fontWeight: FontWeight.w700,
      color: const Color(0XFF2A2727),
      overflow: TextOverflow.ellipsis,
    ),
    titleMedium: TextStyle(
      fontSize: textScalarMain!.scale(18),
      fontWeight: FontWeight.w700,
      color: const Color(0XFF2A2727),
      overflow: TextOverflow.ellipsis,
    ),
    titleSmall: TextStyle(
      fontSize: textScalarMain!.scale(16),
      fontWeight: FontWeight.w700,
      color: const Color(0XFF2A2727),
      overflow: TextOverflow.ellipsis,
    ),
    bodyLarge: TextStyle(
      fontSize: textScalarMain!.scale(14),
      fontWeight: FontWeight.w700,
      color: const Color(0XFF2A2727),
      overflow: TextOverflow.ellipsis,
    ),
    bodyMedium: TextStyle(
      fontSize: textScalarMain!.scale(14),
      fontWeight: FontWeight.w500,
      color: const Color(0XFF2A2727),
      overflow: TextOverflow.ellipsis,
    ),
    bodySmall: TextStyle(
      fontSize: textScalarMain!.scale(12),
      fontWeight: FontWeight.w500,
      color: const Color(0XFF2A2727),
      overflow: TextOverflow.ellipsis,
    ),
    labelLarge: TextStyle(
      fontSize: textScalarMain!.scale(12),
      fontWeight: FontWeight.w600,
      color: const Color(0XFF2A2727),
      overflow: TextOverflow.ellipsis,
    ),
    labelMedium: TextStyle(
      fontSize: textScalarMain!.scale(10),
      fontWeight: FontWeight.w600,
      color: const Color(0XFF2A2727),
      overflow: TextOverflow.ellipsis,
    ),
    labelSmall: TextStyle(
      fontSize: textScalarMain!.scale(10),
      fontWeight: FontWeight.w500,
      color: const Color(0XFF2A2727),
      overflow: TextOverflow.ellipsis,
    ),
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStatePropertyAll(Colors.black),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    backgroundColor: Colors.green,
  ),
  checkboxTheme: CheckboxThemeData(
      checkColor: const MaterialStatePropertyAll<Color>(Colors.white),
      fillColor: const MaterialStatePropertyAll<Color>(Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      side: const BorderSide(color: Colors.black, width: 1)),
  fontFamily: 'Poppins',
  useMaterial3: true,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color(0XFF0E0F11),
    onBackground: Color(0XFF303032),
    primary: Color(0XFFFFFFFF),
    onPrimary: Color(0XFFFFFFFF),
    secondary: Color(0XFFE2E2E2),
    tertiary: Color(0XFF303032),
    onTertiary: Color(0XFF626161),
  ),
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontSize: textScalarMain!.scale(24),
        fontWeight: FontWeight.w700,
        color: const Color(0XFFFFFFFF),
      ),
      surfaceTintColor: Colors.black),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: textScalarMain!.scale(24),
      fontWeight: FontWeight.w700,
      color: const Color(0XFFD6D6D6),
      overflow: TextOverflow.ellipsis,
    ),
    titleMedium: TextStyle(
      fontSize: textScalarMain!.scale(18),
      fontWeight: FontWeight.w700,
      color: const Color(0XFFD6D6D6),
      overflow: TextOverflow.ellipsis,
    ),
    titleSmall: TextStyle(
      fontSize: textScalarMain!.scale(16),
      fontWeight: FontWeight.w700,
      color: const Color(0XFFD6D6D6),
      overflow: TextOverflow.ellipsis,
    ),
    bodyLarge: TextStyle(
      fontSize: textScalarMain!.scale(14),
      fontWeight: FontWeight.w700,
      color: const Color(0XFFD6D6D6),
      overflow: TextOverflow.ellipsis,
    ),
    bodyMedium: TextStyle(
      fontSize: textScalarMain!.scale(14),
      fontWeight: FontWeight.w500,
      color: const Color(0XFFD6D6D6),
      overflow: TextOverflow.ellipsis,
    ),
    bodySmall: TextStyle(
      fontSize: textScalarMain!.scale(12),
      fontWeight: FontWeight.w500,
      color: const Color(0XFFD6D6D6),
      overflow: TextOverflow.ellipsis,
    ),
    labelLarge: TextStyle(
      fontSize: textScalarMain!.scale(12),
      fontWeight: FontWeight.w700,
      color: const Color(0XFFD6D6D6),
      overflow: TextOverflow.ellipsis,
    ),
    labelMedium: TextStyle(
      fontSize: textScalarMain!.scale(10),
      fontWeight: FontWeight.w600,
      color: const Color(0XFFD6D6D6),
      overflow: TextOverflow.ellipsis,
    ),
    labelSmall: TextStyle(
      fontSize: textScalarMain!.scale(10),
      fontWeight: FontWeight.w500,
      color: const Color(0XFFD6D6D6),
      overflow: TextOverflow.ellipsis,
    ),
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStatePropertyAll(Color(0XFFFFFFFF)),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    backgroundColor: Colors.green,
  ),
  checkboxTheme: CheckboxThemeData(
      checkColor: const MaterialStatePropertyAll<Color>(Colors.white),
      fillColor: const MaterialStatePropertyAll<Color>(Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      side: const BorderSide(color: Colors.white, width: 1)),
  fontFamily: 'Poppins',
  useMaterial3: true,
);

Rx<ThemeMode> currentTheme = ThemeMode.light.obs;

Rx<bool> isDarkTheme = false.obs;
