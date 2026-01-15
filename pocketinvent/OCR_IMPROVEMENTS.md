# Améliorations OCR pour la lecture d'IMEI

## Problème
L'OCR ne parvenait pas à lire certains IMEI, affichant simplement "ERREUR IMPOSSIBLE DE LIRE" sans donner d'informations utiles à l'utilisateur.

## Solutions implémentées

### 1. Amélioration de la détection d'IMEI (ocr_service.dart)

**Patterns de détection multiples:**
- Pattern 1: 15 chiffres consécutifs (format standard)
- Pattern 2: IMEI avec espaces ou tirets (ex: 35 98 7610 2345 678)
- Pattern 3: Extraction intelligente de séquences de 15 chiffres

**Diagnostic amélioré:**
- Stockage du texte reconnu pour débogage
- Messages d'erreur détaillés selon le cas:
  - Aucun texte détecté
  - Texte détecté mais pas d'IMEI valide
  - Erreur technique

**Logs de débogage:**
```dart
print('[OCR] Texte reconnu: ${recognizedText.text}');
print('[OCR] IMEI trouvé (pattern X): $imei');
```

### 2. Interface utilisateur améliorée (add_phone_controller.dart)

**Dialog d'erreur informatif:**
Au lieu d'un simple snackbar, affichage d'un dialog avec:
- Message d'erreur détaillé
- Conseils pratiques (éclairage, cadrage, stabilité, propreté)
- Options: "Saisir manuellement" ou "Réessayer"

**Guide de scan:**
Nouvelle méthode `showScanGuide()` qui affiche:
- Conseils avant le scan
- Bonnes pratiques (éclairage, cadrage, stabilité, propreté)
- Information sur l'IMEI (15 chiffres)

### 3. Bouton d'aide dans l'interface (add_phone_view.dart)

Ajout d'un bouton d'aide (?) à côté du titre "IMEI" qui:
- Affiche le guide de scan
- Aide l'utilisateur avant même de scanner
- Réduit les échecs de scan

## Conseils pour l'utilisateur

L'application affiche maintenant ces conseils:

### Avant le scan:
1. **Bon éclairage** - Éviter les reflets et ombres
2. **Cadrage** - Centrer l'IMEI et se rapprocher
3. **Stabilité** - Tenir le téléphone stable
4. **Propreté** - Nettoyer l'objectif et l'étiquette

### En cas d'échec:
- Message détaillé expliquant le problème
- Option de réessayer immédiatement
- Option de saisir manuellement

## Formats d'IMEI supportés

L'OCR peut maintenant détecter:
- `359876102345678` (15 chiffres consécutifs)
- `35 98 7610 2345 678` (avec espaces)
- `35-98-7610-2345-678` (avec tirets)
- Variations avec différents groupements

## Tests recommandés

1. Scanner un IMEI clair et net ✓
2. Scanner un IMEI avec reflets
3. Scanner un IMEI avec mauvais éclairage
4. Scanner un IMEI flou
5. Vérifier les messages d'erreur
6. Tester le bouton d'aide
7. Tester l'option "Réessayer"

## Améliorations futures possibles

1. Prétraitement d'image (contraste, luminosité)
2. Guide visuel en temps réel pendant le scan
3. Détection automatique de la qualité de l'image
4. Support de formats d'IMEI alternatifs
5. Historique des tentatives de scan pour analyse
