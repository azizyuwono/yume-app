import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yume_app/core/router/app_router.dart';
import 'package:yume_app/features/create/domain/entities/generation_state.dart';
import 'package:yume_app/features/create/presentation/create_providers.dart';
import 'package:yume_app/features/create/presentation/widgets/dream_button.dart';
import 'package:yume_app/features/create/presentation/widgets/style_selector.dart';

/// Create Screen - Blank Canvas for dreaming wallpapers with animations
class CreateScreen extends ConsumerStatefulWidget {
  const CreateScreen({super.key});

  @override
  ConsumerState<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen>
    with TickerProviderStateMixin {
  late final TextEditingController _promptController;
  late AnimationController _animController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _inputFade;
  late Animation<double> _styleFade;
  late Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0, 0.4, curve: Curves.easeOut),
      ),
    );

    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0, 0.4, curve: Curves.easeOutCubic),
          ),
        );

    _inputFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    _styleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    _buttonSlide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.5, 1, curve: Curves.easeOutCubic),
          ),
        );

    _animController.forward();
  }

  @override
  void dispose() {
    _promptController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onDream() {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      return;
    }

    // Haptic feedback for button press
    HapticFeedback.mediumImpact();

    // Get selected style
    final selectedStyle = ref.read(selectedStyleProvider);
    final styleName = selectedStyle?.id ?? 'nature';

    // Generate wallpaper
    ref
        .read(createControllerProvider.notifier)
        .generateWallpaper(prompt: prompt, style: styleName);
  }

  @override
  Widget build(BuildContext context) {
    final selectedStyle = ref.watch(selectedStyleProvider);
    final generationState = ref.watch(createControllerProvider);

    // Listen for state changes to navigate or show errors
    ref.listen<GenerationState>(createControllerProvider, (previous, next) {
      switch (next) {
        case GenerationSuccess(:final imageUrl):
          // Navigate to preview on success
          context.push(AppRoutes.preview, extra: imageUrl);
          // Clear prompt for next generation
          _promptController.clear();
          // Reset for next generation
          ref.read(createControllerProvider.notifier).reset();
        case GenerationError(:final message):
          // Show error dialog with retry option
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      color: Theme.of(context).colorScheme.error,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Generation Failed',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              content: Text(
                message,
                style: GoogleFonts.inter(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.8),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    ref.read(createControllerProvider.notifier).reset();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    ref.read(createControllerProvider.notifier).reset();
                    _onDream(); // Retry with same prompt
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        case GenerationInitial():
        case GenerationLoading():
          break;
      }
    });

    final isLoading = generationState is GenerationLoading;
    final isEnabled = _promptController.text.trim().isNotEmpty && !isLoading;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Properly handle keyboard
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Tap outside to dismiss keyboard
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(32),
                      // Header with animation
                      SlideTransition(
                        position: _headerSlide,
                        child: FadeTransition(
                          opacity: _headerFade,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Weave your dream',
                                style: GoogleFonts.cinzel(
                                  fontSize: 32, // Increase size for impact
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  letterSpacing: 1.2,
                                  height: 1.1,
                                ),
                              ),
                              const Gap(4),
                              Row(
                                children: [
                                  Text(
                                    '夢を紡ぐ',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                      letterSpacing: 4,
                                    ),
                                  ),
                                  const Gap(12),
                                  Container(
                                    height: 1,
                                    width: 40,
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(24),
                      // Input with animation
                      FadeTransition(
                        opacity: _inputFade,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.outline.withValues(alpha: 0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: TextField(
                            controller: _promptController,
                            maxLines: 6,
                            enabled: !isLoading,
                            onChanged: (_) => setState(() {}),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.6,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            cursorColor: Theme.of(context).colorScheme.primary,
                            decoration: InputDecoration(
                              hintText:
                                  'Describe your imagination...\n"A futuristic city with flying cars at sunset, cyberpunk style"',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.4),
                                height: 1.6,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(24),
                      // Style label with animation
                      FadeTransition(
                        opacity: _styleFade,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.palette_outlined,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const Gap(12),
                            Text(
                              'Art Style',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              '/ スタイル',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(16),
                      // Style selector with animation - MOVED INSIDE SCROLLABLE AREA
                      FadeTransition(
                        opacity: _styleFade,
                        child: IgnorePointer(
                          ignoring: isLoading,
                          child: Opacity(
                            opacity: isLoading ? 0.5 : 1.0,
                            child: StyleSelector(
                              selectedStyle: selectedStyle,
                              onStyleSelected: (style) {
                                HapticFeedback.selectionClick();
                                ref
                                    .read(selectedStyleProvider.notifier)
                                    .select(style);
                              },
                            ),
                          ),
                        ),
                      ),
                      const Gap(40),
                      // Dream button with slide animation - MOVED INSIDE SCROLLABLE AREA
                      SlideTransition(
                        position: _buttonSlide,
                        child: DreamButton(
                          onPressed: _onDream,
                          isLoading: isLoading,
                          isEnabled: isEnabled,
                        ),
                      ),
                      const Gap(40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
