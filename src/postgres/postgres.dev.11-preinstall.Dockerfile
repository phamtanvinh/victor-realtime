FROM postgres.dev.10

ENV PROJ_VERSION=5.2.0 POSTGIS_VERSION=3.0.0


RUN curl -fSL "http://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz" -o proj-${PROJ_VERSION}.tar.gz \
    && mkdir proj \
    && tar -xf proj-${PROJ_VERSION}.tar.gz -C proj --strip-components=1 \
    && (cd proj && ./configure && make && make install)

RUN curl -fSL "https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz" -o postgis-${POSTGIS_VERSION}.tar.gz \
    && mkdir postgis \
    && tar -xf postgis-${POSTGIS_VERSION}.tar.gz -C postgis --strip-components=1