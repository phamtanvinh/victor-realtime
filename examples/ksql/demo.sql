SET 'auto.offset.reset'='earliest';

drop stream orders;

create stream orders (
    id bigint,
    created varchar,
    product varchar,
    price double,
    qty int
) with (
    kafka_topic = 'orders',
    value_format = 'JSON'
);