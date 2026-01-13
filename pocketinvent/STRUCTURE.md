# 📁 Structure du Projet PocketInvent

## 🎯 Vue d'Ensemble

PocketInvent est une application Flutter complète de gestion de stock de téléphones avec :
- Architecture GetX (MVC)
- Base de données locale Hive
- Backend Supabase (PostgreSQL + Auth + Storage)
- OCR pour extraction d'IMEI
- Design iOS natif

## 📂 Structure des Dossiers

```
pocketinvent/
├── lib/
│   ├── main.dart                          # Point d'entrée de l'application
│   └── app/
│       ├── core/
│       │   └── theme/
│       │       ├── app_colors.dart        # Palette de couleurs
│       │       └── app_theme.dart         # Thème de l'application
│       │
│       ├── data/
│       │   ├── models/
│       │   │   ├── telephone_model.dart   # Modèle Téléphone + Hive
│       │   │   ├── telephone_model.g.dart # Généré par Hive
│       │   │   ├── transaction_model.dart # Modèle Transaction + Hive
│       │   │   └── transaction_model.g.dart
│       │   │
│       │   └── services/
│       │       ├── supabase_service.dart  # Service Supabase (CRUD, Auth)
│       │       ├── storage_service.dart   # Service Hive (cache local)
│       │       └── ocr_service.dart       # Service OCR (extraction IMEI)
│       │
│       ├── modules/
│       │   ├── splash/
│       │   │   ├── splash_view.dart       # Écran de démarrage
│       │   │   ├── splash_controller.dart # Logique splash
│       │   │   └── splash_binding.dart    # Injection de dépendances
│       │   │
│       │   ├── auth/
│       │   │   ├── auth_view.dart         # Écran connexion/inscription
│       │   │   ├── auth_controller.dart   # Logique authentification
│       │   │   └── auth_binding.dart
│       │   │
│       │   ├── home/
│       │   │   ├── home_view.dart         # Liste des téléphones
│       │   │   ├── home_controller.dart   # Logique liste + recherche
│       │   │   └── home_binding.dart
│       │   │
│       │   └── phone/
│       │       ├── add_phone_view.dart    # Ajout de téléphone
│       │       ├── add_phone_controller.dart # Logique ajout + OCR
│       │       ├── add_phone_binding.dart
│       │       ├── phone_detail_view.dart # Détails + historique
│       │       ├── phone_detail_controller.dart
│       │       └── phone_detail_binding.dart
│       │
│       └── routes/
│           ├── app_pages.dart             # Configuration des routes
│           └── app_routes.dart            # Définition des routes
│
├── android/                               # Configuration Android
│   └── app/src/main/AndroidManifest.xml  # Permissions + Deep links
│
├── ios/                                   # Configuration iOS
│   └── Runner/
│       └── Info.plist                     # Permissions + URL schemes
│
├── assets/
│   └── images/                            # Images de l'application
│
├── .env                                   # Variables d'environnement (Supabase)
├── .env.example                           # Exemple de configuration
├── pubspec.yaml                           # Dépendances Flutter
├── supabase_schema.sql                    # Schéma de base de données
├── README.md                              # Documentation principale
├── INSTALLATION.md                        # Guide d'installation détaillé
├── QUICKSTART.md                          # Guide de démarrage rapide
└── STRUCTURE.md                           # Ce fichier
```

## 🔧 Technologies Utilisées

### Frontend
- **Flutter** : Framework UI multiplateforme
- **GetX** : Gestion d'état, navigation, injection de dépendances
- **Hive** : Base de données locale NoSQL

### Backend
- **Supabase** : Backend-as-a-Service
  - PostgreSQL (base de données)
  - Auth (authentification)
  - Storage (stockage de fichiers)
  - Realtime (synchronisation temps réel)

### Fonctionnalités
- **Google ML Kit** : OCR pour extraction d'IMEI
- **Image Picker** : Capture et sélection de photos
- **Cached Network Image** : Cache d'images optimisé
- **Intl** : Formatage de dates et nombres

## 🎨 Design System

Basé sur le fichier `design.json` fourni :

### Couleurs
- **Primary Blue** : `#007AFF` (boutons, liens)
- **Incoming Accent** : `#FF3B30` (rouge - entrées)
- **Outgoing Accent** : `#34C759` (vert - sorties)
- **Text Primary** : `#000000`
- **Text Secondary** : `#8E8E93`
- **Background** : `#F2F2F7`

### Typographie
- **Système** : SF Pro Text (iOS natif)
- **Tailles** : 13-32px selon le contexte

### Composants
- Cards avec `borderRadius: 12px`
- Shadows subtiles (`rgba(0,0,0,0.08)`)
- Segmented control (pill-shaped)
- Search bar avec icône

## 🗄️ Base de Données

### Tables Principales

#### `telephone`
Stocke les informations des téléphones :
- IMEI (unique par utilisateur)
- Marque, modèle, couleur, capacité
- Prix d'achat/vente
- Fournisseur
- Statut de paiement
- Photo

#### `historique_transaction`
Historique complet des opérations :
- Type (Achat, Vente, Retour)
- Client/Fournisseur
- Montant
- Date
- Notes

#### Tables de Référence
- `marque` : Marques de téléphones
- `modele` : Modèles par marque
- `couleur` : Couleurs disponibles
- `capacite` : Capacités de stockage
- `statut_paiement` : Statuts (Payé, Retour, Revendu)
- `fournisseur` : Fournisseurs de l'utilisateur
- `client` : Clients de l'utilisateur

### Sécurité (RLS)
Toutes les tables utilisent Row Level Security :
- Chaque utilisateur ne voit que ses données
- Isolation complète entre utilisateurs
- Politiques définies dans `supabase_schema.sql`

## 🔐 Authentification

### Méthodes Supportées
1. **Email + Mot de passe** (par défaut)
2. **Sign in with Apple** (recommandé pour iOS)
3. **Google Sign In** (optionnel)

### Flux d'Authentification
1. Splash screen → Vérification de session
2. Si connecté → Home
3. Si non connecté → Auth screen
4. Après connexion → Synchronisation des données

## 📸 OCR - Extraction d'IMEI

### Fonctionnement
1. Utilisateur prend une photo de l'étiquette IMEI
2. Google ML Kit extrait le texte
3. Regex recherche un pattern de 15 chiffres
4. Validation du format IMEI
5. Pré-remplissage du champ

### Patterns Supportés
- `123456789012345` (15 chiffres consécutifs)
- `12 345678 901234 5` (avec espaces)
- `12-345678-901234-5` (avec tirets)

## 🔄 Synchronisation

### Stratégie
1. **Lecture** : Cache local (Hive) → Affichage immédiat
2. **Sync** : Supabase en arrière-plan
3. **Écriture** : Supabase → Cache local
4. **Hors ligne** : Lecture seule depuis Hive

### Avantages
- Démarrage instantané
- Fonctionne hors ligne (lecture)
- Synchronisation transparente
- Pas de perte de données

## 🚀 Flux Utilisateur

### 1. Première Utilisation
```
Splash → Auth → Inscription → Vérification email → Connexion → Home (vide)
```

### 2. Ajout d'un Téléphone
```
Home → + → Scanner IMEI (ou saisie manuelle) → Photo → Détails → Enregistrer → Home
```

### 3. Recherche
```
Home → Barre de recherche → Saisie → Filtrage temps réel → Résultats
```

### 4. Vente
```
Home → Téléphone → Menu → Vendre → Formulaire → Enregistrer → Historique mis à jour
```

## 📦 Dépendances Principales

```yaml
# État et Navigation
get: ^4.6.6

# Base de données
hive: ^2.2.3
hive_flutter: ^1.1.0
supabase_flutter: ^2.5.0

# OCR et Images
google_mlkit_text_recognition: ^0.11.0
image_picker: ^1.0.7
cached_network_image: ^3.3.1

# Authentification
sign_in_with_apple: ^5.0.0
google_sign_in: ^6.2.1

# Utilitaires
intl: ^0.19.0
flutter_dotenv: ^5.1.0
```

## 🎯 Points d'Entrée

### main.dart
1. Initialise Hive
2. Initialise Supabase
3. Configure le thème
4. Lance l'application avec GetX

### Routes
- `/splash` : Écran de démarrage
- `/auth` : Authentification
- `/home` : Liste des téléphones
- `/add-phone` : Ajout de téléphone
- `/phone-detail` : Détails d'un téléphone

## 🔨 Commandes Utiles

```bash
# Installer les dépendances
flutter pub get

# Générer les adaptateurs Hive
flutter pub run build_runner build

# Lancer l'application
flutter run

# Build iOS
flutter build ios --release

# Build Android
flutter build apk --release

# Nettoyer le projet
flutter clean
```

## 📝 Fichiers de Configuration

- `.env` : Credentials Supabase (ne pas commiter)
- `.env.example` : Template de configuration
- `pubspec.yaml` : Dépendances et assets
- `supabase_schema.sql` : Schéma de base de données
- `Info.plist` : Configuration iOS
- `AndroidManifest.xml` : Configuration Android

## 🎓 Bonnes Pratiques Implémentées

✅ Architecture MVC avec GetX
✅ Séparation des responsabilités
✅ Services réutilisables
✅ Gestion d'erreurs
✅ Cache local pour performance
✅ Sécurité RLS
✅ Validation des données
✅ UI responsive
✅ Design iOS natif
✅ Code commenté et structuré

## 🔜 Évolutions Possibles

- [ ] Mode sombre
- [ ] Export de données (CSV, PDF)
- [ ] Statistiques et graphiques
- [ ] Notifications push
- [ ] Scan de code-barres
- [ ] Multi-langues
- [ ] Gestion des stocks par emplacement
- [ ] Intégration comptable
