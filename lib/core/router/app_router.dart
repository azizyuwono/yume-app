import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yume_app/core/widgets/scaffold_with_nav_bar.dart';
import 'package:yume_app/features/create/presentation/create_screen.dart';
import 'package:yume_app/features/history/presentation/history_screen.dart';
import 'package:yume_app/features/home/presentation/home_screen.dart';
import 'package:yume_app/features/preview/presentation/preview_screen.dart';

/// App route paths
abstract final class AppRoutes {
  static const String home = '/';
  static const String create = '/create';
  static const String history = '/history';
  static const String preview = '/preview';
}

/// Global navigator keys for nested navigation
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter configuration for Yume app with nested navigation
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: <RouteBase>[
    // Main shell with bottom navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Home tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
              ),
            ),
          ],
        ),
        // Create tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.create,
              name: 'create',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const CreateScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
              ),
            ),
          ],
        ),
        // History tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.history,
              name: 'history',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const HistoryScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
              ),
            ),
          ],
        ),
      ],
    ),
    // Preview route (full screen, outside shell)
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.preview,
      name: 'preview',
      pageBuilder: (context, state) {
        final extra = state.extra;
        String? imageUrl;
        String? wallpaperId;

        if (extra is Map<String, dynamic>) {
          imageUrl = extra['imageUrl'] as String?;
          wallpaperId = extra['id'] as String?;
        } else if (extra is String) {
          imageUrl = extra;
        }

        return CustomTransitionPage(
          key: state.pageKey,
          child: PreviewScreen(imageUrl: imageUrl, wallpaperId: wallpaperId),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
        );
      },
    ),
  ],
);
