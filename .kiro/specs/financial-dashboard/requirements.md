# Requirements Document

## Introduction

Cette spécification définit les améliorations financières et de navigation pour l'application PocketInvent. L'objectif est d'ajouter un tableau de bord financier complet, une gestion comptable rigoureuse des transactions, un workflow de retour obligatoire avant revente, et une navigation moderne pour améliorer l'expérience utilisateur.

## Glossary

- **System**: L'application mobile PocketInvent
- **Dashboard**: Tableau de bord financier affichant les métriques et statistiques
- **Transaction**: Opération financière (Achat, Vente, Retour)
- **Entrée**: Transaction d'achat de téléphone auprès d'un fournisseur
- **Sortie**: Transaction de vente de téléphone à un client
- **Retour**: Transaction de retour d'un téléphone par un client
- **Workflow_Retour**: Processus obligatoire de retour avant revente
- **Navbar**: Barre de navigation moderne de l'application
- **Métrique_Financière**: Indicateur calculé (revenus, dépenses, profit, marge)
- **Période**: Intervalle de temps pour les calculs (jour, semaine, mois, année)
- **Statut_Stock**: État actuel d'un téléphone (En_Stock, Vendu, Retourné)

## Requirements

### Requirement 1: Tableau de Bord Financier

**User Story:** En tant qu'utilisateur, je veux visualiser un tableau de bord financier complet, afin de suivre mes performances commerciales et ma rentabilité.

#### Acceptance Criteria

1. WHEN l'utilisateur accède au tableau de bord, THE System SHALL afficher les métriques financières pour la période sélectionnée
2. THE System SHALL calculer et afficher le total des entrées (achats) pour la période
3. THE System SHALL calculer et afficher le total des sorties (ventes) pour la période
4. THE System SHALL calculer et afficher le profit net (sorties - entrées) pour la période
5. THE System SHALL calculer et afficher la marge bénéficiaire en pourcentage
6. WHEN l'utilisateur sélectionne une période différente, THE System SHALL recalculer toutes les métriques pour cette période
7. THE System SHALL afficher le nombre total de téléphones en stock
8. THE System SHALL afficher le nombre total de téléphones vendus pour la période
9. THE System SHALL afficher le nombre total de téléphones retournés pour la période
10. THE System SHALL afficher la valeur totale du stock actuel

### Requirement 2: Visualisation des Transactions

**User Story:** En tant qu'utilisateur, je veux visualiser l'historique détaillé de toutes mes transactions, afin de comprendre mes flux financiers.

#### Acceptance Criteria

1. WHEN l'utilisateur accède à l'historique des transactions, THE System SHALL afficher toutes les transactions triées par date décroissante
2. THE System SHALL afficher pour chaque transaction le type (Achat, Vente, Retour)
3. THE System SHALL afficher pour chaque transaction le montant avec indication visuelle (entrée en rouge, sortie en vert)
4. THE System SHALL afficher pour chaque transaction le téléphone concerné (marque, modèle, IMEI)
5. THE System SHALL afficher pour chaque transaction la partie concernée (fournisseur ou client)
6. WHEN l'utilisateur filtre par type de transaction, THE System SHALL afficher uniquement les transactions du type sélectionné
7. WHEN l'utilisateur filtre par période, THE System SHALL afficher uniquement les transactions de la période sélectionnée
8. WHEN l'utilisateur recherche par IMEI, THE System SHALL afficher toutes les transactions liées à ce téléphone

### Requirement 3: Workflow de Retour Obligatoire

**User Story:** En tant qu'utilisateur, je veux qu'un téléphone vendu ne puisse être revendu qu'après avoir été marqué comme retourné, afin de garantir la traçabilité et l'intégrité des transactions.

#### Acceptance Criteria

1. WHEN un téléphone a le statut "Vendu", THE System SHALL empêcher toute nouvelle vente de ce téléphone
2. WHEN l'utilisateur tente de vendre un téléphone avec statut "Vendu", THE System SHALL afficher un message d'erreur explicite
3. WHEN l'utilisateur enregistre un retour pour un téléphone vendu, THE System SHALL créer une transaction de type "Retour"
4. WHEN un retour est enregistré, THE System SHALL changer le statut du téléphone de "Vendu" à "Retourné"
5. WHEN un téléphone a le statut "Retourné", THE System SHALL permettre une nouvelle vente
6. WHEN une nouvelle vente est effectuée après retour, THE System SHALL créer une transaction de type "Vente"
7. THE System SHALL maintenir l'historique complet de toutes les transactions (vente initiale, retour, revente)
8. WHEN l'utilisateur consulte l'historique d'un téléphone, THE System SHALL afficher toutes les transactions dans l'ordre chronologique

### Requirement 4: Gestion des Statuts de Stock

**User Story:** En tant qu'utilisateur, je veux que le système gère automatiquement les statuts de stock, afin de toujours connaître l'état actuel de mes téléphones.

#### Acceptance Criteria

1. WHEN un téléphone est ajouté au système, THE System SHALL lui attribuer le statut "En_Stock"
2. WHEN une vente est enregistrée, THE System SHALL changer le statut du téléphone à "Vendu"
3. WHEN un retour est enregistré, THE System SHALL changer le statut du téléphone à "Retourné"
4. WHEN une revente est effectuée après retour, THE System SHALL changer le statut du téléphone à "Vendu"
5. THE System SHALL afficher le statut actuel sur la fiche de chaque téléphone
6. WHEN l'utilisateur filtre par statut, THE System SHALL afficher uniquement les téléphones avec le statut sélectionné
7. THE System SHALL calculer automatiquement le nombre de téléphones par statut pour le tableau de bord

### Requirement 5: Navigation Moderne

**User Story:** En tant qu'utilisateur, je veux une navigation moderne et intuitive, afin d'accéder rapidement aux différentes sections de l'application.

#### Acceptance Criteria

1. THE System SHALL afficher une barre de navigation en bas de l'écran (bottom navigation bar)
2. THE System SHALL inclure dans la navigation les sections : Dashboard, Inventaire, Transactions, Profil
3. WHEN l'utilisateur tape sur une icône de navigation, THE System SHALL afficher la section correspondante
4. THE System SHALL mettre en évidence visuellement la section active dans la navigation
5. THE System SHALL utiliser des icônes modernes et reconnaissables pour chaque section
6. THE System SHALL afficher un badge de notification sur l'icône Transactions quand de nouvelles transactions sont ajoutées
7. WHEN l'utilisateur est sur une section, THE System SHALL maintenir la navigation visible et accessible

### Requirement 6: Calculs Financiers Avancés

**User Story:** En tant qu'utilisateur, je veux des calculs financiers précis et automatiques, afin de prendre des décisions éclairées sur mon activité.

#### Acceptance Criteria

1. THE System SHALL calculer le profit pour chaque téléphone vendu (prix_vente - prix_achat)
2. THE System SHALL calculer la marge bénéficiaire pour chaque téléphone vendu ((prix_vente - prix_achat) / prix_achat * 100)
3. WHEN un retour est enregistré avec remboursement, THE System SHALL déduire le montant du remboursement des revenus
4. THE System SHALL calculer le profit net total en tenant compte de tous les retours
5. THE System SHALL calculer la valeur du stock actuel (somme des prix_achat des téléphones en stock)
6. THE System SHALL calculer le chiffre d'affaires total (somme de toutes les ventes)
7. THE System SHALL calculer les dépenses totales (somme de tous les achats)
8. THE System SHALL afficher tous les montants avec deux décimales et le symbole de devise approprié

### Requirement 7: Filtres et Périodes

**User Story:** En tant qu'utilisateur, je veux filtrer les données par période, afin d'analyser mes performances sur différents intervalles de temps.

#### Acceptance Criteria

1. THE System SHALL proposer les périodes prédéfinies : Aujourd'hui, Cette semaine, Ce mois, Cette année, Tout
2. WHEN l'utilisateur sélectionne une période, THE System SHALL filtrer toutes les données du tableau de bord pour cette période
3. WHEN l'utilisateur sélectionne une période personnalisée, THE System SHALL permettre de choisir une date de début et une date de fin
4. THE System SHALL appliquer le filtre de période aux transactions, aux métriques financières et aux graphiques
5. THE System SHALL sauvegarder la dernière période sélectionnée pour la restaurer à la prochaine ouverture
6. WHEN aucune donnée n'existe pour la période sélectionnée, THE System SHALL afficher un message informatif

### Requirement 8: Graphiques et Visualisations

**User Story:** En tant qu'utilisateur, je veux des graphiques visuels de mes données financières, afin de comprendre rapidement les tendances de mon activité.

#### Acceptance Criteria

1. THE System SHALL afficher un graphique en courbe de l'évolution du chiffre d'affaires sur la période
2. THE System SHALL afficher un graphique en barres comparant les entrées et sorties par mois
3. THE System SHALL afficher un graphique circulaire de la répartition des ventes par marque
4. WHEN l'utilisateur tape sur un élément du graphique, THE System SHALL afficher les détails correspondants
5. THE System SHALL utiliser des couleurs cohérentes (vert pour profits, rouge pour dépenses)
6. THE System SHALL adapter les graphiques à la période sélectionnée
7. WHEN les données sont insuffisantes pour un graphique, THE System SHALL afficher un message approprié

### Requirement 9: Synchronisation et Performance

**User Story:** En tant qu'utilisateur, je veux que les calculs financiers soient rapides et que les données soient toujours à jour, afin d'avoir une vision fiable de mon activité.

#### Acceptance Criteria

1. WHEN une transaction est ajoutée, THE System SHALL mettre à jour immédiatement toutes les métriques du tableau de bord
2. THE System SHALL calculer les métriques en arrière-plan sans bloquer l'interface utilisateur
3. THE System SHALL synchroniser les données avec Supabase en temps réel
4. THE System SHALL mettre en cache les métriques calculées dans Hive pour un accès instantané
5. WHEN la connexion internet est perdue, THE System SHALL afficher les dernières données en cache
6. WHEN la connexion est rétablie, THE System SHALL synchroniser automatiquement les nouvelles transactions
7. THE System SHALL afficher un indicateur de synchronisation pendant les opérations de mise à jour

### Requirement 10: Exports et Rapports

**User Story:** En tant qu'utilisateur, je veux exporter mes données financières, afin de les utiliser dans d'autres outils ou pour ma comptabilité.

#### Acceptance Criteria

1. WHEN l'utilisateur demande un export, THE System SHALL générer un fichier CSV des transactions pour la période sélectionnée
2. THE System SHALL inclure dans l'export toutes les colonnes pertinentes (date, type, montant, IMEI, partie)
3. WHEN l'utilisateur demande un rapport PDF, THE System SHALL générer un document avec les métriques et graphiques
4. THE System SHALL permettre de partager l'export via email, messagerie ou stockage cloud
5. THE System SHALL nommer les fichiers exportés avec la date et la période (ex: "PocketInvent_Transactions_2024-01.csv")
6. WHEN l'export est généré, THE System SHALL afficher une notification de succès avec option de partage
