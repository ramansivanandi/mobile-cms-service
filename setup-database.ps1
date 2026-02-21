# Database Setup Script for Dynamic UI Configuration Service (PowerShell)
# This script helps set up the Oracle database user and schema

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Dynamic UI Configuration - DB Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
try {
    docker ps | Out-Null
} catch {
    Write-Host "Error: Docker is not running. Please start Docker first." -ForegroundColor Red
    exit 1
}

# Check if Oracle container is running
$containerRunning = docker ps | Select-String "oracle-xe-db"
if (-not $containerRunning) {
    Write-Host "Oracle container is not running. Starting it..." -ForegroundColor Yellow
    docker-compose up -d
    Write-Host "Waiting for Oracle to be ready (this may take 1-2 minutes)..." -ForegroundColor Yellow
    Start-Sleep -Seconds 60
}

Write-Host "Creating database user..." -ForegroundColor Green
$createUserScript = @"
CREATE USER C##API_TEST_USER IDENTIFIED BY ApiTestPwd123;
GRANT CONNECT, RESOURCE, DBA TO C##API_TEST_USER;
GRANT UNLIMITED TABLESPACE TO C##API_TEST_USER;
EXIT;
"@

$createUserScript | docker exec -i oracle-xe-db sqlplus sys/OraclePwd123@localhost:1521/ORCL as sysdba

Write-Host ""
Write-Host "Creating schema..." -ForegroundColor Green
Get-Content src/main/resources/db/oracle/schema.sql | docker exec -i oracle-xe-db sqlplus C##API_TEST_USER/ApiTestPwd123@localhost:1521/ORCL

Write-Host ""
Write-Host "Inserting sample data..." -ForegroundColor Green
Get-Content src/main/resources/db/oracle/data.sql | docker exec -i oracle-xe-db sqlplus C##API_TEST_USER/ApiTestPwd123@localhost:1521/ORCL

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Database setup completed!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "You can now start the Spring Boot application." -ForegroundColor Yellow
Write-Host "Run: mvn spring-boot:run" -ForegroundColor Yellow

