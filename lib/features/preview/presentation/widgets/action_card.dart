import 'package:flutter/material.dart';

import 'package:yume_app/core/theme/app_colors.dart';

/// Modern minimalist floating action buttons for preview screen
/// Contains both "Set as Wallpaper" and "Download" buttons
class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    this.onDownload,
    this.onSetWallpaper,
    this.showSetWallpaper = true,
  });

  final VoidCallback? onDownload;
  final VoidCallback? onSetWallpaper;
  final bool showSetWallpaper;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Set as Wallpaper button (only show on Android)
        if (showSetWallpaper) ...[
          _ActionButton(
            icon: Icons.wallpaper_rounded,
            label: 'Set',
            onTap: onSetWallpaper,
          ),
          const SizedBox(width: 12),
        ],
        // Download button
        _ActionButton(
          icon: Icons.download_rounded,
          label: 'Save',
          onTap: onDownload,
        ),
      ],
    );
  }
}

/// Individual action button with icon and label
class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 40,
              offset: const Offset(0, 16),
              spreadRadius: -8,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
