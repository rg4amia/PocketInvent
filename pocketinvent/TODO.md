# ✅ TODO - Configuration PocketInvent

## 🎯 Étapes Obligatoires Avant le Premier Lancement

### ✅ Complété
- [x] Structure du projet créée
- [x] Dépendances Flutter installées
- [x] Adaptateurs Hive générés
- [x] Fichiers de configuration créés

### ⏳ À Faire (OBLIGATOIRE)

#### 1. Configuration Supabase
- [ ] Créer un compte sur [supabase.com](https://supabase.com)
- [ ] Créer un nouveau projet Supabase
- [ ] Copier l'URL du projet (Settings → API)
- [ ] Copier la clé anon/public (Settings → API)
- [ ] Mettre à jour le fichier `.env` avec ces credentials
- [ ] Exécuter le script `supabase_schema.sql` dans SQL Editor
- [ ] Vérifier que toutes les tables sont créées
- [ ] Vérifier que les politiques RLS sont actives

#### 2. Configuration de l'Authentification
- [ ] Dans Supabase Dashboard → Authentication → Providers
- [ ] Vérifier que Email est activé (par défaut)
- [ ] (Optionnel) Configurer Sign in with Apple
- [ ] (Optionnel) Configurer Google Sign In

#### 3. Test de l'Application
- [ ] Lancer l'application : `flutter run`
- [ ] Créer un compte de test
- [ ] Vérifier la connexion
- [ ] Ajouter un téléphone de test
- [ ] Tester la recherche
- [ ] Tester les filtres

## 📝 Configuration Détaillée

### Fichier .env
Éditez `pocketinvent/.env` et remplacez :
```env
SUPABASE_URL=https://votre-projet-id.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.votre_cle_ici
```

### Commandes Utiles
```bash
# Se déplacer dans le dossier
cd pocketinvent

# Vérifier les appareils disponibles
flutter devices

# Lancer sur iOS
flutter run -d ios

# Lancer sur Android
flutter run -d android

# Voir les logs
flutter logs

# Nettoyer et reconstruire
flutter clean && flutter pub get && flutter run
```

## 🔧 Résolution de Problèmes

### Erreur : "SUPABASE_URL not found"
**Solution** : Vérifiez que le fichier `.env` existe et contient les bonnes valeurs

### Erreur : "Failed to connect to Supabase"
**Solution** : 
1. Vérifiez votre connexion internet
2. Vérifiez que l'URL Supabase est correcte
3. Vérifiez que la clé anon est correcte

### Erreur : "Table does not exist"
**Solution** : Exécutez le script `supabase_schema.sql` dans Supabase SQL Editor

### Erreur de build iOS
**Solution** :
```bash
cd ios
pod install
cd ..
flutter clean
flutter run
```

### Erreur de build Android
**Solution** :
```bash
flutter clean
flutter pub get
flutter run
```

## 📚 Documentation

- `README.md` - Vue d'ensemble du projet
- `QUICKSTART.md` - Guide de démarrage rapide
- `INSTALLATION.md` - Guide d'installation détaillé
- `STRUCTURE.md` - Structure du projet
- `supabase_schema.sql` - Schéma de base de données

## 🎉 Une Fois Configuré

Après avoir complété toutes les étapes ci-dessus, vous pourrez :
- ✅ Créer des comptes utilisateurs
- ✅ Ajouter des téléphones avec scan IMEI
- ✅ Rechercher et filtrer les téléphones
- ✅ Gérer les ventes et l'historique
- ✅ Synchroniser les données en temps réel

## 🆘 Besoin d'Aide ?

1. Consultez `QUICKSTART.md` pour un guide pas à pas
2. Consultez `INSTALLATION.md` pour plus de détails
3. Vérifiez les logs : `flutter logs`
4. Consultez la documentation Supabase : https://supabase.com/docs

## 📞 Support

Pour toute question :
- Documentation Flutter : https://flutter.dev/docs
- Documentation Supabase : https://supabase.com/docs
- Documentation GetX : https://pub.dev/packages/get
