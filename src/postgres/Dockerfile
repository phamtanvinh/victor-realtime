FROM postgres:11

USER root

ENV PLUGIN_VERSION=v1.0.0.Beta2
ENV WAL2JSON_COMMIT_ID=92b33c7d7c2fccbeb9f79455dafbc92e87e00ddd


RUN apt-get update
RUN apt-get install -f -y --no-install-recommends \
        software-properties-common \
        build-essential \
        pkg-config \
        git \
        postgresql-server-dev-11 \
        libproj-dev

RUN apt-get install -f -y --no-install-recommends \
        postgresql-11-postgis-2.5 \
        postgresql-11-postgis-2.5-scripts \
        postgis

RUN apt-get clean \
    && add-apt-repository "deb http://ftp.debian.org/debian testing main contrib" \
    && apt-get update && apt-get install -f -y --no-install-recommends \
        liblwgeom-dev \
        libprotobuf-c-dev=1.2.* \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/debezium/postgres-decoderbufs -b $PLUGIN_VERSION --single-branch \
    && (cd postgres-decoderbufs && make && make install )\
    && rm -rf postgres-decoderbufs

RUN git clone https://github.com/eulerto/wal2json -b master --single-branch \
    && (cd wal2json && git checkout $WAL2JSON_COMMIT_ID && make && make install) \
    && rm -rf wal2json

# COPY ./postgres.conf /usr/share/postgresql/postgresql.conf
# RUN chmod 755 /usr/share/postgresql/postgresql.conf

RUN mkdir /home/config && chmod 755 -R /home/config

COPY ./entrypoint.d /docker-entrypoint-initdb.d