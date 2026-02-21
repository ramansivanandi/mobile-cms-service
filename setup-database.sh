#!/bin/bash

# Database Setup Script for Dynamic UI Configuration Service
# This script helps set up the Oracle database user and schema

echo "=========================================="
echo "Dynamic UI Configuration - DB Setup"
echo "=========================================="
echo ""

# Check if Docker is running
if ! docker ps > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker first."
    exit 1
fi

# Check if Oracle container is running
if ! docker ps | grep -q oracle-xe-db; then
    echo "Oracle container is not running. Starting it..."
    docker-compose up -d
    echo "Waiting for Oracle to be ready (this may take 1-2 minutes)..."
    sleep 60
fi

echo "Creating database user..."
docker exec -i oracle-xe-db sqlplus sys/OraclePwd123@localhost:1521/ORCL as sysdba <<EOF
CREATE USER C##API_TEST_USER IDENTIFIED BY ApiTestPwd123;
GRANT CONNECT, RESOURCE, DBA TO C##API_TEST_USER;
GRANT UNLIMITED TABLESPACE TO C##API_TEST_USER;
EXIT;
EOF

echo ""
echo "Creating schema..."
docker exec -i oracle-xe-db sqlplus C##API_TEST_USER/ApiTestPwd123@localhost:1521/ORCL < src/main/resources/db/oracle/schema.sql

echo ""
echo "Inserting sample data..."
docker exec -i oracle-xe-db sqlplus C##API_TEST_USER/ApiTestPwd123@localhost:1521/ORCL < src/main/resources/db/oracle/data.sql

echo ""
echo "=========================================="
echo "Database setup completed!"
echo "=========================================="
echo "You can now start the Spring Boot application."
echo "Run: mvn spring-boot:run"

