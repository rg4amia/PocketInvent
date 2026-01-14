# 🚀 Quick Start - Pièce d'Identité

## ⚡ En 3 Étapes

### 1️⃣ Migration Base de Données (5 min)

Ouvrez votre console Supabase SQL Editor et exécutez :

```sql
-- Ajouter les colonnes
ALTER TABLE client 
ADD COLUMN photo_identite_url TEXT,
ADD COLUMN created_at TIMESTAMP DEFAULT NOW(),
ADD COLUMN updated_at TIMESTAMP DEFAULT NOW();

ALTER TABLE fournisseur 
ADD COLUMN photo_identite_url TEXT,
ADD COLUMN created_at TIMESTAMP DEFAULT NOW(),
ADD COLUMN updated_at TIMESTAMP DEFAULT NOW();
```

### 2️⃣ Créer le Bucket Storage (2 min)

1. Allez dans **Supabase** → **Storage**
2. Cliquez sur **New bucket**
3. Nom : `id-photos`
4. Public : **NON** (décoché)
5. Cliquez sur **Create**

### 3️⃣ Configurer les Politiques (3 min)

Dans Supabase SQL Editor, exécutez :

```sql
-- Upload
CREATE POLICY "Users can upload their own ID photos" ON storage.objects
FOR INSERT WITH CHECK (
    bucket_id = 'id-photos' AND 
    auth.uid()::text = (storage.foldername(name))[1]
);

-- View
CREATE POLICY "Users can view their own ID photos" ON storage.objects
FOR SELECT USING (
    bucket_id = 'id-photos' AND 
    auth.uid()::text = (storage.foldername(name))[1]
);

-- Delete
CREATE POLICY "Users can delete their own ID photos" ON storage.objects
FOR DELETE USING (
    bucket_id = 'id-photos' AND 
    auth.uid()::text = (storage.foldername(name))[1]
);
```

## ✅ C'est Prêt !

Lancez l'application :

```bash
cd pocketinvent
flutter run
```

## 🎯 Test Rapide

1. Ouvrez **Clients** ou **Fournisseurs**
2. Cliquez sur **+** (Ajouter)
3. Remplissez le nom
4. Cliquez sur **Prendre** ou **Galerie**
5. Sélectionnez une photo
6. Cliquez sur **Créer**

✨ La photo est automatiquement uploadée sur Supabase !

## 📚 Documentation Complète

- **Migration détaillée** : `MIGRATION_ID_PHOTO.md`
- **Documentation technique** : `ID_PHOTO_FEATURE_COMPLETE.md`
- **Guide visuel** : `VISUAL_ID_PHOTO.md`
- **Résumé** : `ID_PHOTO_SUMMARY.md`

## 🆘 Problèmes ?

### La photo ne s'upload pas
- Vérifiez que le bucket `id-photos` existe
- Vérifiez que les 3 politiques sont créées
- Vérifiez que l'utilisateur est bien connecté

### Erreur de permission
- Vérifiez que le bucket est **privé** (non public)
- Vérifiez que les politiques RLS sont bien configurées

### L'image est trop grande
- L'app redimensionne automatiquement à 1024x1024
- Si problème persiste, vérifiez la connexion internet

---

**Temps total d'installation : ~10 minutes** ⏱️
