# ✅ Checklist de Test - Scanner IMEI Live

## 🎯 Tests Fonctionnels

### Initialisation
- [ ] Le scanner s'ouvre correctement
- [ ] La caméra s'initialise sans erreur
- [ ] Le message "Initialisation de la caméra..." s'affiche brièvement
- [ ] La prévisualisation caméra s'affiche en plein écran
- [ ] Le cadre de scan est visible et bien positionné

### Interface Utilisateur
- [ ] Le bouton [X] fermer est visible en haut à gauche
- [ ] Le titre "Scanner l'IMEI" est centré
- [ ] Le bouton flash [⚡] est visible en haut à droite
- [ ] Les instructions sont visibles en bas
- [ ] Le cadre blanc avec coins arrondis est bien dessiné
- [ ] L'overlay sombre est appliqué correctement

### Détection IMEI

#### Format Standard (15 chiffres)
- [ ] Détecte: `359876102345678`
- [ ] Détecte: `123456789012345`
- [ ] Détecte: `867543210987654`

#### Format avec Espaces
- [ ] Détecte: `35 98 7610 2345 678`
- [ ] Détecte: `12 34 5678 9012 345`

#### Format avec Tirets
- [ ] Détecte: `35-98-7610-2345-678`
- [ ] Détecte: `12-34-5678-9012-345`

#### Format Mixte
- [ ] Détecte: `35 98-7610 2345-678`

### Feedback Utilisateur
- [ ] "Analyse en cours..." s'affiche pendant le scan
- [ ] L'indicateur de chargement tourne pendant l'analyse
- [ ] Le texte détecté s'affiche (debug) en bas
- [ ] Le dialog de confirmation s'affiche quand IMEI détecté
- [ ] L'IMEI est affiché en grand dans le dialog
- [ ] L'icône ✅ verte est visible

### Boutons et Actions

#### Bouton Flash
- [ ] Clic active le flash (icône change)
- [ ] Clic désactive le flash (icône change)
- [ ] Le flash fonctionne réellement
- [ ] Pas d'erreur si flash non disponible

#### Bouton Fermer [X]
- [ ] Ferme le scanner
- [ ] Retourne à l'écran précédent
- [ ] Libère les ressources (caméra)

#### Dialog de Confirmation
- [ ] Bouton "Réessayer" relance le scan
- [ ] Bouton "Utiliser" ferme le scanner
- [ ] Bouton "Utiliser" remplit le champ IMEI
- [ ] Le callback `onImeiDetected` est appelé

### Gestion des Erreurs

#### Pas de Caméra
- [ ] Message d'erreur si aucune caméra disponible
- [ ] L'app ne crash pas

#### Permission Refusée
- [ ] Message approprié si permission refusée
- [ ] Possibilité de réessayer

#### Échec de Détection
- [ ] Continue de scanner si rien détecté
- [ ] Pas de message d'erreur intempestif
- [ ] L'utilisateur peut fermer manuellement

## 🎨 Tests Visuels

### Layout
- [ ] Le cadre est centré horizontalement
- [ ] Le cadre est centré verticalement
- [ ] Les proportions sont correctes (80% largeur, 30% hauteur)
- [ ] Les coins arrondis sont visibles
- [ ] Les brackets blancs sont bien dessinés

### Couleurs
- [ ] Background noir
- [ ] Overlay semi-transparent
- [ ] Cadre blanc visible
- [ ] Texte blanc lisible
- [ ] Gradient top/bottom pour lisibilité

### Responsive
- [ ] Fonctionne sur petit écran (iPhone SE)
- [ ] Fonctionne sur grand écran (iPad)
- [ ] Fonctionne en portrait
- [ ] Fonctionne en paysage (si supporté)

## ⚡ Tests de Performance

### Vitesse
- [ ] Détection en < 2 secondes (conditions optimales)
- [ ] Pas de lag dans la prévisualisation caméra
- [ ] Le scan toutes les 500ms ne ralentit pas l'UI
- [ ] Le dialog s'affiche instantanément

### Ressources
- [ ] Pas de fuite mémoire après fermeture
- [ ] La caméra est bien libérée
- [ ] Le timer est bien annulé
- [ ] Le TextRecognizer est bien fermé

### Batterie
- [ ] Consommation raisonnable pendant le scan
- [ ] Pas de drain après fermeture

## 🔧 Tests Techniques

### Lifecycle
- [ ] `initState` initialise correctement
- [ ] `dispose` libère toutes les ressources
- [ ] Pas d'erreur si widget démonté pendant scan
- [ ] Gestion correcte du `mounted` flag

### Concurrence
- [ ] Un seul scan à la fois (flag `_isDetecting`)
- [ ] Pas de scans simultanés
- [ ] Déduplication des IMEI détectés

### Edge Cases
- [ ] Texte vide → continue de scanner
- [ ] Texte sans chiffres → continue de scanner
- [ ] Plusieurs IMEI visibles → détecte le premier
- [ ] IMEI déjà détecté → ignore (déduplication)

## 📱 Tests Plateformes

### Android
- [ ] Fonctionne sur Android 8+
- [ ] Permission caméra demandée correctement
- [ ] Flash fonctionne
- [ ] Rotation écran gérée

### iOS
- [ ] Fonctionne sur iOS 12+
- [ ] Permission caméra demandée correctement
- [ ] Flash fonctionne
- [ ] Rotation écran gérée

## 🎯 Tests Utilisateur Réel

### Scénario 1: Scan Réussi
1. [ ] Ouvrir le scanner
2. [ ] Placer IMEI dans le cadre
3. [ ] Attendre détection (< 2 sec)
4. [ ] Vérifier IMEI dans dialog
5. [ ] Cliquer "Utiliser"
6. [ ] Vérifier champ IMEI rempli

### Scénario 2: Mauvais Éclairage
1. [ ] Ouvrir le scanner
2. [ ] Scanner dans le noir
3. [ ] Activer le flash
4. [ ] Détection réussie

### Scénario 3: Réessayer
1. [ ] Ouvrir le scanner
2. [ ] Détection d'un mauvais numéro
3. [ ] Cliquer "Réessayer"
4. [ ] Scanner à nouveau
5. [ ] Détection du bon IMEI

### Scénario 4: Abandon
1. [ ] Ouvrir le scanner
2. [ ] Cliquer [X] pour fermer
3. [ ] Retour à l'écran précédent
4. [ ] Saisir IMEI manuellement

## 🐛 Tests de Régression

### Après Modifications
- [ ] Le scanner s'ouvre toujours
- [ ] La détection fonctionne toujours
- [ ] Les boutons fonctionnent toujours
- [ ] Pas de nouveaux bugs introduits

### Intégration
- [ ] Le champ IMEI est bien rempli
- [ ] La validation IMEI fonctionne
- [ ] L'ajout de téléphone fonctionne
- [ ] Pas d'impact sur autres fonctionnalités

## 📊 Résultats Attendus

### Taux de Réussite
- **Conditions optimales**: > 95%
- **Conditions normales**: > 80%
- **Conditions difficiles**: > 50%

### Temps de Détection
- **Moyen**: 1-2 secondes
- **Maximum acceptable**: 5 secondes

### Satisfaction Utilisateur
- **Facilité d'utilisation**: 4/5 minimum
- **Rapidité**: 4/5 minimum
- **Fiabilité**: 4/5 minimum

## ✅ Validation Finale

- [ ] Tous les tests fonctionnels passent
- [ ] Tous les tests visuels passent
- [ ] Tous les tests de performance passent
- [ ] Tous les tests techniques passent
- [ ] Tests utilisateur réels réussis
- [ ] Pas de bugs critiques
- [ ] Documentation à jour

## 📝 Notes de Test

**Date**: _______________
**Testeur**: _______________
**Appareil**: _______________
**OS Version**: _______________

**Bugs trouvés**:
- 
- 
- 

**Améliorations suggérées**:
- 
- 
- 

**Commentaires**:
- 
- 
- 

---

**Statut Global**: ⬜ À tester | ⬜ En cours | ⬜ Validé | ⬜ Échec
