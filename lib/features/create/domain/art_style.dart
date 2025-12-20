import 'package:flutter/material.dart';

/// Art style for wallpaper generation
class ArtStyle {
  const ArtStyle({
    required this.id,
    required this.name,
    required this.nameJp,
    required this.color,
    required this.icon,
    required this.gradient,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String nameJp;
  final Color color;
  final IconData icon;
  final List<Color> gradient;
  final String? imageUrl;
}

/// Predefined art styles with enhanced visual design
final List<ArtStyle> artStyles = [
  const ArtStyle(
    id: 'nature',
    name: 'Nature',
    nameJp: '自然',
    color: Color(0xFF4A7C59),
    icon: Icons.forest,
    gradient: [Color(0xFF4A7C59), Color(0xFF7BA97E)],
  ),
  const ArtStyle(
    id: 'abstract',
    name: 'Abstract',
    nameJp: '抽象的',
    color: Color(0xFFE85D04),
    icon: Icons.palette,
    gradient: [Color(0xFFE85D04), Color(0xFFFFA726)],
  ),
  const ArtStyle(
    id: 'ukiyoe',
    name: 'Ukiyo-e',
    nameJp: '浮世絵',
    color: Color(0xFFE8D5B7),
    icon: Icons.brush,
    gradient: [Color(0xFFE8D5B7), Color(0xFFD4AF37)],
  ),
  const ArtStyle(
    id: 'cyberpunk',
    name: 'Cyberpunk',
    nameJp: 'サイバー',
    color: Color(0xFF7B2D8E),
    icon: Icons.electrical_services,
    gradient: [Color(0xFF7B2D8E), Color(0xFFE91E63)],
  ),
  const ArtStyle(
    id: 'minimal',
    name: 'Minimal',
    nameJp: 'ミニマル',
    color: Color(0xFF2D2D2D),
    icon: Icons.circle_outlined,
    gradient: [Color(0xFF2D2D2D), Color(0xFF616161)],
  ),
  const ArtStyle(
    id: 'dreamy',
    name: 'Dreamy',
    nameJp: '夢幻的',
    color: Color(0xFFB8A9C9),
    icon: Icons.cloud,
    gradient: [Color(0xFFB8A9C9), Color(0xFFE1BEE7)],
  ),
];
