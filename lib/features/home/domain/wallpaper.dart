/// Wallpaper category enum for filtering
enum WallpaperCategory {
  all('All'),
  ukiyoe('Ukiyo-e'),
  cyberpunk('Cyberpunk'),
  nature('Nature'),
  abstract('Abstract');

  const WallpaperCategory(this.label);
  final String label;
}

/// Wallpaper model
class Wallpaper {
  const Wallpaper({
    required this.id,
    required this.imageUrl,
    required this.prompt,
    required this.category,
    this.aspectRatio = 1.78, // Default phone wallpaper ratio (9:16)
  });

  final String id;
  final String imageUrl;
  final String prompt;
  final WallpaperCategory category;
  final double aspectRatio; // Height / Width ratio for portrait images
}
