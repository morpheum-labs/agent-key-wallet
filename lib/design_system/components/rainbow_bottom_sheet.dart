import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/blurs.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

/// Glass + blur modal sheet (Rainbow-style). Use [builder] for the inner body; call
/// `Navigator.of(sheetContext).pop()` from actions.
Future<T?> showRainbowModalBottomSheet<T>({
  required BuildContext context,
  String? title,
  required Widget Function(BuildContext sheetContext) builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.scrim.withValues(alpha: 0.5),
    builder: (modalContext) {
      final bottomInset = MediaQuery.viewInsetsOf(modalContext).bottom;
      final maxH = MediaQuery.sizeOf(modalContext).height * 0.92;

      return Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(RainbowRadius.xxl.r),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: RainbowBlur.sheet,
                sigmaY: RainbowBlur.sheet,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.borderGlass),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.surfacePrimary.withValues(alpha: 0.94),
                      AppColors.background.withValues(alpha: 0.98),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 28,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxH),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: RainbowSpacing.md.h),
                          child: Center(
                            child: Container(
                              width: 40.w,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: AppColors.labelSecondary.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        if (title != null)
                          Padding(
                            padding: EdgeInsets.only(
                              left: RainbowSpacing.xxl.w,
                              right: RainbowSpacing.xxl.w,
                              bottom: RainbowSpacing.sm.h,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                title,
                                style: Theme.of(modalContext).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.4,
                                    ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: RainbowSpacing.xxl.w,
                            right: RainbowSpacing.xxl.w,
                            bottom: RainbowSpacing.xxl.h,
                          ),
                          child: builder(modalContext),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
