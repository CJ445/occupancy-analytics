FROM eclipse-temurin:17-jre

ARG KAFKA_VERSION=3.5.0
ARG SCALA_VERSION=2.13

WORKDIR /opt/kafka

RUN apt update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

RUN wget https://archive.apache.org/dist/kafka/3.5.0/kafka_2.13-3.5.0.tgz

RUN tar -xvf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz --strip-components=1 && \
    rm kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz



EXPOSE 9092 2181

CMD ["sh", "-c", "\
    bin/zookeeper-server-start.sh config/zookeeper.properties > /dev/null 2>&1 & \
    ZK_PID=$! && \
    sleep 10 && \
    bin/kafka-server-start.sh config/server.properties > /dev/null 2>&1 & \
    KAFKA_PID=$! && \
    sleep 20 && \
    bin/kafka-topics.sh --create --topic raw-events --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1 || true && \
    bin/kafka-topics.sh --create --topic json-encoded-events --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1 || true && \
    trap 'echo Stopping Kafka and Zookeeper...; kill -TERM $KAFKA_PID $ZK_PID; wait' SIGTERM SIGINT && \
    wait"]

