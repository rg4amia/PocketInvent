# Design Document: Financial Dashboard & Transaction Management

## Overview

Ce document décrit le design technique pour l'ajout d'un tableau de bord financier complet, d'une gestion rigoureuse des transactions avec workflow de retour obligatoire, et d'une navigation moderne dans l'application PocketInvent. Le système utilisera Flutter avec GetX pour la gestion d'état, Supabase pour le backend, et Hive pour le cache local.

## Architecture

### Architecture Globale

L'application suit une architecture **MVVM (Model-View-ViewModel)** avec GetX :

```
┌─────────────────────────────────────────────────────────────┐
│                         Presentation Layer                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Dashboard   │  │ Transactions │  │  Inventory   │      │
│  │    View      │  │     View     │  │     View     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│         │                  │                  │              │
│         └──────────────────┴──────────────────┘              │
│                            │                                 │
│                    ┌───────▼────────┐                        │
│                    │  MainNavBar    │                        │
│                    │  (Bottom Nav)  │                        │
│                    └────────────────┘                        │
└─────────────────────────────────────────────────────────────┘
                             │
┌─────────────────────────────────────────────────────────────┐
│                      Business Logic Layer                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Dashboard   │  │ Transaction  │  │  Financial   │      │
│  │ Controller   │  │  Controller  │  │  Calculator  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                             │
┌─────────────────────────────────────────────────────────────┐
│                         Data Layer                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Supabase    │  │     Hive     │  │   Models     │      │
│  │   Service    │  │    Cache     │  │              │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### Flux de Données

1. **Lecture** : Supabase → Cache Hive → Controller → View
2. **Écriture** : View → Controller → Supabase + Cache Hive
3. **Calculs** : Controller → FinancialCalculator → Métriques → View

## Components and Interfaces

### 1. Navigation Component

#### MainNavBar (Bottom Navigation Bar)

```dart
class MainNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  
  // Sections de navigation
  static const List<NavItem> items = [
    NavItem(icon: Icons.dashboard, label: 'Dashboard', route: '/dashboard'),
    NavItem(icon: Icons.inventory, label: 'Inventaire', route: '/inventory'),
    NavItem(icon: Icons.receipt_long, label: 'Transactions', route: '/transactions'),
    NavItem(icon: Icons.person, label: 'Profil', route: '/profile'),
  ];
}
```

**Responsabilités** :
- Afficher les 4 sections principales
- Gérer la navigation entre les sections
- Mettre en évidence la section active
- Afficher des badges de notification

### 2. Dashboard Components

#### DashboardView

```dart
class DashboardView extends GetView<DashboardController> {
  // Sections du dashboard
  - PeriodSelector : Sélection de période
  - FinancialMetricsCard : Métriques principales
  - ChartsSection : Graphiques visuels
  - QuickStatsGrid : Statistiques rapides
}
```

#### FinancialMetricsCard

```dart
class FinancialMetricsCard extends StatelessWidget {
  final FinancialMetrics metrics;
  
  // Affiche :
  - Total des entrées (achats)
  - Total des sorties (ventes)
  - Profit net
  - Marge bénéficiaire
}
```

#### PeriodSelector

```dart
class PeriodSelector extends StatelessWidget {
  final Period selectedPeriod;
  final Function(Period) onPeriodChanged;
  
  // Périodes disponibles
  enum Period {
    today,
    thisWeek,
    thisMonth,
    thisYear,
    all,
    custom
  }
}
```

#### ChartsSection

```dart
class ChartsSection extends StatelessWidget {
  final List<Transaction> transactions;
  
  // Graphiques :
  - RevenueLineChart : Évolution du CA
  - InOutBarChart : Entrées vs Sorties
  - BrandPieChart : Répartition par marque
}
```

### 3. Transaction Components

#### TransactionListView

```dart
class TransactionListView extends GetView<TransactionController> {
  // Composants
  - TransactionFilters : Filtres (type, période)
  - TransactionList : Liste des transactions
  - TransactionCard : Carte individuelle
}
```

#### TransactionCard

```dart
class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  
  // Affiche :
  - Type de transaction (icône + couleur)
  - Montant (vert pour vente, rouge pour achat)
  - Téléphone (marque, modèle, IMEI)
  - Partie (fournisseur ou client)
  - Date et heure
}
```

#### TransactionFilters

```dart
class TransactionFilters extends StatelessWidget {
  final TransactionType? selectedType;
  final Period selectedPeriod;
  final Function(TransactionType?) onTypeChanged;
  final Function(Period) onPeriodChanged;
}
```

### 4. Workflow Components

#### ReturnDialog

```dart
class ReturnDialog extends StatelessWidget {
  final Phone phone;
  final Function(ReturnData) onConfirm;
  
  // Formulaire de retour :
  - Client concerné
  - Montant du remboursement
  - Raison du retour
  - Notes additionnelles
}
```

#### SaleBlockedDialog

```dart
class SaleBlockedDialog extends StatelessWidget {
  final Phone phone;
  
  // Message d'erreur quand vente bloquée
  // Propose d'enregistrer un retour
}
```

## Data Models

### Enhanced Models

#### Transaction Model (Enhanced)

```dart
class Transaction {
  final String id;
  final String userId;
  final String phoneId;
  final TransactionType type; // Achat, Vente, Retour
  final String? clientId;
  final String? fournisseurId;
  final double montant;
  final String statutPaiementId;
  final DateTime dateTransaction;
  final String? notes;
  
  // Relations
  final Phone? phone;
  final Client? client;
  final Fournisseur? fournisseur;
  final StatutPaiement? statutPaiement;
  
  // Méthodes calculées
  bool get isIncome => type == TransactionType.vente;
  bool get isExpense => type == TransactionType.achat || type == TransactionType.retour;
}

enum TransactionType {
  achat,
  vente,
  retour
}
```

#### Phone Model (Enhanced)

```dart
class Phone {
  // Champs existants...
  final String imei;
  final double prixAchat;
  final double? prixVente;
  
  // Nouveau champ pour le statut de stock
  final StockStatus stockStatus;
  
  // Méthodes calculées
  double? get profit => prixVente != null ? prixVente! - prixAchat : null;
  double? get marginPercentage => profit != null ? (profit! / prixAchat) * 100 : null;
  bool get canBeSold => stockStatus == StockStatus.enStock || stockStatus == StockStatus.retourne;
}

enum StockStatus {
  enStock,    // Disponible à la vente
  vendu,      // Vendu, nécessite retour avant revente
  retourne    // Retourné, peut être revendu
}
```

#### FinancialMetrics Model

```dart
class FinancialMetrics {
  final double totalEntrees;      // Total des achats
  final double totalSorties;      // Total des ventes
  final double profitNet;         // Sorties - Entrées
  final double margeBeneficiaire; // (Profit / Entrées) * 100
  final double valeurStock;       // Valeur des téléphones en stock
  final int nombreEnStock;
  final int nombreVendus;
  final int nombreRetournes;
  final Period period;
  
  FinancialMetrics({
    required this.totalEntrees,
    required this.totalSorties,
    required this.profitNet,
    required this.margeBeneficiaire,
    required this.valeurStock,
    required this.nombreEnStock,
    required this.nombreVendus,
    required this.nombreRetournes,
    required this.period,
  });
}
```

#### Period Model

```dart
class Period {
  final PeriodType type;
  final DateTime? startDate;
  final DateTime? endDate;
  
  Period.today() : type = PeriodType.today, startDate = null, endDate = null;
  Period.thisWeek() : type = PeriodType.thisWeek, startDate = null, endDate = null;
  Period.thisMonth() : type = PeriodType.thisMonth, startDate = null, endDate = null;
  Period.thisYear() : type = PeriodType.thisYear, startDate = null, endDate = null;
  Period.all() : type = PeriodType.all, startDate = null, endDate = null;
  Period.custom(this.startDate, this.endDate) : type = PeriodType.custom;
  
  // Méthodes pour obtenir les dates réelles
  DateTime getStartDate();
  DateTime getEndDate();
}

enum PeriodType {
  today,
  thisWeek,
  thisMonth,
  thisYear,
  all,
  custom
}
```

## Business Logic

### FinancialCalculator Service

```dart
class FinancialCalculator {
  // Calcul des métriques financières
  FinancialMetrics calculateMetrics({
    required List<Transaction> transactions,
    required List<Phone> phones,
    required Period period,
  }) {
    // Filtrer les transactions par période
    final filteredTransactions = _filterByPeriod(transactions, period);
    
    // Calculer les totaux
    final totalEntrees = _calculateTotalEntrees(filteredTransactions);
    final totalSorties = _calculateTotalSorties(filteredTransactions);
    final profitNet = totalSorties - totalEntrees;
    final margeBeneficiaire = totalEntrees > 0 ? (profitNet / totalEntrees) * 100 : 0;
    
    // Calculer les statistiques de stock
    final valeurStock = _calculateStockValue(phones);
    final nombreEnStock = phones.where((p) => p.stockStatus == StockStatus.enStock).length;
    final nombreVendus = _countSoldInPeriod(filteredTransactions);
    final nombreRetournes = _countReturnsInPeriod(filteredTransactions);
    
    return FinancialMetrics(...);
  }
  
  double _calculateTotalEntrees(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.achat)
        .fold(0.0, (sum, t) => sum + t.montant);
  }
  
  double _calculateTotalSorties(List<Transaction> transactions) {
    final ventes = transactions
        .where((t) => t.type == TransactionType.vente)
        .fold(0.0, (sum, t) => sum + t.montant);
    
    final retours = transactions
        .where((t) => t.type == TransactionType.retour)
        .fold(0.0, (sum, t) => sum + t.montant);
    
    return ventes - retours; // Les retours réduisent les sorties
  }
  
  double _calculateStockValue(List<Phone> phones) {
    return phones
        .where((p) => p.stockStatus == StockStatus.enStock)
        .fold(0.0, (sum, p) => sum + p.prixAchat);
  }
}
```

### TransactionService

```dart
class TransactionService {
  final SupabaseClient supabase;
  final HiveInterface hive;
  
  // Créer une transaction d'achat
  Future<Transaction> createPurchase({
    required Phone phone,
    required Fournisseur fournisseur,
    required double montant,
  }) async {
    final transaction = Transaction(
      type: TransactionType.achat,
      phoneId: phone.id,
      fournisseurId: fournisseur.id,
      montant: montant,
      dateTransaction: DateTime.now(),
    );
    
    // Sauvegarder dans Supabase
    await supabase.from('historique_transaction').insert(transaction.toJson());
    
    // Mettre à jour le statut du téléphone
    await _updatePhoneStatus(phone.id, StockStatus.enStock);
    
    // Mettre en cache
    await _cacheTransaction(transaction);
    
    return transaction;
  }
  
  // Créer une transaction de vente
  Future<Transaction> createSale({
    required Phone phone,
    required Client client,
    required double montant,
  }) async {
    // Vérifier que le téléphone peut être vendu
    if (!phone.canBeSold) {
      throw SaleBlockedException(
        'Ce téléphone ne peut pas être vendu. '
        'Il doit d\'abord être marqué comme retourné.'
      );
    }
    
    final transaction = Transaction(
      type: TransactionType.vente,
      phoneId: phone.id,
      clientId: client.id,
      montant: montant,
      dateTransaction: DateTime.now(),
    );
    
    await supabase.from('historique_transaction').insert(transaction.toJson());
    await _updatePhoneStatus(phone.id, StockStatus.vendu);
    await _cacheTransaction(transaction);
    
    return transaction;
  }
  
  // Créer une transaction de retour
  Future<Transaction> createReturn({
    required Phone phone,
    required Client client,
    required double montantRemboursement,
    String? notes,
  }) async {
    // Vérifier que le téléphone est vendu
    if (phone.stockStatus != StockStatus.vendu) {
      throw InvalidReturnException(
        'Ce téléphone n\'est pas marqué comme vendu.'
      );
    }
    
    final transaction = Transaction(
      type: TransactionType.retour,
      phoneId: phone.id,
      clientId: client.id,
      montant: montantRemboursement,
      dateTransaction: DateTime.now(),
      notes: notes,
    );
    
    await supabase.from('historique_transaction').insert(transaction.toJson());
    await _updatePhoneStatus(phone.id, StockStatus.retourne);
    await _cacheTransaction(transaction);
    
    return transaction;
  }
  
  Future<void> _updatePhoneStatus(String phoneId, StockStatus status) async {
    await supabase
        .from('telephone')
        .update({'stock_status': status.name})
        .eq('id', phoneId);
  }
}
```

### DashboardController

```dart
class DashboardController extends GetxController {
  final TransactionService transactionService;
  final FinancialCalculator calculator;
  
  final Rx<Period> selectedPeriod = Period.thisMonth().obs;
  final Rx<FinancialMetrics?> metrics = Rx<FinancialMetrics?>(null);
  final RxList<Transaction> transactions = <Transaction>[].obs;
  final RxList<Phone> phones = <Phone>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
    
    // Écouter les changements de période
    ever(selectedPeriod, (_) => calculateMetrics());
  }
  
  Future<void> loadData() async {
    isLoading.value = true;
    try {
      // Charger depuis le cache d'abord
      transactions.value = await _loadCachedTransactions();
      phones.value = await _loadCachedPhones();
      
      // Calculer les métriques
      calculateMetrics();
      
      // Synchroniser avec Supabase en arrière-plan
      await _syncWithSupabase();
    } finally {
      isLoading.value = false;
    }
  }
  
  void calculateMetrics() {
    metrics.value = calculator.calculateMetrics(
      transactions: transactions,
      phones: phones,
      period: selectedPeriod.value,
    );
  }
  
  void changePeriod(Period newPeriod) {
    selectedPeriod.value = newPeriod;
  }
}
```

## Database Schema Updates

### Nouvelle colonne pour telephone

```sql
-- Ajouter la colonne stock_status
ALTER TABLE telephone 
ADD COLUMN stock_status TEXT NOT NULL DEFAULT 'enStock'
CHECK (stock_status IN ('enStock', 'vendu', 'retourne'));

-- Index pour améliorer les performances
CREATE INDEX idx_telephone_stock_status ON telephone(stock_status);
CREATE INDEX idx_telephone_user_status ON telephone(user_id, stock_status);
```

### Nouvelle table pour les métriques en cache (optionnel)

```sql
-- Table pour mettre en cache les métriques calculées
CREATE TABLE financial_metrics_cache (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    period_type TEXT NOT NULL,
    period_start DATE,
    period_end DATE,
    total_entrees DECIMAL(10, 2),
    total_sorties DECIMAL(10, 2),
    profit_net DECIMAL(10, 2),
    marge_beneficiaire DECIMAL(5, 2),
    valeur_stock DECIMAL(10, 2),
    nombre_en_stock INTEGER,
    nombre_vendus INTEGER,
    nombre_retournes INTEGER,
    calculated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, period_type, period_start, period_end)
);

-- RLS pour financial_metrics_cache
ALTER TABLE financial_metrics_cache ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own metrics" ON financial_metrics_cache
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own metrics" ON financial_metrics_cache
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own metrics" ON financial_metrics_cache
    FOR UPDATE USING (auth.uid() = user_id);
```

## Error Handling

### Custom Exceptions

```dart
class SaleBlockedException implements Exception {
  final String message;
  SaleBlockedException(this.message);
}

class InvalidReturnException implements Exception {
  final String message;
  InvalidReturnException(this.message);
}

class InsufficientDataException implements Exception {
  final String message;
  InsufficientDataException(this.message);
}
```

### Error Handling Strategy

1. **Validation des transactions** : Vérifier les statuts avant toute opération
2. **Messages utilisateur clairs** : Expliquer pourquoi une action est bloquée
3. **Fallback gracieux** : Afficher les données en cache si la sync échoue
4. **Retry automatique** : Réessayer les opérations échouées en arrière-plan
5. **Logs détaillés** : Enregistrer toutes les erreurs pour le debugging

## Testing Strategy

### Unit Tests

Tests pour les calculs financiers et la logique métier :

```dart
// Test du FinancialCalculator
test('calculateMetrics should compute correct totals', () {
  final transactions = [
    Transaction(type: TransactionType.achat, montant: 500),
    Transaction(type: TransactionType.vente, montant: 700),
  ];
  
  final metrics = calculator.calculateMetrics(
    transactions: transactions,
    phones: [],
    period: Period.all(),
  );
  
  expect(metrics.totalEntrees, 500);
  expect(metrics.totalSorties, 700);
  expect(metrics.profitNet, 200);
});

// Test du workflow de retour
test('createSale should throw when phone is sold', () async {
  final phone = Phone(stockStatus: StockStatus.vendu);
  
  expect(
    () => transactionService.createSale(phone: phone, ...),
    throwsA(isA<SaleBlockedException>()),
  );
});
```

### Property-Based Tests

Tests avec génération aléatoire de données pour valider les propriétés universelles.

### Integration Tests

Tests de bout en bout pour les workflows complets :

```dart
testWidgets('Complete return workflow', (tester) async {
  // 1. Créer un téléphone et le vendre
  // 2. Tenter de revendre (doit échouer)
  // 3. Enregistrer un retour
  // 4. Revendre avec succès
});
```

## Performance Considerations

### Optimisations

1. **Calculs en arrière-plan** : Utiliser des isolates pour les calculs lourds
2. **Pagination** : Charger les transactions par lots de 50
3. **Cache intelligent** : Mettre en cache les métriques calculées
4. **Indexes database** : Optimiser les requêtes Supabase
5. **Lazy loading** : Charger les graphiques à la demande
6. **Debouncing** : Limiter les recalculs lors des changements de filtre

### Métriques de Performance

- Temps de chargement du dashboard : < 500ms
- Temps de calcul des métriques : < 100ms
- Temps de création de transaction : < 200ms
- Taille du cache Hive : < 10MB

## UI/UX Considerations

### Design System

**Couleurs** :
- Vert (#4CAF50) : Profits, ventes, positif
- Rouge (#F44336) : Dépenses, achats, négatif
- Bleu (#2196F3) : Informations, neutre
- Gris (#9E9E9E) : Désactivé, secondaire

**Typographie** :
- Titres : 24sp, Bold
- Sous-titres : 18sp, Medium
- Corps : 14sp, Regular
- Montants : 20sp, Bold (avec symbole €)

**Animations** :
- Transition entre sections : 300ms
- Apparition des cartes : Fade in + Slide up
- Mise à jour des chiffres : Count up animation

### Responsive Design

- Adaptation pour tablettes (layout en grille)
- Support du mode paysage
- Tailles de police adaptatives
- Espacement proportionnel

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Financial Calculation Properties

Property 1: Total Entrées Calculation
*For any* set of transactions and selected period, the total entrées should equal the sum of all purchase transaction amounts within that period
**Validates: Requirements 1.2**

Property 2: Total Sorties Calculation
*For any* set of transactions and selected period, the total sorties should equal the sum of all sale transactions minus the sum of all return transactions within that period
**Validates: Requirements 1.3, 6.3**

Property 3: Profit Net Formula
*For any* calculated financial metrics, the profit net should equal total sorties minus total entrées
**Validates: Requirements 1.4, 6.4**

Property 4: Marge Bénéficiaire Formula
*For any* financial metrics where total entrées is greater than zero, the marge bénéficiaire should equal (profit net / total entrées) * 100
**Validates: Requirements 1.5**

Property 5: Stock Value Calculation
*For any* list of phones, the stock value should equal the sum of prix_achat for all phones with status "enStock"
**Validates: Requirements 1.10, 6.5**

Property 6: Phone Profit Calculation
*For any* sold phone with non-null prix_vente, the profit should equal prix_vente minus prix_achat
**Validates: Requirements 6.1**

Property 7: Phone Margin Calculation
*For any* sold phone with non-zero prix_achat and non-null prix_vente, the margin percentage should equal ((prix_vente - prix_achat) / prix_achat) * 100
**Validates: Requirements 6.2**

Property 8: Revenue Calculation
*For any* set of transactions, the total revenue should equal the sum of all sale transaction amounts
**Validates: Requirements 6.6**

Property 9: Expenses Calculation
*For any* set of transactions, the total expenses should equal the sum of all purchase transaction amounts
**Validates: Requirements 6.7**

### Transaction Workflow Properties

Property 10: Sale Blocking for Sold Phones
*For any* phone with status "Vendu", attempting to create a sale transaction should throw a SaleBlockedException
**Validates: Requirements 3.1, 3.2**

Property 11: Return Transaction Creation
*For any* phone with status "Vendu", creating a return should produce a transaction with type "Retour" and update the phone status to "Retourné"
**Validates: Requirements 3.3, 3.4**

Property 12: Resale After Return
*For any* phone with status "Retourné", creating a sale transaction should succeed and update the phone status to "Vendu"
**Validates: Requirements 3.5, 3.6**

Property 13: Transaction History Persistence
*For any* phone, all transactions (purchases, sales, returns) should remain in the historique_transaction table regardless of subsequent operations
**Validates: Requirements 3.7**

Property 14: Transaction History Ordering
*For any* phone's transaction history, the transactions should be ordered chronologically by date_transaction
**Validates: Requirements 3.8**

### Status Management Properties

Property 15: Initial Phone Status
*For any* newly created phone, the stock_status should be set to "enStock"
**Validates: Requirements 4.1**

Property 16: Status Change on Sale
*For any* phone with status "enStock" or "Retourné", creating a sale transaction should change the status to "Vendu"
**Validates: Requirements 4.2, 4.4**

Property 17: Status Change on Return
*For any* phone with status "Vendu", creating a return transaction should change the status to "Retourné"
**Validates: Requirements 4.3**

Property 18: Status Count Accuracy
*For any* list of phones, the count of phones by status should equal the number of phones with each respective status value
**Validates: Requirements 4.7, 1.7**

### Filtering and Display Properties

Property 19: Transaction Sorting
*For any* list of transactions displayed in history, the transactions should be sorted by date_transaction in descending order
**Validates: Requirements 2.1**

Property 20: Transaction Display Completeness
*For any* transaction displayed, the rendered output should contain the type, montant, phone details (marque, modèle, IMEI), and associated party (fournisseur or client)
**Validates: Requirements 2.2, 2.4, 2.5**

Property 21: Transaction Type Filtering
*For any* transaction list filtered by type, all displayed transactions should have the selected transaction type
**Validates: Requirements 2.6**

Property 22: Period Filtering
*For any* transaction list filtered by period, all displayed transactions should have date_transaction within the period's date range
**Validates: Requirements 2.7, 7.2, 7.4**

Property 23: IMEI Search Filtering
*For any* transaction list filtered by IMEI, all displayed transactions should be linked to a phone with the searched IMEI
**Validates: Requirements 2.8**

Property 24: Status Filtering
*For any* phone list filtered by status, all displayed phones should have the selected stock_status
**Validates: Requirements 4.6**

Property 25: Visual Color Coding
*For any* transaction displayed, purchases should use red styling and sales should use green styling
**Validates: Requirements 2.3, 8.5**

### Navigation Properties

Property 26: Navigation Route Mapping
*For any* navigation item tapped, the system should navigate to the corresponding route (Dashboard → /dashboard, Inventaire → /inventory, Transactions → /transactions, Profil → /profile)
**Validates: Requirements 5.3**

Property 27: Active Section Highlighting
*For any* active section, the corresponding navigation item should have active visual styling
**Validates: Requirements 5.4**

Property 28: Transaction Badge Visibility
*For any* state where new transactions exist since last view, the Transactions navigation icon should display a notification badge
**Validates: Requirements 5.6**

Property 29: Navigation Persistence
*For any* section being viewed, the bottom navigation bar should remain visible
**Validates: Requirements 5.7**

### Data Formatting Properties

Property 30: Monetary Format
*For any* monetary value displayed, the format should include exactly two decimal places and the appropriate currency symbol
**Validates: Requirements 6.8**

Property 31: Period Persistence
*For any* selected period, the selection should be saved to local storage and restored on next app launch
**Validates: Requirements 7.5**

Property 32: Empty Period Message
*For any* period with zero transactions, the system should display an informative message indicating no data exists
**Validates: Requirements 7.6, 8.7**

### Metrics Update Properties

Property 33: Metrics Recalculation on Period Change
*For any* period change, all financial metrics should be recalculated using only transactions within the new period
**Validates: Requirements 1.6**

Property 34: Metrics Update on Transaction Addition
*For any* newly added transaction, all dashboard metrics should immediately reflect the new transaction in their calculations
**Validates: Requirements 9.1**

Property 35: Metrics Caching
*For any* calculated financial metrics, the values should be stored in Hive cache for offline access
**Validates: Requirements 9.4**

Property 36: Offline Data Display
*For any* state where internet connection is unavailable, the system should display the most recent cached metrics and transactions
**Validates: Requirements 9.5**

Property 37: Sync Indicator Visibility
*For any* ongoing synchronization operation, a loading indicator should be visible to the user
**Validates: Requirements 9.7**

### Export Properties

Property 38: CSV Export Completeness
*For any* export request, the generated CSV file should contain all transactions for the selected period with columns for date, type, montant, IMEI, and party
**Validates: Requirements 10.1, 10.2**

Property 39: Export Filename Convention
*For any* generated export file, the filename should follow the pattern "PocketInvent_Transactions_{period}.csv" or "PocketInvent_Report_{period}.pdf"
**Validates: Requirements 10.5**

Property 40: Export Success Notification
*For any* completed export operation, a success notification should be displayed with sharing options
**Validates: Requirements 10.6**

### Chart Interaction Properties

Property 41: Chart Element Details
*For any* chart element tapped, the system should display detailed information about the data point
**Validates: Requirements 8.4**

Property 42: Chart Period Adaptation
*For any* period change, all charts should update to display only data within the new period
**Validates: Requirements 8.6**

## Security Considerations

1. **RLS Supabase** : Toutes les données isolées par user_id
2. **Validation côté serveur** : Vérifier les montants et statuts
3. **Transactions atomiques** : Utiliser des transactions DB pour la cohérence
4. **Audit trail** : Conserver l'historique complet des modifications
5. **Chiffrement** : Données sensibles chiffrées dans Hive

