# In Progress

# Minecraft

## Dans le répertoire contenant le fichier docker-compose.yml et le dossier flask_api, exécutez la commande suivante pour démarrer l'environnement :

si erreur de permission
```sh
minecraft_server | java.nio.file.AccessDeniedException: /minecraft/bundler
minecraft_server | 	at java.base/sun.nio.fs.UnixException.translateToIOException(Unknown Source)
minecraft_server | 	at java.base/sun.nio.fs.UnixException.rethrowAsIOException(Unknown Source)
minecraft_server | 	at java.base/sun.nio.fs.UnixException.rethrowAsIOException(Unknown Source)
minecraft_server | 	at java.base/sun.nio.fs.UnixFileSystemProvider.createDirectory(Unknown Source)
minecraft_server | 	at java.base/java.nio.file.Files.createDirectory(Unknown Source)
minecraft_server | 	at java.base/java.nio.file.Files.createAndCheckIsDirectory(Unknown Source)
minecraft_server | 	at java.base/java.nio.file.Files.createDirectories(Unknown Source)
minecraft_server | 	at org.bukkit.craftbukkit.bootstrap.Main.run(Main.java:38)
minecraft_server | 	at org.bukkit.craftbukkit.bootstrap.Main.main(Main.java:27)
minecraft_server | Failed to extract server libraries, exiting
minecraft_server exited with code 0
```

faire
```sh
sudo chown -R 1000:1000 ./data
sudo chmod -R 775 ./data
```

ensuite :

```sh
sudo docker-compose up -d --build
```

## pour ouvrir le port 25565

```sh
sudo ufw allow 25565/tcp
```

et ouvrir port 25565 dans le fichier de configuration de votre routeur
