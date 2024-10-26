#!/bin/bash

# Wait for Elasticsearch to be ready
echo "Waiting for Elasticsearch to be ready..."
while ! curl -s -o /dev/null -w "%{http_code}" http://elasticsearch:9200 | grep -q 200; do
  sleep 10
done

# Wait for Kafka Connect to be ready
echo "Waiting for Kafka Connect to be ready..."
while ! curl -s -o /dev/null -w "%{http_code}" http://kafka-connect:8083/connectors | grep -q 200; do
  sleep 10
done

# Register the MySQL Connector
echo "Registering MySQL Connector..."
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" \
    http://kafka-connect:8083/connectors/ -d @/debezium/register-mysql-connector.json

# Check the status of the connector
echo "Checking connector status..."
sleep 5
curl -s http://kafka-connect:8083/connectors/mysql-connector/status | jq .

echo "Setup complete!"