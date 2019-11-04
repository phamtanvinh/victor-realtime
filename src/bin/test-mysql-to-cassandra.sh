curl -X DELETE  http://localhost:8083/connectors/source-mysql-unwrap
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H "Content-Type:application/json" \
     -d '
    {
        "name": "source-mysql-unwrap",
        "config": {
            "connector.class": "io.debezium.connector.mysql.MySqlConnector",
            "tasks.max": "1",
            "database.hostname": "mysql",
            "database.port": "3306",
            "database.user": "debezium",
            "database.password": "dbz",
            "database.server.id": "184055",
            "database.server.name": "mysqlserver",
            "database.whitelist": "inventory",
            "database.history.kafka.bootstrap.servers": "broker:9092",
            "database.history.kafka.topic": "schema-changes.inventory",
            "transforms": "unwrap",
            "transforms.unwrap.type": "io.debezium.transforms.UnwrapFromEnvelope",
            "key.converter": "org.apache.kafka.connect.json.JsonConverter",
            "key.converter.schemas.enable": "false",
            "value.converter": "org.apache.kafka.connect.json.JsonConverter",
            "value.converter.schemas.enable": "false"
        }
    }'

docker-compose exec broker kafka-console-consumer \
    --bootstrap-server broker:9092 \
    --from-beginning \
    --property print.key=true \
    --topic mysqlserver.inventory.customers