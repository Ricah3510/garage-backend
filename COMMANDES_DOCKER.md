# 🐳 Commandes Docker - Garage Simulation

## 📋 Prérequis

- Docker Desktop installé et lancé
- Git (optionnel)

---

## 🚀 Démarrer les services

### 1. Démarrer tous les services (PostgreSQL + Laravel)

```bash
docker-compose up -d
```

### 2. Vérifier que les containers sont lancés

```bash
docker-compose ps
```

Vous devriez voir :
```
NAME              IMAGE                  STATUS
garage_laravel    ...                    Up
garage_postgres   postgres:15-alpine     Up
```

### 3. Accéder à l'application

Ouvrez votre navigateur : **http://localhost:8000**

---

## 🛑 Arrêter les services

### Arrêter tous les containers

```bash
docker-compose stop
```

### Arrêter et supprimer les containers

```bash
docker-compose down
```

### Arrêter et supprimer les containers + volumes (⚠️ Supprime la base de données)

```bash
docker-compose down -v
```

---

## 🔄 Redémarrer les services

### Redémarrer tous les services

```bash
docker-compose restart
```

### Redémarrer uniquement Laravel

```bash
docker-compose restart laravel
```

### Redémarrer uniquement PostgreSQL

```bash
docker-compose restart postgres
```

---

## 📊 Consulter les logs

### Voir les logs de tous les services

```bash
docker-compose logs -f
```

### Voir les logs de Laravel uniquement

```bash
docker-compose logs -f laravel
```

### Voir les logs de PostgreSQL uniquement

```bash
docker-compose logs -f postgres
```

---

## 🗄️ Accéder à PostgreSQL

### Se connecter à PostgreSQL via le terminal

```bash
docker-compose exec postgres psql -U garage_user -d garage_db
```

### Commandes PostgreSQL utiles

Une fois connecté à PostgreSQL :

```sql
-- Lister toutes les tables
\dt

-- Voir les données d'une table
SELECT * FROM t_client;

-- Quitter PostgreSQL
\q
```

---

## 🔧 Commandes Laravel

### Exécuter une commande Artisan

```bash
docker-compose exec laravel php artisan <commande>
```

### Exemples de commandes Laravel utiles

```bash
# Voir les routes
docker-compose exec laravel php artisan route:list

# Créer un nouveau contrôleur
docker-compose exec laravel php artisan make:controller NomController

# Créer un nouveau modèle
docker-compose exec laravel php artisan make:model NomModel

# Créer une migration
docker-compose exec laravel php artisan make:migration nom_de_la_migration

# Nettoyer le cache
docker-compose exec laravel php artisan cache:clear
docker-compose exec laravel php artisan config:clear
docker-compose exec laravel php artisan route:clear
```

---

## 📦 Gestion des dépendances Composer

### Installer une nouvelle dépendance

```bash
docker-compose run --rm laravel composer require nom/package
```

### Mettre à jour les dépendances

```bash
docker-compose run --rm laravel composer update
```

### Installer les dépendances (après un git clone)

```bash
docker-compose run --rm laravel composer install
```

---

## 🔨 Reconstruire les images Docker

Si vous modifiez le `Dockerfile` ou `docker-compose.yml` :

```bash
docker-compose up -d --build
```

---

## 🧹 Nettoyage

### Supprimer tous les containers arrêtés

```bash
docker container prune
```

### Supprimer toutes les images non utilisées

```bash
docker image prune -a
```

### Supprimer tous les volumes non utilisés (⚠️ Attention : supprime les données)

```bash
docker volume prune
```

---

## 🆘 Dépannage

### Le container Laravel redémarre en boucle

Vérifier les logs :
```bash
docker-compose logs laravel
```

### Problème de permissions

```bash
# Donner les permissions sur le dossier storage et bootstrap/cache
docker-compose exec laravel chmod -R 777 storage bootstrap/cache
```

### Réinstaller les dépendances

```bash
docker-compose run --rm laravel composer install
docker-compose run --rm laravel php artisan key:generate
```

### PostgreSQL ne démarre pas

```bash
# Supprimer le volume et recréer
docker-compose down -v
docker-compose up -d postgres
```

---

## 📝 Configuration importante

### Fichiers de configuration

- `docker-compose.yml` : Configuration des services Docker
- `Dockerfile` : Image Docker pour Laravel
- `backend/.env` : Configuration Laravel (DB, sessions, etc.)
- `database/init.sql` : Script d'initialisation PostgreSQL

### Variables d'environnement importantes (backend/.env)

```env
DB_CONNECTION=pgsql
DB_HOST=postgres
DB_PORT=5432
DB_DATABASE=garage_db
DB_USERNAME=garage_user
DB_PASSWORD=garage_password

SESSION_DRIVER=file
```

---

## 🔐 Informations de connexion

### PostgreSQL

- **Host** : localhost (depuis votre machine) / postgres (depuis Laravel)
- **Port** : 5432
- **Database** : garage_db
- **Username** : garage_user
- **Password** : garage_password

### Laravel

- **URL** : http://localhost:8000
- **API Base URL** : http://localhost:8000/api

---

## 📌 Premier démarrage après clone du projet

Si vous clonez le projet pour la première fois :

```bash
# 1. Aller dans le dossier du projet
cd garage-simulation

# 2. Copier le fichier .env
cp backend/.env.example backend/.env

# 3. Modifier backend/.env avec les bonnes valeurs (voir ci-dessus)

# 4. Installer les dépendances
docker-compose run --rm laravel composer install

# 5. Générer la clé d'application
docker-compose run --rm laravel php artisan key:generate

# 6. Démarrer les services
docker-compose up -d

# 7. Vérifier que tout fonctionne
docker-compose ps
```

---

## ✅ Vérification rapide

```bash
# Tout est OK si :
docker-compose ps
# Affiche les 2 containers avec STATUS "Up"

# ET
curl http://localhost:8000
# Retourne du HTML (page Laravel)
```

---

**🎉 Vous êtes prêt à développer !**

##Bibiotheque firebase
docker-compose run --rm laravel composer require kreait/firebase-php

## Installe route api
docker-compose exec laravel php artisan install:api