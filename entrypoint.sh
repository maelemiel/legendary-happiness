#!/bin/bash
set -e

# Création des dossiers nécessaires
mkdir -p /minecraft/{world,plugins,logs}

# Vérifier si le fichier de configuration existe
if [ ! -f "/server/minecraft_config.json" ]; then
    echo "Fichier de configuration non trouvé à l'emplacement /server/minecraft_config.json"
    exit 1
fi

# Accepter l'EULA
echo "eula=true" > /minecraft/eula.txt

# Créer ou vider le fichier server.properties
> /minecraft/server.properties

# Extraire les configurations du serveur et les écrire dans server.properties
jq -r '.server | to_entries[] | "\(.key)=\(.value)"' "/server/minecraft_config.json" >> /minecraft/server.properties

# Configurer la mémoire
MEMORY_MIN=$(jq -r '.system.memory.min // "1G"' "/server/minecraft_config.json")
MEMORY_MAX=$(jq -r '.system.memory.max // "1G"' "/server/minecraft_config.json")

# Configurer RCON si activé
ENABLE_RCON=$(jq -r '.system.rcon.enabled // "false"' "/server/minecraft_config.json")
if [ "$ENABLE_RCON" = "true" ]; then
    RCON_PORT=$(jq -r '.system.rcon.port // "25575"' "/server/minecraft_config.json")
    RCON_PASSWORD=$(jq -r '.system.rcon.password // "minecraft"' "/server/minecraft_config.json")
    echo "enable-rcon=true" >> /minecraft/server.properties
    echo "rcon.port=${RCON_PORT}" >> /minecraft/server.properties
    echo "rcon.password=${RCON_PASSWORD}" >> /minecraft/server.properties
fi

# Copier le jar dans le dossier minecraft
cp /server/spigot.jar /minecraft/

# Lancer le serveur Minecraft avec les paramètres mémoire
cd /minecraft
exec java -Xms${MEMORY_MIN} -Xmx${MEMORY_MAX} -XX:+UseG1GC -jar /minecraft/spigot.jar nogui