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
    hass-addon/                     # ← Dépôt à ajouter dans HA
    ├── repository.yaml             # ← Déclaration du dépôt HA
    ├── README.md                  # ← Ce document
    └── farmotic/                   # ← L'addon (slug)
        ├── config.yaml             # ← Métadonnées + options de l'addon
        ├── Dockerfile              # ← Image de conteneur Python 3.11
        ├── run.sh                  # ← Script de démarrage
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
   https://github.com/Nosimandimby/ha-Farmotic
   ```
   (cette URL est déclarée dans `repository.yaml` du dépôt ; vous pouvez aussi utiliser `https://github.com/Nosimandimby/Farmotic/ha-Farmotic` si le dépôt est organisé différemment).
4. Cliquez sur **Ajouter**.
5. Recherchez **Farmotic** dans la liste des add-ons disponibles.
6. Cliquez sur **Installer**, puis **Démarrer**.
7. Ouvrez l'addon (icône 🐔) ou allez sur `http://IP_HA:<port>` (3001 par défaut).

### Méthode 2 — Copie locale (développement)

Copiez le dossier `hass-addon/farmotic` dans `/config/addons/` sur votre Home Assistant :

```bash
cp -r hass-addon/farmotic /config/addons/farmotic
```

Puis rechargez les add-ons dans HA : **Paramètres → Compléments → Recharger**.

## 🚀 Test rapide (Docker autonome)

```bash
# Depuis la racine du dépôt (où se trouve repository.yaml et folder hass-addon/)
cd hass-addon
# Build
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

L'addon accepte les options suivantes (configurables via l'interface de Home Assistant) :

| Option    | Défaut | Description                                   |
|-----------|--------|-----------------------------------------------|
| `port`    | 3001   | Numéro de port TCP sur lequel le serveur FastAPI écoute (1–65535). |
| `host`    | 0.0.0.0 | Interface réseau : `0.0.0.0` = accessible LAN, `127.0.0.1` = local uniquement. |
| `auto_update` | false | Active la mise à jour automatique depuis le dépôt Git distant (nécessite un accès réseau). |
| `no_open` | true   | Si `true`, le navigateur n'est pas ouvert automatiquement au démarrage. |

> **Important :** l'option `port` modifie uniquement le port d'écoute **dans le conteneur**. La correspondance de port réseau (`ports:` dans `config.yaml`) reste fixe (`3001/tcp: 3001`). Pour tester manuellement, utilisez `--port <votre_port>` en lançant l'addon (ou modifiez l'option `port` dans HA et redémarrez l'addon).

## 🔑 Identifiants par défaut

- **Login** : `admin`
- **Mot de passe** : `admin`

> ⚠️ Changez-les dans *Paramètres → Mon compte* au premier accès.

## 💾 Données persistantes

- La base SQLite (`database.sqlite`) est stockée dans `/data/database.sqlite` (montée par le volume Home Assistant `data`).
- Le secret de session (`session-secret.txt`) est dans `/data/session-secret.txt`.
- Tous les fichiers de l'application sont sauvegardés en cas de redémarrage de l'addon.
