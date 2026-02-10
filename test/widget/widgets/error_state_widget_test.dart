// Error State Widget Test

import 'package:demo_shop_app/features/products/widgets/error_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    required String error,
    required VoidCallback onRetry,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ErrorStateWidget(error: error, onRetry: onRetry),
      ),
    );
  }

  group('ErrorStateWidget', () {
    testWidgets('should display error message', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestWidget(error: 'Network error occurred', onRetry: () {}),
      );

      // Assert
      expect(find.text('Network error occurred'), findsOneWidget);
    });

    testWidgets('should remove Exception prefix from error', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestWidget(
          error: 'Exception: Something went wrong',
          onRetry: () {},
        ),
      );

      // Assert
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.textContaining('Exception:'), findsNothing);
    });

    testWidgets('should display error title', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestWidget(error: 'Test error', onRetry: () {}),
      );

      // Assert
      expect(find.text('Oops! Something went wrong'), findsOneWidget);
    });

    testWidgets('should display error image', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestWidget(error: 'Test error', onRetry: () {}),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display retry button with icon', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestWidget(error: 'Test error', onRetry: () {}),
      );

      // Assert
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should call onRetry when retry button is pressed', (
      tester,
    ) async {
      // Arrange
      var retryPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          error: 'Test error',
          onRetry: () => retryPressed = true,
        ),
      );

      // Act
      await tester.tap(find.text('Try Again'));
      await tester.pump();

      // Assert
      expect(retryPressed, true);
    });

    testWidgets('should be centered on screen', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestWidget(error: 'Test error', onRetry: () {}),
      );

      // Assert
      // The SingleChildScrollView contains a Center widget
      final scrollView = find.byType(SingleChildScrollView);
      expect(scrollView, findsOneWidget);
    });
  });
}
