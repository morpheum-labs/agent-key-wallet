import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

/// Large centered balance: numeric [balanceText] values tween with an elastic curve;
/// loading / error strings use a soft [AnimatedSwitcher].
class RainbowBalanceHero extends StatefulWidget {
  const RainbowBalanceHero({
    super.key,
    required this.caption,
    required this.balanceText,
    required this.footer,
  });

  final String caption;
  final String balanceText;
  final String footer;

  @override
  State<RainbowBalanceHero> createState() => _RainbowBalanceHeroState();
}

/// Alias for docs / parity with Rainbow naming — same widget as [RainbowBalanceHero].
typedef RainbowBalanceHeader = RainbowBalanceHero;

class _RainbowBalanceHeroState extends State<RainbowBalanceHero> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _amountAnimation;
  double? _lastEnd;
  String _symbol = '';

  static const _animDuration = Duration(milliseconds: 780);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _animDuration);
    final p = _parseAmount(widget.balanceText);
    if (p != null) {
      _lastEnd = p.$1;
      _symbol = p.$2;
      _amountAnimation = Tween<double>(begin: p.$1, end: p.$1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      );
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant RainbowBalanceHero oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newP = _parseAmount(widget.balanceText);
    final oldP = _parseAmount(oldWidget.balanceText);
    if (newP == null) {
      _lastEnd = null;
      return;
    }
    _symbol = newP.$2;
    // First real value after loading: animate from 0; updates: from previous amount.
    final from = oldP?.$1 ?? _lastEnd ?? 0.0;
    final to = newP.$1;
    if ((from - to).abs() < 1e-18) return;
    _amountAnimation = Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward(from: 0);
    _lastEnd = to;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final parsed = _parseAmount(widget.balanceText);

    final balanceStyle = textTheme.displayLarge?.copyWith(
      fontSize: 48.sp,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.2,
      height: 1.02,
      color: Colors.white,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.caption,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            color: AppColors.labelSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: RainbowSpacing.md.h),
        if (parsed == null || _amountAnimation == null)
          _SwitcherBalance(
            balanceText: widget.balanceText,
            balanceStyle: balanceStyle,
          )
        else
          AnimatedBuilder(
            animation: _amountAnimation!,
            builder: (context, _) {
              final formatted = _formatAnimatedAmount(_amountAnimation!.value);
              return _GradientBalanceText(
                text: '$formatted $_symbol',
                style: balanceStyle,
              );
            },
          ),
        SizedBox(height: RainbowSpacing.sm.h),
        Text(
          widget.footer,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            fontSize: 12.5.sp,
            color: AppColors.labelSecondary,
          ),
        ),
      ],
    );
  }
}

class _SwitcherBalance extends StatelessWidget {
  const _SwitcherBalance({
    required this.balanceText,
    required this.balanceStyle,
  });

  final String balanceText;
  final TextStyle? balanceStyle;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.elasticOut,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.elasticOut),
            ),
            child: child,
          ),
        );
      },
      child: _GradientBalanceText(
        key: ValueKey<String>(balanceText),
        text: balanceText,
        style: balanceStyle,
      ),
    );
  }
}

/// Large balance digits with semantic accent gradient (Rainbow-style).
class _GradientBalanceText extends StatelessWidget {
  const _GradientBalanceText({
    super.key,
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => RainbowGradients.accentRibbon().createShader(bounds),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}

/// Returns `(amount, symbol)` when [s] is like `12.34 ETH`; otherwise null.
({double amount, String symbol})? _parseAmount(String s) {
  final t = s.trim();
  if (t.isEmpty) return null;
  if (t == '…' || t == '...' || t == 'Unavailable' || t == '—') return null;

  final i = t.lastIndexOf(' ');
  if (i <= 0) return null;
  final numPart = t.substring(0, i).trim();
  final sym = t.substring(i + 1).trim();
  if (sym.isEmpty) return null;
  final n = double.tryParse(numPart.replaceAll(',', ''));
  if (n == null) return null;
  return (amount: n, symbol: sym);
}

String _formatAnimatedAmount(double v) {
  if (v == 0) return '0';
  final s = v.toStringAsFixed(8);
  return s.replaceFirst(RegExp(r'\.?0+$'), '');
}
