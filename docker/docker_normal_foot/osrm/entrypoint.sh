#!/usr/bin/env bash

# Defaults
OSRM_MAP_NAME=${COUNTRY_MAP:="netherlands-latest"}
OSRM_DATA_PATH=${OSRM_DATA_PATH:="/data"}
OSRM_ALGO=${OSRM_ALGO:="--algorithm mld"}
OSRM_API_PARAMS=${OSRM_API_PARAMS:="--max-table-size 100000 --max-viaroute-size 15000 --max-trip-size=10000"}

# Small routine
_sig() {
  kill -TERM $child 2>/dev/null
}

trap _sig SIGKILL SIGTERM SIGHUP SIGINT EXIT

if [ ! -f $OSRM_DATA_PATH/$OSRM_MAP_NAME.osrm ]; then
  echo "$OSRM_MAP_NAME.osrm not present! Please re-run docker-compose up."
fi

# Generalized call to osrm-routed
echo "Starting routing engine HTTP server"
osrm-routed $OSRM_ALGO $OSRM_DATA_PATH/$OSRM_MAP_NAME.osrm $OSRM_API_PARAMS &
child=$!
wait "$child"