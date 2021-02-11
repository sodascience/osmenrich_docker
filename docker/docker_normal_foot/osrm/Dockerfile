FROM osrm/osrm-backend:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget && \
    rm -rf /var/lib/apt/lists/*

# Retrieve args from docker-compose
ARG NAME
ARG COUNTRY_MAP
ARG REGION
ARG PROFILE

# Copy data
RUN echo "Copying osm data to container $NAME"
RUN mkdir -p /data
COPY ./entrypoint.sh /data
RUN chmod +x /data/entrypoint.sh
COPY /data/$COUNTRY_MAP.osm.pbf /data

# Extract
RUN echo 'Running the extraction on container $NAME'
RUN /usr/local/bin/osrm-extract -p /opt/$PROFILE.lua /data/$COUNTRY_MAP.osm.pbf
RUN rm /data/$COUNTRY_MAP.osm.pbf

# Partition
RUN echo 'Running the partition on container $NAME'
RUN /usr/local/bin/osrm-partition /data/$COUNTRY_MAP.osrm

# Customization
RUN echo 'Running the customization on container $NAME'
RUN /usr/local/bin/osrm-customize /data/$COUNTRY_MAP.osrm

ENTRYPOINT ["/data/entrypoint.sh"]
