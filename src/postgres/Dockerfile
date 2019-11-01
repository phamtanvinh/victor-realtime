FROM postgres:11 as build


ENV PLUGIN_VERSION=v1.0.0.Beta2
ENV PROTOC_VERSION=1.3.*
ENV WAL2JSON_COMMIT_ID=92b33c7d7c2fccbeb9f79455dafbc92e87e00ddd


RUN apt-get update \
    && apt-get install -f -y --no-install-recommends \
        software-properties-common \
        build-essential \
        pkg-config \
        git \
        postgresql-server-dev-$PG_MAJOR \
        libproj-dev \
    && apt-get clean \
    && add-apt-repository "deb http://ftp.debian.org/debian testing main contrib" \
    && apt-get update && apt-get install -f -y --no-install-recommends \
        liblwgeom-dev \
        libprotobuf-c-dev=$PROTOC_VERSION \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/debezium/postgres-decoderbufs -b $PLUGIN_VERSION --single-branch \
    && (cd postgres-decoderbufs && make && make install ) \
    && rm -rf postgres-decoderbufs

RUN git clone https://github.com/eulerto/wal2json -b master --single-branch \
    && (cd wal2json && git checkout $WAL2JSON_COMMIT_ID && make && make install) \
    && rm -rf wal2json

FROM postgres:11

ENV POSTGIS_VERSION=2.5

RUN apt-get update \
    && apt-get install -f -y --no-install-recommends \
        software-properties-common \
    && apt-get install -f -y --no-install-recommends \
        postgresql-$PG_MAJOR-postgis-$POSTGIS_VERSION \
        postgresql-$PG_MAJOR-postgis-$POSTGIS_VERSION-scripts \
        postgis \
    && add-apt-repository "deb http://ftp.debian.org/debian testing main contrib" \
    && apt-get update && apt-get install -f -y --no-install-recommends \
        libprotobuf-c1 \
    && rm -rf /var/lib/apt/lists/*


COPY --from=build /usr/lib/postgresql/$PG_MAJOR/lib/decoderbufs.so /usr/lib/postgresql/$PG_MAJOR/lib/wal2json.so /usr/lib/postgresql/$PG_MAJOR/lib/
COPY --from=build /usr/share/postgresql/$PG_MAJOR/extension/decoderbufs.control /usr/share/postgresql/$PG_MAJOR/extension/

COPY ./postgres.conf /usr/share/postgresql/postgresql.conf
COPY ./pg_hba.conf /home/postgres/pg_hba.conf
COPY ./entrypoint.d /docker-entrypoint-initdb.d

# RUN chown -R postgres:postgres /usr/share/postgresql
# RUN chown -R postgres:postgres /home/postgres
# RUN chown -R postgres:postgres /docker-entrypoint-initdb.d