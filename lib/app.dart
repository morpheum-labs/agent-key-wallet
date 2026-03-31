import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rainbow_flutter/core/di/injection.dart';
import 'package:rainbow_flutter/core/router/app_router.dart';
import 'package:rainbow_flutter/core/theme/app_theme.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';

class RainbowApp extends StatefulWidget {
  const RainbowApp({super.key});

  @override
  State<RainbowApp> createState() => _RainbowAppState();
}

class _RainbowAppState extends State<RainbowApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(walletRepository: getIt())
      ..add(const AuthStarted());
    _router = createAppRouter(
      authBloc: _authBloc,
      navigatorKey: _navigatorKey,
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _authBloc,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        routerConfig: _router,
        builder: (context, child) {
          return BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) => current is AuthError,
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
