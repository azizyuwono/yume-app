import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yume_app/core/constants/app_constants.dart';
import 'package:yume_app/core/services/image_download_service.dart';
import 'package:yume_app/core/services/snackbar_service.dart';
import 'package:yume_app/core/services/storage_service.dart';
import 'package:yume_app/core/services/wallpaper_service.dart';
import 'package:yume_app/core/theme/app_colors.dart';
import 'package:yume_app/core/utils/result.dart';
import 'package:yume_app/features/home/domain/wallpaper.dart';
import 'package:yume_app/features/preview/presentation/widgets/action_card.dart';
import 'package:yume_app/features/preview/presentation/widgets/glass_back_button.dart';
import 'package:yume_app/features/preview/presentation/widgets/wallpaper_location_sheet.dart';

/// Preview Screen - Museum Mode for fullscreen wallpaper viewing with Hero animation
class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({super.key, this.imageUrl, this.wallpaperId});

  final String? imageUrl;
  final String? wallpaperId;

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<Offset> _buttonSlideAnimation;
  late Animation<Offset> _cardSlideAnimation;

  bool _isDownloading = false;
  bool _isSettingWallpaper = false;

  @override
  void initState() {
    super.initState();

    // Set system UI overlay style in initState
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: AppConstants.animSlow),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonSlideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _cardSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: const Interval(0.3, 1, curve: Curves.easeOutCubic),
          ),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _onDownload() async {
    if (widget.imageUrl == null || _isDownloading) {
      return;
    }

    setState(() => _isDownloading = true);
    HapticFeedback.lightImpact();

    // Use Riverpod providers for services
    final downloadService = ref.read(imageDownloadServiceProvider);
    final storageService = ref.read(storageServiceProvider);

    // CRITICAL: Download HD version for best quality
    final hdUrl = _getHdUrl();
    final result = await downloadService.downloadAndSaveToGallery(
      context,
      hdUrl,
    );

    if (!mounted) {
      return;
    }

    // Save to Hive storage if download successful
    if (result is Success) {
      final wallpaper = Wallpaper(
        id:
            widget.wallpaperId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        imageUrl: hdUrl, // Save HD URL, not low-res
        prompt: 'Downloaded wallpaper',
        category: WallpaperCategory.all,
      );
      await storageService.saveWallpaper(wallpaper);
    }

    setState(() => _isDownloading = false);

    result.when(
      success: (_) =>
          SnackBarService().showSuccess(context, 'Saved to Gallery'),
      failure: (message) => SnackBarService().showError(context, message),
    );
  }

  void _showWallpaperLocationSheet() {
    if (widget.imageUrl == null) {
      return;
    }

    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          WallpaperLocationSheet(onLocationSelected: _onSetWallpaper),
    );
  }

  Future<void> _onSetWallpaper(WallpaperLocation location) async {
    if (widget.imageUrl == null || _isSettingWallpaper) {
      return;
    }

    setState(() => _isSettingWallpaper = true);
    HapticFeedback.mediumImpact();

    final wallpaperService = ref.read(wallpaperServiceProvider);

    final result = await wallpaperService.setWallpaperFromUrl(
      widget.imageUrl!,
      location,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isSettingWallpaper = false);

    result.when(
      success: (_) {
        final locationLabel = wallpaperService.getLocationLabel(location);
        SnackBarService().showSuccess(
          context,
          'Wallpaper set for $locationLabel',
        );
      },
      failure: (message) => SnackBarService().showError(context, message),
    );
  }

  bool _controlsVisible = true;

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
  }

  @override
  Widget build(BuildContext context) {
    final wallpaperService = ref.read(wallpaperServiceProvider);
    final showSetWallpaper = wallpaperService.isSupported;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fullscreen background image with Zoom and Hero animation
            _buildInteractiveImage(),

            // Overlays (Glass Back Button & Actions)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _controlsVisible ? 1.0 : 0.0,
              curve: Curves.easeInOut,
              child: Stack(
                children: [
                  // Glass back button - Top Left
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    child: SlideTransition(
                      position: _buttonSlideAnimation,
                      child: IgnorePointer(
                        ignoring: !_controlsVisible,
                        child: GlassBackButton(onPressed: () => context.pop()),
                      ),
                    ),
                  ),

                  // Loading indicator
                  if (_isDownloading || _isSettingWallpaper)
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isSettingWallpaper
                                  ? 'Setting...'
                                  : 'Downloading...',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Glass Actions - Bottom Center
                  Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + 32,
                    left: 24,
                    right: 24,
                    child: SlideTransition(
                      position: _cardSlideAnimation,
                      child: IgnorePointer(
                        ignoring: !_controlsVisible,
                        child: Center(
                          child: ActionCard(
                            onDownload: _isDownloading ? null : _onDownload,
                            onSetWallpaper: _isSettingWallpaper
                                ? null
                                : _showWallpaperLocationSheet,
                            showSetWallpaper: showSetWallpaper,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveImage() {
    if (widget.imageUrl == null || !widget.imageUrl!.startsWith('http')) {
      return Container(color: Colors.black);
    }

    // Original URL (Low-Res from grid - already cached, instant display)
    final originalUrl = widget.imageUrl!;

    // Generate HD URL for preview
    // Extract prompt from original turbo URL and upgrade to flux HD
    String hdUrl = originalUrl;
    try {
      final uri = Uri.parse(originalUrl);
      final prompt = uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last
          : 'wallpaper';
      // Upgrade to HD: flux model, 1080x1920 for crisp mobile preview
      hdUrl =
          'https://image.pollinations.ai/prompt/$prompt?width=1080&height=1920&model=flux&nologo=true&enhance=false';
    } catch (e) {
      // Fallback: just use original if parsing fails
      hdUrl = originalUrl;
    }

    // PROGRESSIVE LOADING STACK:
    // Layer 1: Low-res instant preview (from grid cache)
    // Layer 2: HD image fades in smoothly on top
    return InteractiveViewer(
      minScale: 1,
      maxScale: 4,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // LAYER 1: Low-Res Instant Preview (Bottom)
          Hero(
            tag: originalUrl,
            child: CachedNetworkImage(
              imageUrl: originalUrl,
              cacheKey: '${originalUrl}_thumbnail',
              fit: BoxFit.cover,
              // Use smaller cache for low-res
              memCacheWidth: 512,
              memCacheHeight: 896,
              placeholder: (context, url) => Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.grey900,
                child: const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white54,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),

          // LAYER 2: HD Image Overlay (Top - fades in smoothly)
          CachedNetworkImage(
            imageUrl: hdUrl,
            cacheKey: '${hdUrl}_hd_preview',
            fit: BoxFit.cover,
            // HD cache settings for crisp preview
            memCacheWidth:
                (MediaQuery.of(context).size.width *
                        MediaQuery.of(context).devicePixelRatio)
                    .toInt(),
            memCacheHeight:
                (MediaQuery.of(context).size.height *
                        MediaQuery.of(context).devicePixelRatio)
                    .toInt(),
            maxWidthDiskCache: 3840,
            maxHeightDiskCache: 2160,
            // CRITICAL: Smooth fade-in over low-res image
            fadeInDuration: const Duration(milliseconds: 800),
            // CRITICAL: Transparent placeholder so low-res shows through
            placeholder: (context, url) => const SizedBox.shrink(),
            // FIX: On timeout/524 error, just keep showing low-res (don't show error)
            errorWidget: (context, url, error) {
              // Log error but don't show it - low-res is good enough
              debugPrint('HD image load failed (using low-res): $error');
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  /// Generate HD URL for download (always use best quality)
  String _getHdUrl() {
    if (widget.imageUrl == null) {
      return '';
    }

    final originalUrl = widget.imageUrl!;
    try {
      final uri = Uri.parse(originalUrl);
      final prompt = uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last
          : 'wallpaper';
      // HD download: flux model, 1080x1920 for crisp mobile
      return 'https://image.pollinations.ai/prompt/$prompt?width=1080&height=1920&model=flux&nologo=true&enhance=false';
    } catch (e) {
      return originalUrl;
    }
  }
}
