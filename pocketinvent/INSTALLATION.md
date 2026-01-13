# Guide d'Installation - PocketInvent

## Prérequis

- Flutter SDK (>=3.0.0)
- Dart SDK
- Xcode (pour iOS)
- Android Studio (pour Android)
- Compte Supabase

## Étapes d'Installation

### 1. Cloner le projet

```bash
git clone <url-du-repo>
cd pocketinvent
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Configuration Supabase

#### A. Créer un projet Supabase

1. Allez sur [supabase.com](https://supabase.com)
2. Créez un nouveau projet
3. Notez votre `SUPABASE_URL` et `SUPABASE_ANON_KEY`

#### B. Exécuter le schéma SQL

1. Dans le dashboard Supabase, allez dans "SQL Editor"
2. Copiez le contenu de `supabase_schema.sql`
3. Exécutez le script

#### C. Configurer l'authentification

1. Dans Supabase Dashboard → Authentication → Providers
2. Activez **Email** (activé par défaut)
3. Pour **Sign in with Apple** (iOS) :
   - Allez dans Apple Developer Console
   - Créez un Service ID
   - Configurez le dans Supabase avec votre Bundle ID
4. Pour **Google Sign In** (optionnel) :
   - Créez un projet dans Google Cloud Console
   - Configurez OAuth 2.0
   - Ajoutez les credentials dans Supabase

#### D. Configurer le Storage

1. Dans Supabase Dashboard → Storage
2. Le bucket `phone-photos` devrait être créé automatiquement par le script SQL
3. Vérifiez que les politiques RLS sont actives

### 4. Configuration de l'application

#### A. Créer le fichier .env

```bash
cp .env.example .env
```

Éditez `.env` et ajoutez vos credentials Supabase :

```
SUPABASE_URL=https://votre-projet.supabase.co
SUPABASE_ANON_KEY=votre_anon_key_ici
```

#### B. Générer les adaptateurs Hive

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Configuration iOS

#### A. Configurer le Bundle ID

1. Ouvrez `ios/Runner.xcworkspace` dans Xcode
2. Sélectionnez le projet Runner
3. Dans "Signing & Capabilities", configurez votre Team
4. Changez le Bundle Identifier (ex: `com.votreentreprise.pocketinvent`)

#### B. Configurer Sign in with Apple

1. Dans Xcode, allez dans "Signing & Capabilities"
2. Cliquez sur "+ Capability"
3. Ajoutez "Sign in with Apple"

#### C. Mettre à jour Info.plist

Le fichier `ios/Runner/Info.plist` est déjà configuré, mais vérifiez que le scheme URL correspond à votre configuration Supabase.

### 6. Configuration Android

#### A. Configurer le package name

1. Ouvrez `android/app/build.gradle`
2. Changez `applicationId` (ex: `com.votreentreprise.pocketinvent`)

#### B. Mettre à jour AndroidManifest.xml

Le fichier est déjà configuré, mais vérifiez que le scheme correspond à votre configuration Supabase.

### 7. Lancer l'application

#### iOS

```bash
flutter run -d ios
```

#### Android

```bash
flutter run -d android
```

## Résolution des problèmes

### Erreur de génération Hive

Si vous obtenez des erreurs liées aux adaptateurs Hive :

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Erreur de permissions iOS

Assurez-vous que les permissions sont bien définies dans `Info.plist` :
- NSCameraUsageDescription
- NSPhotoLibraryUsageDescription

### Erreur de connexion Supabase

1. Vérifiez que votre fichier `.env` est correctement configuré
2. Vérifiez que les credentials Supabase sont corrects
3. Vérifiez que les politiques RLS sont actives dans Supabase

### Erreur OCR

L'OCR utilise Google ML Kit qui nécessite :
- iOS 12.0 ou supérieur
- Android API 21 ou supérieur

## Tests

Pour tester l'application :

1. Créez un compte avec email/mot de passe
2. Ajoutez un téléphone manuellement
3. Testez le scan IMEI avec une photo d'étiquette
4. Vérifiez la synchronisation avec Supabase
5. Testez la recherche et les filtres
6. Créez une vente

## Production

### Build iOS

```bash
flutter build ios --release
```

Puis ouvrez Xcode pour archiver et soumettre à l'App Store.

### Build Android

```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

## Support

Pour toute question ou problème, consultez :
- [Documentation Flutter](https://flutter.dev/docs)
- [Documentation Supabase](https://supabase.com/docs)
- [Documentation GetX](https://pub.dev/packages/get)
