FROM postgres:16

COPY schema/init.sql /docker-entrypoint-initdb.d/

EXPOSE 5432
ENV POSTGRES_DB=kafka_data
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=admin

# Start PostgreSQL
CMD ["postgres"]