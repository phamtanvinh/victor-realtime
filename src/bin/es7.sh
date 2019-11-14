curl -X DELETE http://localhost:8083/connectors/sink-es7-customers
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d '
    {
        "name": "elasticsearch-sink",
        "config": {
            "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
            "tasks.max": "1",
            "topics": "test-elasticsearch-sink",
            "key.ignore": "true",
            "connection.url": "http://localhost:29200",
            "type.name": "kafka-connect",
            "name": "elasticsearch-sink"
        }
    }'


docker-compose exec schema-registry /usr/bin/kafka-avro-console-consumer \
    --bootstrap-server broker:9092 \
    --from-beginning \
    --property print.key=true \
    --property schema.registry.url=http://schema-registry:8081 \
    --topic test-elasticsearch-sink