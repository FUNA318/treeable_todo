import 'package:app/components/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'colors.dart';
import 'routes.dart';
import 'components/pages/login.dart';
import 'components/pages/signup.dart';
import 'components/providers/auth_user.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

CustomTransitionPage buildPageWithoutAnimation({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) => child,
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authUserProvider);

  return GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(path: Routes.home, builder: (context, state) => const HomePage()),
      GoRoute(
        path: Routes.signup,
        pageBuilder:
            (context, state) => buildPageWithoutAnimation(
              child: SignupPage(),
              context: context,
              state: state,
            ),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder:
            (context, state) => buildPageWithoutAnimation(
              child: LoginPage(),
              context: context,
              state: state,
            ),
      ),
    ],
    redirect: (context, state) async {
      if (state.fullPath == '/signup' || state.fullPath == '/login') {
        return null;
      }
      if (authState == null) ref.read(authUserProvider.notifier).fetchUser();
      return authState != null ? null : Routes.login;
    },
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      title: 'Todo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Noto Sans JP',
        colorScheme: const ColorScheme.light(
          primary: ThemeColors.primary,
          onPrimary: ThemeColors.onPrimary,
          primaryContainer: ThemeColors.primaryContainer,
          onPrimaryContainer: ThemeColors.onPrimaryContainer,
          secondary: ThemeColors.secondary,
          onSecondary: ThemeColors.onSecondary,
          secondaryContainer: ThemeColors.secondaryContainer,
          onSecondaryContainer: ThemeColors.onSecondaryContainer,
          tertiary: ThemeColors.teritary,
          tertiaryContainer: ThemeColors.teritaryContainer,
          onTertiary: ThemeColors.onTeritary,
          onTertiaryContainer: ThemeColors.onTeritaryContainer,
          surface: ThemeColors.surface,
          onSurface: ThemeColors.onSurface,
          error: ThemeColors.error,
          onError: ThemeColors.onError,
          errorContainer: ThemeColors.errorContainer,
          onErrorContainer: ThemeColors.onErrorContainer,
          outline: ThemeColors.outline,
        ),
      ),
    );
  }
}
