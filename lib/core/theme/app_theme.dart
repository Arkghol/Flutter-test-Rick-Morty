import 'package:flutter/material.dart';

import 'package:r_m_list/core/theme/app_colors.dart';
import 'package:r_m_list/core/theme/app_dimensions.dart';

class AppTheme {
  AppTheme._();

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seedColor),
    cardTheme: const CardThemeData(
      elevation: 2,
      margin: AppDimensions.cardMargin,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      brightness: Brightness.dark,
    ),
    cardTheme: const CardThemeData(
      elevation: 2,
      margin: AppDimensions.cardMargin,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}
