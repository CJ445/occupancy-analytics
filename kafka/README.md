
# **Kafka Setup**

## 1. Build the Kafka Container
To build the Kafka container, run the following command:

```bash
docker build -t kafka_container .
```

## 2. Run Kafka Services

To run the Kafka services, follow these steps:

### Step 1: Navigate to the Kafka Directory

Go to the Kafka directory where the startup script is located:

```bash
cd occupancy-analytics/kafka/scripts
```

### Step 2: Make the Script Executable

Ensure that the start_kafka.sh script has executable permissions:

```bash
chmod +x start_kafka.sh
```

### Step 3: Run the Script

Run the startup script to initiate the Kafka services, including Zookeeper, topic creation, and the Kafka server:

```bash
./start_kafka.sh
```

This will start the Kafka container along with the necessary services.
