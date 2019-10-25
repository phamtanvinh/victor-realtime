docker build ./src/postgres \
    -f ./src/postgres/postgres.dev.10-base.Dockerfile \
    -t postgres.dev.10