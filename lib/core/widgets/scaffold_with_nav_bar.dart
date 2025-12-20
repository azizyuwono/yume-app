import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

/// Floating Glass Navbar with blur effect and animated icons
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true, // Content extends behind navbar
      body: navigationShell,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: SafeArea(
          bottom: false,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).cardColor.withValues(alpha: isDark ? 0.7 : 0.8),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavBarItem(
                      icon: Icons.home_rounded,
                      activeIcon: Icons.home_rounded,
                      isActive: navigationShell.currentIndex == 0,
                      onTap: () => navigationShell.goBranch(0),
                    ),
                    _NavBarItem(
                      icon: Icons.add_circle_outline_rounded,
                      activeIcon: Icons.add_circle_rounded,
                      isActive: navigationShell.currentIndex == 1,
                      onTap: () => navigationShell.goBranch(1),
                    ),
                    _NavBarItem(
                      icon: Icons.history_rounded,
                      activeIcon: Icons.history_rounded,
                      isActive: navigationShell.currentIndex == 2,
                      onTap: () => navigationShell.goBranch(2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated Nav Item with Fluid effect
/// Animated Nav Item with Fluid effect
class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic, // Smoother than elasticOut
            padding: EdgeInsets.symmetric(
              horizontal: isActive ? 20 : 12,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? activeColor.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: Tween<double>(begin: 0.85, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                size: isActive ? 26 : 24,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
