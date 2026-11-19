#!/bin/sh
# Script de démarrage pour l'addon Farmotic (Home Assistant)
set -e

# S'assurer que /data (volume monté par HA) est disponible en écriture.
# On ne fait pas échouer le démarrage si le volume pose problème.
mkdir -p /data 2>/dev/null || true

# Dossier de données effectif :
#  - /data                       si le volume HA est accessible en écriture (persistant)
#  - /opt/farmotic/data-local    sinon (repli : le conteneur reste utilisable)
if [ -w /data ]; then
  DATA_DIR="/data"
else
  DATA_DIR="/opt/farmotic/data-local"
fi
mkdir -p "$DATA_DIR"

# On force le chemin de la base SQLite via DB_PATH (pris en compte par main.py).
export DB_PATH="$DATA_DIR/database.sqlite"

# Lien symbolique pour compatibilité avec d'anciennes installations.
rm -rf /opt/farmotic/data
ln -s "$DATA_DIR" /opt/farmotic/data

# Les options de l'addon (port, host) sont passées par Home Assistant
# comme variables d'environnement PORT et HOST (via legacy mode).
# On utilise les valeurs par défaut si non définies.
export FARMOTIC_NO_OPEN=1
cd /opt/farmotic
exec python3 -m uvicorn main:app --host "${HOST:-0.0.0.0}" --port "${PORT:-3001}"