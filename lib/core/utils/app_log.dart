import 'package:flutter/foundation.dart';

/// Simple logging utility for debugging
/// Only logs in debug mode, no output in release builds
abstract final class AppLog {
  // Prevent instantiation
  const AppLog._();

  /// Debug log (informational)
  static void d(String message, [String? tag]) {
    if (kDebugMode) {
      print('🔵 ${tag != null ? '[$tag] ' : ''}$message');
    }
  }

  /// Error log
  static void e(String message, [Object? error, String? tag]) {
    if (kDebugMode) {
      print('🔴 ${tag != null ? '[$tag] ' : ''}$message ${error ?? ""}');
    }
  }

  /// Warning log
  static void w(String message, [String? tag]) {
    if (kDebugMode) {
      print('🟡 ${tag != null ? '[$tag] ' : ''}$message');
    }
  }

  /// Info log
  static void i(String message, [String? tag]) {
    if (kDebugMode) {
      print('ℹ️  ${tag != null ? '[$tag] ' : ''}$message');
    }
  }
}
