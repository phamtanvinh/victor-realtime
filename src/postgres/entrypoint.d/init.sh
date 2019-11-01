#!/bin/bash
set -e

rm -rf "$PGDATA/pg_hba.conf"
mv /home/postgres/pg_hba.conf "$PGDATA/pg_hba.conf"
{ echo "host replication $POSTGRES_USER 0.0.0.0/0 trust"; } >> "$PGDATA/pg_hba.conf"