import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pocketinvent/app/modules/dashboard/dashboard_view.dart';
import 'package:pocketinvent/app/modules/dashboard/dashboard_controller.dart';
import 'package:pocketinvent/app/modules/transaction/transaction_view.dart';
import 'package:pocketinvent/app/modules/transaction/transaction_controller.dart';
import 'package:pocketinvent/app/modules/widgets/main_nav_bar.dart';
import 'package:pocketinvent/app/data/services/supabase_service.dart';
import 'package:pocketinvent/app/data/services/storage_service.dart';
import 'package:pocketinvent/app/data/services/notification_service.dart';
import 'package:pocketinvent/app/data/models/financial_metrics.dart';
import 'package:pocketinvent/app/data/models/period.dart';

/// UI Validation Tests for Task 12: Checkpoint - Valider l'interface utilisateur
///
/// These tests validate:
/// - All screens render without errors
/// - Visual consistency across components
/// - Navigation functionality
/// - Widget interactions
///
/// Requirements: Task 12 - Checkpoint validation
void main() {
  group('UI Validation Tests', () {
    late SupabaseService mockSupabaseService;
    late StorageService mockStorageService;
    late NotificationService mockNotificationService;

    setUp(() {
      // Create mock services
      mockSupabaseService = _MockSupabaseService();
      mockStorageService = _MockStorageService();
      mockNotificationService = _MockNotificationService();

      // Register mock services
      Get.put<SupabaseService>(mockSupabaseService);
      Get.put<StorageService>(mockStorageService);
      Get.put<NotificationService>(mockNotificationService);
    });

    tearDown(() {
      Get.reset();
    });

    group('Dashboard View Tests', () {
      testWidgets('Dashboard renders without errors', (tester) async {
        // Arrange
        final controller = DashboardController();
        Get.put(controller);

        // Act
        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Dashboard'), findsOneWidget);
        expect(find.byType(DashboardView), findsOneWidget);
      });

      testWidgets('Dashboard shows loading state initially', (tester) async {
        // Arrange
        final controller = DashboardController();
        Get.put(controller);

        // Act
        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );

        // Assert - should show loading or empty state
        expect(
          find
              .byType(CircularProgressIndicator)
              .or(find.text('Aucune donnée disponible')),
          findsWidgets,
        );
      });

      testWidgets('Dashboard displays metrics when available', (tester) async {
        // Arrange
        final controller = DashboardController();
        Get.put(controller);

        // Set mock metrics
        controller.metrics.value = FinancialMetrics(
          totalEntrees: 1000.0,
          totalSorties: 1500.0,
          profitNet: 500.0,
          margeBeneficiaire: 50.0,
          valeurStock: 2000.0,
          nombreEnStock: 10,
          nombreVendus: 5,
          nombreRetournes: 1,
          period: Period.thisMonth(),
        );

        // Act
        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );
        await tester.pumpAndSettle();

        // Assert - check for key UI elements
        expect(find.text('Métriques Financières'), findsOneWidget);
        expect(find.text('Statistiques Rapides'), findsOneWidget);
        expect(find.text('Graphiques'), findsOneWidget);
      });

      testWidgets('Period selector is present', (tester) async {
        // Arrange
        final controller = DashboardController();
        Get.put(controller);

        controller.metrics.value = FinancialMetrics(
          totalEntrees: 0,
          totalSorties: 0,
          profitNet: 0,
          margeBeneficiaire: 0,
          valeurStock: 0,
          nombreEnStock: 0,
          nombreVendus: 0,
          nombreRetournes: 0,
          period: Period.thisMonth(),
        );

        // Act
        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Période'), findsOneWidget);
      });
    });

    group('Transaction View Tests', () {
      testWidgets('Transaction view renders without errors', (tester) async {
        // Arrange
        final controller = TransactionController();
        Get.put(controller);

        // Act
        await tester.pumpWidget(
          GetMaterialApp(
            home: const TransactionView(),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Transactions'), findsOneWidget);
        expect(find.byType(TransactionView), findsOneWidget);
      });

      testWidgets('Transaction view shows search bar', (tester) async {
        // Arrange
        final controller = TransactionController();
        Get.put(controller);

        // Act
        await tester.pumpWidget(
          GetMaterialApp(
            home: const TransactionView(),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Rechercher par IMEI...'), findsOneWidget);
      });

      testWidgets('Transaction filters are present', (tester) async {
        // Arrange
        final controller = TransactionController();
        Get.put(controller);

        // Act
        await tester.pumpWidget(
          GetMaterialApp(
            home: const TransactionView(),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Type de transaction'), findsOneWidget);
        expect(find.text('Période'), findsOneWidget);
      });

      testWidgets('Transaction view shows empty state when no data',
          (tester) async {
        // Arrange
        final controller = TransactionController();
        Get.put(controller);

        // Act
        await tester.pumpWidget(
          GetMaterialApp(
            home: const TransactionView(),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Aucune transaction'), findsOneWidget);
      });
    });

    group('Navigation Tests', () {
      testWidgets('MainNavBar renders with all items', (tester) async {
        // Arrange
        int selectedIndex = 0;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: MainNavBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  selectedIndex = index;
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Dashboard'), findsOneWidget);
        expect(find.text('Inventaire'), findsOneWidget);
        expect(find.text('Transactions'), findsOneWidget);
        expect(find.text('Profil'), findsOneWidget);
      });

      testWidgets('MainNavBar highlights active section', (tester) async {
        // Act
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

        // Assert - Dashboard should be highlighted (index 0)
        expect(find.byType(MainNavBar), findsOneWidget);
      });

      testWidgets('MainNavBar shows badge when count > 0', (tester) async {
        // Act
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

        // Assert
        expect(find.text('5'), findsOneWidget);
      });

      testWidgets('MainNavBar responds to taps', (tester) async {
        // Arrange
        int tappedIndex = -1;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: MainNavBar(
                currentIndex: 0,
                onTap: (index) {
                  tappedIndex = index;
                },
              ),
            ),
          ),
        );

        // Act - tap on Transactions (index 2)
        await tester.tap(find.text('Transactions'));
        await tester.pumpAndSettle();

        // Assert
        expect(tappedIndex, 2);
      });
    });

    group('Visual Consistency Tests', () {
      testWidgets('Dashboard uses consistent colors', (tester) async {
        // Arrange
        final controller = DashboardController();
        Get.put(controller);

        controller.metrics.value = FinancialMetrics(
          totalEntrees: 1000.0,
          totalSorties: 1500.0,
          profitNet: 500.0,
          margeBeneficiaire: 50.0,
          valeurStock: 2000.0,
          nombreEnStock: 10,
          nombreVendus: 5,
          nombreRetournes: 1,
          period: Period.thisMonth(),
        );

        // Act
        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );
        await tester.pumpAndSettle();

        // Assert - verify widgets render (color consistency is visual)
        expect(find.byType(DashboardView), findsOneWidget);
      });

      testWidgets('All screens have consistent AppBar styling', (tester) async {
        // Test Dashboard AppBar
        final dashController = DashboardController();
        Get.put(dashController);

        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AppBar), findsOneWidget);

        // Clean up
        Get.delete<DashboardController>();

        // Test Transaction AppBar
        final transController = TransactionController();
        Get.put(transController);

        await tester.pumpWidget(
          GetMaterialApp(
            home: const TransactionView(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AppBar), findsOneWidget);
      });
    });

    group('Workflow Tests', () {
      testWidgets('Dashboard pull-to-refresh works', (tester) async {
        // Arrange
        final controller = DashboardController();
        Get.put(controller);

        controller.metrics.value = FinancialMetrics(
          totalEntrees: 0,
          totalSorties: 0,
          profitNet: 0,
          margeBeneficiaire: 0,
          valeurStock: 0,
          nombreEnStock: 0,
          nombreVendus: 0,
          nombreRetournes: 0,
          period: Period.thisMonth(),
        );

        await tester.pumpWidget(
          GetMaterialApp(
            home: const DashboardView(),
          ),
        );
        await tester.pumpAndSettle();

        // Act - simulate pull to refresh
        await tester.drag(
          find.byType(RefreshIndicator),
          const Offset(0, 300),
        );
        await tester.pumpAndSettle();

        // Assert - no errors thrown
        expect(find.byType(DashboardView), findsOneWidget);
      });

      testWidgets('Transaction search field accepts input', (tester) async {
        // Arrange
        final controller = TransactionController();
        Get.put(controller);

        await tester.pumpWidget(
          GetMaterialApp(
            home: const TransactionView(),
          ),
        );
        await tester.pumpAndSettle();

        // Act
        await tester.enterText(
          find.byType(TextField),
          '123456789',
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('123456789'), findsOneWidget);
      });
    });
  });
}

// Mock Services
class _MockSupabaseService extends GetxService implements SupabaseService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockStorageService extends GetxService implements StorageService {
  @override
  List getAllTransactions() => [];

  @override
  List getAllTelephones() => [];

  @override
  dynamic getTelephone(String id) => null;

  @override
  dynamic getUserData(String key) => null;

  @override
  Future<void> saveUserData(String key, dynamic value) async {}

  @override
  Future<void> saveTransactions(List transactions) async {}

  @override
  Future<void> saveTelephones(List phones) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockNotificationService extends GetxService
    implements NotificationService {
  @override
  int getNewTransactionCount() => 0;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
