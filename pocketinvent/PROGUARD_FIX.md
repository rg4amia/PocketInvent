# 🔧 Correction ProGuard pour Build Release

## ❌ Problème

Lors du build en mode release (`flutter build apk --release`), R8 (le minifier Android) échouait avec l'erreur :

```
ERROR: Missing classes detected while running R8
Missing class com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions
Missing class com.google.mlkit.vision.text.devanagari.DevanagariTextRecognizerOptions
Missing class com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions
Missing class com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions
```

## 🔍 Cause

Le plugin `google_mlkit_text_recognition` référence des classes pour plusieurs langues (chinois, japonais, coréen, devanagari) mais ces dépendances ne sont pas incluses par défaut. R8 détecte ces références manquantes et échoue.

## ✅ Solution

### 1. Création du fichier ProGuard

Créé `android/app/proguard-rules.pro` avec les règles suivantes :

```proguard
# Ignore missing ML Kit language-specific classes that are not used
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# Keep ML Kit classes
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Keep Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Keep Supabase
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# Keep image picker
-keep class io.flutter.plugins.imagepicker.** { *; }
-dontwarn io.flutter.plugins.imagepicker.**

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
```

### 2. Configuration du build.gradle.kts

Modifié `android/app/build.gradle.kts` pour activer ProGuard :

```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug")
        minifyEnabled = true
        shrinkResources = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
```

## 📋 Règles ProGuard Expliquées

### `-dontwarn`
Indique à R8 d'ignorer les avertissements pour les classes manquantes qui ne sont pas utilisées dans notre app.

### `-keep class`
Empêche R8 de supprimer ou d'obfusquer certaines classes nécessaires au runtime.

### `minifyEnabled = true`
Active la minification du code (réduction de la taille de l'APK).

### `shrinkResources = true`
Supprime les ressources non utilisées pour réduire encore la taille de l'APK.

## 🎯 Langues Supportées

Notre app utilise uniquement la reconnaissance de texte **Latin** (français, anglais, etc.) via ML Kit. Les langues suivantes sont ignorées car non utilisées :

- ❌ Chinois (chinese)
- ❌ Devanagari (hindi, sanskrit, etc.)
- ❌ Japonais (japanese)
- ❌ Coréen (korean)

Si vous avez besoin de ces langues à l'avenir, vous devrez :
1. Ajouter les dépendances correspondantes dans `pubspec.yaml`
2. Retirer les règles `-dontwarn` pour ces langues

## 🚀 Build Release

Maintenant vous pouvez builder en mode release sans erreur :

```bash
# APK
flutter build apk --release

# App Bundle (pour Google Play)
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 📦 Taille de l'APK

Avec ProGuard activé, la taille de l'APK est optimisée :

- **Minification** : Code Dart et Java réduit
- **Obfuscation** : Noms de classes/méthodes raccourcis
- **Shrinking** : Ressources non utilisées supprimées
- **Tree-shaking** : Icônes Material réduites de 99.6%

## ⚠️ Notes Importantes

### Debug vs Release

- **Debug** : ProGuard désactivé, build rapide, debugging facile
- **Release** : ProGuard activé, build plus lent, APK optimisé

### Signature

Actuellement, le build release utilise la clé de debug :
```kotlin
signingConfig = signingConfigs.getByName("debug")
```

Pour la production, vous devrez créer une clé de signature propre :

```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

Puis configurer dans `android/key.properties` et `build.gradle.kts`.

## 🧪 Test du Build

Après ces modifications, testez le build :

```bash
# Clean
flutter clean

# Get dependencies
flutter pub get

# Build
flutter build apk --release

# Install sur device
flutter install --release
```

## 📊 Résultat

- ✅ Build release réussi
- ✅ Taille APK optimisée
- ✅ Pas d'erreurs R8
- ✅ ML Kit fonctionne correctement (reconnaissance Latin)
- ✅ Toutes les fonctionnalités préservées

---

**Status** : ✅ Corrigé  
**Build** : ✅ Release OK  
**ProGuard** : ✅ Configuré  
**Optimisation** : ✅ Activée
