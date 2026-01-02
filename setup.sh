#!/bin/bash

ROOT_DIR="."
echo "--- Configuring MM2 Lab in ./$ROOT_DIR ---"

# 1. Cleaning
podman-compose down 2>/dev/null
podman rm -f kafka-source kafka-target mirror-maker prometheus grafana 2>/dev/null
sudo rm -rf $ROOT_DIR/data

mkdir -p $ROOT_DIR/libs
#mkdir -p $ROOT_DIR/config/{source,target,mm2}
#mkdir -p $ROOT_DIR/scripts
#mkdir -p $ROOT_DIR/prometheus

mkdir -p $ROOT_DIR/data/source-data
mkdir -p $ROOT_DIR/data/source-logs
mkdir -p $ROOT_DIR/data/target-data
mkdir -p $ROOT_DIR/data/target-logs

sudo chmod -R 777 $ROOT_DIR/data

# 2. JMX Agent Download
if [ ! -f "$ROOT_DIR/libs/jmx_prometheus_javaagent.jar" ]; then
    echo "Baixando JMX Prometheus Agent..."
    curl -L -o $ROOT_DIR/libs/jmx_prometheus_javaagent.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.20.0/jmx_prometheus_javaagent-0.20.0.jar
fi
sudo chmod 644 $ROOT_DIR/libs/jmx_prometheus_javaagent.jar

echo "--- Setup Finished ---"
echo "1. podman-compose up -d"
echo "2. Follow the logs: podman logs -f kafka-source"