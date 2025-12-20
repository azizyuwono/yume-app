import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// Theme mode notifier for managing app theme (light/dark/system)
/// Persists user preference in Hive storage
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const String _boxName = 'settings';
  static const String _key = 'theme_mode';

  @override
  ThemeMode build() {
    return _loadThemeMode();
  }

  /// Load theme mode from Hive storage
  ThemeMode _loadThemeMode() {
    try {
      final box = Hive.box<String>(_boxName);
      final value = box.get(_key, defaultValue: 'system');
      return _stringToThemeMode(value!);
    } catch (_) {
      return ThemeMode.system;
    }
  }

  /// Set theme mode and persist to storage
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final box = Hive.box<String>(_boxName);
      await box.put(_key, _themeModeToString(mode));
    } catch (_) {
      // Silently fail if storage is unavailable
    }
  }

  /// Toggle between light and dark mode
  void toggleTheme() {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.dark,
    };
    setThemeMode(newMode);
  }

  /// Convert string to ThemeMode
  ThemeMode _stringToThemeMode(String value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Convert ThemeMode to string
  String _themeModeToString(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }
}
