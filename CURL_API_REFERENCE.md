Execution order:
  1. Products (no deps)
  2. Categories (needs productId)
  3. Pages (needs categoryId)
  4. Widgets (needs pageId)
  5. Widget Properties (needs widgetId)
  6. Widget Rules (needs widgetId)
  7. Widget Actions (needs widgetId)
  8. OnLoad Services (needs pageId)
  9. UI Config (read-only aggregation)
  10. Mock Web Services (standalone)
  11. Data Sources (needs widgetId)
  
# Curl API Reference - Dynamic UI Code

**Base URL**: `http://localhost:8081`

---

## 1. Product Controller
**Base Path**: `/api/builder/products`

### Get All Products
```bash
curl -X GET "http://localhost:8081/api/builder/products" \
  -H "Content-Type: application/json"
```

### Get Product by ID
```bash
curl -X GET "http://localhost:8081/api/builder/products/1" \
  -H "Content-Type: application/json"
```

### Create Product
```bash
curl -X POST "http://localhost:8081/api/builder/products" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Insurance Product",
    "description": "Motor Insurance Product"
  }'
```

### Update Product
```bash
curl -X PUT "http://localhost:8081/api/builder/products/1" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated Insurance Product",
    "description": "Updated Motor Insurance Product"
  }'
```

### Delete Product
```bash
curl -X DELETE "http://localhost:8081/api/builder/products/1" \
  -H "Content-Type: application/json"
```

---

## 2. Category Controller
**Base Path**: `/api/builder/categories`

### Get All Categories
```bash
curl -X GET "http://localhost:8081/api/builder/categories" \
  -H "Content-Type: application/json"
```

### Get Category by ID
```bash
curl -X GET "http://localhost:8081/api/builder/categories/1" \
  -H "Content-Type: application/json"
```

### Get Categories by Product ID
```bash
curl -X GET "http://localhost:8081/api/builder/categories/product/1" \
  -H "Content-Type: application/json"
```

### Create Category
```bash
curl -X POST "http://localhost:8081/api/builder/categories" \
  -H "Content-Type: application/json" \
  -d '{
    "productId": 1,
    "name": "Motor Insurance",
    "description": "Motor vehicle insurance category"
  }'
```

### Update Category
```bash
curl -X PUT "http://localhost:8081/api/builder/categories/1" \
  -H "Content-Type: application/json" \
  -d '{
    "productId": 1,
    "name": "Updated Motor Insurance",
    "description": "Updated motor vehicle insurance category"
  }'
```

### Delete Category
```bash
curl -X DELETE "http://localhost:8081/api/builder/categories/1" \
  -H "Content-Type: application/json"
```

---

## 3. Page Controller
**Base Path**: `/api/builder/pages`

### Get All Pages (with optional filter)
```bash
curl -X GET "http://localhost:8081/api/builder/pages" \
  -H "Content-Type: application/json"
```

### Get Pages by Category ID
```bash
curl -X GET "http://localhost:8081/api/builder/pages?categoryId=1" \
  -H "Content-Type: application/json"
```

### Get Page by ID
```bash
curl -X GET "http://localhost:8081/api/builder/pages/1" \
  -H "Content-Type: application/json"
```

### Create Page
```bash
curl -X POST "http://localhost:8081/api/builder/pages" \
  -H "Content-Type: application/json" \
  -d '{
    "categoryId": 1,
    "title": "Motor Insurance Form",
    "orderNo": 1,
    "layoutType": "vertical",
    "columnsPerRow": 2
  }'
```

### Update Page
```bash
curl -X PUT "http://localhost:8081/api/builder/pages/1" \
  -H "Content-Type: application/json" \
  -d '{
    "categoryId": 1,
    "title": "Updated Motor Insurance Form",
    "orderNo": 1,
    "layoutType": "horizontal",
    "columnsPerRow": 3
  }'
```

### Delete Page
```bash
curl -X DELETE "http://localhost:8081/api/builder/pages/1" \
  -H "Content-Type: application/json"
```

---

## 4. Widget Controller
**Base Path**: `/api/builder/widgets`

### Get Widgets by Page ID
```bash
curl -X GET "http://localhost:8081/api/builder/widgets/page/1" \
  -H "Content-Type: application/json"
```

### Get Widget by ID
```bash
curl -X GET "http://localhost:8081/api/builder/widgets/1" \
  -H "Content-Type: application/json"
```

### Create Widget
```bash
curl -X POST "http://localhost:8081/api/builder/widgets" \
  -H "Content-Type: application/json" \
  -d '{
    "pageId": 1,
    "parentWidgetId": null,
    "type": "text",
    "name": "ageInput",
    "label": "Age",
    "orderNo": 1
  }'
```

### Create Nested Widget (with Parent)
```bash
curl -X POST "http://localhost:8081/api/builder/widgets" \
  -H "Content-Type: application/json" \
  -d '{
    "pageId": 1,
    "parentWidgetId": 5,
    "type": "text",
    "name": "nestedInput",
    "label": "Nested Field",
    "orderNo": 1
  }'
```

### Update Widget
```bash
curl -X PUT "http://localhost:8081/api/builder/widgets/1" \
  -H "Content-Type: application/json" \
  -d '{
    "pageId": 1,
    "parentWidgetId": null,
    "type": "number",
    "name": "ageInput",
    "label": "Age (Updated)",
    "orderNo": 2
  }'
```

### Delete Widget
```bash
curl -X DELETE "http://localhost:8081/api/builder/widgets/1" \
  -H "Content-Type: application/json"
```

---

## 5. Widget Properties Controller
**Base Path**: `/api/builder/widget-properties`

### Get Properties by Widget ID
```bash
curl -X GET "http://localhost:8081/api/builder/widget-properties/widget/1" \
  -H "Content-Type: application/json"
```

### Create Property
```bash
curl -X POST "http://localhost:8081/api/builder/widget-properties" \
  -H "Content-Type: application/json" \
  -d '{
    "widgetId": 1,
    "propKey": "placeholder",
    "propValue": "Enter your age"
  }'
```

### Update Property
```bash
curl -X PUT "http://localhost:8081/api/builder/widget-properties/1" \
  -H "Content-Type: application/json" \
  -d '{
    "propKey": "placeholder",
    "propValue": "Enter age here"
  }'
```

### Delete Property
```bash
curl -X DELETE "http://localhost:8081/api/builder/widget-properties/1" \
  -H "Content-Type: application/json"
```

### Create Properties Batch
```bash
curl -X POST "http://localhost:8081/api/builder/widget-properties/batch" \
  -H "Content-Type: application/json" \
  -d '[
    {
      "widgetId": 1,
      "propKey": "placeholder",
      "propValue": "Enter your age"
    },
    {
      "widgetId": 1,
      "propKey": "required",
      "propValue": "true"
    },
    {
      "widgetId": 1,
      "propKey": "min",
      "propValue": "18"
    }
  ]'
```

---

## 6. Widget Rules Controller
**Base Path**: `/api/builder/widget-rules`

### Get Rules by Widget ID
```bash
curl -X GET "http://localhost:8081/api/builder/widget-rules/widget/1" \
  -H "Content-Type: application/json"
```

### Create Rule
```bash
curl -X POST "http://localhost:8081/api/builder/widget-rules" \
  -H "Content-Type: application/json" \
  -d '{
    "widgetId": 1,
    "ruleType": "validation",
    "ruleExpression": "age >= 18 && age <= 100"
  }'
```

### Create Visibility Rule
```bash
curl -X POST "http://localhost:8081/api/builder/widget-rules" \
  -H "Content-Type: application/json" \
  -d '{
    "widgetId": 2,
    "ruleType": "visibility",
    "ruleExpression": "carBrand == \"BMW\" || carBrand == \"Mercedes\""
  }'
```

### Update Rule
```bash
curl -X PUT "http://localhost:8081/api/builder/widget-rules/1" \
  -H "Content-Type: application/json" \
  -d '{
    "ruleType": "validation",
    "ruleExpression": "age >= 21 && age <= 100"
  }'
```

### Delete Rule
```bash
curl -X DELETE "http://localhost:8081/api/builder/widget-rules/1" \
  -H "Content-Type: application/json"
```

---

## 7. Widget Actions Controller
**Base Path**: `/api/builder/widget-actions`

### Get Actions by Widget ID
```bash
curl -X GET "http://localhost:8081/api/builder/widget-actions/widget/1" \
  -H "Content-Type: application/json"
```

### Create Action (HTTP Request)
```bash
curl -X POST "http://localhost:8081/api/builder/widget-actions" \
  -H "Content-Type: application/json" \
  -d '{
    "widgetId": 1,
    "actionName": "submitForm",
    "actionType": "http",
    "triggerEvent": "click",
    "httpMethod": "POST",
    "endpointUrl": "http://localhost:8081/api/insurance/submit",
    "payloadTemplate": {"age": "${age}", "carBrand": "${carBrand}"},
    "payloadType": "dynamic",
    "headers": {"Content-Type": "application/json"},
    "timeoutMs": 30000,
    "orderNo": 1,
    "isEnabled": "Y"
  }'
```

### Create Action (Navigation)
```bash
curl -X POST "http://localhost:8081/api/builder/widget-actions" \
  -H "Content-Type: application/json" \
  -d '{
    "widgetId": 1,
    "actionName": "navigateToPage",
    "actionType": "navigation",
    "triggerEvent": "click",
    "successHandler": "window.location.href=\"/confirmation\"",
    "orderNo": 1,
    "isEnabled": "Y"
  }'
```

### Create Action with Condition
```bash
curl -X POST "http://localhost:8081/api/builder/widget-actions" \
  -H "Content-Type: application/json" \
  -d '{
    "widgetId": 1,
    "actionName": "conditionalSubmit",
    "actionType": "http",
    "triggerEvent": "click",
    "httpMethod": "POST",
    "endpointUrl": "http://localhost:8081/api/insurance/submit",
    "payloadTemplate": {"age": "${age}", "carBrand": "${carBrand}"},
    "conditionExpression": "age >= 18",
    "orderNo": 1,
    "isEnabled": "Y"
  }'
```

### Update Action
```bash
curl -X PUT "http://localhost:8081/api/builder/widget-actions/1" \
  -H "Content-Type: application/json" \
  -d '{
    "actionName": "submitFormUpdated",
    "actionType": "http",
    "triggerEvent": "click",
    "httpMethod": "PUT",
    "endpointUrl": "http://localhost:8081/api/user/profile",
    "payloadTemplate": {"username": "${username}", "salary": "${salary}"},
    "payloadType": "dynamic",
    "headers": {"Authorization": "Bearer token"},
    "timeoutMs": 45000,
    "orderNo": 2,
    "isEnabled": "Y"
  }'
```

### Delete Action
```bash
curl -X DELETE "http://localhost:8081/api/builder/widget-actions/1" \
  -H "Content-Type: application/json"
```

---

## 8. OnLoad Service Controller
**Base Path**: `/api/builder/onload-services`

### Get Services by Page ID
```bash
curl -X GET "http://localhost:8081/api/builder/onload-services/page/1" \
  -H "Content-Type: application/json"
```

### Create OnLoad Service
```bash
curl -X POST "http://localhost:8081/api/builder/onload-services" \
  -H "Content-Type: application/json" \
  -d '{
    "pageId": 1,
    "serviceId": "loadUserProfile",
    "api": "http://localhost:8081/api/user/profile",
    "httpMethod": "GET",
    "payload": null,
    "headers": {"Authorization": "Bearer token"},
    "serviceIdentifier": "userProfileService",
    "onSuccess": "populateProfileFields",
    "onFailure": "showErrorMessage"
  }'
```

### Create OnLoad Service with POST Payload
```bash
curl -X POST "http://localhost:8081/api/builder/onload-services" \
  -H "Content-Type: application/json" \
  -d '{
    "pageId": 1,
    "serviceId": "initializeForm",
    "api": "http://localhost:8081/api/forms/initialize",
    "httpMethod": "POST",
    "payload": {"formType": "insurance", "userId": "12345"},
    "headers": {"Content-Type": "application/json"},
    "serviceIdentifier": "formInitService",
    "onSuccess": "setFormDefaults",
    "onFailure": "showInitError"
  }'
```

### Update OnLoad Service
```bash
curl -X PUT "http://localhost:8081/api/builder/onload-services/1" \
  -H "Content-Type: application/json" \
  -d '{
    "serviceId": "loadUserProfileV2",
    "api": "http://localhost:8081/api/profile/get",
    "httpMethod": "GET",
    "payload": null,
    "headers": {"Authorization": "Bearer newToken"},
    "serviceIdentifier": "userProfileServiceV2",
    "onSuccess": "updateProfileUI",
    "onFailure": "displayError"
  }'
```

### Delete OnLoad Service
```bash
curl -X DELETE "http://localhost:8081/api/builder/onload-services/1" \
  -H "Content-Type: application/json"
```

---

## 9. UI Configuration Controller
**Base Path**: `/api/ui-config`

### Get Complete UI Configuration
```bash
curl -X GET "http://localhost:8081/api/ui-config/1" \
  -H "Content-Type: application/json"
```

### Test POST Insurance (Mock Endpoint)
```bash
curl -X POST "http://localhost:8081/api/ui-config/post/ins" \
  -H "Content-Type: application/json" \
  -d '{}'
```

---

## 10. Web Services / Mock API Controller
**Base Path**: `/api`

### Health Check
```bash
curl -X GET "http://localhost:8081/api/health" \
  -H "Content-Type: application/json"
```

### Get User Profile
```bash
curl -X GET "http://localhost:8081/api/user/profile" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer token"
```

### Get Car Brands (with optional category parameter)
```bash
curl -X GET "http://localhost:8081/api/cars/brands" \
  -H "Content-Type: application/json"
```

```bash
curl -X GET "http://localhost:8081/api/cars/brands?category=luxury" \
  -H "Content-Type: application/json"
```

### Initialize Form
```bash
curl -X POST "http://localhost:8081/api/forms/initialize" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer token" \
  -d '{
    "formType": "insurance",
    "userId": "12345"
  }'
```

### Get Configuration Settings (with optional category)
```bash
curl -X GET "http://localhost:8081/api/config/settings" \
  -H "Content-Type: application/json"
```

```bash
curl -X GET "http://localhost:8081/api/config/settings?category=motor" \
  -H "Content-Type: application/json"
```

### Get Validation Rules
```bash
curl -X GET "http://localhost:8081/api/validation/rules" \
  -H "Content-Type: application/json"
```

### Get User List
```bash
curl -X GET "http://localhost:8081/api/users/list" \
  -H "Content-Type: application/json" \
  -H "Content-Type: application/json"
```

### Get User Profile (Alternative Endpoint)
```bash
curl -X GET "http://localhost:8081/api/profile/get" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer token"
```

### Submit Insurance Form
```bash
curl -X POST "http://localhost:8081/api/insurance/submit" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer token" \
  -d '{
    "age": 28,
    "carBrand": "Toyota",
    "email": "user@example.com",
    "phone": "+1234567890"
  }'
```

### Update User Profile
```bash
curl -X PUT "http://localhost:8081/api/user/profile" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer token" \
  -d '{
    "username": "john.doe",
    "email": "newemail@example.com",
    "department": "Finance",
    "salary": "80000"
  }'
```

### Delete Item
```bash
curl -X DELETE "http://localhost:8081/api/items/123" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer token"
```

---

## API Response Format

All API responses follow this standard format:

### Success Response
```json
{
  "success": true,
  "errorCode": null,
  "errorMessage": null,
  "data": {
    // Response data here
  }
}
```

### Error Response
```json
{
  "success": false,
  "errorCode": "100001",
  "errorMessage": "Error message here",
  "data": null
}
```

---

## Common Error Codes

| Code | Message | Description |
|------|---------|-------------|
| 100001 | Failed to fetch | General fetch error |
| 100002 | Not found | Resource not found |
| 100003 | Failed to create | Creation error |
| 100004 | Failed to update | Update error |
| 100005 | Failed to delete | Delete error |
| 400001 | BAD_REQUEST | Invalid request data |
| 404001 | NOT_FOUND | Item not found |

---

## Testing Tips

1. **Use Pretty JSON Output**: Add `| jq` to the end of curl commands for formatted JSON
   ```bash
   curl -X GET "http://localhost:8081/api/builder/products" | jq
   ```

2. **Save Response to File**:
   ```bash
   curl -X GET "http://localhost:8081/api/builder/products" -o response.json
   ```

3. **Verbose Mode**: Use `-v` flag for debugging
   ```bash
   curl -v -X GET "http://localhost:8081/api/builder/products"
   ```

4. **Test with Authentication**: Add authorization header
   ```bash
   curl -X GET "http://localhost:8081/api/user/profile" \
     -H "Authorization: Bearer YOUR_TOKEN"
   ```

---

## API Documentation

For interactive API documentation, visit:
- **Swagger UI**: http://localhost:8081/swagger-ui.html
- **OpenAPI JSON**: http://localhost:8081/api-docs

# :hover                                                                                                                                                                                                                                                   
  curl -s -X POST "http://34.18.92.50:8084/api/widgets/1/pseudo-styles" \                                                                                                                                                                                          
    -H "Content-Type: application/json" \                                                                                                                                                                                                                    
    -d '{                                                                                                                                                                                                                                                    
      "selector": ":hover",
      "propKey": "display",                                                                                                                                                                                                                                  
      "propValue": "flex",                                                                                                                                                                                                                                   
      "remarks": "hover display"                                                                                                                                                                                                                             
    }'

  curl -s -X POST "http://34.18.92.50:8084/api/widgets/1/pseudo-styles" \
    -H "Content-Type: application/json" \
    -d '{
      "selector": ":hover",
      "propKey": "flex-direction",
      "propValue": "column",
      "remarks": "hover flex direction"
    }'

  curl -s -X POST "http://34.18.92.50:8084/api/widgets/1/pseudo-styles" \
    -H "Content-Type: application/json" \
    -d '{
      "selector": ":hover",
      "propKey": "max-height",
      "propValue": "300px",
      "remarks": "hover max height"
    }'

  curl -s -X POST "http://34.18.92.50:8084/api/widgets/1/pseudo-styles" \
    -H "Content-Type: application/json" \
    -d '{
      "selector": ":hover",
      "propKey": "overflow",
      "propValue": "hidden",
      "remarks": "hover overflow"
    }'

  curl -s -X POST "http://34.18.92.50:8084/api/widgets/1/pseudo-styles" \
    -H "Content-Type: application/json" \
    -d '{
      "selector": ":hover",
      "propKey": "padding",
      "propValue": "1rem",
      "remarks": "hover padding"
    }'

  curl -s -X POST "http://34.18.92.50:8084/api/widgets/1/pseudo-styles" \
    -H "Content-Type: application/json" \
    -d '{
      "selector": ":hover",
      "propKey": "background-color",
      "propValue": "rgba(0,0,0,0.6)",
      "remarks": "hover background"
    }'

  curl -s -X POST "http://34.18.92.50:8084/api/widgets/1/pseudo-styles" \
    -H "Content-Type: application/json" \
    -d '{
      "selector": ":hover",
      "propKey": "transition",
      "propValue": "all 0.3s ease",
      "remarks": "hover transition"
    }'
