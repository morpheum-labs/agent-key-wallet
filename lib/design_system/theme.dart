import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'theme_extension.dart';
import 'typography.dart';

abstract final class RainbowAppTheme {
  static ThemeData dark() {
    final base = RainbowTypography.textTheme(AppColors.label, AppColors.labelSecondary);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentSecondary,
        surface: AppColors.surfacePrimary,
        onPrimary: AppColors.label,
        onSecondary: AppColors.label,
        onSurface: AppColors.label,
      ),
      textTheme: base,
      extensions: const [RainbowThemeExtension.dark],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: base.bodyLarge,
      ),
      dividerColor: AppColors.borderGlass,
    );
  }
}
