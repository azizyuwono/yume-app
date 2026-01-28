import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:yume_app/app.dart';
import 'package:yume_app/core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Storage
  final container = ProviderContainer();
  await container.read(storageServiceProvider).init();

  // Initialize settings box for theme persistence
  await Hive.openBox<String>('settings');

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
