import 'package:hive/hive.dart';

import '../../../home/domain/wallpaper.dart';

class LocalWallpaper extends HiveObject {
  late String id;
  late String imageUrl;
  late String prompt;
  late String category;
  late double aspectRatio;

  LocalWallpaper({
    required this.id,
    required this.imageUrl,
    required this.prompt,
    required this.category,
    this.aspectRatio = 1.78,
  });

  /// Convert from Domain Model to Hive Model
  factory LocalWallpaper.fromDomain(Wallpaper wallpaper) {
    return LocalWallpaper(
      id: wallpaper.id,
      imageUrl: wallpaper.imageUrl,
      prompt: wallpaper.prompt,
      category: wallpaper.category.name, // Enum to String
      aspectRatio: wallpaper.aspectRatio,
    );
  }

  /// Convert from Hive Model to Domain Model
  Wallpaper toDomain() {
    return Wallpaper(
      id: id,
      imageUrl: imageUrl,
      prompt: prompt,
      category: WallpaperCategory.values.firstWhere(
        (e) => e.name == category,
        orElse: () => WallpaperCategory.all,
      ),
      aspectRatio: aspectRatio,
    );
  }
}

class LocalWallpaperAdapter extends TypeAdapter<LocalWallpaper> {
  @override
  final int typeId = 0;

  @override
  LocalWallpaper read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalWallpaper(
      id: fields[0] as String,
      imageUrl: fields[1] as String,
      prompt: fields[2] as String,
      category: fields[3] as String,
      aspectRatio: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LocalWallpaper obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.prompt)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.aspectRatio);
  }
}
