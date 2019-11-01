docker-compose exec broker kafka-console-consumer \
     --bootstrap-server broker:9092 \
     --from-beginning \
     --property print.key=true \
     --topic dbserver1.test.test_table