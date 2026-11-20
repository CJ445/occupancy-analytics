
# **PostgreSQL Setup**  

## **Overview**

This README provides instructions for building and running the PostgreSQL Docker container. PostgreSQL is used for storing our occupancy data. The `schema` folder contains the database schema in the `init.sql` file, which will be executed to set up the database during the Docker container build process.

---

## **Building the PostgreSQL Container**

To build the PostgreSQL container, run the following command:

```bash
$ docker build -t postgres-container .
```

---

## **Running the PostgreSQL Database**

To run the PostgreSQL database, follow these steps:

1. **Navigate to the PostgreSQL Scripts Directory**

   ```bash
   $ cd occupancy-analytics/postgres/scripts
   
   ```
2. **Make the Startup Script Executable**

   ```bash
   $ chmod +x start_DB.sh
   
   ```
3. **Run the Startup Script**

   ```bash
   $ ./start_DB.sh
   
   ```

---

## **Important Notes**

- Ensure Docker is installed and running on your machine.
- The init.sql file in the schema folder will automatically set up the database schema when the container is built.