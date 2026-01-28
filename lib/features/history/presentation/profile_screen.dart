import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:yume_app/core/theme/app_colors.dart';

/// Profile Screen placeholder
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grey200, width: 2),
              ),
              child: const Icon(
                Icons.person_outline,
                size: 48,
                color: AppColors.grey400,
              ),
            ),
            const Gap(24),
            Text('Guest User', style: theme.textTheme.titleLarge),
            const Gap(8),
            Text(
              'Sign in to save your creations',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
