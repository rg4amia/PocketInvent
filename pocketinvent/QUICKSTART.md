# 🚀 Guide de Démarrage Rapide - PocketInvent

## ✅ Étapes Complétées

- ✅ Structure du projet créée
- ✅ Dépendances installées
- ✅ Adaptateurs Hive générés
- ✅ Fichier .env créé

## 📋 Prochaines Étapes

### 1. Configuration Supabase (OBLIGATOIRE)

#### A. Créer un projet Supabase
1. Allez sur [supabase.com](https://supabase.com)
2. Créez un nouveau projet
3. Attendez que le projet soit prêt (2-3 minutes)

#### B. Récupérer les credentials
1. Dans le dashboard Supabase, allez dans **Settings** → **API**
2. Copiez :
   - **Project URL** (ex: `https://xxxxx.supabase.co`)
   - **anon public key** (commence par `eyJ...`)

#### C. Mettre à jour le fichier .env
Éditez le fichier `.env` et remplacez :
```env
SUPABASE_URL=https://votre-projet.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### D. Créer la base de données
1. Dans Supabase Dashboard, allez dans **SQL Editor**
2. Cliquez sur **New Query**
3. Copiez tout le contenu du fichier `supabase_schema.sql`
4. Collez-le dans l'éditeur
5. Cliquez sur **Run** (ou Ctrl/Cmd + Enter)
6. Vérifiez qu'il n'y a pas d'erreurs

#### E. Configurer l'authentification
1. Dans Supabase Dashboard → **Authentication** → **Providers**
2. **Email** est déjà activé par défaut ✅
3. Pour **Sign in with Apple** (recommandé pour iOS) :
   - Suivez le guide : https://supabase.com/docs/guides/auth/social-login/auth-apple
   - Nécessite un compte Apple Developer
4. Pour **Google Sign In** (optionnel) :
   - Suivez le guide : https://supabase.com/docs/guides/auth/social-login/auth-google

### 2. Lancer l'Application

#### Option A : iOS (Recommandé)
```bash
cd pocketinvent
flutter run -d ios
```

#### Option B : Android
```bash
cd pocketinvent
flutter run -d android
```

#### Option C : Simulateur/Émulateur
```bash
# Lister les appareils disponibles
flutter devices

# Lancer sur un appareil spécifique
flutter run -d <device-id>
```

### 3. Tester l'Application

#### Premier lancement
1. L'app devrait s'ouvrir sur l'écran de connexion
2. Cliquez sur **S'inscrire**
3. Créez un compte avec email/mot de passe
4. Vérifiez votre email (si configuré dans Supabase)
5. Connectez-vous

#### Ajouter un téléphone
1. Cliquez sur le bouton **+** (flottant en bas à droite)
2. **Option 1 - Scanner IMEI** :
   - Cliquez sur "Scanner IMEI"
   - Prenez une photo d'une étiquette IMEI
   - L'IMEI sera extrait automatiquement
3. **Option 2 - Saisie manuelle** :
   - Entrez l'IMEI manuellement (15 chiffres)
4. Prenez une photo du téléphone (optionnel)
5. Remplissez les détails (marque, modèle, couleur, etc.)
6. Cliquez sur **Enregistrer**

#### Rechercher un téléphone
1. Utilisez la barre de recherche en haut
2. Tapez : IMEI, marque, modèle ou nom du fournisseur
3. Les résultats s'affichent en temps réel

#### Filtrer par statut
1. Utilisez les onglets : **Tous** / **Entrées** / **Sorties**
2. **Entrées** = téléphones en stock
3. **Sorties** = téléphones revendus

#### Vendre un téléphone
1. Cliquez sur un téléphone dans la liste
2. Cliquez sur les 3 points en haut à droite
3. Sélectionnez **Vendre**
4. Remplissez les informations de vente
5. Enregistrez

## 🔧 Résolution des Problèmes

### Erreur : "Supabase URL not found"
- Vérifiez que le fichier `.env` existe
- Vérifiez que les credentials sont corrects
- Redémarrez l'application

### Erreur : "Failed to load data"
- Vérifiez votre connexion internet
- Vérifiez que le schéma SQL a été exécuté dans Supabase
- Vérifiez les politiques RLS dans Supabase

### L'OCR ne fonctionne pas
- Assurez-vous d'avoir les permissions caméra
- iOS : Vérifiez `Info.plist`
- Android : Vérifiez `AndroidManifest.xml`
- Prenez une photo claire et nette de l'IMEI

### Erreur de build iOS
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

### Erreur de build Android
```bash
flutter clean
flutter pub get
flutter run
```

## 📱 Fonctionnalités Disponibles

✅ Authentification (Email, Apple, Google)
✅ Scan OCR de l'IMEI
✅ Ajout de téléphones avec photo
✅ Recherche instantanée
✅ Filtres par statut
✅ Historique des transactions
✅ Gestion des ventes
✅ Synchronisation cloud + cache local
✅ Mode hors ligne (lecture seule)

## 📚 Documentation Complète

Pour plus de détails, consultez :
- `INSTALLATION.md` - Guide d'installation détaillé
- `README.md` - Documentation du projet
- `supabase_schema.sql` - Structure de la base de données

## 🆘 Support

Si vous rencontrez des problèmes :
1. Vérifiez les logs : `flutter logs`
2. Consultez la documentation Supabase
3. Vérifiez que toutes les étapes ont été suivies

## 🎉 Prêt à Démarrer !

Une fois Supabase configuré, lancez simplement :
```bash
cd pocketinvent
flutter run
```

Bon développement ! 🚀
