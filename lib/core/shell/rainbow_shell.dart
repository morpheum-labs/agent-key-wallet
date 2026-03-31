import 'package:flutter/material.dart';

import 'package:rainbow_flutter/design_system/components/rainbow_bottom_tab_bar.dart';

/// Main tab shell: body is [StatefulNavigationShell].
class RainbowShell extends StatelessWidget {
  const RainbowShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final idx = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: RainbowBottomTabBar(
        currentIndex: idx,
        onTap: navigationShell.goBranch,
      ),
    );
  }
}
