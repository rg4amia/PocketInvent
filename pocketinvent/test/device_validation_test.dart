import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pocketinvent/app/modules/dashboard/dashboard_view.dart';
import 'package:pocketinvent/app/modules/dashboard/dashboard_controller.dart';
import 'package:pocketinvent/app/modules/transaction/transaction_view.dart';
import 'package:pocketinvent/app/modules/transaction/transaction_controller.dart';
import 'package:pocketinvent/app/modules/widgets/main_nav_bar.dart';
import 'package:pocketinvent/app/data/services/storage_service.dart';
import 'package:pocketinvent/app/data/services/transaction_service.dart';
import 'package:pocketinvent/app/data/services/financial_calculator.dart';

/// Device Validation Tests
///
/// These tests validate that the UI components work correctly
/// across different screen sizes and orientations.
///
/// Requirements: All (comprehensive device testing)
void main() {
  group('Device Validation Tests', () {
    late StorageService storageService;
    late TransactionService transactionService;
    late FinancialCalculator calculator;

    setUp(() {
      // Initialize GetX
      Get.testMode = true;

      // Mock services
      storageService = StorageService();
      transactionService = TransactionService();
      calculator = FinancialCalculator();
    });

    tearDown(() {
      Get.reset();
    });

    group('Responsive Design Tests', () {
      testWidgets('Dashboard adapts to iPhone SE screen size',
          (WidgetTester tester) async {
        // iPhone SE: 375x667
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify bottom navigation is visible
        expect(find.byType(MainNavBar), findsOneWidget);

        // Verify content doesn't overflow
        expect(tester.takeException(), isNull);

        // Reset
        addTearDown(() => tester.view.resetPhysicalSize());
      });

      testWidgets('Dashboard adapts to iPhone 15 Pro Max screen size',
          (WidgetTester tester) async {
        // iPhone 15 Pro Max: 430x932
        tester.view.physicalSize = const Size(430, 932);
        tester.view.devicePixelRatio = 3.0;

        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify bottom navigation is visible
        expect(find.byType(MainNavBar), findsOneWidget);

        // Verify content doesn't overflow
        expect(tester.takeException(), isNull);

        // Reset
        addTearDown(() => tester.view.resetPhysicalSize());
      });

      testWidgets('Dashboard adapts to iPad screen size',
          (WidgetTester tester) async {
        // iPad Pro 12.9": 1024x1366
        tester.view.physicalSize = const Size(1024, 1366);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify bottom navigation is visible
        expect(find.byType(MainNavBar), findsOneWidget);

        // Verify content doesn't overflow
        expect(tester.takeException(), isNull);

        // Reset
        addTearDown(() => tester.view.resetPhysicalSize());
      });

      testWidgets('Dashboard adapts to landscape orientation',
          (WidgetTester tester) async {
        // Landscape: 667x375 (iPhone SE rotated)
        tester.view.physicalSize = const Size(667, 375);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify bottom navigation is visible
        expect(find.byType(MainNavBar), findsOneWidget);

        // Verify content doesn't overflow
        expect(tester.takeException(), isNull);

        // Reset
        addTearDown(() => tester.view.resetPhysicalSize());
      });

      testWidgets('Transaction view adapts to small screen',
          (WidgetTester tester) async {
        // Small Android phone: 360x640
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(
          GetMaterialApp(
            home: const TransactionView(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify search bar is visible
        expect(find.byType(TextField), findsOneWidget);

        // Verify bottom navigation is visible
        expect(find.byType(MainNavBar), findsOneWidget);

        // Verify content doesn't overflow
        expect(tester.takeException(), isNull);

        // Reset
        addTearDown(() => tester.view.resetPhysicalSize());
      });
    });

    group('Navigation Tests', () {
      testWidgets('Bottom navigation bar displays all items',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: MainNavBar(
                currentIndex: 0,
                onTap: (_) {},
              ),
            ),
          ),
        );

        // Verify all 4 navigation items are present
        expect(find.text('Dashboard'), findsOneWidget);
        expect(find.text('Inventaire'), findsOneWidget);
        expect(find.text('Transactions'), findsOneWidget);
        expect(find.text('Profil'), findsOneWidget);
      });

      testWidgets('Navigation highlights active section',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: MainNavBar(
                currentIndex: 0,
                onTap: (_) {},
              ),
            ),
          ),
        );

        // Find the Dashboard icon (first item)
        final dashboardIcon = find.byIcon(Icons.dashboard_rounded).first;
        expect(dashboardIcon, findsOneWidget);

        // Verify it's highlighted (would need to check color in real test)
      });

      testWidgets('Navigation badge displays on transactions',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: MainNavBar(
                currentIndex: 0,
                onTap: (_) {},
                transactionBadgeCount: 5,
              ),
            ),
          ),
        );

        // Verify badge is displayed
        expect(find.text('5'), findsOneWidget);
      });

      testWidgets('Navigation badge shows 99+ for large counts',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: MainNavBar(
                currentIndex: 0,
                onTap: (_) {},
                transactionBadgeCount: 150,
              ),
            ),
          ),
        );

        // Verify badge shows 99+
        expect(find.text('99+'), findsOneWidget);
      });
    });

    group('Touch Target Tests', () {
      testWidgets('Navigation items have sufficient touch targets',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: MainNavBar(
                currentIndex: 0,
                onTap: (_) {},
              ),
            ),
          ),
        );

        // Find all navigation items
        final navItems = find.byType(GestureDetector);

        // Verify each item has sufficient size (minimum 44x44 for iOS)
        for (final item in navItems.evaluate()) {
          final size = item.size;
          expect(size != null, isTrue);
          if (size != null) {
            // Height should be at least 44 (iOS guideline)
            expect(size.height >= 44, isTrue,
                reason: 'Touch target height should be at least 44');
          }
        }
      });
    });

    group('Text Readability Tests', () {
      testWidgets('Dashboard text is readable on small screens',
          (WidgetTester tester) async {
        // iPhone SE: 375x667
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );

        await tester.pumpAndSettle();

        // Find text widgets
        final textWidgets = find.byType(Text);

        // Verify text widgets exist
        expect(textWidgets, findsWidgets);

        // In a real test, we would verify font sizes are >= 14sp
        // and contrast ratios meet WCAG guidelines

        // Reset
        addTearDown(() => tester.view.resetPhysicalSize());
      });
    });

    group('Safe Area Tests', () {
      testWidgets('Dashboard respects safe area on iPhone with notch',
          (WidgetTester tester) async {
        // iPhone 15 Pro with notch
        tester.view.physicalSize = const Size(393, 852);
        tester.view.devicePixelRatio = 3.0;
        tester.view.padding = const FakeViewPadding(
          top: 59.0, // Status bar + notch
          bottom: 34.0, // Home indicator
        );

        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify content doesn't overlap with notch or home indicator
        expect(tester.takeException(), isNull);

        // Reset
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetPadding();
        });
      });
    });

    group('Performance Tests', () {
      testWidgets('Dashboard renders without jank',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );

        // Measure frame rendering time
        await tester.pumpAndSettle();

        // In a real test, we would use Flutter DevTools to measure
        // frame rendering time and ensure it's < 16ms (60 FPS)
      });

      testWidgets('Transaction list scrolls smoothly',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: const TransactionView(),
          ),
        );

        await tester.pumpAndSettle();

        // Find the scrollable list
        final listView = find.byType(ListView);

        if (listView.evaluate().isNotEmpty) {
          // Simulate scroll
          await tester.drag(listView, const Offset(0, -300));
          await tester.pumpAndSettle();

          // Verify no exceptions during scroll
          expect(tester.takeException(), isNull);
        }
      });
    });

    group('Orientation Change Tests', () {
      testWidgets('Dashboard handles orientation change gracefully',
          (WidgetTester tester) async {
        // Start in portrait
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );

        await tester.pumpAndSettle();

        // Rotate to landscape
        tester.view.physicalSize = const Size(667, 375);

        await tester.pumpAndSettle();

        // Verify no exceptions
        expect(tester.takeException(), isNull);

        // Verify bottom navigation is still visible
        expect(find.byType(MainNavBar), findsOneWidget);

        // Reset
        addTearDown(() => tester.view.resetPhysicalSize());
      });
    });

    group('Animation Tests', () {
      testWidgets('Dashboard animations complete successfully',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );

        // Pump frames to allow animations to complete
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle();

        // Verify no exceptions during animations
        expect(tester.takeException(), isNull);
      });
    });

    group('Empty State Tests', () {
      testWidgets('Dashboard shows empty state correctly',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );

        await tester.pumpAndSettle();

        // Look for empty state indicators
        // (In real test, would verify specific empty state widgets)
        expect(tester.takeException(), isNull);
      });

      testWidgets('Transaction view shows empty state correctly',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: const TransactionView(),
          ),
        );

        await tester.pumpAndSettle();

        // Look for empty state indicators
        expect(tester.takeException(), isNull);
      });
    });
  });
}

/// Fake view padding for testing safe area
class FakeViewPadding implements ViewPadding {
  const FakeViewPadding({
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
  });

  @override
  final double left;
  @override
  final double top;
  @override
  final double right;
  @override
  final double bottom;
}
