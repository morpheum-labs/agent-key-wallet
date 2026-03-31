import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// SF Pro Rounded on iOS; [Nunito](https://fonts.google.com/specimen/Nunito) elsewhere (rounded, readable).
abstract final class RainbowTypography {
  static const String _iosRounded = '.SF Pro Rounded';

  static bool get _useSfProRounded =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

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
    );
  }
}
