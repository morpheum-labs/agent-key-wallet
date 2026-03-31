import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SF Pro Rounded on iOS; [Nunito](https://fonts.google.com/specimen/Nunito) elsewhere (rounded, readable).
abstract final class RainbowTypography {
  static const String _iosRounded = '.SF Pro Rounded';
  static const String _fallbackRounded = 'Nunito';

  static bool get _useSfProRounded =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// For [ThemeData.fontFamily] so inputs and default text pick up the rounded stack.
  static String? get fontFamily =>
      _useSfProRounded ? _iosRounded : _fallbackRounded;

  static TextTheme textTheme(Color primary, Color secondary) {
    TextStyle base({
      double fontSize = 16,
      FontWeight weight = FontWeight.w400,
      double height = 1.35,
      double letterSpacing = 0,
      Color? color,
    }) {
      if (_useSfProRounded) {
        return TextStyle(
          fontFamily: _iosRounded,
          fontSize: fontSize,
          fontWeight: weight,
          height: height,
          letterSpacing: letterSpacing,
          color: color ?? primary,
        );
      }
      return GoogleFonts.nunito(
        fontSize: fontSize,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color ?? primary,
      );
    }

    return TextTheme(
      displayLarge: base(
        fontSize: 34,
        weight: FontWeight.w700,
        letterSpacing: -0.6,
        color: primary,
      ),
      displayMedium: base(
        fontSize: 28,
        weight: FontWeight.w700,
        letterSpacing: -0.5,
        color: primary,
      ),
      displaySmall: base(
        fontSize: 24,
        weight: FontWeight.w700,
        letterSpacing: -0.4,
        color: primary,
      ),
      headlineMedium: base(
        fontSize: 20,
        weight: FontWeight.w600,
        letterSpacing: -0.3,
        color: primary,
      ),
      headlineSmall: base(
        fontSize: 18,
        weight: FontWeight.w600,
        letterSpacing: -0.25,
        color: primary,
      ),
      titleLarge: base(
        fontSize: 22,
        weight: FontWeight.w600,
        letterSpacing: -0.3,
        color: primary,
      ),
      titleMedium: base(
        fontSize: 17,
        weight: FontWeight.w600,
        letterSpacing: -0.2,
        color: primary,
      ),
      bodyLarge: base(
        fontSize: 17,
        weight: FontWeight.w500,
        height: 1.35,
        color: primary,
      ),
      bodyMedium: base(
        fontSize: 15,
        weight: FontWeight.w500,
        height: 1.4,
        color: secondary,
      ),
      bodySmall: base(
        fontSize: 13,
        weight: FontWeight.w500,
        height: 1.38,
        color: secondary,
      ),
      labelLarge: base(
        fontSize: 15,
        weight: FontWeight.w600,
        height: 1.2,
        color: primary,
      ),
      labelMedium: base(
        fontSize: 13,
        weight: FontWeight.w600,
        height: 1.25,
        color: secondary,
      ),
      labelSmall: base(
        fontSize: 11,
        weight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.2,
        color: secondary,
      ),
    );
  }
}
