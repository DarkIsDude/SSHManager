Ce projet ne fonctionne que depuis une machine sous MAC OS. Il a été testé avec "El Capitan". Il doit donc fonctionner avec OS X et MAC OS 10.10+.

Le but est d'offrir un manager de connection SSH simple et rapide d'emploi. Pour se connecter, il crée un script qu'il dépose sur la machine de manière temporaire. Il lance ensuite le terminal (ou iTerm) pour exécuter le shell et lancer la connexion.

# Particularité

Pour pouvoir me connecter sur les serveurs de mon entreprise et avoir un encodage correct, j'ai du désactiver l'option ’Set locale variables automatically’.

# Configuration

Le projet fonctionne par défaut avec iTerm2 pour se connecter sur les machines en SSH et FileZilla pour le SFTP. **FileZilla a été choisi car ni Transmit ni CyberDuck ne supporte la configuration d'une connection par ligne de commande**.