import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rainbow_flutter/core/shell/rainbow_shell.dart';
import 'package:rainbow_flutter/core/utils/go_router_refresh.dart';
import 'package:rainbow_flutter/features/activity/presentation/pages/activity_page.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:rainbow_flutter/features/auth/presentation/pages/create_wallet_page.dart';
import 'package:rainbow_flutter/features/auth/presentation/pages/import_wallet_page.dart';
import 'package:rainbow_flutter/features/auth/presentation/pages/onboarding_page.dart';
import 'package:rainbow_flutter/features/auth/presentation/pages/splash_page.dart';
import 'package:rainbow_flutter/features/discover/presentation/pages/discover_page.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/pages/home_page.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/pages/receive_page.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/pages/send_page.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/pages/token_detail_page.dart';
import 'package:rainbow_flutter/features/profile/presentation/pages/profile_page.dart';

bool _isShellPath(String path) {
  const bases = ['/wallet', '/discover', '/activity', '/profile'];
  for (final b in bases) {
    if (path == b || path.startsWith('$b/')) return true;
  }
  return path == '/home';
}

GoRouter createAppRouter({
  required AuthBloc authBloc,
  required GlobalKey<NavigatorState> navigatorKey,
}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final s = authBloc.state;
      final path = state.uri.path;

      if (s is AuthLoading) {
        if (path != '/splash') return '/splash';
        return null;
      }
      if (s is AuthAuthenticated) {
        const authPaths = ['/splash', '/onboarding', '/create', '/import'];
        if (authPaths.contains(path)) return '/wallet';
        if (path == '/home') return '/wallet';
        return null;
      }
      if (s is AuthUnauthenticated) {
        if (path == '/splash') return '/onboarding';
        if (_isShellPath(path)) return '/onboarding';
        return null;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/create',
        builder: (context, state) => const CreateWalletPage(),
      ),
      GoRoute(
        path: '/import',
        builder: (context, state) => const ImportWalletPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return RainbowShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallet',
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'token/:symbol',
                    parentNavigatorKey: navigatorKey,
                    builder: (context, state) => TokenDetailPage(
                      symbol: state.pathParameters['symbol']!,
                    ),
                  ),
                  GoRoute(
                    path: 'receive',
                    parentNavigatorKey: navigatorKey,
                    builder: (context, state) => const ReceivePage(),
                  ),
                  GoRoute(
                    path: 'send',
                    parentNavigatorKey: navigatorKey,
                    builder: (context, state) => const SendPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/discover',
                builder: (context, state) => const DiscoverPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/activity',
                builder: (context, state) => const ActivityPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
