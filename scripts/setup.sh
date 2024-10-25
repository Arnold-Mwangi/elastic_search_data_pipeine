#!/bin/bash

# Wait for Elasticsearch to be ready
echo "Waiting for Elasticsearch to be ready..."
while ! curl -s -o /dev/null -w "%{http_code}" http://elasticsearch:9200 | grep -q 200; do
  sleep 60
done

# Wait for Kafka Connect to be ready
echo "Waiting for Kafka Connect to be ready..."
while ! curl -s -o /dev/null -w "%{http_code}" http://kafka-connect:8083/connectors | grep -q 200; do
  sleep 60
done

# Read tables from config file and format for Debezium
TABLE_LIST=$(jq -r '.tables | join(",zimasa_consumer.")' /debezium/table_config.json)
TABLE_LIST="zimasa_consumer.${TABLE_LIST}"

# Update the Debezium connector configuration
sed -i "s/\${table_list}/${TABLE_LIST}/" /debezium/register-mysql-connector.json

# Register the MySQL Connector
echo "Registering MySQL Connector..."
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" \
    http://kafka-connect:8083/connectors/ -d @/debezium/register-mysql-connector.json

echo "Setup complete!"