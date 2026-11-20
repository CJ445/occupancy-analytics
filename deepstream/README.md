# **DeepStream Setup**

## **Overview**

This README provides instructions for building and running the DeepStream Docker container. The container can operate in two modes: **GUI** or **headless**. Ensure all necessary services are set up before proceeding.

---

## **Building the Docker Container**

To build the DeepStream Docker container, run the following command:

```bash
$ docker build -t deepstream_container .
```

> **Note**: Execute  the below  after setting up all other required services. This will be the last step to start the app.

---

## **Running the DeepStream Docker**

The DeepStream Docker container will run two scripts.

1. **Running Deepstream**
2. **Consuming and storing data TO DB**

### *Running Deepstream**

To run it ,follow these steps:

1. Navigate to the scripts directory:
   ```bash
   $ cd occupancy-analytics/deepstream/scripts
   ```
2. Make the script executable:
   ```bash
   $ chmod +x start_deepstream.sh
   ```
3. Run the script:
   ```bash
   ./start_deepstream.sh
   ```


### **Consuming and storing data TO DB**

follow these steps:

1. Navigate to the scripts directory:
   ```bash
   $ cd occupancy-analytics/deepstream/scripts
   ```
2. Make the script executable:
   ```bash
   $ chmod +x start_consume.sh
   ```
3. Run the script:
   ```bash
   $ ./start_consume.sh
   ```

---

## **Important Notes**

- Ensure Docker is installed and configured for GPU support.
- DeepStream containers are available for both dGPU and Jetson platforms. Pull the appropriate image for your hardware.
- For more details on configuration and usage, refer to the [NVIDIA DeepStream documentation](https://developer.nvidia.com/deepstream-sdk).

---

