-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Table: couleur
CREATE TABLE couleur (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    libelle TEXT NOT NULL,
    code_couleur TEXT
);

-- Table: marque
CREATE TABLE marque (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nom TEXT NOT NULL UNIQUE
);

-- Table: modele
CREATE TABLE modele (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nom TEXT NOT NULL,
    marque_id UUID NOT NULL REFERENCES marque(id) ON DELETE CASCADE
);

-- Table: capacite
CREATE TABLE capacite (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    valeur TEXT NOT NULL UNIQUE
);

-- Table: fournisseur
CREATE TABLE fournisseur (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    nom TEXT NOT NULL,
    telephone TEXT,
    email TEXT,
    photo_identite_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: client
CREATE TABLE client (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    nom TEXT NOT NULL,
    telephone TEXT,
    email TEXT,
    photo_identite_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: statut_paiement
CREATE TABLE statut_paiement (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    libelle TEXT NOT NULL UNIQUE
);

-- Table: telephone
CREATE TABLE telephone (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    imei TEXT NOT NULL,
    marque_id UUID NOT NULL REFERENCES marque(id),
    modele_id UUID NOT NULL REFERENCES modele(id),
    couleur_id UUID NOT NULL REFERENCES couleur(id),
    capacite_id UUID NOT NULL REFERENCES capacite(id),
    fournisseur_id UUID REFERENCES fournisseur(id),
    prix_achat DECIMAL(10, 2) NOT NULL,
    prix_vente DECIMAL(10, 2),
    statut_paiement_id UUID NOT NULL REFERENCES statut_paiement(id),
    date_entree TIMESTAMP NOT NULL,
    photo_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, imei)
);

-- Table: historique_transaction
CREATE TABLE historique_transaction (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    telephone_id UUID NOT NULL REFERENCES telephone(id) ON DELETE CASCADE,
    type_transaction TEXT NOT NULL CHECK (type_transaction IN ('Achat', 'Vente', 'Retour')),
    client_id UUID REFERENCES client(id),
    fournisseur_id UUID REFERENCES fournisseur(id),
    montant DECIMAL(10, 2) NOT NULL,
    statut_paiement_id UUID NOT NULL REFERENCES statut_paiement(id),
    date_transaction TIMESTAMP NOT NULL,
    notes TEXT
);

-- Row Level Security (RLS) Policies

-- Enable RLS on all tables
ALTER TABLE fournisseur ENABLE ROW LEVEL SECURITY;
ALTER TABLE client ENABLE ROW LEVEL SECURITY;
ALTER TABLE telephone ENABLE ROW LEVEL SECURITY;
ALTER TABLE historique_transaction ENABLE ROW LEVEL SECURITY;

-- Fournisseur policies
CREATE POLICY "Users can view their own fournisseurs" ON fournisseur
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own fournisseurs" ON fournisseur
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own fournisseurs" ON fournisseur
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own fournisseurs" ON fournisseur
    FOR DELETE USING (auth.uid() = user_id);

-- Client policies
CREATE POLICY "Users can view their own clients" ON client
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own clients" ON client
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own clients" ON client
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own clients" ON client
    FOR DELETE USING (auth.uid() = user_id);

-- Telephone policies
CREATE POLICY "Users can view their own telephones" ON telephone
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own telephones" ON telephone
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own telephones" ON telephone
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own telephones" ON telephone
    FOR DELETE USING (auth.uid() = user_id);

-- Historique_transaction policies
CREATE POLICY "Users can view their own transactions" ON historique_transaction
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own transactions" ON historique_transaction
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Reference tables (public read access)
ALTER TABLE couleur ENABLE ROW LEVEL SECURITY;
ALTER TABLE marque ENABLE ROW LEVEL SECURITY;
ALTER TABLE modele ENABLE ROW LEVEL SECURITY;
ALTER TABLE capacite ENABLE ROW LEVEL SECURITY;
ALTER TABLE statut_paiement ENABLE ROW LEVEL SECURITY;

-- Couleur policies
CREATE POLICY "Anyone can view couleurs" ON couleur FOR SELECT USING (true);
CREATE POLICY "Authenticated users can insert couleurs" ON couleur FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update couleurs" ON couleur FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete couleurs" ON couleur FOR DELETE USING (auth.role() = 'authenticated');

-- Marque policies
CREATE POLICY "Anyone can view marques" ON marque FOR SELECT USING (true);
CREATE POLICY "Authenticated users can insert marques" ON marque FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update marques" ON marque FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete marques" ON marque FOR DELETE USING (auth.role() = 'authenticated');

-- Modele policies
CREATE POLICY "Anyone can view modeles" ON modele FOR SELECT USING (true);
CREATE POLICY "Authenticated users can insert modeles" ON modele FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update modeles" ON modele FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete modeles" ON modele FOR DELETE USING (auth.role() = 'authenticated');

-- Capacite policies
CREATE POLICY "Anyone can view capacites" ON capacite FOR SELECT USING (true);
CREATE POLICY "Authenticated users can insert capacites" ON capacite FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update capacites" ON capacite FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete capacites" ON capacite FOR DELETE USING (auth.role() = 'authenticated');

-- Statut_paiement policies
CREATE POLICY "Anyone can view statut_paiement" ON statut_paiement FOR SELECT USING (true);
CREATE POLICY "Authenticated users can insert statut_paiement" ON statut_paiement FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update statut_paiement" ON statut_paiement FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete statut_paiement" ON statut_paiement FOR DELETE USING (auth.role() = 'authenticated');

-- Insert default data 

-- Statuts de paiement
INSERT INTO statut_paiement (libelle) VALUES
    ('Payé'),
    ('Retour'),
    ('Revendu');

-- Couleurs
INSERT INTO couleur (libelle, code_couleur) VALUES
    ('Noir', '#000000'),
    ('Blanc', '#FFFFFF'),
    ('Bleu', '#0000FF'),
    ('Rouge', '#FF0000'),
    ('Vert', '#00FF00'),
    ('Or', '#FFD700'),
    ('Argent', '#C0C0C0'),
    ('Rose', '#FFC0CB');

-- Capacités
INSERT INTO capacite (valeur) VALUES
    ('64GB'),
    ('128GB'),
    ('256GB'),
    ('512GB'),
    ('1TB');

-- Marques
INSERT INTO marque (nom) VALUES
    ('Apple'),
    ('Samsung'),
    ('Xiaomi'),
    ('Huawei'),
    ('OnePlus'),
    ('Google'),
    ('Oppo'),
    ('Vivo');

-- Modèles Apple
INSERT INTO modele (nom, marque_id) 
SELECT 'iPhone 15 Pro Max', id FROM marque WHERE nom = 'Apple';
INSERT INTO modele (nom, marque_id) 
SELECT 'iPhone 15 Pro', id FROM marque WHERE nom = 'Apple';
INSERT INTO modele (nom, marque_id) 
SELECT 'iPhone 15', id FROM marque WHERE nom = 'Apple';
INSERT INTO modele (nom, marque_id) 
SELECT 'iPhone 14 Pro Max', id FROM marque WHERE nom = 'Apple';
INSERT INTO modele (nom, marque_id) 
SELECT 'iPhone 14 Pro', id FROM marque WHERE nom = 'Apple';
INSERT INTO modele (nom, marque_id) 
SELECT 'iPhone 14', id FROM marque WHERE nom = 'Apple';

-- Modèles Samsung
INSERT INTO modele (nom, marque_id) 
SELECT 'Galaxy S24 Ultra', id FROM marque WHERE nom = 'Samsung';
INSERT INTO modele (nom, marque_id) 
SELECT 'Galaxy S24+', id FROM marque WHERE nom = 'Samsung';
INSERT INTO modele (nom, marque_id) 
SELECT 'Galaxy S24', id FROM marque WHERE nom = 'Samsung';
INSERT INTO modele (nom, marque_id) 
SELECT 'Galaxy Z Fold 5', id FROM marque WHERE nom = 'Samsung';
INSERT INTO modele (nom, marque_id) 
SELECT 'Galaxy Z Flip 5', id FROM marque WHERE nom = 'Samsung';

-- Storage bucket for phone photos
INSERT INTO storage.buckets (id, name, public) 
VALUES ('phone-photos', 'phone-photos', true)
ON CONFLICT (id) DO NOTHING;

-- Storage bucket for ID photos
INSERT INTO storage.buckets (id, name, public) 
VALUES ('id-photos', 'id-photos', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for phone photos
DROP POLICY IF EXISTS "Users can upload their own phone photos" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can view phone photos" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own phone photos" ON storage.objects;

CREATE POLICY "Users can upload their own phone photos" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'phone-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Anyone can view phone photos" ON storage.objects
    FOR SELECT USING (bucket_id = 'phone-photos');

CREATE POLICY "Users can delete their own phone photos" ON storage.objects
    FOR DELETE USING (bucket_id = 'phone-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Storage policies for ID photos
DROP POLICY IF EXISTS "Users can upload their own ID photos" ON storage.objects;
DROP POLICY IF EXISTS "Users can view their own ID photos" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own ID photos" ON storage.objects;

CREATE POLICY "Users can upload their own ID photos" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'id-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view their own ID photos" ON storage.objects
    FOR SELECT USING (bucket_id = 'id-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete their own ID photos" ON storage.objects
    FOR DELETE USING (bucket_id = 'id-photos' AND auth.uid()::text = (storage.foldername(name))[1]);
