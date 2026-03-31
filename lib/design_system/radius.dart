/// Corner radius scale — Rainbow uses a strict 8 / 12 / 16 / 24 px rhythm (plus common pills & sheets).
abstract final class RainbowRadius {
  /// 8px — chips, small controls.
  static const double xs = 8;

  /// 12px — compact rows, small cards.
  static const double sm = 12;

  /// 16px — standard cards, inputs.
  static const double md = 16;

  /// 20px — medium emphasis surfaces.
  static const double lg = 20;

  /// 24px — hero cards, glass panels ([GlassCard] default).
  static const double xl = 24;

  /// 32px — large sheets, prominent modules.
  static const double xxl = 32;

  /// Fully rounded ends (capsule / pill).
  static const double full = 999;
}
