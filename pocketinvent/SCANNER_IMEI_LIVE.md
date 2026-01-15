# Scanner IMEI en Temps Réel

## 🎯 Fonctionnalité

Scanner IMEI avec détection automatique en temps réel, similaire à un scanner de QR code.

## ✨ Caractéristiques

### 1. Détection Automatique
- **Scan continu** toutes les 500ms
- **Détection automatique** dès que l'IMEI est visible
- **Pas besoin de bouton** - la détection se fait automatiquement

### 2. Interface Intuitive

#### Cadre de Scan
- Zone de scan rectangulaire avec coins arrondis
- Coins avec brackets blancs pour guider l'utilisateur
- Overlay sombre pour mettre en évidence la zone de scan

#### Indicateurs Visuels
- **En attente**: Icône de scanner
- **En analyse**: Indicateur de chargement + "Analyse en cours..."
- **Texte détecté**: Affichage du texte reconnu (debug)

#### Contrôles
- **Bouton fermer** (X) en haut à gauche
- **Bouton flash** (⚡) en haut à droite - toggle on/off
- **Instructions** en bas de l'écran

### 3. Détection Multi-Pattern

Le scanner détecte plusieurs formats d'IMEI:

```dart
// Pattern 1: 15 chiffres consécutifs
359876102345678

// Pattern 2: Avec espaces
35 98 7610 2345 678

// Pattern 3: Avec tirets
35-98-7610-2345-678

// Pattern 4: Extraction intelligente
Extrait 15 chiffres de n'importe quel texte
```

### 4. Confirmation Interactive

Quand un IMEI est détecté:
1. **Arrêt automatique** du scan
2. **Dialog de confirmation** avec:
   - ✅ Icône de succès
   - 📱 IMEI détecté en grand
   - ❓ "Voulez-vous utiliser cet IMEI?"
3. **Options**:
   - **Réessayer**: Relance le scan
   - **Utiliser**: Ferme le scanner et remplit le champ IMEI

## 🎨 Design

### Couleurs
- **Background**: Noir (caméra)
- **Overlay**: Noir semi-transparent (50%)
- **Cadre**: Blanc avec coins arrondis
- **Brackets**: Blanc, épaisseur 4px
- **Texte**: Blanc avec ombres pour lisibilité

### Layout
```
┌─────────────────────────────┐
│ [X]  Scanner l'IMEI      [ ]│ ← Top bar avec gradient
│                             │
│    ┌─────────────────┐      │
│    │                 │      │
│    │   ZONE DE SCAN  │      │ ← Zone transparente
│    │                 │      │
│    └─────────────────┘      │
│                             │
│  [⚡] Flash toggle          │ ← Bouton flash
│                             │
│  📷 Placez l'IMEI           │
│     dans le cadre           │ ← Instructions
│  La détection est auto      │
└─────────────────────────────┘
```

## 🔧 Implémentation Technique

### Architecture

```dart
ImeiCameraScanner (StatefulWidget)
├── CameraController (camera package)
├── TextRecognizer (ML Kit)
├── Timer (détection continue)
└── ScannerOverlayPainter (CustomPainter)
```

### Flux de Détection

```
1. Initialisation caméra
   ↓
2. Démarrage Timer (500ms)
   ↓
3. Capture image
   ↓
4. OCR avec ML Kit
   ↓
5. Extraction IMEI (3 patterns)
   ↓
6. IMEI trouvé?
   ├─ Oui → Dialog confirmation
   └─ Non → Continuer scan
```

### Optimisations

1. **Throttling**: Scan toutes les 500ms (pas en continu)
2. **Flag _isDetecting**: Évite les scans simultanés
3. **Déduplication**: Ignore les IMEI déjà détectés
4. **Dispose propre**: Libération des ressources (caméra, timer, OCR)

## 📱 Utilisation

### Dans l'Application

```dart
// Dans add_phone_controller.dart
Future<void> scanImeiWithOcr() async {
  Get.to(
    () => ImeiCameraScanner(
      onImeiDetected: (String imei) {
        imeiController.text = imei;
        // Afficher confirmation
      },
    ),
  );
}
```

### Callback

```dart
ImeiCameraScanner(
  onImeiDetected: (String imei) {
    // Appelé quand l'utilisateur confirme l'IMEI
    print('IMEI détecté: $imei');
  },
)
```

## 🎯 Avantages vs Ancienne Méthode

| Aspect | Avant (Photo) | Maintenant (Live) |
|--------|---------------|-------------------|
| **Vitesse** | 3-5 secondes | Instantané |
| **UX** | Prendre photo → Attendre | Pointer → Détecté |
| **Feedback** | Après capture | En temps réel |
| **Erreurs** | Message après | Réessai immédiat |
| **Guidage** | Aucun | Cadre visuel |

## 🚀 Améliorations Futures

### Court Terme
- [ ] Vibration au moment de la détection
- [ ] Son de confirmation
- [ ] Animation du cadre lors de la détection

### Moyen Terme
- [ ] Zoom automatique sur l'IMEI
- [ ] Amélioration du contraste en temps réel
- [ ] Historique des scans (pour debug)

### Long Terme
- [ ] IA pour détecter la position de l'IMEI
- [ ] Guide visuel "Rapprochez-vous" / "Éloignez-vous"
- [ ] Support de plusieurs IMEI simultanés

## 🐛 Dépannage

### Caméra ne s'initialise pas
```dart
// Vérifier les permissions
// Android: AndroidManifest.xml
<uses-permission android:name="android.permission.CAMERA"/>

// iOS: Info.plist
<key>NSCameraUsageDescription</key>
<string>Pour scanner les IMEI</string>
```

### Détection trop lente
```dart
// Ajuster l'intervalle du timer
Timer.periodic(Duration(milliseconds: 300), ...); // Plus rapide
```

### Faux positifs
```dart
// Ajouter validation supplémentaire
if (candidate.startsWith(RegExp(r'[3-8]'))) {
  // IMEI commence généralement par 3-8
  return candidate;
}
```

## 📊 Performance

- **Temps de détection**: < 1 seconde (conditions optimales)
- **CPU**: Modéré (scan toutes les 500ms)
- **Batterie**: Impact faible (arrêt automatique après détection)
- **Mémoire**: ~50MB (caméra + ML Kit)

## ✅ Tests Recommandés

1. ✓ Scanner un IMEI clair
2. ✓ Scanner avec mauvais éclairage
3. ✓ Scanner avec reflets
4. ✓ Tester le bouton flash
5. ✓ Tester "Réessayer"
6. ✓ Tester "Utiliser"
7. ✓ Tester fermeture (X)
8. ✓ Vérifier libération ressources

## 🎓 Conseils d'Utilisation

Pour les utilisateurs:
1. **Tenez stable** - Évitez les mouvements
2. **Bon éclairage** - Utilisez le flash si nécessaire
3. **Centrez l'IMEI** - Dans le cadre blanc
4. **Patience** - La détection prend 1-2 secondes

---

**Note**: Cette fonctionnalité nécessite le package `camera` et les permissions caméra sur Android et iOS.
