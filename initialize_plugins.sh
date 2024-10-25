#!/bin/sh

# Vérifie si le dossier plugins existe dans data, le crée si nécessaire
if [ ! -d "/data/plugins" ]; then
    mkdir -p /data/plugins
fi

# Copie les plugins de plugins_source vers data/plugins
cp -u /plugins_source/*.jar /data/plugins/