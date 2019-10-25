FROM postgres:11-alpine

RUN apk add --no-cache protobuf-c-dev

RUN apk add --no-cache --virtual .debezium-build-deps autoconf automake curl file gcc g++ git libtool make musl-dev pkgconf tar \
    && apk add --no-cache json-c libxml2-dev \
    && apk add --no-cache \
        --repository 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' \
        --repository 'http://dl-cdn.alpinelinux.org/alpine/edge/main' \
        gdal-dev geos-dev