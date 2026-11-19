# Farmotic — Addon Home Assistant

Addon Home Assistant fonctionnel basé sur l'application **Farmotic** (suivi d'élevage de poulets de chair).

## Description

L'addon expose l'interface React (Vite + Tailwind) et le serveur FastAPI de Farmotic en tant qu'addon Home Assistant. Il permet :

- Gestion des **cycles** (bandes) de poulet avec stats (poids, date, série, synthèse).
- Enregistrements journaliers : poids, alimentation, eau, mortalité, température, humidité.
- Suivi de la **mortalité**, charges financières, ventes, références de croissance.
- Indicateurs techniques et économiques : indice de consommation (IC), coût par kilo, marge.
- Gestion multi-utilisateurs avec rôles (`admin`, `operateur`, `lecteur`).
- Sauvegarde / restauration de la base SQLite locale.
- Mises à jour automatiques depuis Git (option désactivée par défaut).
- Fonctionnement hors-ligne (PWA, mode offline).

## Structure du dépôt (pour Home Assistant)

```
Farmotic/
└── hass-addon/                     # ← Dépôt à ajouter dans HA
    ├── repository.yaml             # ← Déclaration du dépôt HA
    └── farmotic/                   # ← L'addon (slug)
        ├── config.yaml             # ← Métadonnées de l'addon
        ├── Dockerfile              # ← Image de conteneur Python 3.11
        ├── run.sh                  # ← Script de démarrage
        ├── README.md               # ← Ce document
        ├── main.py                 # ← Backend FastAPI
        ├── lancer.py               # ← Lanceur original
        ├── maj.py                  # ← Moteur de mise à jour
        ├── mettre_a_jour.py        # ← Script CLI mise à jour
        ├── requirements.txt        # ← Dépendances Python
        └── build/                  # ← Interface React compilée
```

## 🔧 Installation dans Home Assistant

### Méthode 1 — Via l'interface HA (recommandé)

1. Allez dans **Paramètres → Compléments (Add-ons) → Boutique d'add-ons**.
2. Cliquez sur **"..." (trois points) → Déposer un dépôt d'add-on**.
3. Saisissez l'URL du dépôt :
   ```
   https://github.com/Nosimandimby/Farmotic
   ```
   (ou `https://github.com/Nosimandimby/Farmotic/tree/main/hass-addon` si les fichiers sont dans un sous-dossier).
4. Cliquez sur **Ajouter**.
5. Recherchez **Farmotic** dans la liste des add-ons disponibles.
6. Cliquez sur **Installer**, puis **Démarrer**.
7. Ouvrez l'addon (icône 🐔) ou allez sur `http://IP_HA:3001`.

### Méthode 2 — Copie locale (développement)

Copiez le dossier `hass-addon/farmotic` dans `/config/addons/` sur votre Home Assistant :

```bash
cp -r hass-addon/farmotic /config/addons/farmotic
```

Puis rechargez les add-ons dans HA : **Paramètres → Compléments → Recharger**.

## 🚀 Test rapide (Docker autonome)

```bash
# Build
cd /home/nosimandimby/Documents/Freebuff/Farmotic/hass-addon
docker build -t farmotic:latest farmotic/

# Run avec volume persistant
docker run -d --name farmotic \
  -p 3001:3001 \
  -v farmotic-data:/data \
  farmotic:latest

# Test API
curl http://localhost:3001/api/sante
# {"ok":true}
```

## ⚙️ Configuration

| Option | Défaut | Description |
|--------|--------|-------------|
| `port` | 3001 | Port d'écoute |
| `host` | 0.0.0.0 | Interface réseau (0.0.0.0 = accessible LAN) |
| `auto_update` | false | Mises à jour auto depuis Git |
| `no_open` | true | Ne pas ouvrir le navigateur au démarrage |

## 🔑 Identifiants par défaut

- **Login** : `admin`
- **Mot de passe** : `admin`

> ⚠️ Changez-les dans *Paramètres → Mon compte* au premier accès.

## 💾 Données persistantes

- La base SQLite est stockée dans `/data/database.sqlite` (persistante via le volume Home Assistant).
- Le secret de session est dans `/data/session-secret.txt`.
