# Dynamic UI Configuration Service

A Spring Boot microservice that dynamically generates UI configurations from an Oracle database. The service provides a RESTful API that returns complete UI component definitions including properties, validation rules, data sources, and actions for frontend applications (e.g., Angular, React).

## 🎯 Overview

This service enables **database-driven UI configuration**, allowing you to:
- Define UI components, pages, and their relationships in the database
- Configure component properties, validation rules, and data sources dynamically
- Define actions (API calls, navigation) for interactive components like buttons
- Retrieve complete UI configuration as JSON for frontend consumption

## 🏗️ Architecture

### System Flow

```
Frontend (Angular/React) 
    ↓ HTTP Request
REST API (/api/ui-config/{productId})
    ↓
Service Layer (UiConfigService)
    ↓
Repository Layer (JPA Repositories)
    ↓
Oracle Database
    ↓
Returns nested JSON structure
```

### Technology Stack

- **Framework**: Spring Boot 3.2.0
- **Java Version**: 17
- **Database**: Oracle Database (XE or Standard)
- **ORM**: JPA/Hibernate
- **Build Tool**: Maven
- **API Documentation**: Swagger/OpenAPI 3
- **Connection Pool**: HikariCP

## 📊 Database Schema

The system uses a hierarchical structure to organize UI configurations:

### Core Tables

**PRODUCT** → **CATEGORY** → **PAGE** → **UI_COMPONENT**

### Component Configuration Tables

- **UI_COMPONENT_PROPS**: Key-value properties for components (e.g., `placeholder`, `required`, `min`, `max`)
- **UI_COMPONENT_RULE**: Validation rules with expressions (e.g., `value >= 18`)
- **UI_DATA_SOURCE**: Data sources for dropdowns, lists (static JSON or dynamic sources)
- **UI_COMPONENT_ACTION**: Actions for interactive components (API calls, navigation)

### Table Relationships

```
PRODUCT (1) ──→ (N) CATEGORY
CATEGORY (1) ──→ (N) PAGE
PAGE (1) ──→ (N) UI_COMPONENT
UI_COMPONENT (1) ──→ (N) UI_COMPONENT_PROPS
UI_COMPONENT (1) ──→ (N) UI_COMPONENT_RULE
UI_COMPONENT (1) ──→ (N) UI_DATA_SOURCE
UI_COMPONENT (1) ──→ (N) UI_COMPONENT_ACTION
```

### Key Fields

#### UI_COMPONENT
- `TYPE`: Component type (textbox, dropdown, button, etc.)
- `NAME`: Unique identifier for the component
- `LABEL`: Display label
- `ORDER_NO`: Display order

#### UI_COMPONENT_ACTION
- `ACTION_TYPE`: Type of action (api_call, navigation, form_submit)
- `HTTP_METHOD`: HTTP method (GET, POST, PUT, DELETE)
- `ENDPOINT_URL`: Backend service endpoint
- `PAYLOAD_TEMPLATE`: JSON template with placeholders (e.g., `{{fieldName}}`)
- `PAYLOAD_TYPE`: `static`, `dynamic`, or `none`
- `HEADERS`: Custom HTTP headers as JSON
- `SUCCESS_HANDLER`: Action on success (e.g., `navigate:/success`)
- `ERROR_HANDLER`: Action on error (e.g., `showMessage:Error occurred`)

## 🚀 Quick Start

### Prerequisites

- Java 17 or higher
- Maven 3.6+
- Oracle Database (or Docker for Oracle XE)
- IDE (IntelliJ IDEA, Eclipse, VS Code)

### Setup Steps

1. **Clone/Download the project**

2. **Start Oracle Database** (using Docker Compose):
   ```bash
   docker-compose up -d
   ```
   Wait 1-2 minutes for database initialization.

3. **Create Database User**:
   ```bash
   docker exec -it oracle-xe-db sqlplus sys/OraclePwd123@localhost:1521/ORCL as sysdba
   ```
   ```sql
   CREATE USER C##API_TEST_USER IDENTIFIED BY ApiTestPwd123;
   GRANT CONNECT, RESOURCE, DBA TO C##API_TEST_USER;
   GRANT UNLIMITED TABLESPACE TO C##API_TEST_USER;
   EXIT;
   ```

4. **Run Database Scripts**:
   - Execute `src/main/resources/db/oracle/schema.sql` to create tables
   - Execute `src/main/resources/db/oracle/data.sql` to insert sample data

5. **Configure Application** (if needed):
   Edit `src/main/resources/application.properties`:
   ```properties
   spring.datasource.url=jdbc:oracle:thin:@localhost:1521/ORCL
   spring.datasource.username=C##API_TEST_USER
   spring.datasource.password=ApiTestPwd123
   ```

6. **Run the Application**:
   ```bash
   mvn spring-boot:run
   ```

The application will start on **http://localhost:8080**

## 📡 API Documentation

### Get UI Configuration

**Endpoint**: `GET /api/ui-config/{productId}`

**Description**: Retrieves complete UI configuration for a product, including all categories, pages, components, properties, rules, data sources, and actions.

**Parameters**:
- `productId` (path): The ID of the product

**Response Structure**:
```json
{
  "product": "Product Name",
  "categories": [
    {
      "name": "Category Name",
      "pages": [
        {
          "title": "Page Title",
          "order": 1,
          "components": [
            {
              "type": "textbox",
              "label": "Field Label",
              "name": "fieldName",
              "order": 1,
              "properties": {
                "placeholder": "Enter value",
                "required": "true"
              },
              "rules": [
                {
                  "type": "validation",
                  "expression": "value >= 18"
                }
              ],
              "dataSource": null,
              "actions": null
            },
            {
              "type": "button",
              "label": "Submit",
              "name": "submit",
              "order": 2,
              "actions": [
                {
                  "name": "submit",
                  "type": "api_call",
                  "triggerEvent": "click",
                  "httpMethod": "POST",
                  "endpointUrl": "/api/submit",
                  "payloadTemplate": {
                    "field1": "{{field1}}",
                    "field2": "{{field2}}"
                  },
                  "payloadType": "dynamic",
                  "headers": {
                    "Content-Type": "application/json"
                  },
                  "successHandler": "navigate:/success",
                  "errorHandler": "showMessage:Error occurred",
                  "timeout": 30000
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```

### Access Swagger UI

Once the application is running:
- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **OpenAPI JSON**: http://localhost:8080/api-docs

## 🔧 Component Types

The system supports various component types:

- **textbox**: Text input field
- **dropdown**: Select dropdown
- **button**: Action button
- **checkbox**: Checkbox input
- **radio**: Radio button group
- **textarea**: Multi-line text input
- *...and more as needed*

## 🎨 Actions System

### Action Types

1. **api_call**: Makes HTTP request to backend service
2. **navigation**: Navigates to another page/route
3. **form_submit**: Standard form submission
4. **validation**: Triggers validation logic
5. **custom**: Custom JavaScript handler

### Payload Templates

Actions support dynamic payloads using placeholders:

- **Field Placeholders**: `{{fieldName}}` - Replaced with form field values
- **System Variables**: `{{$timestamp}}`, `{{$user.id}}`, `{{$token}}` - System-provided values

**Example**:
```json
{
  "age": "{{age}}",
  "carBrand": "{{carBrand}}",
  "timestamp": "{{$timestamp}}"
}
```

### Action Handlers

- **Success Handler**: Action to perform on successful API call
  - `navigate:/path` - Navigate to route
  - `showMessage:Success!` - Display message
  - `reload` - Reload page
  
- **Error Handler**: Action to perform on error
  - `showMessage:Error occurred` - Display error message
  - `navigate:/error` - Navigate to error page

## 📁 Project Structure

```
src/
├── main/
│   ├── java/com/dynamicui/
│   │   ├── DynamicUiCodeApplication.java    # Main application
│   │   ├── config/
│   │   │   └── AppConfig.java               # Bean configurations
│   │   ├── controller/
│   │   │   └── UiConfigController.java      # REST endpoints
│   │   ├── service/
│   │   │   └── UiConfigService.java         # Business logic
│   │   ├── repository/
│   │   │   ├── ProductRepository.java        # JPA repositories
│   │   │   ├── CategoryRepository.java
│   │   │   ├── PageRepository.java
│   │   │   ├── UIComponentRepository.java
│   │   │   ├── PropertyRepository.java
│   │   │   ├── RulesRepository.java
│   │   │   ├── DataSourceRepository.java
│   │   │   └── ActionRepository.java
│   │   ├── entity/
│   │   │   ├── Product.java                  # JPA entities
│   │   │   ├── Category.java
│   │   │   ├── Page.java
│   │   │   ├── UIComponent.java
│   │   │   ├── UIComponentProps.java
│   │   │   ├── UIComponentRule.java
│   │   │   ├── UIDataSource.java
│   │   │   └── UIComponentAction.java
│   │   └── dto/
│   │       ├── UiConfigResponse.java         # Response DTOs
│   │       ├── CategoryDto.java
│   │       ├── PageDto.java
│   │       ├── ComponentDto.java
│   │       ├── RuleDto.java
│   │       └── ActionDto.java
│   └── resources/
│       ├── application.properties           # Configuration
│       └── db/oracle/
│           ├── schema.sql                    # Database schema
│           └── data.sql                      # Sample data
└── pom.xml                                   # Maven dependencies
```

## 🔍 Key Features

### 1. Eager Loading with EntityGraph
- Uses JPA EntityGraph to fetch all related data in a single query
- Prevents N+1 query problems
- Optimized database access

### 2. JSON Parsing
- Automatically parses JSON strings from database (payload templates, headers, data sources)
- Handles parsing errors gracefully
- Falls back to raw string if parsing fails

### 3. Dynamic Payload Support
- Supports template-based payloads with field placeholders
- Enables dynamic form data submission
- Supports system variables

### 4. Action Filtering
- Only returns enabled actions (`IS_ENABLED = 'Y'`)
- Sorts actions by `ORDER_NO` for sequential execution
- Supports conditional actions via `CONDITION_EXPRESSION`

## ⚙️ Configuration

### Database Connection

Edit `src/main/resources/application.properties`:

```properties
# Oracle Connection
spring.datasource.url=jdbc:oracle:thin:@localhost:1521/ORCL
spring.datasource.username=C##API_TEST_USER
spring.datasource.password=ApiTestPwd123

# JPA Settings
spring.jpa.hibernate.ddl-auto=none
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

# Connection Pool (HikariCP)
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=2
```

### Logging

Configure logging levels in `application.properties`:

```properties
logging.level.org.springframework.web=INFO
logging.level.org.hibernate.SQL=DEBUG
logging.level.com.dynamicui=DEBUG
```

## 🧪 Testing

### Test API Endpoint

```bash
# Using curl
curl http://localhost:8080/api/ui-config/1

# Using PowerShell
Invoke-RestMethod -Uri http://localhost:8080/api/ui-config/1 -Method Get

# Using HTTPie
http GET http://localhost:8080/api/ui-config/1
```

### Verify Database Connection

Check application logs for:
- `HikariPool-1 - Starting...`
- `HikariPool-1 - Start completed.`
- SQL queries being logged (if `show-sql=true`)

## 🐛 Troubleshooting

### Database Connection Issues

**Problem**: Cannot connect to Oracle database

**Solutions**:
1. Verify Oracle is running: `docker ps` (for Docker) or check Oracle service
2. Check connection string format: `jdbc:oracle:thin:@host:port/serviceName`
3. Verify username/password in `application.properties`
4. Check Oracle listener: `docker exec -it oracle-xe-db lsnrctl status`
5. Ensure firewall allows port 1521

### Application Won't Start

**Problem**: Application fails to start

**Solutions**:
1. Check Java version: `java -version` (should be 17+)
2. Verify Maven: `mvn -version`
3. Clean and rebuild: `mvn clean install`
4. Check for port conflicts (default: 8080)
5. Review application logs for specific errors

### Empty Response

**Problem**: API returns empty categories/pages

**Solutions**:
1. Verify data exists in database
2. Check `productId` matches database records
3. Verify foreign key relationships are correct
4. Check application logs for SQL queries
5. Ensure EntityGraph is fetching all relationships

## 🔐 Security Considerations

⚠️ **Important for Production**:

1. **Credentials**: Use environment variables or secure vaults for database credentials
2. **HTTPS**: Enable HTTPS for all API endpoints
3. **Authentication**: Implement API authentication/authorization
4. **Input Validation**: Validate and sanitize all inputs
5. **SQL Injection**: Use parameterized queries (already implemented via JPA)
6. **Rate Limiting**: Implement rate limiting to prevent abuse
7. **CORS**: Configure CORS properly for frontend access
8. **Connection Encryption**: Use encrypted database connections

## 📝 Best Practices

1. **Database Design**:
   - Use sequences for primary keys
   - Create indexes on foreign keys
   - Use CASCADE DELETE for related records

2. **Component Naming**:
   - Use descriptive, unique component names
   - Follow consistent naming conventions
   - Use meaningful labels for UI display

3. **Actions**:
   - Use descriptive action names
   - Set appropriate timeouts
   - Provide clear success/error handlers
   - Test payload templates before deployment

4. **Performance**:
   - Use EntityGraph for eager loading
   - Create indexes on frequently queried columns
   - Monitor connection pool usage
   - Consider caching for frequently accessed configurations

## 📚 Additional Resources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Spring Data JPA Documentation](https://spring.io/projects/spring-data-jpa)
- [Oracle JDBC Documentation](https://docs.oracle.com/en/database/oracle/oracle-database/)
- [HikariCP Configuration](https://github.com/brettwooldridge/HikariCP)

## 🤝 Contributing

When adding new features:
1. Update database schema (`schema.sql`)
2. Create/update JPA entities
3. Add repository interfaces
4. Update service layer
5. Add/update DTOs
6. Update this README

## 📄 License

This project is provided as-is for demonstration and development purposes.

---

**For questions or issues, please refer to the application logs or contact the development team.**
