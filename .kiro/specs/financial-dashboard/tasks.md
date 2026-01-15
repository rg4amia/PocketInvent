# Implementation Plan: Financial Dashboard & Transaction Management

## Overview

Ce plan d'implémentation détaille les étapes pour ajouter le tableau de bord financier, la gestion des transactions avec workflow de retour obligatoire, et la navigation moderne à l'application PocketInvent. L'implémentation sera progressive avec des checkpoints réguliers pour valider le bon fonctionnement.

## Tasks

- [x] 1. Mise à jour du schéma de base de données
  - Ajouter la colonne `stock_status` à la table `telephone`
  - Créer les indexes pour optimiser les requêtes
  - Mettre à jour les données existantes avec le statut par défaut
  - _Requirements: 4.1, 4.2, 4.3, 4.4_

- [x] 2. Créer les modèles de données enrichis
  - [x] 2.1 Étendre le modèle Phone avec StockStatus
    - Ajouter l'enum `StockStatus` (enStock, vendu, retourne)
    - Ajouter le champ `stockStatus` au modèle `Phone`
    - Ajouter les méthodes calculées `profit`, `marginPercentage`, `canBeSold`
    - Mettre à jour les méthodes `toJson` et `fromJson`
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 6.1, 6.2_

  - [x] 2.2 Créer le modèle FinancialMetrics
    - Définir la classe `FinancialMetrics` avec tous les champs
    - Implémenter les constructeurs et méthodes de sérialisation
    - _Requirements: 1.2, 1.3, 1.4, 1.5, 1.10_

  - [x] 2.3 Créer le modèle Period
    - Définir l'enum `PeriodType`
    - Créer la classe `Period` avec constructeurs nommés
    - Implémenter les méthodes `getStartDate()` et `getEndDate()`
    - _Requirements: 7.1, 7.2, 7.3_

  - [ ]* 2.4 Écrire les tests unitaires pour les modèles
    - Tester la sérialisation/désérialisation
    - Tester les méthodes calculées (profit, margin)
    - Tester les calculs de dates pour Period
    - _Requirements: 6.1, 6.2_

- [ ] 3. Implémenter le service FinancialCalculator
  - [x] 3.1 Créer la classe FinancialCalculator
    - Implémenter `calculateMetrics()`
    - Implémenter `_calculateTotalEntrees()`
    - Implémenter `_calculateTotalSorties()`
    - Implémenter `_calculateStockValue()`
    - Implémenter `_filterByPeriod()`
    - _Requirements: 1.2, 1.3, 1.4, 1.5, 1.10, 6.3, 6.4, 6.5, 6.6, 6.7_

  - [ ]* 3.2 Écrire les property tests pour FinancialCalculator
    - **Property 1: Total Entrées Calculation**
    - **Validates: Requirements 1.2**

  - [ ]* 3.3 Écrire les property tests pour les calculs de profit
    - **Property 3: Profit Net Formula**
    - **Validates: Requirements 1.4, 6.4**

  - [ ]* 3.4 Écrire les property tests pour les calculs de marge
    - **Property 4: Marge Bénéficiaire Formula**
    - **Validates: Requirements 1.5**

  - [ ]* 3.5 Écrire les property tests pour la valeur du stock
    - **Property 5: Stock Value Calculation**
    - **Validates: Requirements 1.10, 6.5**

- [ ] 4. Checkpoint - Valider les calculs financiers
  - Vérifier que tous les tests passent
  - Tester manuellement les calculs avec des données de test
  - Demander à l'utilisateur si des questions se posent

- [x] 5. Implémenter le service TransactionService
  - [x] 5.1 Créer la classe TransactionService
    - Implémenter `createPurchase()`
    - Implémenter `createSale()` avec validation du statut
    - Implémenter `createReturn()`
    - Implémenter `_updatePhoneStatus()`
    - Implémenter `_cacheTransaction()`
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 4.2, 4.3, 4.4_

  - [x] 5.2 Créer les exceptions personnalisées
    - Définir `SaleBlockedException`
    - Définir `InvalidReturnException`
    - Définir `InsufficientDataException`
    - _Requirements: 3.2_

  - [ ]* 5.3 Écrire les property tests pour le workflow de vente
    - **Property 10: Sale Blocking for Sold Phones**
    - **Validates: Requirements 3.1, 3.2**

  - [ ]* 5.4 Écrire les property tests pour le workflow de retour
    - **Property 11: Return Transaction Creation**
    - **Validates: Requirements 3.3, 3.4**

  - [ ]* 5.5 Écrire les property tests pour la revente après retour
    - **Property 12: Resale After Return**
    - **Validates: Requirements 3.5, 3.6**

  - [ ]* 5.6 Écrire les property tests pour la persistance de l'historique
    - **Property 13: Transaction History Persistence**
    - **Validates: Requirements 3.7**

- [x] 6. Implémenter les contrôleurs GetX
  - [x] 6.1 Créer le DashboardController
    - Définir les observables (selectedPeriod, metrics, transactions, phones)
    - Implémenter `loadData()`
    - Implémenter `calculateMetrics()`
    - Implémenter `changePeriod()`
    - Implémenter la synchronisation avec Supabase
    - _Requirements: 1.1, 1.6, 9.1, 9.4, 9.5_

  - [x] 6.2 Créer le TransactionController
    - Définir les observables pour les filtres
    - Implémenter `loadTransactions()`
    - Implémenter `filterByType()`
    - Implémenter `filterByPeriod()`
    - Implémenter `searchByIMEI()`
    - _Requirements: 2.1, 2.6, 2.7, 2.8_

  - [ ]* 6.3 Écrire les property tests pour les filtres
    - **Property 21: Transaction Type Filtering**
    - **Property 22: Period Filtering**
    - **Property 23: IMEI Search Filtering**
    - **Validates: Requirements 2.6, 2.7, 2.8**

- [x] 7. Créer la navigation moderne (Bottom NavBar)
  - [x] 7.1 Créer le widget MainNavBar
    - Définir les 4 sections (Dashboard, Inventaire, Transactions, Profil)
    - Implémenter la navigation entre sections
    - Ajouter les icônes modernes
    - Implémenter le highlighting de la section active
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.7_

  - [x] 7.2 Ajouter le système de badges de notification
    - Implémenter la détection de nouvelles transactions
    - Afficher le badge sur l'icône Transactions
    - _Requirements: 5.6_

  - [ ]* 7.3 Écrire les tests d'intégration pour la navigation
    - Tester la navigation entre sections
    - Tester le highlighting de la section active
    - Tester l'affichage des badges
    - _Requirements: 5.3, 5.4, 5.6_

- [x] 8. Checkpoint - Valider la navigation et les services
  - Vérifier que la navigation fonctionne correctement
  - Tester les workflows de transaction
  - Demander à l'utilisateur si des questions se posent

- [x] 9. Créer les composants du Dashboard
  - [x] 9.1 Créer le widget PeriodSelector
    - Afficher les périodes prédéfinies
    - Implémenter la sélection de période personnalisée
    - Gérer le changement de période
    - _Requirements: 7.1, 7.2, 7.3_

  - [x] 9.2 Créer le widget FinancialMetricsCard
    - Afficher les 4 métriques principales (entrées, sorties, profit, marge)
    - Utiliser les couleurs appropriées (vert/rouge)
    - Formater les montants avec 2 décimales et symbole €
    - _Requirements: 1.2, 1.3, 1.4, 1.5, 6.8_

  - [x] 9.3 Créer le widget QuickStatsGrid
    - Afficher le nombre de téléphones en stock
    - Afficher le nombre de téléphones vendus
    - Afficher le nombre de téléphones retournés
    - Afficher la valeur du stock
    - _Requirements: 1.7, 1.8, 1.9, 1.10_

  - [x] 9.4 Créer le widget ChartsSection
    - Implémenter le graphique en courbe (évolution CA)
    - Implémenter le graphique en barres (entrées vs sorties)
    - Implémenter le graphique circulaire (répartition par marque)
    - Ajouter l'interactivité (tap pour détails)
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.6_

  - [x] 9.5 Créer la vue DashboardView
    - Assembler tous les widgets
    - Gérer les états de chargement
    - Afficher les messages pour périodes vides
    - _Requirements: 1.1, 7.6, 8.7_

  - [ ]* 9.6 Écrire les tests de widget pour le Dashboard
    - Tester l'affichage des métriques
    - Tester le changement de période
    - Tester l'affichage des messages d'erreur
    - _Requirements: 1.1, 1.6, 7.6_

- [x] 10. Créer les composants des Transactions
  - [x] 10.1 Créer le widget TransactionCard
    - Afficher le type avec icône et couleur
    - Afficher le montant (vert pour vente, rouge pour achat)
    - Afficher les détails du téléphone (marque, modèle, IMEI)
    - Afficher la partie concernée (fournisseur ou client)
    - Afficher la date
    - _Requirements: 2.2, 2.3, 2.4, 2.5_

  - [x] 10.2 Créer le widget TransactionFilters
    - Implémenter le filtre par type
    - Implémenter le filtre par période
    - _Requirements: 2.6, 2.7_

  - [x] 10.3 Créer la vue TransactionListView
    - Afficher la liste des transactions triées par date
    - Intégrer les filtres
    - Gérer le scroll infini (pagination)
    - _Requirements: 2.1, 2.6, 2.7_

  - [ ]* 10.4 Écrire les property tests pour l'affichage des transactions
    - **Property 19: Transaction Sorting**
    - **Property 20: Transaction Display Completeness**
    - **Validates: Requirements 2.1, 2.2, 2.4, 2.5**

- [x] 11. Implémenter les dialogues de workflow
  - [x] 11.1 Créer le ReturnDialog
    - Formulaire de saisie du retour
    - Validation des données
    - Appel au TransactionService.createReturn()
    - _Requirements: 3.3, 3.4_

  - [x] 11.2 Créer le SaleBlockedDialog
    - Message d'erreur explicite
    - Bouton pour enregistrer un retour
    - _Requirements: 3.2_

  - [x] 11.3 Intégrer les dialogues dans les workflows
    - Afficher SaleBlockedDialog quand vente bloquée
    - Afficher ReturnDialog pour enregistrer un retour
    - _Requirements: 3.1, 3.2, 3.3_

- [x] 12. Checkpoint - Valider l'interface utilisateur
  - Tester tous les écrans et workflows
  - Vérifier la cohérence visuelle
  - Demander à l'utilisateur si des questions se posent

- [ ] 13. Implémenter la synchronisation et le cache
  - [ ] 13.1 Configurer Hive pour le cache des métriques
    - Créer les adapters Hive pour les modèles
    - Implémenter le cache des FinancialMetrics
    - Implémenter le cache des Transactions
    - _Requirements: 9.4_

  - [ ] 13.2 Implémenter la synchronisation Supabase
    - Écouter les changements en temps réel
    - Mettre à jour le cache local
    - Gérer les conflits de synchronisation
    - _Requirements: 9.3, 9.6_

  - [ ] 13.3 Implémenter le mode hors ligne
    - Détecter la perte de connexion
    - Afficher les données en cache
    - Afficher l'indicateur de synchronisation
    - _Requirements: 9.5, 9.7_

  - [ ]* 13.4 Écrire les tests pour le cache et la sync
    - Tester la mise en cache des métriques
    - Tester l'affichage des données hors ligne
    - _Requirements: 9.4, 9.5_

- [x] 14. Implémenter les fonctionnalités d'export
  - [x] 14.1 Créer le service ExportService
    - Implémenter `exportToCSV()`
    - Implémenter `exportToPDF()`
    - Implémenter le nommage des fichiers
    - _Requirements: 10.1, 10.2, 10.3, 10.5_

  - [x] 14.2 Intégrer l'export dans l'UI
    - Ajouter les boutons d'export
    - Afficher les notifications de succès
    - Implémenter le partage des fichiers
    - _Requirements: 10.4, 10.6_

  - [ ]* 14.3 Écrire les property tests pour l'export
    - **Property 38: CSV Export Completeness**
    - **Property 39: Export Filename Convention**
    - **Validates: Requirements 10.1, 10.2, 10.5**

- [-] 15. Optimisations et polish
  - [x] 15.1 Optimiser les performances
    - Implémenter la pagination pour les transactions
    - Utiliser des isolates pour les calculs lourds
    - Optimiser les requêtes Supabase avec indexes
    - _Requirements: 9.2_

  - [-] 15.2 Améliorer l'UX
    - Ajouter des animations de transition
    - Implémenter le pull-to-refresh
    - Ajouter des skeleton loaders
    - _Requirements: 1.1, 9.1_

  - [ ] 15.3 Tester sur différents appareils
    - Tester sur iPhone (priorité)
    - Tester sur Android
    - Vérifier le responsive design
    - _Requirements: Tous_

- [ ] 16. Checkpoint final - Tests complets
  - Exécuter tous les tests unitaires et d'intégration
  - Tester tous les workflows de bout en bout
  - Vérifier les performances
  - Demander à l'utilisateur de valider l'implémentation complète

## Notes

- Les tâches marquées avec `*` sont optionnelles et peuvent être sautées pour un MVP plus rapide
- Chaque tâche référence les requirements spécifiques pour la traçabilité
- Les checkpoints permettent une validation incrémentale
- Les property tests valident les propriétés de correction universelles
- Les tests unitaires valident des exemples spécifiques et cas limites
- L'implémentation suit l'architecture MVVM avec GetX
- La priorité est donnée à iOS (iPhone) comme spécifié dans le cahier des charges
