docker-compose exec schema-registry kafka-avro-console-producer \
     --broker-list broker:9092 \
     --topic demo-orders \
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

docker-compose exec schema-registry /usr/bin/kafka-avro-console-consumer \
    --bootstrap-server broker:9092 \
    --from-beginning \
    --property print.key=true \
    --property schema.registry.url=http://schema-registry:8081 \
    --topic demo-orders