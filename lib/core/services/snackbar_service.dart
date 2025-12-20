import 'dart:collection';

import 'package:flutter/material.dart';

/// Modern minimalist SnackBar service with queue system
class SnackBarService {
  static final SnackBarService _instance = SnackBarService._internal();
  factory SnackBarService() => _instance;
  SnackBarService._internal();

  final Queue<_SnackBarItem> _queue = Queue();
  bool _isShowing = false;

  /// Show a success snackbar
  void showSuccess(BuildContext context, String message) {
    _enqueue(context, message, SnackBarType.success);
  }

  /// Show an error snackbar
  void showError(BuildContext context, String message) {
    // Log error for debugging
    debugPrint('🔴 SnackBar Error: $message');
    _enqueue(context, message, SnackBarType.error);
  }

  /// Show an info snackbar
  void showInfo(BuildContext context, String message) {
    _enqueue(context, message, SnackBarType.info);
  }

  void _enqueue(
    BuildContext context,
    String message,
    SnackBarType type, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _queue.add(
      _SnackBarItem(
        context: context,
        message: message,
        type: type,
        duration: duration,
      ),
    );

    if (!_isShowing) {
      _showNext();
    }
  }

  void _showNext() {
    if (_queue.isEmpty) {
      _isShowing = false;
      return;
    }

    _isShowing = true;
    final item = _queue.removeFirst();

    if (!item.context.mounted) {
      _showNext();
      return;
    }

    // Modern minimalist snackbar design
    final snackBar = SnackBar(
      content: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: _getColor(item.type),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Icon(_getIcon(item.type), color: _getColor(item.type), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.message,
              style: const TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.06), width: 1),
      ),
      duration: item.duration,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );

    ScaffoldMessenger.of(item.context).showSnackBar(snackBar).closed.then((_) {
      Future.delayed(const Duration(milliseconds: 300), _showNext);
    });
  }

  IconData _getIcon(SnackBarType type) {
    return switch (type) {
      SnackBarType.success => Icons.check_circle_rounded,
      SnackBarType.error => Icons.error_rounded,
      SnackBarType.info => Icons.info_rounded,
    };
  }

  Color _getColor(SnackBarType type) {
    return switch (type) {
      SnackBarType.success => const Color(0xFF10B981),
      SnackBarType.error => const Color(0xFFEF4444),
      SnackBarType.info => const Color(0xFF6366F1),
    };
  }

  void clear() {
    _queue.clear();
  }
}

enum SnackBarType { success, error, info }

class _SnackBarItem {
  final BuildContext context;
  final String message;
  final SnackBarType type;
  final Duration duration;

  _SnackBarItem({
    required this.context,
    required this.message,
    required this.type,
    required this.duration,
  });
}
