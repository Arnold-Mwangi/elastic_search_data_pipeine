FROM debezium/connect:1.9

USER root

RUN curl -L -o /usr/local/bin/jq "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" \
    && chmod +x /usr/local/bin/jq

RUN mkdir -p /debezium /scripts && \
    chown -R kafka:kafka /debezium /scripts && \
    chmod -R 755 /debezium /scripts

USER kafka