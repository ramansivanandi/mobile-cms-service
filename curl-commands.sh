#!/bin/bash
# =====================================================================
# DynamicUiCode - Complete cURL Commands
# Backend: http://localhost:8081
# Angular UI Builder: http://localhost:4201
# =====================================================================
# EXECUTION ORDER (FK dependencies):
#   1. Products
#   2. Categories (requires productId)
#   3. Pages (requires categoryId)
#   4. Widgets (requires pageId, optional parentWidgetId)
#   5. Widget Properties (requires widgetId)
#   6. Widget Rules (requires widgetId)
#   7. Widget Actions (requires widgetId)
#   8. OnLoad Services (requires pageId)
#   9. UI Config (read-only, fetches full tree)
#  10. Mock Web Services (no DB, standalone)
# =====================================================================

BASE=http://localhost:8081

# =============================================================
# 1. PRODUCTS  /api/builder/products
# =============================================================

# 1a. Create Product
curl -s -X POST "$BASE/api/builder/products" \
  -H "Content-Type: application/json" \
  -d '{"name":"Insurance","description":"Insurance Product Configuration"}' | json_pp

# 1b. Create second Product
curl -s -X POST "$BASE/api/builder/products" \
  -H "Content-Type: application/json" \
  -d '{"name":"Banking","description":"Banking Product Configuration"}' | json_pp

# 1c. Get All Products
curl -s "$BASE/api/builder/products" | json_pp

# 1d. Get Product by ID
curl -s "$BASE/api/builder/products/1" | json_pp

# 1e. Update Product
curl -s -X PUT "$BASE/api/builder/products/1" \
  -H "Content-Type: application/json" \
  -d '{"name":"Insurance Updated","description":"Updated description"}' | json_pp

# 1f. Delete Product (careful - cascades!)
# curl -s -X DELETE "$BASE/api/builder/products/2" | json_pp

# =============================================================
# 2. CATEGORIES  /api/builder/categories
# =============================================================

# 2a. Create Category (productId=1)
curl -s -X POST "$BASE/api/builder/categories" \
  -H "Content-Type: application/json" \
  -d '{"productId":1,"name":"Motor Insurance","description":"Motor Insurance Category"}' | json_pp

# 2b. Create second Category (productId=1)
curl -s -X POST "$BASE/api/builder/categories" \
  -H "Content-Type: application/json" \
  -d '{"productId":1,"name":"Home Insurance","description":"Home Insurance Category"}' | json_pp

# 2c. Get All Categories
curl -s "$BASE/api/builder/categories" | json_pp

# 2d. Get Categories by Product
curl -s "$BASE/api/builder/categories/product/1" | json_pp

# 2e. Get Category by ID
curl -s "$BASE/api/builder/categories/1" | json_pp

# 2f. Update Category
curl -s -X PUT "$BASE/api/builder/categories/1" \
  -H "Content-Type: application/json" \
  -d '{"name":"Motor Insurance Updated","description":"Updated","productId":1}' | json_pp

# 2g. Delete Category
# curl -s -X DELETE "$BASE/api/builder/categories/2" | json_pp

# =============================================================
# 3. PAGES  /api/builder/pages
# =============================================================

# 3a. Create Page (categoryId=1)
curl -s -X POST "$BASE/api/builder/pages" \
  -H "Content-Type: application/json" \
  -d '{"categoryId":1,"title":"Personal Info","orderNo":1,"layoutType":"horizontal","columnsPerRow":2}' | json_pp

# 3b. Create second Page (categoryId=1)
curl -s -X POST "$BASE/api/builder/pages" \
  -H "Content-Type: application/json" \
  -d '{"categoryId":1,"title":"Confirmation","orderNo":2,"layoutType":"vertical"}' | json_pp

# 3c. Get All Pages
curl -s "$BASE/api/builder/pages" | json_pp

# 3d. Get Pages by Category
curl -s "$BASE/api/builder/pages?categoryId=1" | json_pp

# 3e. Get Page by ID
curl -s "$BASE/api/builder/pages/1" | json_pp

# 3f. Update Page
curl -s -X PUT "$BASE/api/builder/pages/1" \
  -H "Content-Type: application/json" \
  -d '{"title":"Personal Information","orderNo":1,"layoutType":"horizontal","columnsPerRow":3,"categoryId":1}' | json_pp

# 3g. Delete Page
# curl -s -X DELETE "$BASE/api/builder/pages/2" | json_pp

# =============================================================
# 4. WIDGETS  /api/builder/widgets
# =============================================================

# 4a. Create Widgets on page 1 (top-level, parentWidgetId=null)
curl -s -X POST "$BASE/api/builder/widgets" \
  -H "Content-Type: application/json" \
  -d '{"pageId":1,"type":"textbox","name":"age","label":"Age","orderNo":1}' | json_pp

curl -s -X POST "$BASE/api/builder/widgets" \
  -H "Content-Type: application/json" \
  -d '{"pageId":1,"type":"dropdown","name":"carBrand","label":"Car Brand","orderNo":2}' | json_pp

curl -s -X POST "$BASE/api/builder/widgets" \
  -H "Content-Type: application/json" \
  -d '{"pageId":1,"type":"button","name":"submit","label":"Submit","orderNo":3}' | json_pp

curl -s -X POST "$BASE/api/builder/widgets" \
  -H "Content-Type: application/json" \
  -d '{"pageId":1,"type":"checkbox","name":"termsAccepted","label":"Accept Terms and Conditions","orderNo":4}' | json_pp

# 4b. Create a Card widget (container for nested children)
curl -s -X POST "$BASE/api/builder/widgets" \
  -H "Content-Type: application/json" \
  -d '{"pageId":1,"type":"card","name":"detailsCard","label":"Details Card","orderNo":5}' | json_pp

# 4c. Create nested widgets inside the card (parentWidgetId = card's widgetId)
#     Replace 5 with the actual card widgetId from step 4b response
curl -s -X POST "$BASE/api/builder/widgets" \
  -H "Content-Type: application/json" \
  -d '{"pageId":1,"parentWidgetId":5,"type":"textbox","name":"email","label":"Email Address","orderNo":1}' | json_pp

# 4d. Get Widgets by Page
curl -s "$BASE/api/builder/widgets/page/1" | json_pp

# 4e. Get Widget by ID
curl -s "$BASE/api/builder/widgets/1" | json_pp

# 4f. Update Widget
curl -s -X PUT "$BASE/api/builder/widgets/1" \
  -H "Content-Type: application/json" \
  -d '{"pageId":1,"type":"textbox","name":"age","label":"Your Age","orderNo":1}' | json_pp

# 4g. Delete Widget
# curl -s -X DELETE "$BASE/api/builder/widgets/6" | json_pp

# =============================================================
# 5. WIDGET PROPERTIES  /api/builder/widget-properties
# =============================================================

# 5a. Create single property (widgetId=1, the age textbox)
curl -s -X POST "$BASE/api/builder/widget-properties" \
  -H "Content-Type: application/json" \
  -d '{"widgetId":1,"propKey":"placeholder","propValue":"Enter age"}' | json_pp

curl -s -X POST "$BASE/api/builder/widget-properties" \
  -H "Content-Type: application/json" \
  -d '{"widgetId":1,"propKey":"required","propValue":"true"}' | json_pp

curl -s -X POST "$BASE/api/builder/widget-properties" \
  -H "Content-Type: application/json" \
  -d '{"widgetId":1,"propKey":"min","propValue":"1"}' | json_pp

curl -s -X POST "$BASE/api/builder/widget-properties" \
  -H "Content-Type: application/json" \
  -d '{"widgetId":1,"propKey":"max","propValue":"100"}' | json_pp

# 5b. Batch create properties (widgetId=2, the dropdown)
curl -s -X POST "$BASE/api/builder/widget-properties/batch" \
  -H "Content-Type: application/json" \
  -d '[
    {"widgetId":2,"propKey":"placeholder","propValue":"Select car brand"},
    {"widgetId":2,"propKey":"required","propValue":"true"},
    {"widgetId":2,"propKey":"multiple","propValue":"false"}
  ]' | json_pp

# 5c. Button properties
curl -s -X POST "$BASE/api/builder/widget-properties/batch" \
  -H "Content-Type: application/json" \
  -d '[
    {"widgetId":3,"propKey":"variant","propValue":"primary"},
    {"widgetId":3,"propKey":"size","propValue":"large"}
  ]' | json_pp

# 5d. Get Properties by Widget
curl -s "$BASE/api/builder/widget-properties/widget/1" | json_pp

# 5e. Update Property
curl -s -X PUT "$BASE/api/builder/widget-properties/1" \
  -H "Content-Type: application/json" \
  -d '{"propKey":"placeholder","propValue":"Enter your age"}' | json_pp

# 5f. Delete Property
# curl -s -X DELETE "$BASE/api/builder/widget-properties/1" | json_pp

# =============================================================
# 6. WIDGET RULES  /api/builder/widget-rules
# =============================================================

# 6a. Validation rule for age textbox
curl -s -X POST "$BASE/api/builder/widget-rules" \
  -H "Content-Type: application/json" \
  -d '{"widgetId":1,"ruleType":"validation","ruleExpression":"value >= 18"}' | json_pp

# 6b. Visibility rule for dropdown
curl -s -X POST "$BASE/api/builder/widget-rules" \
  -H "Content-Type: application/json" \
  -d '{"widgetId":2,"ruleType":"visibility","ruleExpression":"age >= 18"}' | json_pp

# 6c. Enable rule for submit button
curl -s -X POST "$BASE/api/builder/widget-rules" \
  -H "Content-Type: application/json" \
  -d '{"widgetId":3,"ruleType":"enabled","ruleExpression":"termsAccepted == true"}' | json_pp

# 6d. Get Rules by Widget
curl -s "$BASE/api/builder/widget-rules/widget/1" | json_pp

# 6e. Update Rule
curl -s -X PUT "$BASE/api/builder/widget-rules/1" \
  -H "Content-Type: application/json" \
  -d '{"ruleType":"validation","ruleExpression":"value >= 21"}' | json_pp

# 6f. Delete Rule
# curl -s -X DELETE "$BASE/api/builder/widget-rules/1" | json_pp

# =============================================================
# 7. WIDGET ACTIONS  /api/builder/widget-actions
# =============================================================

# 7a. Submit action for button (widgetId=3)
curl -s -X POST "$BASE/api/builder/widget-actions" \
  -H "Content-Type: application/json" \
  -d '{
    "widgetId": 3,
    "actionName": "submit",
    "actionType": "api_call",
    "triggerEvent": "click",
    "httpMethod": "POST",
    "endpointUrl": "/api/insurance/submit",
    "payloadTemplate": "{\"age\": \"{{age}}\", \"carBrand\": \"{{carBrand}}\"}",
    "payloadType": "dynamic",
    "headers": "{\"Content-Type\": \"application/json\"}",
    "successHandler": "navigateToPage:2:store:submitResponse",
    "errorHandler": "showMessage:Error occurred while submitting",
    "timeoutMs": 30000,
    "orderNo": 1,
    "isEnabled": "Y"
  }' | json_pp

# 7b. Data binding action for dropdown (widgetId=2)
curl -s -X POST "$BASE/api/builder/widget-actions" \
  -H "Content-Type: application/json" \
  -d '{
    "widgetId": 2,
    "actionName": "loadOptions",
    "actionType": "data_binding",
    "triggerEvent": "focus",
    "successHandler": "updateDropdown:carBrand:carBrands",
    "orderNo": 1,
    "isEnabled": "Y"
  }' | json_pp

# 7c. Get Actions by Widget
curl -s "$BASE/api/builder/widget-actions/widget/3" | json_pp

# 7d. Update Action
curl -s -X PUT "$BASE/api/builder/widget-actions/1" \
  -H "Content-Type: application/json" \
  -d '{
    "widgetId": 3,
    "actionName": "submit",
    "actionType": "api_call",
    "triggerEvent": "click",
    "httpMethod": "POST",
    "endpointUrl": "/api/insurance/submit",
    "payloadTemplate": "{\"age\": \"{{age}}\", \"carBrand\": \"{{carBrand}}\", \"terms\": \"{{termsAccepted}}\"}",
    "payloadType": "dynamic",
    "headers": "{\"Content-Type\": \"application/json\"}",
    "successHandler": "navigateToPage:2:store:submitResponse",
    "errorHandler": "showMessage:Submission failed",
    "timeoutMs": 15000,
    "orderNo": 1,
    "isEnabled": "Y"
  }' | json_pp

# 7e. Delete Action
# curl -s -X DELETE "$BASE/api/builder/widget-actions/1" | json_pp

# =============================================================
# 8. ONLOAD SERVICES  /api/builder/onload-services
# =============================================================

# 8a. Load user profile on page load
curl -s -X POST "$BASE/api/builder/onload-services" \
  -H "Content-Type: application/json" \
  -d '{
    "pageId": 1,
    "serviceId": "USER_DATA_SERVICE",
    "api": "/api/user/profile",
    "httpMethod": "GET",
    "headers": "{\"Content-Type\": \"application/json\"}",
    "serviceIdentifier": "userProfile",
    "onSuccess": "setFormData:userProfile",
    "onFailure": "showMessage:Failed to load user data"
  }' | json_pp

# 8b. Load car brands for dropdown
curl -s -X POST "$BASE/api/builder/onload-services" \
  -H "Content-Type: application/json" \
  -d '{
    "pageId": 1,
    "serviceId": "CAR_BRANDS_SERVICE",
    "api": "/api/cars/brands",
    "httpMethod": "GET",
    "headers": "{\"Content-Type\": \"application/json\"}",
    "serviceIdentifier": "carBrands",
    "onSuccess": "updateDropdown:carBrand",
    "onFailure": "showMessage:Failed to load car brands"
  }' | json_pp

# 8c. Initialize form defaults
curl -s -X POST "$BASE/api/builder/onload-services" \
  -H "Content-Type: application/json" \
  -d '{
    "pageId": 1,
    "serviceId": "INIT_FORM_SERVICE",
    "api": "/api/forms/initialize",
    "httpMethod": "POST",
    "payload": "{\"formType\": \"insurance\"}",
    "headers": "{\"Content-Type\": \"application/json\"}",
    "serviceIdentifier": "formInit",
    "onSuccess": "setFormData:formData",
    "onFailure": "showMessage:Failed to initialize form"
  }' | json_pp

# 8d. Get OnLoad Services by Page
curl -s "$BASE/api/builder/onload-services/page/1" | json_pp

# 8e. Update OnLoad Service
curl -s -X PUT "$BASE/api/builder/onload-services/1" \
  -H "Content-Type: application/json" \
  -d '{
    "serviceId": "USER_DATA_SERVICE",
    "api": "/api/user/profile",
    "httpMethod": "GET",
    "headers": "{\"Content-Type\": \"application/json\", \"Authorization\": \"Bearer token\"}",
    "serviceIdentifier": "userProfile",
    "onSuccess": "setFormData:userProfile",
    "onFailure": "showMessage:User data load failed"
  }' | json_pp

# 8f. Delete OnLoad Service
# curl -s -X DELETE "$BASE/api/builder/onload-services/1" | json_pp

# =============================================================
# 9. UI CONFIG  /api/ui-config  (read-only, fetches full tree)
# =============================================================

# 9a. Get complete UI config for product 1
curl -s "$BASE/api/ui-config/1" | json_pp

# 9b. Test POST insurance (mock endpoint on UiConfigController)
curl -s -X POST "$BASE/api/ui-config/post/ins" \
  -H "Content-Type: application/json" \
  -d '{"test":"data"}' | json_pp

# =============================================================
# 10. MOCK WEB SERVICES  /api/*  (no DB, standalone)
# =============================================================

# 10a. Health check
curl -s "$BASE/api/health" | json_pp

# 10b. Get user profile
curl -s "$BASE/api/user/profile" | json_pp

# 10c. Get car brands
curl -s "$BASE/api/cars/brands" | json_pp

# 10d. Get car brands with category filter
curl -s "$BASE/api/cars/brands?category=luxury" | json_pp

# 10e. Initialize form
curl -s -X POST "$BASE/api/forms/initialize" \
  -H "Content-Type: application/json" \
  -d '{"formType":"insurance","userId":"12345"}' | json_pp

# 10f. Get config settings
curl -s "$BASE/api/config/settings" | json_pp

# 10g. Get config settings with category
curl -s "$BASE/api/config/settings?category=motor" | json_pp

# 10h. Get validation rules
curl -s "$BASE/api/validation/rules" | json_pp

# 10i. Get users list
curl -s "$BASE/api/users/list" | json_pp

# 10j. Get profile
curl -s "$BASE/api/profile/get" | json_pp

# 10k. Submit insurance form
curl -s -X POST "$BASE/api/insurance/submit" \
  -H "Content-Type: application/json" \
  -d '{"age":25,"carBrand":"Toyota","termsAccepted":true}' | json_pp

# 10l. Submit insurance - missing fields (400 error)
curl -s -X POST "$BASE/api/insurance/submit" \
  -H "Content-Type: application/json" \
  -d '{"name":"John"}' | json_pp

# 10m. Update user profile
curl -s -X PUT "$BASE/api/user/profile" \
  -H "Content-Type: application/json" \
  -d '{"firstName":"John","lastName":"Doe","email":"john@example.com"}' | json_pp

# 10n. Delete item (success)
curl -s -X DELETE "$BASE/api/items/123" | json_pp

# 10o. Delete item (not found)
curl -s -X DELETE "$BASE/api/items/999" | json_pp

# =============================================================
# 11. SWAGGER UI
# =============================================================
# Open in browser: http://localhost:8081/swagger-ui.html
# API docs JSON:   http://localhost:8081/api-docs
