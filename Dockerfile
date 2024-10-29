# Étape de construction de Spigot
FROM eclipse-temurin:21-jdk AS builder

RUN mkdir /build
WORKDIR /build

RUN apt update && apt install -y \
    ca-certificates \
    wget \
    git \
    jq

RUN wget -O BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

RUN git config --global --unset core.autocrlf || exit 0
RUN java -jar BuildTools.jar --rev 1.21.3
RUN mv spigot-*.jar spigot.jar

# Étape d'exécution du serveur Minecraft
FROM eclipse-temurin:21-jre

# Installation de jq
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

# Création des répertoires et de l'utilisateur
RUN groupadd -g 1001 minecraft && \
    useradd -r -u 1001 -g minecraft -s /bin/bash minecraft && \
    mkdir -p /minecraft /server && \
    chown -R minecraft:minecraft /minecraft /server && \
    chmod -R 755 /minecraft /server

# Déclaration explicite du volume
VOLUME ["/minecraft"]

# Copie des fichiers nécessaires
COPY --from=builder --chown=minecraft:minecraft /build/spigot.jar /server/
COPY --chown=minecraft:minecraft entrypoint.sh /server/
COPY --chown=minecraft:minecraft minecraft_config.json /server/

# Configuration des permissions
RUN chmod +x /server/entrypoint.sh

# Configuration de l'environnement
WORKDIR /minecraft

# Exposition des ports
EXPOSE 25565
EXPOSE 25575

USER minecraft:minecraft

ENTRYPOINT ["/server/entrypoint.sh"]
