docker build ./src/postgres \
    -f ./src/postgres/postgres.dev.11-preinstall.Dockerfile \
    -t postgres.dev.11