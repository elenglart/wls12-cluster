#!/bin/bash

docker container prune --force
docker volume prune --force
docker-compose up --build --scale wls-managed=2