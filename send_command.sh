#!/bin/bash

# Variables
HOST="127.0.0.1"  # Adresse IP de votre serveur Minecraft
PORT="25575"      # Port RCON
PASSWORD="votre_mot_de_passe_rcon_sécurisé"  # Mot de passe RCON
COMMAND=$1        # Commande à envoyer, passée en argument

# Vérifier si une commande a été donnée
if [ -z "$COMMAND" ]; then
  echo "Veuillez fournir une commande à envoyer au serveur Minecraft."
  exit 1
fi

# Utiliser mcrcon pour envoyer la commande
mcrcon -H $HOST -P $PORT -p "$PASSWORD" "$COMMAND"

# Rendez le script exécutable :
# chmod +x send_command.sh

# Exécutez le script pour envoyer une commande (par exemple list) :
# ./send_command.sh "list"