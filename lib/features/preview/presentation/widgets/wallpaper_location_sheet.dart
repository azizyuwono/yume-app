import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/wallpaper_service.dart';
import '../../../../core/theme/app_colors.dart';

/// Bottom sheet for selecting wallpaper location (Home/Lock/Both)
class WallpaperLocationSheet extends StatelessWidget {
  const WallpaperLocationSheet({super.key, required this.onLocationSelected});

  final void Function(WallpaperLocation location) onLocationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Center(
            child: Text(
              'Set as Wallpaper',
              style: GoogleFonts.cinzel(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Choose where to apply this wallpaper',
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.grey500),
            ),
          ),
          const SizedBox(height: 24),

          // Location options
          _LocationOption(
            icon: Icons.home_rounded,
            title: 'Home Screen',
            subtitle: 'Set as your home screen wallpaper',
            onTap: () {
              Navigator.pop(context);
              onLocationSelected(WallpaperLocation.homeScreen);
            },
          ),
          const SizedBox(height: 12),
          _LocationOption(
            icon: Icons.lock_rounded,
            title: 'Lock Screen',
            subtitle: 'Set as your lock screen wallpaper',
            onTap: () {
              Navigator.pop(context);
              onLocationSelected(WallpaperLocation.lockScreen);
            },
          ),
          const SizedBox(height: 12),
          _LocationOption(
            icon: Icons.smartphone_rounded,
            title: 'Both Screens',
            subtitle: 'Set as home and lock screen wallpaper',
            onTap: () {
              Navigator.pop(context);
              onLocationSelected(WallpaperLocation.both);
            },
          ),
        ],
      ),
    );
  }
}

/// Individual location option tile
class _LocationOption extends StatelessWidget {
  const _LocationOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.darkSurfaceVariant : AppColors.grey100,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey700 : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.grey400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
