-- Création des tables
CREATE TABLE t_client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    firebase_uid VARCHAR(255) UNIQUE NOT NULL,
    fcm_token TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE t_voiture (
    id_voiture SERIAL PRIMARY KEY,
    modele VARCHAR(255) NOT NULL,
    immatriculation VARCHAR(50) UNIQUE NOT NULL,
    id_client INTEGER REFERENCES t_client(id_client) ON DELETE CASCADE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE t_status (
    id_status SERIAL PRIMARY KEY,
    nom VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE t_intervention (
    id_intervention SERIAL PRIMARY KEY,
    nom VARCHAR(100) UNIQUE NOT NULL,
    duree_secondes INTEGER NOT NULL,
    prix DECIMAL(10,2) NOT NULL
);

CREATE TABLE t_slot (
    id_slot SERIAL PRIMARY KEY,
    nom VARCHAR(50) UNIQUE NOT NULL,
    type VARCHAR(20) NOT NULL
);

CREATE TABLE t_reparation (
    id_reparation SERIAL PRIMARY KEY,
    id_voiture INTEGER REFERENCES t_voiture(id_voiture) ON DELETE CASCADE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_fin TIMESTAMP NULL
);

CREATE TABLE t_reparation_status (
    id SERIAL PRIMARY KEY,
    id_reparation INTEGER REFERENCES t_reparation(id_reparation) ON DELETE CASCADE,
    id_status INTEGER REFERENCES t_status(id_status),
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE t_reparation_intervention (
    id SERIAL PRIMARY KEY,
    id_reparation INTEGER REFERENCES t_reparation(id_reparation) ON DELETE CASCADE,
    id_intervention INTEGER REFERENCES t_intervention(id_intervention),
    id_status INTEGER REFERENCES t_status(id_status),
    date_debut TIMESTAMP NULL,
    date_fin TIMESTAMP NULL,
    date_modification_status TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE t_reparation_slot (
    id SERIAL PRIMARY KEY,
    id_reparation INTEGER REFERENCES t_reparation(id_reparation) ON DELETE CASCADE,
    id_slot INTEGER REFERENCES t_slot(id_slot),
    date_attribution TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_liberation TIMESTAMP NULL
);

CREATE TABLE t_paiement (
    id_paiement SERIAL PRIMARY KEY,
    id_reparation INTEGER REFERENCES t_reparation(id_reparation) ON DELETE CASCADE,
    montant DECIMAL(10,2) NOT NULL,
    date_paiement TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour performances
CREATE INDEX idx_voiture_client ON t_voiture(id_client);
CREATE INDEX idx_reparation_voiture ON t_reparation(id_voiture);
CREATE INDEX idx_reparation_status_reparation ON t_reparation_status(id_reparation);
CREATE INDEX idx_reparation_intervention_reparation ON t_reparation_intervention(id_reparation);
CREATE INDEX idx_reparation_slot_slot ON t_reparation_slot(id_slot);

-- Données initiales : Statuts
INSERT INTO t_status (nom) VALUES 
    ('en_attente'),
    ('en_cours'),
    ('terminee'),
    ('payee');

-- Données initiales : Interventions
INSERT INTO t_intervention (nom, duree_secondes, prix) VALUES 
    ('Frein', 300, 150.00),
    ('Vidange', 600, 80.00),
    ('Filtre', 180, 50.00),
    ('Batterie', 240, 120.00),
    ('Amortisseurs', 900, 350.00),
    ('Embrayage', 1200, 500.00),
    ('Pneus', 420, 200.00),
    ('Système de refroidissement', 720, 180.00);

-- Données initiales : Slots
INSERT INTO t_slot (nom, type) VALUES 
    ('Slot Réparation 1', 'reparation'),
    ('Slot Réparation 2', 'reparation');

-- Utilisateur de test
INSERT INTO t_client(nom, email, firebase_uid, fcm_token) VALUES
    ('Garage Naka', 'garage.naka@gmail.com', 'we6ZeK96qReZez0n0O2TXtqLf082', NULL);