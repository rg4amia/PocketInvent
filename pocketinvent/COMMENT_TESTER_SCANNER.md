# 🧪 Comment Tester le Scanner IMEI

## 🚀 Démarrage Rapide

### 1. Lancer l'Application

```bash
cd pocketinvent
flutter run
```

### 2. Naviguer vers le Scanner

1. Ouvrir l'application
2. Se connecter (si nécessaire)
3. Aller dans **"Ajouter un téléphone"**
4. Cliquer sur **"Scanner IMEI en direct"**

### 3. Autoriser la Caméra

- **Android**: Accepter la permission caméra
- **iOS**: Accepter la permission caméra

## 📱 Préparer un IMEI de Test

### Option 1: Utiliser un Vrai Téléphone
- Trouver l'étiquette IMEI au dos du téléphone
- Ou dans Paramètres > À propos

### Option 2: Créer une Étiquette de Test

Imprimez ou affichez sur un écran:

```
IMEI: 359876102345678
```

Ou avec espaces:
```
IMEI: 35 98 7610 2345 678
```

### Option 3: Utiliser l'Image Fournie

L'image `imei-number.webp` dans le dossier racine peut être utilisée pour tester.

## 🧪 Scénarios de Test

### Test 1: Scan Basique ✅

**Objectif**: Vérifier que le scan fonctionne

1. Ouvrir le scanner
2. Placer l'IMEI dans le cadre blanc
3. Attendre 1-2 secondes
4. Vérifier que le dialog s'affiche
5. Vérifier que l'IMEI est correct
6. Cliquer "Utiliser"
7. Vérifier que le champ IMEI est rempli

**Résultat attendu**: ✅ IMEI détecté et rempli

### Test 2: Mauvais Éclairage 🔦

**Objectif**: Tester le bouton flash

1. Ouvrir le scanner
2. Couvrir partiellement l'objectif (simuler obscurité)
3. Cliquer sur le bouton flash ⚡
4. Vérifier que le flash s'allume
5. Scanner l'IMEI
6. Vérifier la détection

**Résultat attendu**: ✅ Flash fonctionne, détection réussie

### Test 3: Réessayer 🔄

**Objectif**: Tester le bouton "Réessayer"

1. Ouvrir le scanner
2. Scanner un mauvais numéro (pas 15 chiffres)
3. Attendre la détection
4. Dans le dialog, cliquer "Réessayer"
5. Scanner le bon IMEI
6. Cliquer "Utiliser"

**Résultat attendu**: ✅ Peut réessayer, détection réussie

### Test 4: Fermeture ❌

**Objectif**: Tester le bouton fermer

1. Ouvrir le scanner
2. Cliquer sur [X] en haut à gauche
3. Vérifier retour à l'écran précédent
4. Vérifier que la caméra est libérée

**Résultat attendu**: ✅ Fermeture propre, pas de crash

### Test 5: Différents Formats 📝

**Objectif**: Tester les différents formats d'IMEI

Tester avec:
- `359876102345678` (sans séparation)
- `35 98 7610 2345 678` (avec espaces)
- `35-98-7610-2345-678` (avec tirets)

**Résultat attendu**: ✅ Tous les formats détectés

### Test 6: Performance ⚡

**Objectif**: Mesurer le temps de détection

1. Ouvrir le scanner
2. Démarrer un chronomètre
3. Placer l'IMEI dans le cadre
4. Arrêter quand le dialog s'affiche
5. Noter le temps

**Résultat attendu**: ✅ < 2 secondes

### Test 7: Stabilité 🎯

**Objectif**: Tester avec mouvement

1. Ouvrir le scanner
2. Bouger légèrement le téléphone
3. Vérifier que la détection fonctionne quand même

**Résultat attendu**: ✅ Détection même avec léger mouvement

### Test 8: Ressources 💾

**Objectif**: Vérifier libération des ressources

1. Ouvrir le scanner
2. Fermer immédiatement
3. Répéter 5 fois
4. Vérifier qu'il n'y a pas de lag

**Résultat attendu**: ✅ Pas de fuite mémoire

## 🐛 Problèmes Courants

### Le scanner ne s'ouvre pas

**Causes possibles**:
- Permission caméra refusée
- Caméra utilisée par une autre app
- Erreur d'initialisation

**Solutions**:
1. Vérifier les permissions dans les paramètres
2. Fermer les autres apps utilisant la caméra
3. Redémarrer l'app
4. Vérifier les logs: `flutter logs`

### La détection ne fonctionne pas

**Causes possibles**:
- Mauvais éclairage
- IMEI flou
- IMEI trop petit
- Format non supporté

**Solutions**:
1. Activer le flash
2. Se rapprocher de l'IMEI
3. Nettoyer l'objectif
4. Vérifier que l'IMEI a 15 chiffres

### Le flash ne fonctionne pas

**Causes possibles**:
- Appareil sans flash
- Flash désactivé dans les paramètres
- Erreur de permission

**Solutions**:
1. Vérifier que l'appareil a un flash
2. Tester le flash avec l'app caméra native
3. Vérifier les permissions

### L'app crash

**Causes possibles**:
- Erreur de permission
- Ressources non libérées
- Bug dans le code

**Solutions**:
1. Vérifier les logs: `flutter logs`
2. Redémarrer l'app
3. Vérifier les permissions
4. Signaler le bug avec les logs

## 📊 Métriques à Mesurer

### Performance
- ⏱️ Temps d'initialisation: _____ sec
- ⏱️ Temps de détection: _____ sec
- 💾 Utilisation mémoire: _____ MB
- 🔋 Impact batterie: _____ %

### Fiabilité
- ✅ Taux de réussite: _____ %
- ❌ Taux d'échec: _____ %
- 🔄 Nombre de réessais moyen: _____

### UX
- 😊 Facilité d'utilisation: _____ /5
- ⚡ Rapidité perçue: _____ /5
- 🎯 Précision: _____ /5

## 📝 Rapport de Test

### Informations

- **Date**: _______________
- **Testeur**: _______________
- **Appareil**: _______________
- **OS**: _______________
- **Version App**: _______________

### Résultats

| Test | Statut | Temps | Notes |
|------|--------|-------|-------|
| Scan basique | ⬜ | ___ sec | |
| Mauvais éclairage | ⬜ | ___ sec | |
| Réessayer | ⬜ | ___ sec | |
| Fermeture | ⬜ | ___ sec | |
| Différents formats | ⬜ | ___ sec | |
| Performance | ⬜ | ___ sec | |
| Stabilité | ⬜ | ___ sec | |
| Ressources | ⬜ | ___ sec | |

**Légende**: ✅ Réussi | ❌ Échec | ⚠️ Partiel | ⬜ Non testé

### Bugs Trouvés

1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

### Améliorations Suggérées

1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

### Commentaires Généraux

_______________________________________________
_______________________________________________
_______________________________________________

## 🎯 Validation Finale

- [ ] Tous les tests passent
- [ ] Performance acceptable
- [ ] Pas de bugs critiques
- [ ] UX satisfaisante
- [ ] Documentation à jour

**Statut Global**: ⬜ Validé | ⬜ À corriger | ⬜ Rejeté

## 📞 Support

En cas de problème:
1. Consulter `GUIDE_UTILISATEUR_SCANNER.md`
2. Vérifier `SCANNER_IMEI_LIVE.md`
3. Consulter les logs Flutter
4. Contacter l'équipe de développement

---

**Bon test! 🚀**
