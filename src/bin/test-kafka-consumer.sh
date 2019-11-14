docker-compose exec broker kafka-console-consumer \
     --bootstrap-server broker:9092 \
     --from-beginning \
     --property print.key=true \
     --topic testtable

docker-compose exec broker kafka-console-consumer \
     --bootstrap-server broker:9092 \
     --from-beginning \
     --property print.key=true \
     --topic customers

docker-compose exec mysql bash -c  'mysql inventory -u $MYSQL_USER  -p$MYSQL_PASSWORD --execute "insert into customers values(default, \"John\", \"Doe\", \"john.doe@example.com\");"'
docker-compose exec mysql bash -c  'mysql inventory -u $MYSQL_USER  -p$MYSQL_PASSWORD --execute "insert into customers values(default, \"Vinh\", \"Pham\", \"vinhpt@example.com\");"'

docker-compose exec postgres bash -c 'psql -U $POSTGRES_USER $POSTGRES_DB -c "select * from customers"'

docker-compose exec mysql bash -c  'mysql demo -u $MYSQL_USER  -p$MYSQL_PASSWORD --execute "insert into orders values(4, \"2016-05-06 13:56:00\", \"FU-KOSPI-C-20150201-100\", 150, 100);"'
# insert into orders values ( 1, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);
# insert into orders values ( 2, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);
# insert into orders values ( 3, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);
# insert into orders values ( 4, "2016-05-06 13:53:00", "OP-DAX-P-20150201-95.7", 94.2, 100);
# insert into orders values ( 6, "2016-05-06 13:53:00", "OP-DAX-C-20150201-100", 99.5, 100);

docker-compose exec schema-registry /usr/bin/kafka-avro-console-consumer \
    --bootstrap-server broker:9092 \
    --from-beginning \
    --property print.key=true \
    --property schema.registry.url=http://schema-registry:8081 \
    --topic orders