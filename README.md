
# **Project README**

## **Overview**

This README provides instructions for building and running the various components of the project, including DeepStream, PostgreSQL, Kafka, and Grafana. Follow the execution steps in the order provided to ensure proper setup and functionality.

---

## **Execution Steps**

### **Create Docker Network**
```bash
docker network create deepstream-kafka-network
```

1. **[PostgreSQL](postgres/README.md)**
   - Follow the instructions to build and run the PostgreSQL Docker container.
   -The schema for DB is in the schema folder in init.sql file

2. **[Grafana](grafana/README.md)**
   - Follow the instructions to build and run the Grafana services.

3. **[Kafka](kafka/README.md)**
   - Follow the instructions to build and run the Kafka services.

4. -**[DeepStream](deepstream/README.md)**
   - Follow the instructions to build and run the DeepStream Docker container.
   -NOTE running the start_deepstream will be the last step. All other services should be up and runinng.   


---



---

## **Important Notes**

- Ensure that the PostgreSQL database is running and accessible to Grafana.
- You can access Grafana by navigating to
 http://ip address:3000  on your web browser after starting the service. The default login is
 ```bash
 USERNAME : admin
 PASSWORD : admin
 ```