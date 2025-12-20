import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/wallpaper.dart';

/// Enhanced category chip with ripple effects and animations
class CategoryChip extends StatefulWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final WallpaperCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedBg = isDark ? AppColors.darkPrimary : AppColors.primary;
    final selectedBorder = isDark ? AppColors.darkPrimary : AppColors.primary;
    final unselectedBg = isDark ? AppColors.darkSurface : AppColors.background;
    final unselectedBorder = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.grey300;
    final selectedText = isDark ? AppColors.darkOnPrimary : AppColors.onPrimary;
    final unselectedText = isDark
        ? AppColors.darkOnSurface
        : AppColors.onBackground;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected ? selectedBg : unselectedBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected ? selectedBorder : unselectedBorder,
              width: widget.isSelected ? 1.5 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: selectedBorder.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: selectedBorder.withValues(alpha: 0.1),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                      spreadRadius: -4,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              widget.category.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: widget.isSelected
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: widget.isSelected ? selectedText : unselectedText,
                letterSpacing: 0.5,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal scrollable row of category chips with stagger animation
class CategoryChipsRow extends StatefulWidget {
  const CategoryChipsRow({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final WallpaperCategory selectedCategory;
  final ValueChanged<WallpaperCategory> onCategorySelected;

  @override
  State<CategoryChipsRow> createState() => _CategoryChipsRowState();
}

class _CategoryChipsRowState extends State<CategoryChipsRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final List<Animation<double>> _slideAnimations = [];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create stagger animations for each chip
    for (int i = 0; i < WallpaperCategory.values.length; i++) {
      final start = i * 0.1;
      final end = start + 0.4;
      _slideAnimations.add(
        Tween<double>(begin: 40.0, end: 0.0).animate(
          CurvedAnimation(
            parent: _animController,
            curve: Interval(
              start.clamp(0.0, 0.6),
              end.clamp(0.4, 1.0),
              curve: Curves.easeOutCubic,
            ),
          ),
        ),
      );
    }

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: ListView.separated(
          shrinkWrap: true, // Center the list
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          itemCount: WallpaperCategory.values.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final category = WallpaperCategory.values[index];
            return AnimatedBuilder(
              animation: _slideAnimations[index],
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimations[index].value),
                  child: Opacity(
                    opacity: (40 - _slideAnimations[index].value) / 40,
                    child: child,
                  ),
                );
              },
              child: CategoryChip(
                category: category,
                isSelected: category == widget.selectedCategory,
                onTap: () => widget.onCategorySelected(category),
              ),
            );
          },
        ),
      ),
    );
  }
}
