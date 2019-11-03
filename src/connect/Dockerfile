FROM debezium/connect:0.10
ENV KAFKA_CONNECT_JDBC_DIR=$KAFKA_CONNECT_PLUGINS_DIR/kafka-connect-jdbc \
    KAFKA_CONNECT_ES_DIR=$KAFKA_CONNECT_PLUGINS_DIR/kafka-connect-elasticsearch \
    KAFKA_CONNECT_CASSANDRA_DIR=$KAFKA_CONNECT_PLUGINS_DIR/kafka-connect-cassandra

ARG POSTGRES_VERSION=42.2.8
ARG KAFKA_JDBC_VERSION=5.3.1

USER root 
RUN yum install -y wget

USER kafka

# Deploy PostgreSQL JDBC Driver
RUN cd /kafka/libs && curl -sO https://jdbc.postgresql.org/download/postgresql-$POSTGRES_VERSION.jar

# Deploy Kafka Connect JDBC
RUN mkdir $KAFKA_CONNECT_JDBC_DIR && cd $KAFKA_CONNECT_JDBC_DIR \
	&& curl -sO http://packages.confluent.io/maven/io/confluent/kafka-connect-jdbc/$KAFKA_JDBC_VERSION/kafka-connect-jdbc-$KAFKA_JDBC_VERSION.jar

# Deploy Confluent Elasticsearch sink connector
RUN mkdir $KAFKA_CONNECT_ES_DIR && cd $KAFKA_CONNECT_ES_DIR \
    && curl -sO http://packages.confluent.io/maven/io/confluent/kafka-connect-elasticsearch/5.0.0/kafka-connect-elasticsearch-5.0.0.jar \
    && curl -sO http://central.maven.org/maven2/io/searchbox/jest/2.0.0/jest-2.0.0.jar \
    && curl -sO http://central.maven.org/maven2/org/apache/httpcomponents/httpcore-nio/4.4.4/httpcore-nio-4.4.4.jar \
    && curl -sO http://central.maven.org/maven2/org/apache/httpcomponents/httpclient/4.5.1/httpclient-4.5.1.jar \
    && curl -sO http://central.maven.org/maven2/org/apache/httpcomponents/httpasyncclient/4.1.1/httpasyncclient-4.1.1.jar \
    && curl -sO http://central.maven.org/maven2/org/apache/httpcomponents/httpcore/4.4.4/httpcore-4.4.4.jar \
    && curl -sO http://central.maven.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar \
    && curl -sO http://central.maven.org/maven2/commons-codec/commons-codec/1.9/commons-codec-1.9.jar \
    && curl -sO http://central.maven.org/maven2/org/apache/httpcomponents/httpcore/4.4.4/httpcore-4.4.4.jar \
    && curl -sO http://central.maven.org/maven2/io/searchbox/jest-common/2.0.0/jest-common-2.0.0.jar \
    && curl -sO http://central.maven.org/maven2/com/google/code/gson/gson/2.4/gson-2.4.jar

# Deploy cassandra sink connector
RUN mkdir $KAFKA_CONNECT_CASSANDRA_DIR && cd $KAFKA_CONNECT_CASSANDRA_DIR \
    && wget https://github.com/lensesio/stream-reactor/releases/download/1.2.3/kafka-connect-cassandra-1.2.3-2.1.0-all.tar.gz \
    && tar xvf kafka-connect-cassandra-1.2.3-2.1.0-all.tar.gz \
    && rm -rf kafka-connect-cassandra-1.2.3-2.1.0-all.tar.gz