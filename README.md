# Kafka Mirror Maker 2 (MM2) Replication Lab

This project provides a complete, containerized laboratory to simulate, observe, and measure **Kafka Cluster Replication** using **Mirror Maker 2 (MM2)**.

It leverages **Podman** (compatible with Docker) to provision the infrastructure and includes a fully configured monitoring stack with **Prometheus** and **Grafana** to demonstrate Disaster Recovery concepts like **RPO** (Recovery Point Objective) and **RTO** (Recovery Time Objective).

## Architecture

The lab consists of the following isolated components:

* **Kafka Source:** The primary cluster generating data (Active).
* **Kafka Target:** The secondary cluster receiving data (Passive/DR).
* **Mirror Maker 2:** The connector responsible for replicating data, offsets, and configuration.
* **Prometheus:** Scrapes JMX metrics exposed by the MM2 Java agent.
* **Grafana:** Visualizes the metrics with pre-provisioned dashboards using "Infrastructure as Code" concepts.

## Prerequisites

* Linux OS or WSL2.
* **Podman** and **podman-compose** (or Docker/Docker Compose).
* `curl` and `git`.

## Installation & Setup

### 1. Setup the Environment
Run the provided setup script. This script cleans up previous data, creates the necessary directory structure with correct permissions, and downloads the required JMX Prometheus Agent.

```bash
./setup.sh
```

### 2. Start the Lab
Initialize the containers in detached mode.

```bash
podman-compose up -d
```

### 3. Verify Status
Ensure all containers (`kafka-source`, `kafka-target`, `mirror-maker`, `prometheus`, `grafana`) are running.

```bash
podman ps
```

## Monitoring (Grafana)

The environment uses Grafana Provisioning to automatically configure the Datasource and Import the Dashboard. No manual configuration is required.

1.  Access **[http://localhost:3000](http://localhost:3000)**.
2.  **Login:** `admin` / `admin`.
3.  Navigate to **Dashboards** > **MM2 Dash**.

### Key Metrics for DR Analysis

* **Avg Data Transfer:** Shows the replication bandwidth throughput (MB/s).
* **Replication Latency (RPO):** The time it takes for a record produced at Source to be persisted at Target.
    * *Lab Benchmark:* ~600ms (Sub-second RPO).
* **Records LAG (RTO):** The volume of data buffered in MM2 waiting to be delivered.
    * *Lab Benchmark:* < 500 records (Near-zero RTO).

## Simulation: Generating Load

To observe the lag rising and draining, inject a high volume of data into the Source cluster.

Run the flood script:

```bash
./test.sh
```

*Tip: Watch the Grafana dashboard immediately after running this command to see the Lag spike and the Latency increase due to queueing.*

## Key Configurations

### `config/mm2/mm2.properties`
Main configuration file for Mirror Maker 2. It defines the source/target clusters and tuning parameters (like batch size throttling).

### `config/mm2/metrics.yaml`
Configures the JMX Exporter agent. It defines the rules to translate Kafka Connect internal MBeans into readable Prometheus metrics.

## Cleanup

To stop the lab and remove all persistent data (reset to zero):

```bash
podman-compose down
./setup.sh # recreate data and log dirs
```