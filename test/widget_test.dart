// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yume_app/app.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: App()));

    // Verify the app builds successfully (wait for async routing if needed, but text 'Yume' is in the app title? No, title doesn't show in widget tree unless in AppBar)
    // App uses MaterialApp.router. The initial route is likely '/'.
    // If Home screen has 'Yume', it might show up.
    // However, usually we pumpAndSettle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify the app builds successfully
    // 'Yume' is in the AppBar of HomeScreen.
    expect(find.text('Yume'), findsOneWidget);
  });
}
