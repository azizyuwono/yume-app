import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yume_app/core/router/app_router.dart';
import 'package:yume_app/core/theme/app_colors.dart';
import 'package:yume_app/core/theme/theme_provider.dart';
import 'package:yume_app/core/widgets/sliver_shimmer_grid.dart';
import 'package:yume_app/features/home/presentation/home_providers.dart';
import 'package:yume_app/features/home/presentation/widgets/category_chips.dart';
import 'package:yume_app/features/home/presentation/widgets/wallpaper_card.dart';

/// Home Screen - Zen Gallery with masonry grid and animations
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0, 0.6, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final wallpapers = ref.watch(filteredWallpapersProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Responsive grid columns based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900
        ? 4
        : screenWidth > 600
        ? 3
        : 2;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Enhanced Refresh Indicator for smoother experience
      body: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.mediumImpact();
          // Ensure at least some delay for visual feedback
          await Future.delayed(const Duration(milliseconds: 1000));
          // Invalidate both providers for complete refresh
          ref.invalidate(featuredWallpapersProvider);
          ref.invalidate(filteredWallpapersProvider);
        },
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        displacement: 20,
        edgeOffset: MediaQuery.of(context).padding.top + 60,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Floating SliverAppBar with animation
            SliverAppBar(
              floating: true,
              snap: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              expandedHeight: 100,
              actions: [
                // Theme toggle button
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(themeModeProvider.notifier).toggleTheme();
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          RotationTransition(
                            turns: Tween<double>(
                              begin: 0,
                              end: 1,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                      child: Icon(
                        themeMode == ThemeMode.dark ||
                                (themeMode == ThemeMode.system && isDark)
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        key: ValueKey(isDark),
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SlideTransition(
                      position: _titleSlide,
                      child: FadeTransition(
                        opacity: _titleFade,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Yume',
                                  style: GoogleFonts.cinzel(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const Gap(12),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'インスピレーション',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.grey500,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Category chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                child: CategoryChipsRow(
                  selectedCategory: selectedCategory,
                  onCategorySelected: (category) {
                    ref
                        .read(selectedCategoryProvider.notifier)
                        .select(category);
                  },
                ),
              ),
            ),

            // Masonry Grid Gallery with staggered animation
            wallpapers.when(
              data: (data) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childCount: data.length,
                  itemBuilder: (context, index) {
                    final wallpaper = data[index];
                    return WallpaperCard(
                      wallpaper: wallpaper,
                      animationDelay: Duration(
                        milliseconds: 100 + (index * 50),
                      ),
                      onTap: () {
                        // Pass wallpaper data as map for Hero tag matching
                        context.push(
                          AppRoutes.preview,
                          extra: {
                            'imageUrl': wallpaper.imageUrl,
                            'id': wallpaper.id,
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              loading: () => SliverShimmerGrid(crossAxisCount: crossAxisCount),
              error: (error, stack) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const Gap(16),
                      Text(
                        'Failed to load dreams',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const Gap(24),
                      FilledButton.icon(
                        onPressed: () {
                          ref.invalidate(featuredWallpapersProvider);
                          ref.invalidate(filteredWallpapersProvider);
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: Gap(100)),
          ],
        ),
      ),
    );
  }
}
