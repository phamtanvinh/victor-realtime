##########################################################################################
#
#   Simple sink from mysql
#
##########################################################################################

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
            "database.server.id": "191031",
            "database.server.name": "mysqlserver",
            "database.whitelist": "demo",
            "database.history.kafka.bootstrap.servers": "broker:9092",
            "database.history.kafka.topic": "schema-changes.demo",
            "key.converter": "org.apache.kafka.connect.json.JsonConverter",
            "key.converter.schemas.enable": "false",
            "value.converter": "org.apache.kafka.connect.json.JsonConverter",
            "value.converter.schemas.enable": "false",
            "transforms": "unwrap,route",
            "transforms.unwrap.type": "io.debezium.transforms.UnwrapFromEnvelope",
            "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
            "transforms.route.regex": "([^.]+)\\.([^.]+)\\.([^.]+)",
            "transforms.route.replacement": "$3"
        }
    }'

curl -X DELETE http://localhost:8083/connectors/sink-cassandra-orders
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d '
     {
        "name": "sink-cassandra-orders",
        "config": {
            "connector.class":"com.datamountaineer.streamreactor.connect.cassandra.sink.CassandraSinkConnector",
            "tasks.max":"1",
            "topics": "mysqlserver.demo.orders",
            "key.converter": "org.apache.kafka.connect.json.JsonConverter",
            "key.converter.schemas.enable": "false",
            "value.converter": "org.apache.kafka.connect.json.JsonConverter",
            "value.converter.schemas.enable": "false",
            "connect.cassandra.contact.points":"cassandra",
            "connect.cassandra.port": "9042",
            "connect.cassandra.key.space": "demo",
            "connect.cassandra.username":"cassandra",
            "connect.cassandra.password":"cassandra",
            "connect.cassandra.kcql": "INSERT INTO orders SELECT * from orders"
        }   
    }'
    
# time to test realtime sync
# docker-compose exec mysql bash -c 'mysql demo -u$MYSQL_USER -p$MYSQL_PASSWORD'
# insert into orders values ( 3, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);
# insert into orders values ( 4, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);
# insert into orders values ( 5, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);
# insert into orders values ( 6, "2016-05-06 13:53:00", "OP-DAX-C-20150201-100", 99.5, 100);
# insert into orders values ( 7, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);
# insert into orders values ( 8, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);
# insert into orders values ( 9, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);
# insert into orders values ( 10, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);
# insert into orders values ( 11, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);

docker-compose exec mysql mysql demo -umysqluser -pmysqlpw --execute 'insert into orders values ( 3, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);' 
docker-compose exec mysql mysql demo -umysqluser -pmysqlpw --execute 'insert into orders values ( 4, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);'
docker-compose exec mysql mysql demo -umysqluser -pmysqlpw --execute 'insert into orders values ( 5, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);'
docker-compose exec mysql mysql demo -umysqluser -pmysqlpw --execute 'insert into orders values ( 6, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);'
docker-compose exec mysql mysql demo -umysqluser -pmysqlpw --execute 'insert into orders values ( 7, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);'
docker-compose exec mysql mysql demo -umysqluser -pmysqlpw --execute 'insert into orders values ( 8, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);'
docker-compose exec mysql mysql demo -umysqluser -pmysqlpw --execute 'insert into orders values ( 9, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);'
docker-compose exec mysql mysql demo -umysqluser -pmysqlpw --execute 'insert into orders values ( 10, "2019-11-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);'
docker-compose exec mysql mysql demo -umysqluser -pmysqlpw --execute 'insert into orders values ( 12, "2019-11-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);'


##########################################################################################
#
#   mysql to cassandra using avro
#
##########################################################################################

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
            "database.server.id": "191031",
            "database.server.name": "mysqlserver",
            "database.whitelist": "demo",
            "database.history.kafka.bootstrap.servers": "broker:9092",
            "database.history.kafka.topic": "schema-changes.demo",
            "key.converter": "io.confluent.connect.avro.AvroConverter",
            "key.converter.schemas.enable": "true",
            "value.converter": "io.confluent.connect.avro.AvroConverter",
            "value.converter.schemas.enable": "true",
            "key.converter.schema.registry.url":"http://schema-registry:8081",
            "value.converter.schema.registry.url":"http://schema-registry:8081",
            "transforms": "unwrap,route",
            "transforms.unwrap.type": "io.debezium.transforms.UnwrapFromEnvelope",
            "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
            "transforms.route.regex": "([^.]+)\\.([^.]+)\\.([^.]+)",
            "transforms.route.replacement": "$3"
        }
    }'

curl -X DELETE http://localhost:8083/connectors/sink-cassandra-orders
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d '
     {
        "name": "sink-cassandra-orders",
        "config": {
            "connector.class":"com.datamountaineer.streamreactor.connect.cassandra.sink.CassandraSinkConnector",
            "tasks.max":"1",
            "topics": "mysqlserver.demo.orders",
            "key.converter": "io.confluent.connect.avro.AvroConverter",
            "key.converter.schema.registry.url":"http://schema-registry:8081",
            "value.converter": "io.confluent.connect.avro.AvroConverter",
            "value.converter.schema.registry.url":"http://schema-registry:8081",
            "connect.cassandra.contact.points":"cassandra",
            "connect.cassandra.port": "9042",
            "connect.cassandra.key.space": "demo",
            "connect.cassandra.username":"cassandra",
            "connect.cassandra.password":"cassandra",
            "connect.cassandra.kcql": "INSERT INTO orders SELECT * from orders"
        }   
    }'
    
##########################################################################################
#
#   Simple sink with avro
#
##########################################################################################

# producer
docker-compose exec schema-registry kafka-avro-console-producer \
     --broker-list broker:9092 \
     --topic orders-topic \
     --property value.schema='
          {
               "type":"record",
               "name":"myrecord",
               "fields":[
                    {"name":"id","type":"int"},
                    {"name":"created","type":"string"},
                    {"name":"product","type":"string"},
                    {"name":"price","type":"double"},
                    {"name":"qty", "type":"int"}
               ]
          }'


{"id": 1, "created": "2016-05-06 13:53:00", "product": "OP-DAX-P-20150201-95.7", "price": 94.2, "qty":100}
{"id": 2, "created": "2016-05-06 13:54:00", "product": "OP-DAX-C-20150201-100", "price": 99.5, "qty":100}
{"id": 3, "created": "2016-05-06 13:55:00", "product": "FU-DATAMOUNTAINEER-20150201-100", "price": 10000, "qty":100}
{"id": 4, "created": "2016-05-06 13:56:00", "product": "FU-KOSPI-C-20150201-100", "price": 150, "qty":100}


# cassandra sink
curl -X DELETE http://localhost:8083/connectors/orders-topic
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d '
     {
        "name": "orders-topic",
        "config": {
            "connector.class":"com.datamountaineer.streamreactor.connect.cassandra.sink.CassandraSinkConnector",
            "tasks.max":"1",
            "topics":"orders-topic",
            "key.converter": "io.confluent.connect.avro.AvroConverter",
            "key.converter.schema.registry.url":"http://schema-registry:8081",
            "value.converter": "io.confluent.connect.avro.AvroConverter",
            "value.converter.schema.registry.url":"http://schema-registry:8081",
            "connect.cassandra.contact.points":"cassandra",
            "connect.cassandra.port": "9042",
            "connect.cassandra.key.space": "demo",
            "connect.cassandra.username":"cassandra",
            "connect.cassandra.password":"cassandra",
            "connect.cassandra.kcql": "INSERT INTO demo_orders SELECT * from orders-topic"
        }   
    }'

##########################################################################################
#
#   Test consumer
#
##########################################################################################

docker-compose exec broker kafka-console-consumer \
    --bootstrap-server broker:9092 \
    --from-beginning \
    --property print.key=true \
    --topic orders


# avro consumer
docker-compose exec schema-registry /usr/bin/kafka-avro-console-consumer \
    --bootstrap-server broker:9092 \
    --from-beginning \
    --property print.key=true \
    --property schema.registry.url=http://schema-registry:8081 \
    --topic orders
