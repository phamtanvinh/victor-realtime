FROM postgres.dev.11

ENV PROJ_VERSION=5.2.0 POSTGIS_VERSION=3.0.0

RUN apk add \
        --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        gdal \
        json-c-dev \
        protobuf-c-dev \
    && cd /home/postgis \
    && ./autogen.sh \
    && ./configure \
    && make && make install