docker-compose exec schema-registry kafka-avro-console-producer \
     --broker-list broker:9092 \
     --topic orders \
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