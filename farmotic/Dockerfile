FROM python:3.11-slim

LABEL org.opencontainers.image.title="Farmotic"
LABEL org.opencontainers.image.description="Suivi d'élevage de poulets de chair - Addon Home Assistant"
LABEL org.opencontainers.image.source="https://github.com/Nosimandimby/Farmotic"

# Installer les dépendances système
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Créer un utilisateur non-root
RUN useradd -m -u 1000 -s /bin/bash farmotic

# Dossier de données persistant (monté par HA sous /data)
RUN mkdir -p /data && chown farmotic:farmotic /data

# Dossier de travail
WORKDIR /opt/farmotic

# Copier les dépendances Python d'abord pour profiter du cache
COPY requirements.txt ./

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Copier le code de l'application
COPY main.py lancer.py maj.py mettre_a_jour.py ./
COPY build/ ./build/

# Copier le script de lancement
COPY run.sh ./

# Donner les permissions à l'utilisateur farmotic
RUN chown -R farmotic:farmotic /opt/farmotic \
    && chmod +x /opt/farmotic/run.sh

# Variables par défaut
ENV HOST=0.0.0.0
ENV PORT=3001
ENV FARMOTIC_NO_OPEN=1

# Exposer le port (utilisé par HA pour l'accès direct via l'onglet "Open Web UI")
EXPOSE 3001

# Lancer l'application (root pour écrire dans le volume /data monté par HA)
CMD ["./run.sh"]