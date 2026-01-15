import 'package:flutter_test/flutter_test.dart';
import 'package:pocketinvent/app/modules/widgets/main_nav_bar.dart';
import 'package:pocketinvent/app/data/models/telephone_model.dart';
import 'package:pocketinvent/app/routes/app_pages.dart';

/// Checkpoint 8: Verification tests for navigation and transaction services
///
/// This test file verifies:
/// 1. Navigation configuration is correct
/// 2. MainNavBar has proper structure
/// 3. Transaction workflow models are properly defined
void main() {
  group('Checkpoint 8: Navigation Verification', () {
    test('MainNavBar should have 4 navigation items', () {
      expect(MainNavBar.items.length, 4);
    });

    test('Navigation items should have correct routes', () {
      expect(MainNavBar.items[0].route, Routes.DASHBOARD);
      expect(MainNavBar.items[1].route, Routes.HOME);
      expect(MainNavBar.items[2].route, Routes.TRANSACTIONS);
      expect(MainNavBar.items[3].route, Routes.HUB);
    });

    test('Navigation items should have correct labels', () {
      expect(MainNavBar.items[0].label, 'Dashboard');
      expect(MainNavBar.items[1].label, 'Inventaire');
      expect(MainNavBar.items[2].label, 'Transactions');
      expect(MainNavBar.items[3].label, 'Profil');
    });

    test('All routes should be defined', () {
      expect(Routes.DASHBOARD, '/dashboard');
      expect(Routes.HOME, '/home');
      expect(Routes.TRANSACTIONS, '/transactions');
      expect(Routes.HUB, '/hub');
    });
  });

  group('Checkpoint 8: Transaction Workflow Models', () {
    test('StockStatus enum should have all required values', () {
      expect(StockStatus.values.length, 3);
      expect(StockStatus.values.contains(StockStatus.enStock), true);
      expect(StockStatus.values.contains(StockStatus.vendu), true);
      expect(StockStatus.values.contains(StockStatus.retourne), true);
    });

    test('Phone model should have canBeSold property', () {
      // Test enStock phone can be sold
      final phoneEnStock = TelephoneModel(
        id: 'test-1',
        userId: 'user-1',
        imei: '123456789',
        marqueId: 'marque-1',
        marqueName: 'Apple',
        modeleId: 'modele-1',
        modeleName: 'iPhone 12',
        couleurId: 'couleur-1',
        couleurName: 'Noir',
        capaciteId: 'capacite-1',
        capaciteValue: '128GB',
        prixAchat: 500.0,
        statutPaiementId: 'statut-1',
        statutPaiementLibelle: 'Payé',
        dateEntree: DateTime.now(),
        stockStatus: StockStatus.enStock,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(phoneEnStock.canBeSold, true);

      // Test vendu phone cannot be sold
      final phoneVendu = TelephoneModel(
        id: 'test-2',
        userId: 'user-1',
        imei: '987654321',
        marqueId: 'marque-2',
        marqueName: 'Samsung',
        modeleId: 'modele-2',
        modeleName: 'Galaxy S21',
        couleurId: 'couleur-2',
        couleurName: 'Blanc',
        capaciteId: 'capacite-2',
        capaciteValue: '256GB',
        prixAchat: 600.0,
        statutPaiementId: 'statut-1',
        statutPaiementLibelle: 'Payé',
        dateEntree: DateTime.now(),
        stockStatus: StockStatus.vendu,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(phoneVendu.canBeSold, false);

      // Test retourne phone can be sold
      final phoneRetourne = TelephoneModel(
        id: 'test-3',
        userId: 'user-1',
        imei: '555555555',
        marqueId: 'marque-3',
        marqueName: 'Google',
        modeleId: 'modele-3',
        modeleName: 'Pixel 6',
        couleurId: 'couleur-3',
        couleurName: 'Bleu',
        capaciteId: 'capacite-3',
        capaciteValue: '128GB',
        prixAchat: 450.0,
        statutPaiementId: 'statut-1',
        statutPaiementLibelle: 'Payé',
        dateEntree: DateTime.now(),
        stockStatus: StockStatus.retourne,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(phoneRetourne.canBeSold, true);
    });

    test('Phone model should calculate profit correctly', () {
      final phone = TelephoneModel(
        id: 'test-4',
        userId: 'user-1',
        imei: '111111111',
        marqueId: 'marque-1',
        marqueName: 'Apple',
        modeleId: 'modele-1',
        modeleName: 'iPhone 13',
        couleurId: 'couleur-1',
        couleurName: 'Noir',
        capaciteId: 'capacite-1',
        capaciteValue: '256GB',
        prixAchat: 700.0,
        prixVente: 900.0,
        statutPaiementId: 'statut-1',
        statutPaiementLibelle: 'Payé',
        dateEntree: DateTime.now(),
        stockStatus: StockStatus.vendu,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(phone.profit, 200.0);
    });

    test('Phone model should calculate margin percentage correctly', () {
      final phone = TelephoneModel(
        id: 'test-5',
        userId: 'user-1',
        imei: '222222222',
        marqueId: 'marque-2',
        marqueName: 'Samsung',
        modeleId: 'modele-2',
        modeleName: 'Galaxy S22',
        couleurId: 'couleur-2',
        couleurName: 'Blanc',
        capaciteId: 'capacite-2',
        capaciteValue: '128GB',
        prixAchat: 500.0,
        prixVente: 750.0,
        statutPaiementId: 'statut-1',
        statutPaiementLibelle: 'Payé',
        dateEntree: DateTime.now(),
        stockStatus: StockStatus.vendu,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(phone.marginPercentage, 50.0);
    });

    test('Phone model should return null profit when not sold', () {
      final phone = TelephoneModel(
        id: 'test-6',
        userId: 'user-1',
        imei: '333333333',
        marqueId: 'marque-1',
        marqueName: 'Apple',
        modeleId: 'modele-1',
        modeleName: 'iPhone 14',
        couleurId: 'couleur-1',
        couleurName: 'Noir',
        capaciteId: 'capacite-1',
        capaciteValue: '512GB',
        prixAchat: 800.0,
        statutPaiementId: 'statut-1',
        statutPaiementLibelle: 'Payé',
        dateEntree: DateTime.now(),
        stockStatus: StockStatus.enStock,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(phone.profit, null);
      expect(phone.marginPercentage, null);
    });
  });

  group('Checkpoint 8: Configuration Verification', () {
    test('App should have all required routes configured', () {
      final requiredRoutes = [
        Routes.SPLASH,
        Routes.AUTH,
        Routes.HUB,
        Routes.HOME,
        Routes.DASHBOARD,
        Routes.TRANSACTIONS,
      ];

      for (final route in requiredRoutes) {
        expect(route, isNotNull);
        expect(route, isNotEmpty);
      }
    });
  });
}
