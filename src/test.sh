curl -X DELETE http://localhost:8083/connectors/source-pg
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d @source-pg.json

curl -X DELETE http://localhost:8083/connectors/sink-es-test-table
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d @sink-es.test_table.json
