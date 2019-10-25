FROM postgres:11-alpine

ENV PROJ_VERSION=5.2.0 POSTGIS_VERSION=2.5.2


RUN apk add --no-cache --virtual .debezium-build-deps \
        autoconf automake curl file gcc g++ git libtool make musl-dev pkgconf tar geos-dev protobuf-c-dev \
    && apk add --no-cache json-c libxml2 \
    && apk add --no-cache \
        --repository 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' \
        --repository 'http://dl-cdn.alpinelinux.org/alpine/edge/main' \
        gdal

RUN curl -fSL "http://download.osgeo.org/proj/proj-$PROJ_VERSION.tar.gz" -o proj-$PROJ_VERSION.tar.gz \
    && mkdir proj \
    && tar -xf proj-$PROJ_VERSION.tar.gz -C proj --strip-components=1 \
    && (cd /proj && ./configure && make && make install)

RUN  curl -fSL "https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz" -o postgis-${POSTGIS_VERSION}.tar.gz \
    && mkdir postgis \
    && tar -xf postgis-${POSTGIS_VERSION}.tar.gz -C postgis --strip-components=1 \
    && (cd postgis && ./configure && make && make install)