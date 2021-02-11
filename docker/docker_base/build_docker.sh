#!/usr/bin/env bash
# Script for the setup of the docker infrastructure of OSRM

# Download country map
COUNTRY_MAP=$(grep COUNTRY_MAP .env | xargs)
COUNTRY_MAP=${COUNTRY_MAP#*=}
REGION=$(grep REGION .env | xargs)
REGION=${REGION#*=}
if test -f "osrm/data/${COUNTRY_MAP}.osm.pbf"; then
    echo "Map ${REGION}/${COUNTRY_MAP} already exists. Skipping download."
    sleep 2
    # Create services
    docker-compose up
else
    echo "Download latest map from ${REGION}/${COUNTRY_MAP}"
    wget -O osrm/data/${COUNTRY_MAP}.osm.pbf https://download.geofabrik.de/${REGION}/${COUNTRY_MAP}.osm.pbf
    sleep 2
    # Create services
    docker-compose up
fi