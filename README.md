<img src="img/docker.png" width="200px"></img>

# Docker-compose workflow for `osmenrich`

We provide a docker-compose workflow to install and run local instances of the Overpass API, used to serve data from openstreetmap, and OSRM, used to compute routing distances and durations.

This repository is maintained by the [ODISSEI Social Data Science (SoDa)](https://odissei-data.nl/nl/soda/) team.

<img src="img/word_colour-l.png" width="250px"></img>

<!-- INSTALLATION -->
## Installation

We provide one supported way to install the Overpass API and OSRM servers used in `osmenrich`, which makes use of `docker-compose`.

We run instances of the Overpass API and of OSRM via `Docker`.

- The Overpass API uses the docker image from [wiktorn](https://github.com/wiktorn/Overpass-API).
- The OSRM instances use the official docker image of the OSRM project: [https://hub.docker.com/r/osrm/osrm-backend/](https://hub.docker.com/r/osrm/osrm-backend/).

**Note**: Docker needs to have **at least** 4GB of RAM and 2GB of Swap memory _available_ at the time of installation to complete the installation of the overpass API instance. In case your machine does not have enough memory, we suggest you to close the instance(s) of OSRM created using docker-compose to free up memory before trying again.

### Installation via Docker

We assume that `docker` is installed and running on your machine. If that is not the case, please head to the [Docker website](https://www.docker.com/products/docker-desktop) to download Docker Desktop.

Before setting up the server instances using the default settings set by the SoDa science team you need to the setup that most resembles the objective of your project. The table below offers an overview of the choices that we currently provide.


| Version     | Overpass server/ <br />OSM server | OSRM server for<br />distances/durations | Name to use |
| :---------- | :-------------------------------: | :--------------------------------------: | :---------: |
| Base        |                Yes                |                    No                    |   `base`    |
| Normal car  |                Yes                |               Only by car                |    `car`    |
| Normal foot |                Yes                |               Only by foot               |   `foot`    |
| Normal bike |                Yes                |               Only by bike               |   `bike`    |
| Advanced    |                Yes                |            Car, foot and bike            | `advanced`  |


#### On MacOS or Linux

Once you chose which setup is the most fitting with what required by your project, you need to carry out two steps:

**1.** Go to the docker folder for the use case you want to setup and modify what comes after the `=` for the following variables in the `.env` file:
   - To select a specific region to use with the OpenStreetMap server, go to <https://download.geofabrik.de/> and find the region of interest. Once found, add the name of the country and of the region (or subregion) after the `=` in the following two variable in the `.env` file:
     - `COUNTRY_MAP=` _add name of the country_
     - `REGION=` _add name of the region or subregion_
   - Within the same webpage, find the link to the _map file_ that ends with `.osm.bz2` (usually under the section `Other Formats and Auxiliary Files`) for the country or region you previoulsy selected and copy this link after the `=` in the following variable in the `.env` file:
     - `OVERPASS_PLANET_URL=` _add the link to the `.osm.bz2` file (usually under the section `Other Formats and Auxiliary Files`)_
   - To select the replication server, go to <http://download.openstreetmap.fr/replication/> and find the same country or region you selected above. When found, navigate to the `minute` folder and copy the URL after the `=` of the following variable:
     - `OVERPASS_DIFF_URL=` _add the URL of the replication server (needs to end with `/minute/`)_
     
**2.** Then, just use the following commands to download the map and start the containers:

```bash
  # You need to be in the **root** folder of the repository
  cd docker
  bash ./build.sh <name-of-the-chose-docker-setup>
```

#### On Windows

**1.** Follow **step 1** of the _MacOS or Linux guide_ with the only difference that you also need to download the `<your-location>-latest.osm.pbf` data for your location of interest to `docker/osrm/data` from <https://download.geofabrik.de/>

**2.** `cd` to the folder of your preferred choice of setup, for example `cd docker base`

**3.** Then, with Docker Desktop open, start docker compose with `docker-compose up`

The complete install procedure will take at least one hour. If you run into any problem, please look at the [troubleshooting section](#troubleshooting) below or open an [issue](#issue).

### Manual Installation

However, we also provided a small guide to manually setup the instances, available [here](MANUAL.md). This guide is not actively supported by the SoDa science team and we recommend to use it only if you know what you are doing and want to have precise control the installation settings for each instance.


<!-- TROUBLESHOOTING -->
## Troubleshooting

- If Docker complains about not being able to connect to its daemon, make sure you are in the `docker` group:
  
  ```cmd
  sudo usermod -aG docker $USER
  ```

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community an amazing place to
learn, inspire, and create. Any contributions you make are **greatly
appreciated**.

In this project we use the
[Gitflow workflow](https://nvie.com/posts/a-successful-git-branching-model/)
to help us with continious development. Instead of having a single
`master`/`main` branch we use two branches to record the history of the
project: `develop` and `master`. The `master` branch is used only for the
official releases of the project, while the `develop` branch is used to
integrate the new features developed. Finally, `feature` branches are used to
develop new features or additions to the project that will be `rebased and
squash` in the `develop` branch.

The workflow to contribute with Gitflow becomes:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/<AmazingFeature>`)
3. Commit your Changes (`git commit -m 'Add some <AmazingFeature>'`)
4. Push to the Branch (`git push origin feature/<AmazingFeature>`)
5. Open a Pull Request

## License

The `osmenrich_docker` repository is published under the MIT license.
