pg_recvlogical -d test --slot test_slot --create-slot -P wal2json
pg_recvlogical -d test --slot test_slot --start -o pretty-print=1 -f - # subscribe