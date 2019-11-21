# REALTIME RESEARCH WITH KAFKA

This is a sample to setup kafka for streaming data between databases such as RDBMS and NoSQL. I use **Confluent Kafka** with connectors of third parties, such as **debezium** and **lenses**.

#### Technical

- Docker for deployment
- Databases: RDBMS (MySQL, Postgres), Elasticsearch, Cassandra
- Connectors, Kafka Connect and Apache Avro

#### Debezium Architecture

![](./assets/debezium-architecture.png)

#### How to setup

- Bring up all containers: `cd victor-realtime/src && docker-compose up -d`
- Initialize database for Cassandra:
  + Access cassandra container: `docker-compose exec cassandra cqlsh`
  + Pass code below to prompt window:
```sql
CREATE KEYSPACE demo WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor' : 3};
use demo;

CREATE TABLE orders (id int, created varchar, product varchar, qty int, price float, PRIMARY KEY (id, created))
WITH CLUSTERING ORDER BY (created ASC);

CREATE TABLE demo_orders (id int, created varchar, product varchar, qty int, price float, PRIMARY KEY (id, created))
WITH CLUSTERING ORDER BY (created ASC);
```

##### Setup source connectors
- Mysql Source with **Avro Converter**, publishes database ***demo***
```shell
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
```

- Postgres Source publishes schema ***test***
```sh
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d '
     {
        "name": "sink-cassandra-orders",
        "config": {
            "connector.class":"com.datamountaineer.streamreactor.connect.cassandra.sink.CassandraSinkConnector",
            "tasks.max":"1",
            "topics": "orders",
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
```

##### Setup Sink Connectors
- ES subscribes **customers** topic from demo schema of mysql source
```sh
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
            "connection.url": "http://es6:9200",
            "transforms": "unwrap,key",
            "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
            "transforms.unwrap.drop.tombstones": "false",
            "transforms.key.type": "org.apache.kafka.connect.transforms.ExtractField$Key",
            "transforms.key.field": "test_id",
            "key.ignore": "false",
            "behavior.on.null.values": "delete"
        }
    }'
```
- Cassandra subscribes **orders** topic from database demo
```sh
curl -i -X POST http://localhost:8083/connectors/ \
     -H "Accept:application/json" \
     -H  "Content-Type:application/json" \
     -d '
     {
        "name": "sink-cassandra-orders",
        "config": {
            "connector.class":"com.datamountaineer.streamreactor.connect.cassandra.sink.CassandraSinkConnector",
            "tasks.max":"1",
            "topics":"orders",
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
```

#### Time to test

- Test consumer

```sh
docker-compose exec broker kafka-console-consumer \
    --bootstrap-server broker:9092 \
    --from-beginning \
    --property print.key=true \
    --topic orders
```

```sh
docker-compose exec schema-registry /usr/bin/kafka-avro-console-consumer \
    --bootstrap-server broker:9092 \
    --from-beginning \
    --property print.key=true \
    --property schema.registry.url=http://schema-registry:8081 \
    --topic orders
```

- Test elasticsearch
```sh
curl localhost:9200/testtable/_search
```

- Test cassandra
```sh
docker-compose exec cassandra csqlsh
> use demo;
> select * from orders;
```

- Update mysql source
```sh
docker-compose exec mysql mysql demo -umysqluser -pmysqlpw --execute 'insert into orders values ( 3, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);' 
docker-compose exec mysql mysql demo -umysqluser -pmysqlpw --execute 'update orders set qty=99 where id = 2;'
```