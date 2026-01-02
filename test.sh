#!/bin/bash

TOPIC="app-cliente-v1"
RECORD_SIZE=1024
NUM_RECORDS=100000

echo "--- Iniciando Gerador de Lag em Loop (Ctrl+C para parar) ---"

while true; do
    echo "[$(date +%T)] Injetando $NUM_RECORDS mensagens de ${RECORD_SIZE} bytes..."
    
    # Executa o Perf Test (Produção em alta velocidade)
    podman exec kafka-source /opt/kafka/bin/kafka-producer-perf-test.sh \
        --topic $TOPIC \
        --num-records $NUM_RECORDS \
        --record-size $RECORD_SIZE \
        --throughput -1 \
        --producer-props bootstrap.servers=localhost:9092 > /dev/null 2>&1

    echo "Aguardando o Mirror Maker consumir..."
    
    sleep 5
    echo "-------------------------------------------------------"
done