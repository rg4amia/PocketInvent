# PocketInvent

Application mobile de gestion de stock et de suivi des transactions de téléphones, développée avec Flutter et Supabase.

## 🎯 Objectif

PocketInvent est un assistant d'inventaire de poche qui permet de gérer efficacement le stock de téléphones, suivre les transactions (achats, ventes, retours) et maintenir un historique complet de chaque appareil via son IMEI.

**Plateforme prioritaire** : iOS (iPhone) - Développement optimisé pour l'écosystème Apple avec support de Sign in with Apple.

## 🚀 Technologies

- **Frontend**: Flutter (priorité iOS/iPhone)
- **Gestion d'état**: GetX
- **Base de données locale**: Hive (cache et mode hors ligne)
- **Backend**: Supabase (base de données PostgreSQL, authentification, temps réel)
- **Authentification**: Supabase Auth (Email, Sign in with Apple, Google)
- **Stockage**: Supabase Storage (photos des téléphones)
- **OCR**: Google ML Kit Text Recognition (extraction automatique de l'IMEI)

## 📊 Structure de la Base de Données

### Tables Principales

#### `users`
- Gestion des utilisateurs (Supabase Auth)
- Profil utilisateur avec nom d'entreprise et photo

#### `couleur`
- Gestion des couleurs avec libellé et code hexadécimal

#### `marque` & `modele`
- Référentiel des marques et modèles de téléphones

#### `capacite`
- Capacités de stockage disponibles (128GB, 256GB, etc.)

#### `fournisseur` & `client`
- Gestion des contacts (fournisseurs et clients)
- Isolés par utilisateur (user_id)

#### `statut_paiement`
- Statuts: Payé, Retour, Revendu

#### `telephone`
- Table principale contenant tous les détails des appareils
- Champs: IMEI (unique par utilisateur), marque, modèle, couleur, capacité, prix, photo, etc.
- Isolée par utilisateur (user_id)

#### `historique_transaction`
- Traçabilité complète de toutes les opérations (achat, vente, retour)
- Isolée par utilisateur (user_id)

**Sécurité** : Row Level Security (RLS) activé sur toutes les tables pour garantir l'isolation des données par utilisateur.

## ✨ Fonctionnalités

### Authentification
- 🔐 Connexion sécurisée avec Supabase Auth
- 🍎 **Sign in with Apple** (obligatoire pour iOS)
- 📧 Connexion Email/Mot de passe
- 🔑 Récupération de mot de passe
- 👤 Gestion du profil utilisateur
- 🔒 Isolation des données par utilisateur (RLS)

### Gestion des Entrées
- ✅ Ajout par photo ou saisie manuelle
- 📸 **Extraction automatique de l'IMEI par OCR** (scan de l'étiquette)
- ✔️ Validation automatique du format IMEI (15 chiffres)
- ✏️ Correction manuelle possible après OCR
- ✅ Enregistrement de l'IMEI (identifiant unique)
- ✅ Sélection des attributs via listes déroulantes
- ✅ Upload automatique des photos vers Supabase Storage

### Suivi et Consultation
- 🔍 Recherche instantanée par IMEI, marque, modèle, fournisseur ou client
- 📈 Historique complet des transactions par téléphone
- 💰 Suivi des statuts de paiement (Payé, Retour, Revendu)
- 📱 Synchronisation temps réel avec Supabase
- 💾 Mode hors ligne avec cache local Hive

### Gestion des Ventes
- 🛒 Enregistrement des ventes avec association client
- 📝 Création automatique d'entrées dans l'historique
- 🔄 Mise à jour des statuts en temps réel

## 🏗️ Architecture

```
┌─────────────────┐
│   Flutter App   │
│     (GetX)      │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌──▼──────┐
│ Hive  │ │Supabase │
│(Local)│ │ (Cloud) │
└───────┘ └─────────┘
```

## 📦 Installation

```bash
# Cloner le repository
git clone [url-du-repo]

# Installer les dépendances
flutter pub get

# Configurer Supabase
# Créer un fichier .env avec vos credentials Supabase

# Lancer l'application
flutter run
```

### Dépendances principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6                    # Gestion d'état
  hive: ^2.2.3                   # Base de données locale
  hive_flutter: ^1.1.0
  supabase_flutter: ^2.0.0       # Backend Supabase
  google_mlkit_text_recognition: ^0.11.0  # OCR pour IMEI
  image_picker: ^1.0.0           # Capture de photos
  sign_in_with_apple: ^5.0.0     # Sign in with Apple (iOS)
```

### Configuration iOS spécifique

Pour Sign in with Apple, ajouter dans `ios/Runner/Info.plist` :
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.yourapp.pocketinvent</string>
    </array>
  </dict>
</array>
```

## 🔧 Configuration Supabase

1. Créer un projet sur [supabase.com](https://supabase.com)
2. Activer l'authentification :
   - Email/Password
   - Sign in with Apple (configurer dans Apple Developer)
   - Google (optionnel)
3. Exécuter les migrations SQL pour créer les tables
4. Configurer les politiques RLS (Row Level Security) pour isoler les données par utilisateur
5. Configurer Supabase Storage pour les photos
6. Ajouter les credentials dans votre application (.env)

## 📝 Workflow

1. **Première utilisation** :
   - Écran de bienvenue
   - Inscription ou connexion (Email, Sign in with Apple, Google)
   - Configuration du profil

2. **Ajout d'un téléphone**: 
   - **Option OCR**: Photo étiquette IMEI → Extraction automatique → Validation → Photo téléphone → Saisie infos → Sync
   - **Option manuelle**: Saisie IMEI → Photo téléphone → Saisie infos → Sync

3. **Recherche**: Saisie IMEI/nom → Filtrage temps réel → Affichage résultats

4. **Vente**: Sélection téléphone → Ajout client → Création transaction → Mise à jour statut

5. **Historique**: Consultation de toutes les opérations liées à un appareil

## 🎯 Fonctionnalité OCR - Détails

L'extraction automatique de l'IMEI utilise **Google ML Kit** pour :
- Scanner l'étiquette IMEI sur la boîte du téléphone
- Scanner l'IMEI affiché dans les paramètres du téléphone (capture d'écran)
- Extraire uniquement les séquences de 15 chiffres (format IMEI standard)
- Valider automatiquement le format
- Permettre la correction manuelle en cas d'erreur de reconnaissance

**Avantages** :
- ⚡ Gain de temps considérable (pas de saisie manuelle)
- ✅ Réduction des erreurs de frappe
- 📱 Fonctionne hors ligne (ML Kit on-device)
- 🆓 Gratuit et sans limite d'utilisation

## 📄 Licence

À définir

## 👥 Contributeurs

À définir
