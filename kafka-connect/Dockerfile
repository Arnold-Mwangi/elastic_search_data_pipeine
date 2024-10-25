# Start from the debezium/connect base image
FROM debezium/connect:1.7

# Download and install jq
USER root
RUN curl -L -o /usr/local/bin/jq "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" \
    && chmod +x /usr/local/bin/jq
USER kafka
