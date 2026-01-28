import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yume_app/core/theme/app_colors.dart';
import 'package:yume_app/features/create/domain/art_style.dart';

/// Enhanced art style selector bubble with icon and gradient
class StyleBubble extends StatelessWidget {
  const StyleBubble({
    super.key,
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  final ArtStyle style;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Determine the active color based on selection
    final activeColor = style.gradient.first;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Enhanced bubble with gradient and icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: style.gradient,
                ),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: isSelected ? 3 : 0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                          spreadRadius: 2,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Stack(
                children: [
                  // Inner glow for depth
                  if (isSelected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Icon(
                      style.icon,
                      color: Colors.white,
                      size: isSelected ? 30 : 26,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Style name
            Text(
              style.name,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : AppColors.grey500,
                letterSpacing: isSelected ? 0.5 : 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrollable row of style bubbles
class StyleSelector extends StatelessWidget {
  const StyleSelector({
    super.key,
    required this.selectedStyle,
    required this.onStyleSelected,
  });

  final ArtStyle? selectedStyle;
  final ValueChanged<ArtStyle> onStyleSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: artStyles.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final style = artStyles[index];
          return StyleBubble(
            style: style,
            isSelected: style.id == selectedStyle?.id,
            onTap: () => onStyleSelected(style),
          );
        },
      ),
    );
  }
}
