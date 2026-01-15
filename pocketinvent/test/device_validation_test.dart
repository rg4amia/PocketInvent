              ),
            ),
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
  });
}
entation Change Tests', () {
      testWidgets('UI handles orientation change gracefully',
          (WidgetTester tester) async {
        // Start in portrait
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const Center(child: Text('Test')),
              bottomNavigationBar: MainNavBar(
                currentIndex: 0,
                onTap: (_) {},
vigationBar: MainNavBar(
                currentIndex: 0,
                onTap: (_) {},
              ),
            ),
          ),
        );

        // Find the MainNavBar
        final navBar = find.byType(MainNavBar);
        expect(navBar, findsOneWidget);

        // Get the size of the navigation bar
        final navBarSize = tester.getSize(navBar);

        // Verify height is sufficient (70 as defined in MainNavBar)
        expect(navBarSize.height, equals(70));
      });
    });

    group('Ori                currentIndex: 0,
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
              bottomNanBar: MainNavBar(
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
              ),
            ),
          ),
        );

        // Find the Dashboard icon (first item)
        final dashboardIcon = find.byIcon(Icons.dashboard_rounded);
        expect(dashboardIcon, findsOneWidget);
      });

      testWidgets('Navigation badge displays on transactions',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigatior) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: MainNavBar(onBar: MainNavBar(
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
          (WidgetTester testeays all items',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigatiurrentIndex: 0,
                onTap: (_) {},
              ),
            ),
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
    });

    group('Navigation Tests', () {
      testWidgets('Bottom navigation bar displset
        addTearDown(() => tester.view.resetPhysicalSize());
      });

      testWidgets('UI adapts to small Android screen',
          (WidgetTester tester) async {
        // Small Android phone: 360x640
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const Center(child: Text('Test')),
              bottomNavigationBar: MainNavBar(
                c.takeException(), isNull);

        // Re
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const Center(child: Text('Test')),
              bottomNavigationBar: MainNavBar(
                currentIndex: 0,
                onTap: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify bottom navigation is visible
        expect(find.byType(MainNavBar), findsOneWidget);

        // Verify content doesn't overflow
        expect(tester
        tester.view.devicePixelRatio = 2.0;
wait tester.pumpAndSettle();

        // Verify bottom navigation is visible
        expect(find.byType(MainNavBar), findsOneWidget);

        // Verify content doesn't overflow
        expect(tester.takeException(), isNull);

        // Reset
        addTearDown(() => tester.view.resetPhysicalSize());
      });

      testWidgets('UI adapts to landscape orientation',
          (WidgetTester tester) async {
        // Landscape: 667x375 (iPhone SE rotated)
        tester.view.physicalSize = const Size(667, 375);,
            ),
          ),
        );

        ae());
      });

      testWidgets('UI adapts to iPad screen size',
          (WidgetTester tester) async {
        // iPad Pro 12.9": 1024x1366
        tester.view.physicalSize = const Size(1024, 1366);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const Center(child: Text('Test')),
              bottomNavigationBar: MainNavBar(
                currentIndex: 0,
                onTap: (_) {},
              )eption(), isNull);

        // Reset
        addTearDown(() => tester.view.resetPhysicalSizait tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const Center(child: Text('Test')),
              bottomNavigationBar: MainNavBar(
                currentIndex: 0,
                onTap: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify bottom navigation is visible
        expect(find.byType(MainNavBar), findsOneWidget);

        // Verify content doesn't overflow
        expect(tester.takeExc= 3.0;

        aw  // Verify bottom navigation is visible
        expect(find.byType(MainNavBar), findsOneWidget);

        // Verify content doesn't overflow
        expect(tester.takeException(), isNull);

        // Reset
        addTearDown(() => tester.view.resetPhysicalSize());
      });

      testWidgets('UI adapts to iPhone 15 Pro Max screen size',
          (WidgetTester tester) async {
        // iPhone 15 Pro Max: 430x932
        tester.view.physicalSize = const Size(430, 932);
        tester.view.devicePixelRatio ter tester) async {
        // iPhone SE: 375x667
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const Center(child: Text('Test')),
              bottomNavigationBar: MainNavBar(
                currentIndex: 0,
                onTap: (_) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

      package:flutter_test/flutter_test.dart';
import 'package:pocketinvent/app/modules/widgets/main_nav_bar.dart';

/// Device Validation Tests
///
/// These tests validate that the UI components work correctly
/// across different screen sizes and orientations.
///
/// Requirements: All (comprehensive device testing)
void main() {
  group('Device Validation Tests', () {
    group('Responsive Design Tests', () {
      testWidgets('UI adapts to iPhone SE screen size',
          (WidgetTesimport 'package:flutter/material.dart';
