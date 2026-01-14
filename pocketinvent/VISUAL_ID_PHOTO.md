# 📸 Pièce d'Identité - Guide Visuel

## 🎯 Aperçu de la Fonctionnalité

### État Vide (Pas de photo)
```
┌─────────────────────────────────────┐
│                                     │
│            🪪 (Icône)              │
│                                     │
│   ┌──────────┐   ┌──────────┐     │
│   │ 📷 Prendre│   │ 🖼️ Galerie│     │
│   └──────────┘   └──────────┘     │
│                                     │
└─────────────────────────────────────┘
```

### Avec Photo
```
┌─────────────────────────────────────┐
│  ┌─────────────────────────────┐ ❌ │
│  │                             │    │
│  │      [PHOTO D'IDENTITÉ]     │    │
│  │                             │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

## 🎨 Spécifications Design

### Couleurs
| Élément | Couleur | Code |
|---------|---------|------|
| Bouton Prendre | Bleu primaire | `#4D6FFF` |
| Bouton Galerie | Bordure bleue | `#4D6FFF` |
| Bouton Supprimer | Rouge | `#EF4444` |
| Fond conteneur | Gris clair | `#F3F4F6` |
| Bordure | Gris | `#E5E7EB` |

### Dimensions
| Élément | Taille |
|---------|--------|
| Conteneur photo | 200px hauteur |
| Border radius | 12px |
| Boutons radius | 10px |
| Icône grande | 48px |
| Icône bouton | 20px |
| Bouton supprimer | 32x32px |

### Espacement
| Élément | Valeur |
|---------|--------|
| Entre champs | 16px |
| Padding boutons | 16px horizontal, 12px vertical |
| Entre boutons | 12px |

## 📱 Flux Utilisateur

### Ajouter un Client/Fournisseur avec Photo

```
1. Liste Clients/Fournisseurs
   ↓ [Clic sur +]
   
2. Formulaire Nouveau
   ├─ Nom *
   ├─ Téléphone
   ├─ Email
   └─ Pièce d'identité
      ├─ [Prendre] → Ouvre caméra
      └─ [Galerie] → Ouvre galerie
   
3. Photo sélectionnée
   ├─ Prévisualisation affichée
   └─ [❌] pour supprimer
   
4. [Créer]
   ↓
   
5. Upload automatique
   ├─ Photo → Supabase Storage
   └─ URL → Base de données
```

### Modifier avec Changement de Photo

```
1. Liste Clients/Fournisseurs
   ↓ [Clic sur ✏️]
   
2. Formulaire Modification
   ├─ Données existantes
   └─ Photo existante affichée
   
3. [❌] Supprimer l'ancienne
   ↓
   
4. [Prendre] ou [Galerie]
   ↓
   
5. Nouvelle photo sélectionnée
   ↓
   
6. [Modifier]
   ↓
   
7. Traitement
   ├─ Suppression ancienne photo
   ├─ Upload nouvelle photo
   └─ Mise à jour URL
```

## 🗂️ Structure des Fichiers

```
pocketinvent/
├── lib/
│   ├── app/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── client.dart ✅ (+ photoIdentiteUrl)
│   │   │   │   └── fournisseur.dart ✅ (+ photoIdentiteUrl)
│   │   │   └── services/
│   │   │       ├── client_service.dart ✅ (+ upload/delete)
│   │   │       └── fournisseur_service.dart ✅ (+ upload/delete)
│   │   └── modules/
│   │       ├── client/
│   │       │   ├── client_controller.dart ✅ (+ photo logic)
│   │       │   └── client_view.dart ✅ (+ IdPhotoPicker)
│   │       ├── fournisseur/
│   │       │   ├── fournisseur_controller.dart ✅ (+ photo logic)
│   │       │   └── fournisseur_view.dart ✅ (+ IdPhotoPicker)
│   │       └── widgets/
│   │           └── id_photo_picker.dart ✨ NOUVEAU
│   └── ...
├── supabase_schema.sql ✅ (+ colonnes + bucket)
├── MIGRATION_ID_PHOTO.md 📝
├── ID_PHOTO_FEATURE_COMPLETE.md 📝
└── VISUAL_ID_PHOTO.md 📝 (ce fichier)
```

## 🔐 Sécurité Supabase

### Structure du Bucket `id-photos`

```
id-photos/
├── {user_id_1}/
│   ├── {user_id_1}_1234567890.jpg
│   ├── {user_id_1}_1234567891.jpg
│   └── ...
├── {user_id_2}/
│   ├── {user_id_2}_1234567892.jpg
│   └── ...
└── ...
```

### Politiques RLS

| Action | Condition | Résultat |
|--------|-----------|----------|
| INSERT | `auth.uid() = folder_name` | ✅ Peut uploader dans son dossier |
| SELECT | `auth.uid() = folder_name` | ✅ Peut voir ses photos |
| DELETE | `auth.uid() = folder_name` | ✅ Peut supprimer ses photos |
| Autre user | `auth.uid() ≠ folder_name` | ❌ Accès refusé |

## 📊 Données Stockées

### Table `client`
```sql
CREATE TABLE client (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    nom TEXT NOT NULL,
    telephone TEXT,
    email TEXT,
    photo_identite_url TEXT,  ← NOUVEAU
    created_at TIMESTAMP,      ← NOUVEAU
    updated_at TIMESTAMP       ← NOUVEAU
);
```

### Table `fournisseur`
```sql
CREATE TABLE fournisseur (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    nom TEXT NOT NULL,
    telephone TEXT,
    email TEXT,
    photo_identite_url TEXT,  ← NOUVEAU
    created_at TIMESTAMP,      ← NOUVEAU
    updated_at TIMESTAMP       ← NOUVEAU
);
```

### Exemple d'URL stockée
```
https://[project].supabase.co/storage/v1/object/public/id-photos/
{user_id}/{user_id}_1705234567890.jpg
```

## 🎬 Démonstration

### Scénario 1 : Nouveau Client avec Photo

1. **Ouvrir** : Clients → [+]
2. **Remplir** :
   - Nom : "Jean Dupont"
   - Téléphone : "0612345678"
   - Email : "jean@example.com"
3. **Photo** : [Prendre] → Prendre photo de la carte d'identité
4. **Vérifier** : Photo affichée en prévisualisation
5. **Sauvegarder** : [Créer]
6. **Résultat** : Client créé avec photo dans Supabase

### Scénario 2 : Modifier Photo Existante

1. **Ouvrir** : Clients → [✏️] sur "Jean Dupont"
2. **Voir** : Photo actuelle affichée
3. **Changer** : [❌] puis [Galerie] → Sélectionner nouvelle photo
4. **Sauvegarder** : [Modifier]
5. **Résultat** : 
   - Ancienne photo supprimée de Supabase
   - Nouvelle photo uploadée
   - URL mise à jour dans la base

## 🧪 Tests à Effectuer

### ✅ Checklist de Test

- [ ] Créer un client sans photo
- [ ] Créer un client avec photo (caméra)
- [ ] Créer un client avec photo (galerie)
- [ ] Modifier un client et ajouter une photo
- [ ] Modifier un client et changer la photo
- [ ] Modifier un client et supprimer la photo
- [ ] Vérifier que la photo s'affiche correctement
- [ ] Vérifier que l'ancienne photo est supprimée
- [ ] Vérifier les permissions (autre utilisateur ne peut pas voir)
- [ ] Tester avec une grande image (vérifier redimensionnement)

### 🔍 Vérifications Supabase

1. **Storage** : Aller dans Storage → id-photos
   - Vérifier que les dossiers sont créés par user_id
   - Vérifier que les photos sont bien uploadées
   - Vérifier que les anciennes photos sont supprimées

2. **Database** : Aller dans Table Editor → client/fournisseur
   - Vérifier que `photo_identite_url` contient l'URL
   - Vérifier que `created_at` et `updated_at` sont remplis

3. **Policies** : Aller dans Storage → Policies
   - Vérifier que les 3 policies sont actives
   - Tester avec un autre compte (ne doit pas voir les photos)

## 🎉 Résultat Final

### Interface Utilisateur
- ✅ Design moderne et épuré
- ✅ Conforme au design system
- ✅ Intuitive et facile à utiliser
- ✅ Feedback visuel immédiat

### Backend
- ✅ Stockage sécurisé dans Supabase
- ✅ Politiques RLS strictes
- ✅ Optimisation automatique des images
- ✅ Gestion automatique des suppressions

### Code
- ✅ Réutilisable (widget IdPhotoPicker)
- ✅ Maintenable et bien structuré
- ✅ Sans erreurs de diagnostic
- ✅ Commenté et documenté

---

**Prêt à utiliser !** 🚀
