#!/bin/sh
# Script de démarrage pour l'addon Farmotic (Home Assistant)
set -e

# S'assurer que le dossier /data est créable (mounté par HA)
mkdir -p /data

# Créer un lien symbolique pour que le dossier data de l'application pointe vers /data
mkdir -p /opt/farmotic/data
if [ ! -L /opt/farmotic/data ]; then
  rm -rf /opt/farmotic/data
  ln -s /data /opt/farmotic/data
fi

# Lancer le serveur FastAPI/Uvicorn
export FARMOTIC_NO_OPEN=1
cd /opt/farmotic
exec python3 -m uvicorn main:app --host 0.0.0.0 --port 3001
