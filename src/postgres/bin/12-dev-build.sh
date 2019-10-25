docker build ./src/postgres \
    -f ./src/postgres/postgres.dev.12-preinstall.Dockerfile \
    -t postgres.dev.12-preinstall