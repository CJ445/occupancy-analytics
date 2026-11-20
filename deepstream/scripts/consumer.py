import json
import psycopg2
from kafka import KafkaConsumer

# Database connection
conn = psycopg2.connect(
    dbname='kafka_data',
    user='postgres',
    password='admin',  # Replace with your password
    host='postgres-container',#postgres container name
    port='5432'
)
cursor = conn.cursor()
# Define topic as a constant
TOPIC_NAME = 'json-encoded-events'

# Set up Kafka Consumer
consumer = KafkaConsumer(
    TOPIC_NAME,
    bootstrap_servers='kafka_container:9092',
    auto_offset_reset='earliest',
    enable_auto_commit=True,
    group_id='my-group'
)

# Retrieve ds_instance_id based on the topic name
cursor.execute(
    """
    SELECT id FROM public.ds_instance
    WHERE mq_topic = %s
    """,
    (TOPIC_NAME,)
)
ds_instance_id_result = cursor.fetchone()
if ds_instance_id_result:
    ds_instance_id = ds_instance_id_result[0]
else:
    raise ValueError(f"No DeepStream instance found with topic {TOPIC_NAME}")

# Build a dictionary to map (ds_instance_id, ds_source_id) -> camera_id
cursor.execute(
    """
    SELECT id, ds_source_id FROM public.camera
    WHERE ds_instance_id = %s
    """,
    (ds_instance_id,)
)
camera_mapping = {ds_source_id: camera_id for camera_id, ds_source_id in cursor.fetchall()}

# Consume messages from Kafka and insert into PostgreSQL
for message in consumer:
    data = json.loads(message.value)

    # Extract source ID from message
    source_id = data.get("source_id")

    # Retrieve the camera_id from the camera mapping dictionary
    camera_id = camera_mapping.get(source_id)

    if camera_id:
        # Insert data into occupancy_data
        cursor.execute(
            """
            INSERT INTO public.occupancy_data (camera_id, timestamp, entry, exit, occupancy)
            VALUES (%s, %s, %s, %s, %s)
            """,
            (camera_id, data["@timestamp"], data["Entry"], data["Exit"], data["occupancy"])
        )
        conn.commit()
        print(f"Inserted: {data}")  # Optional: Print inserted data for confirmation
    else:
        print(f"Camera with source_id {source_id} not found for DeepStream instance ID {ds_instance_id}.")

# Close connections (this part won't be reached in this infinite loop)
# cursor.close()
# conn.close()