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

docker-compose exec mysql bash -c  'mysql -u $MYSQL_USER  -p$MYSQL_PASSWORD inventory --execute "insert into customers values(default, \"John\", \"Doe\", \"john.doe@example.com\");"'
docker-compose exec mysql bash -c  'mysql -u $MYSQL_USER  -p$MYSQL_PASSWORD inventory --execute "insert into customers values(default, \"Vinh\", \"Pham\", \"vinhpt@example.com\");"'

docker-compose exec postgres bash -c 'psql -U $POSTGRES_USER $POSTGRES_DB -c "select * from customers"'