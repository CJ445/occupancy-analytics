
# **Grafana Setup**

## 1. Build the Grafana Container
To build the Grafana container, run the following command:

```bash
docker build -t grafana_container .
```

## 2. Run Grafana

To run the Grafana services, follow these steps:

### Step 1: Navigate to the Grafana Directory

Go to the Grafana directory:

```bash
cd occupancy-analytics/grafana
```

### Step 2: Make the Script Executable

Ensure that the start_grafana.sh script has executable permissions:

```bash
chmod +x start_grafana.sh
```

### Step 3: Run the Script

Run the startup script to initiate the Grafana services:

```bash
./start_grafana.sh
```