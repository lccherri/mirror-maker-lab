#!/bin/bash
set -e
NODE_ROLE=$1
CONFIG_FILE=$2
CLUSTER_ID=$3

echo "--- Iniciando Node ($NODE_ROLE) ---"

# Garante que LOG_DIR aponte para nosso volume montado
export LOG_DIR=/opt/kafka/logs

if [ ! -f "/var/lib/kafka/data/meta.properties" ]; then
    echo "Formatando Storage KRaft com ID: $CLUSTER_ID"
    /opt/kafka/bin/kafka-storage.sh format -t $CLUSTER_ID -c $CONFIG_FILE
else
    echo "Storage já formatado. Pulando formatação."
fi

echo "Iniciando Kafka..."
exec /opt/kafka/bin/kafka-server-start.sh $CONFIG_FILE
