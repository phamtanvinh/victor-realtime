# source configs
curl -X DELETE http://localhost:8083/connectors/source-pg-test
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d '
    {
        "name": "source-pg-test",
        "config": {
            "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
            "tasks.max": "1",
            "database.hostname": "postgres",
            "database.port": "5432",
            "database.user": "postgresuser",
            "database.password": "postgrespw",
            "database.dbname" : "inventory",
            "database.server.name": "pgserver",
            "schema.whitelist": "test",
            "database.history.kafka.bootstrap.servers": "broker:9092",
            "database.history.kafka.topic": "schema-changes.test",
            "transforms": "route",
            "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
            "transforms.route.regex": "([^.]+)\\.([^.]+)\\.([^.]+)",
            "transforms.route.replacement": "$3"
        }
    }'



curl -X DELETE http://localhost:8083/connectors/source-mysql-inventory
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d '{
        "name": "source-mysql-inventory",
        "config": {
            "connector.class": "io.debezium.connector.mysql.MySqlConnector",
            "tasks.max": "1",
            "database.hostname": "mysql",
            "database.port": "3306",
            "database.user": "debezium",
            "database.password": "dbz",
            "database.server.id": "191031",
            "database.allowPublicKeyRetrieval": "true",
            "database.server.name": "mysqlserver",
            "database.whitelist": "inventory",
            "database.history.kafka.bootstrap.servers": "broker:9092",
            "database.history.kafka.topic": "schema-changes.inventory",
            "transforms": "route",
            "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
            "transforms.route.regex": "([^.]+)\\.([^.]+)\\.([^.]+)",
            "transforms.route.replacement": "$3"
        }
    }'


# sink configs

curl -X DELETE http://localhost:8083/connectors/sink-es-testtable
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d '
     {
        "name": "sink-es-testtable",
        "config": {
            "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
            "tasks.max": "1",
            "topics": "testtable",
            "type.name": "testtable",
            "connection.url": "http://es:9200",
            "transforms": "unwrap,key",
            "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
            "transforms.unwrap.drop.tombstones": "false",
            "transforms.key.type": "org.apache.kafka.connect.transforms.ExtractField$Key",
            "transforms.key.field": "test_id",
            "key.ignore": "false",
            "behavior.on.null.values": "delete"
        }
    }'



curl -X DELETE http://localhost:8083/connectors/sink-es-customers
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d '
    {
        "name": "sink-es-customers",
        "config": {
            "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
            "tasks.max": "1",
            "topics": "customers",
            "connection.url": "http://es:9200",
            "transforms": "unwrap,key",
            "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
            "transforms.unwrap.drop.tombstones": "false",
            "transforms.key.type": "org.apache.kafka.connect.transforms.ExtractField$Key",
            "transforms.key.field": "id",
            "key.ignore": "false",
            "type.name": "customer",
            "behavior.on.null.values": "delete"
        }
    }'



curl -X DELETE http://localhost:8083/connectors/sink-pg-customers
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d '
     {
        "name": "sink-pg-customers",
        "config": {
            "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
            "tasks.max": "1",
            "topics": "customers",
            "connection.url": "jdbc:postgresql://postgres:5432/inventory?user=postgresuser&password=postgrespw",
            "transforms": "unwrap",
            "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
            "transforms.unwrap.drop.tombstones": "false",
            "auto.create": "true",
            "insert.mode": "upsert",
            "delete.enabled": "true",
            "pk.fields": "id",
            "pk.mode": "record_key"
        }
    }'