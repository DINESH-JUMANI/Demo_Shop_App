// Integration Test - Product Flow

import 'package:demo_shop_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize SharedPreferences with mock values
    SharedPreferences.setMockInitialValues({});
  });

  group('Product Flow Integration Test', () {
    testWidgets('should complete full product browsing flow', (tester) async {
      // Start the app
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Wait for splash screen to complete
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Verify we're on the product screen (home)
      expect(find.text('Products'), findsOneWidget);

      // Wait for products to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find and tap on the first product card
      final productCard = find.byType(Card).first;
      await tester.tap(productCard);
      await tester.pumpAndSettle();

      // Verify we're on product detail screen
      expect(find.byType(AppBar), findsOneWidget);

      // Go back to product list
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Verify we're back on product screen
      expect(find.text('Products'), findsOneWidget);
    });

    testWidgets('should search for products', (tester) async {
      // Start the app
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Find search field
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      // Enter search query
      await tester.enterText(searchField, 'phone');
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Wait for search results
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify products are displayed (assuming API returns results)
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('should navigate to settings', (tester) async {
      // Start the app
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Find and tap settings navigation item
      final settingsIcon = find.byIcon(Icons.settings);
      await tester.tap(settingsIcon);
      await tester.pumpAndSettle();

      // Verify we're on settings screen
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('should scroll products list', (tester) async {
      // Start the app
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Wait for products to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Scroll down
      await tester.drag(find.byType(GridView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Wait for pagination
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify more products loaded
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('should handle empty search results', (tester) async {
      // Start the app
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Enter search query that returns no results
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'xyznonexistent12345');
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Wait for search
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify empty state is shown
      expect(find.text('No Products Found'), findsOneWidget);
    });
  });
}
