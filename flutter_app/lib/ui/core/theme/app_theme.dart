import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static const SystemUiOverlayStyle darkOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0xFF0C0A09),
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static const SystemUiOverlayStyle lightOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFFF6F5F2),
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static SystemUiOverlayStyle get currentOverlayStyle =>
      AppColors.isLight ? lightOverlayStyle : darkOverlayStyle;

  static ThemeData buildDarkTheme(Locale locale) {
    final isArabic = locale.languageCode == 'ar';
    final fontFamily = isArabic ? 'Cairo' : 'Inter';

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: const Color(0xFF0C0A09),
      canvasColor: const Color(0xFF0C0A09),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: Color(0xFFA78BFA),
        surface: Color(0xF51F1C1A),
        error: AppColors.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFFFAFAF9),
        onError: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFFA78BFA),
        selectionColor: Color(0x558B5CF6),
        selectionHandleColor: AppColors.primary,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData buildLightTheme(Locale locale) {
    final isArabic = locale.languageCode == 'ar';
    final fontFamily = isArabic ? 'Cairo' : 'Inter';

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: const Color(0xFFF6F5F2),
      canvasColor: const Color(0xFFF6F5F2),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryDark,
        secondary: AppColors.primary,
        surface: Color(0xFFFFFFFF),
        error: AppColors.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1C1917),
        onError: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primaryDark,
        selectionColor: Color(0x388B5CF6),
        selectionHandleColor: AppColors.primaryDark,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
