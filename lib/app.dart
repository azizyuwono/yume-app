import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yume_app/core/router/app_router.dart';
import 'package:yume_app/core/theme/theme.dart';
import 'package:yume_app/core/theme/theme_provider.dart';

/// Yume App - AI Wallpaper Generator
/// Japanese Minimalist Design with Dark Mode support
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Yume',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
