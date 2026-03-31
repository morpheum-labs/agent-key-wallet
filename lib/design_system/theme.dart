import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'radius.dart';
import 'theme_extension.dart';
import 'typography.dart';

/// Full dark [ThemeData] + Rainbow tokens via [RainbowThemeExtension].
abstract final class RainbowAppTheme {
  static ThemeData dark() {
    final base = RainbowTypography.textTheme(AppColors.label, AppColors.labelSecondary);

    final colorScheme = ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.accentSecondary,
      surface: AppColors.surfacePrimary,
      onPrimary: AppColors.label,
      onSecondary: AppColors.label,
      onSurface: AppColors.label,
      error: AppColors.error,
      onError: AppColors.label,
    ).copyWith(
      surfaceContainerHighest: AppColors.surfaceElevated,
      onSurfaceVariant: AppColors.labelSecondary,
      outline: AppColors.borderStrong,
      outlineVariant: AppColors.borderGlass,
      scrim: AppColors.scrim,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: RainbowTypography.fontFamily,
      applyElevationOverlayColor: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: colorScheme,
      textTheme: base,
      primaryColor: AppColors.accent,
      extensions: const [RainbowThemeExtension.dark],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: base.bodyLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RainbowRadius.md),
        ),
      ),
      dividerColor: AppColors.borderGlass,
      dividerTheme: const DividerThemeData(
        color: AppColors.borderGlass,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfacePrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RainbowRadius.lg),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RainbowRadius.xl),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceSecondary,
        elevation: 0,
        modalBackgroundColor: AppColors.surfaceSecondary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(RainbowRadius.xl),
          ),
        ),
        dragHandleColor: AppColors.labelSecondary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.labelSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: AppColors.accent.withValues(alpha: 0.22),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.accent : AppColors.labelSecondary,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return (selected ? base.labelSmall?.copyWith(fontWeight: FontWeight.w600) : base.labelSmall)
              ?.copyWith(color: selected ? AppColors.label : AppColors.labelSecondary);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.label,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RainbowRadius.md),
          ),
          textStyle: base.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.label,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RainbowRadius.md),
          ),
          textStyle: base.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.label,
          side: const BorderSide(color: AppColors.borderGlass),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RainbowRadius.md),
          ),
          textStyle: base.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentSecondary,
          textStyle: base.labelLarge,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.label,
        size: 24,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.labelSecondary,
        textColor: AppColors.label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RainbowRadius.md),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.label,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RainbowRadius.lg),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accentSecondary,
        linearTrackColor: AppColors.surfaceElevated,
        circularTrackColor: AppColors.surfaceElevated,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RainbowRadius.md),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RainbowRadius.md),
          borderSide: const BorderSide(color: AppColors.borderGlass),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RainbowRadius.md),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RainbowRadius.md),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RainbowRadius.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: base.bodyMedium,
        hintStyle: base.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceElevated,
        deleteIconColor: AppColors.labelSecondary,
        disabledColor: AppColors.surfacePrimary,
        selectedColor: AppColors.accent.withValues(alpha: 0.25),
        secondarySelectedColor: AppColors.accentSecondary.withValues(alpha: 0.25),
        labelStyle: base.labelMedium!,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RainbowRadius.xs),
        ),
        side: const BorderSide(color: AppColors.borderGlass),
        brightness: Brightness.dark,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.label,
        unselectedLabelColor: AppColors.labelSecondary,
        indicatorColor: AppColors.accent,
        labelStyle: base.labelLarge,
        unselectedLabelStyle: base.bodyMedium,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
