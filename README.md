# Image docker de base pour déploiement d'un cluster weblogic 12.2.1.4

Ce projet permet la construction d'une image docker servant de socle au déploiement d'un cluster weblogic 12c.

## Build
A la racine du projet
```./build.sh
```
## Variable d'environnement surchargeable
DOMAIN_NAME
ADMIN_NAME
ADMIN_LISTEN_PORT
MANAGED_SERVER_PORT
MANAGED_SERVER_NAME_BASE
CONFIGURED_MANAGED_SERVER_COUNT
CLUSTER_NAME
PRODUCTION_MODE
USERNAME
PASSWORD
DOMAIN_HOME

## Démarrage des managed
Surcharge de CMD pour pointer sur le script de démarrage de la managed : /bin/bash /var/opt/oracle/scripts/startManagedServer.sh

## Exemple d'utilisation
Le docker-compose.yml à la racine permet de voir comment utiliser l'image.
Le script start.sh peut être utilisé pour démarrer un cluster avec 2 managed.
