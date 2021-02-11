# Manual installation of local APIs via `Docker`

This option is aimed at people who prefer to manually setup the Overpass API and the OSRM instance(s) and who know what they are doing.

## Manually setting up an Overpass API instance via `Docker`

We run a custom instance of the Overpass API via `Docker`. This instance uses the docker image from [wiktorn](https://github.com/wiktorn/Overpass-API).

### To install

1. Open`Docker`
2. Before pasting the script below to the terminal, modify the path in which the data will be downloaded. From `/path/to/overpass/` to your folder of choice (e.g. `/User/name/docker/overpass/`).

   ```bash
    docker run \
        -e OVERPASS_META=yes \
        -e OVERPASS_MODE=init \
        -e OVERPASS_PLANET_URL=http://download.geofabrik.de/europe/netherlands-latest.osm.bz2 \
        -e OVERPASS_DIFF_URL=http://download.openstreetmap.fr/replication/europe/netherlands/minute/ \
        -e OVERPASS_RULES_LOAD=10 \
        -v /path/to/overpass:/db \
        -p 8888:80 \
        -i -t \
        --name overpass_netherlands \
        wiktorn/overpass-api
    ```

3. Paste the script above to the terminal and wait for `Docker` and Overpass to complete the installation

### Notes

- Depending on your internet connection and on your computer, this step might take a while (1-2 hours).
- When the Docker image is has completed the installation, restart it to start serving the overpass API on port `8888`.
- **Remember**: Docker needs to have **at least** 4GB of RAM and 2GB of Swap memory available to complete the installation of the overpass API instance.

If you run into any problem, the [troubleshooting section](#troubleshooting) might help you.

<!-- TODO: Specify folders and naming better --->

## Manually setting up an OSRM instance via `Docker`

To query the distances between the features of interest retrieved using the OSM API (via `overpass API`) and a dataset, we use a local instance of the OSRM API provided by [project OSRM](http://project-osrm.org/) (documentation available [here](http://project-osrm.org/docs/v5.23.0/api/#)). Although the API has a default server, this server is (a) limited to providing only *driving durations* recommend  and (b) limited in its bandwith. Thus, please use it for testing purposes only.

Restating this point simply, if you are planning to use this library for research or production, **awalys set up your own osrm instance** (locally or on a VM) using the instruction below.

### To install

In this setup we use the open-source routing machine (OSRM). In particular we use project OSRM's official Docker image. Source:
[https://hub.docker.com/r/osrm/osrm-backend/](https://hub.docker.com/r/osrm/osrm-backend/).

1. Download the `<your-location>-latest.osm.pbf` data for your location of interest [here](http://download.geofabrik.de/europe.html) (in this example we are using `netherlands-latest.osm.pbf`, remember to change the name throughout the examples) and put it in a folder (e.g., `/path/to/osrm/netherlands-latest.osm.pbf`) on your computer.
2. Preprocess the data for walking distances using the osrm docker backend image.

   1. If you are not already inside the folder `/path/to/osrm/netherlands-latest.osm.pbf`, navigate to that folder in your terminal

   2. ```cmd
      docker run -t --rm -v "${PWD}:/data" osrm/osrm-backend osrm-extract -p /opt/foot.lua /data/netherlands-latest.osm.pbf
      ```

      Change `foot.lua` to `car.lua` or `bicycle.lua` for driving or cycling distances.

   3. ```cmd
      docker run -t --rm -v "${PWD}:/data" osrm/osrm-backend osrm-partition /data/netherlands-latest.osrm
      ```

   4. ```cmd
      docker run -t --rm -v "${PWD}:/data" osrm/osrm-backend osrm-customize /data/netherlands-latest.osrm
      ```

3. Start up the server and have it listen to port 5000:

   ```cmd
   docker run -d -t -i -p 5000:5000 --name osrm_netherlands_foot -v "${PWD}:/data" osrm/osrm-backend osrm-routed --port 5000 --algorithm mld --max-table-size 100000 /data/netherlands-latest.osrm
   ```

  Where `-t` `-i` publishes the container in interactive mode, `-d` tells the container to run in the background, `-p` publishes the container port to the defined one.

4. _Optional_: redo steps `1` to `3` changing the osrm transportation [profile](https://github.com/Project-OSRM/osrm-backend/blob/master/docs/profiles.md) and the port (`-p 500X:500X` and `--port 500X`) to run multiple instances of osrm on different transportation methods (foot, driving and cycling)

5. _Optional_: start a user-friendly frontend on port 9966, where you can try out routing:

   ```cmd
   docker run -d -p 9966:9966 --name osrm_frontend_foot osrm/osrm-frontend
   ```

   You can visit the frontend by entering [http://127.0.0.1:9966](http://127.0.0.1:9966) in your browser.

## Troubleshooting

- If the installation of the overpass API instance using docker results in the following (or similar) error message:

   ```cmd
   $PLANET_FILE
   17 Killed | $EXEC_DIR/bin/update_database --db-dir=$DB_DIR/ $META $COMPRESSION
   Failed to process planet file
   ```

   To solve it you need to increase the RAM and the Swap memory available to Docker (`Docker -> Preferences -> Resources`).
