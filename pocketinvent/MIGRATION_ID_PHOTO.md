# Migration: Ajout de la pièce d'identité pour Clients et Fournisseurs

## Modifications de la base de données

### 1. Ajouter les colonnes pour les photos d'identité

Exécutez ces commandes SQL dans votre console Supabase :

```sql
-- Ajouter la colonne photo_identite_url à la table client
ALTER TABLE client 
ADD COLUMN photo_identite_url TEXT,
ADD COLUMN created_at TIMESTAMP DEFAULT NOW(),
ADD COLUMN updated_at TIMESTAMP DEFAULT NOW();

-- Ajouter la colonne photo_identite_url à la table fournisseur
ALTER TABLE fournisseur 
ADD COLUMN photo_identite_url TEXT,
ADD COLUMN created_at TIMESTAMP DEFAULT NOW(),
ADD COLUMN updated_at TIMESTAMP DEFAULT NOW();
```

### 2. Créer le bucket de stockage pour les photos d'identité

Dans Supabase Storage, créez un nouveau bucket :

1. Allez dans **Storage** > **Create a new bucket**
2. Nom du bucket : `id-photos`
3. Public : **Non** (privé pour la sécurité)
4. Cliquez sur **Create bucket**

### 3. Configurer les politiques de sécurité pour le bucket

Exécutez ces commandes SQL pour les politiques de stockage :

```sql
-- Politique pour uploader ses propres photos d'identité
CREATE POLICY "Users can upload their own ID photos" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'id-photos' AND 
        auth.uid()::text = (storage.foldername(name))[1]
    );

-- Politique pour voir ses propres photos d'identité
CREATE POLICY "Users can view their own ID photos" ON storage.objects
    FOR SELECT USING (
        bucket_id = 'id-photos' AND 
        auth.uid()::text = (storage.foldername(name))[1]
    );

-- Politique pour supprimer ses propres photos d'identité
CREATE POLICY "Users can delete their own ID photos" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'id-photos' AND 
        auth.uid()::text = (storage.foldername(name))[1]
    );
```

## Modifications du code

### Fichiers modifiés :

1. **Models** :
   - `lib/app/data/models/client.dart` - Ajout du champ `photoIdentiteUrl`
   - `lib/app/data/models/fournisseur.dart` - Ajout du champ `photoIdentiteUrl`

2. **Services** :
   - `lib/app/data/services/client_service.dart` - Ajout des méthodes `uploadIdPhoto()` et `deleteIdPhoto()`
   - `lib/app/data/services/fournisseur_service.dart` - Ajout des méthodes `uploadIdPhoto()` et `deleteIdPhoto()`

3. **Controllers** :
   - `lib/app/modules/client/client_controller.dart` - Ajout de la gestion des photos
   - `lib/app/modules/fournisseur/fournisseur_controller.dart` - Ajout de la gestion des photos

4. **Views** :
   - `lib/app/modules/client/client_view.dart` - Import du widget IdPhotoPicker
   - `lib/app/modules/fournisseur/fournisseur_view.dart` - Import du widget IdPhotoPicker

5. **Nouveau widget** :
   - `lib/app/modules/widgets/id_photo_picker.dart` - Widget réutilisable pour la sélection de photos

## Fonctionnalités ajoutées

### Interface utilisateur (selon design.json)

- **Sélection de photo** : Boutons stylisés avec les couleurs du design system (#4D6FFF)
- **Prévisualisation** : Affichage de l'image avec bordures arrondies (12px)
- **Suppression** : Bouton rouge en overlay pour supprimer la photo
- **Deux options** :
  - Prendre une photo avec la caméra
  - Sélectionner depuis la galerie

### Sécurité

- Les photos sont stockées dans un bucket privé
- Chaque utilisateur ne peut accéder qu'à ses propres photos
- Les photos sont organisées par dossier utilisateur (user_id)
- Suppression automatique de l'ancienne photo lors de la mise à jour

## Test de la fonctionnalité

1. Lancez l'application
2. Allez dans **Clients** ou **Fournisseurs**
3. Cliquez sur **Ajouter** (+)
4. Remplissez les informations
5. Cliquez sur **Prendre** ou **Galerie** pour ajouter une photo d'identité
6. Sauvegardez

La photo sera uploadée sur Supabase et l'URL sera enregistrée dans la base de données.

## Notes importantes

- Les photos sont redimensionnées à 1024x1024 max pour optimiser le stockage
- La qualité est fixée à 85% pour un bon compromis taille/qualité
- Format supporté : JPEG
- Les anciennes photos sont automatiquement supprimées lors de la mise à jour
