import 'package:rainbow_flutter/design_system/theme.dart';

/// App entry theme — delegates to [RainbowAppTheme].
abstract final class AppTheme {
  static ThemeData dark() => RainbowAppTheme.dark();
}
