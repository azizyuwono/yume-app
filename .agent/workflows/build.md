---
description: Build APK or IPA for distribution
---

# Build Workflow

## Prerequisites

- Ensure all dependencies are installed: `flutter pub get`
- Run code generation: `dart run build_runner build --delete-conflicting-outputs`

## Build Commands

### Debug APK

// turbo

1. Run: `flutter build apk --debug`

### Release APK

2. Run: `flutter build apk --release`

### App Bundle (for Play Store)

3. Run: `flutter build appbundle --release`

### iOS (macOS only)

4. Run: `flutter build ios --release`
