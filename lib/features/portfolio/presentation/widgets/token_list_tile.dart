import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/components/rainbow_token_asset_row.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/token_asset.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/utils/format_percent.dart';

class TokenListTile extends StatelessWidget {
  const TokenListTile({
    super.key,
    required this.token,
    required this.onTap,
  });

  final TokenAsset token;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final seed = token.symbol.hashCode;
    final p = token.percentChange24h;
    final positive = p == null ? (seed.isEven) : p >= 0;

    return RainbowTokenAssetRow(
      sparklineSeed: seed,
      percentIsPositive: positive,
      percentLabel: formatPercentChange(p),
      sparklineValues: token.sparklinePoints,
      leading: Container(
        width: 46.w,
        height: 46.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              token.accentColor.withValues(alpha: 0.5),
              token.accentColor.withValues(alpha: 0.14),
            ],
          ),
          border: Border.all(color: AppColors.borderGlass),
        ),
        alignment: Alignment.center,
        child: Text(
          token.symbol.length >= 2 ? token.symbol.substring(0, 2) : token.symbol,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.label,
              ),
        ),
      ),
      title: token.name,
      subtitle: '${token.balanceDisplay} ${token.symbol}',
      trailingPrimary: token.fiatDisplay,
      onTap: onTap,
    );
  }
}
