// Empty State Widget Test

import 'package:demo_shop_app/features/products/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onRetry,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: EmptyStateWidget(
          title: title,
          message: message,
          icon: icon ?? Icons.inbox_outlined,
          onRetry: onRetry,
        ),
      ),
    );
  }

  group('EmptyStateWidget', () {
    testWidgets('should display title and message', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestWidget(
          title: 'No Data',
          message: 'There is no data available',
        ),
      );

      // Assert
      expect(find.text('No Data'), findsOneWidget);
      expect(find.text('There is no data available'), findsOneWidget);
    });

    testWidgets('should display image', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestWidget(title: 'Empty', message: 'No items found'),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display retry button when onRetry is provided', (
      tester,
    ) async {
      // Arrange
      var retryPressed = false;

      // Act
      await tester.pumpWidget(
        createTestWidget(
          title: 'Empty',
          message: 'No items',
          onRetry: () => retryPressed = true,
        ),
      );

      // Assert
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Act - Tap retry button
      await tester.tap(find.text('Try Again'));
      await tester.pump();

      // Assert
      expect(retryPressed, true);
    });

    testWidgets('should not display retry button when onRetry is null', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestWidget(title: 'Empty', message: 'No items', onRetry: null),
      );

      // Assert
      expect(find.text('Try Again'), findsNothing);
      expect(find.byIcon(Icons.refresh), findsNothing);
    });

    testWidgets('should be centered on screen', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestWidget(title: 'Empty', message: 'No data'),
      );

      // Assert
      final center = find.byType(Center);
      expect(center, findsOneWidget);
    });
  });
}
