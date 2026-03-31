import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rainbow_flutter/core/utils/go_router_refresh.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:rainbow_flutter/features/auth/presentation/pages/create_wallet_page.dart';
import 'package:rainbow_flutter/features/auth/presentation/pages/import_wallet_page.dart';
import 'package:rainbow_flutter/features/auth/presentation/pages/onboarding_page.dart';
import 'package:rainbow_flutter/features/auth/presentation/pages/splash_page.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/pages/home_page.dart';

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
        if (authPaths.contains(path)) return '/home';
        return null;
      }
      if (s is AuthUnauthenticated) {
        if (path == '/splash') return '/onboarding';
        if (path == '/home') return '/onboarding';
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
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
