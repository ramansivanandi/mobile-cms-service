-- =====================================================================
-- INSERT Query Examples for Widget Tables
-- =====================================================================
-- This file contains INSERT query examples for the newly created/renamed tables:
-- - WIDGET (renamed from UI_COMPONENT)
-- - WIDGET_PROPS (renamed from UI_COMPONENT_PROPS)
-- - WIDGET_RULE (renamed from UI_COMPONENT_RULE)
-- - WIDGET_ACTION (renamed from UI_COMPONENT_ACTION)
-- - ON_LOAD_SERVICE (newly created)
-- =====================================================================

-- =====================================================================
-- 1. WIDGET Table - INSERT Query Examples
-- =====================================================================
-- Replace PAGE_ID with the actual page ID from your PAGE table
-- =====================================================================

-- Example 1: Textbox Widget
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 1, 'textbox', 'age', 'Age', 1);

-- Example 2: Dropdown Widget
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 1, 'dropdown', 'carBrand', 'Car Brand', 2);

-- Example 3: Button Widget
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 1, 'button', 'submit', 'Submit', 3);

-- Example 4: Checkbox Widget
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 1, 'checkbox', 'termsAccepted', 'Accept Terms', 4);

-- Example 5: Radio Button Widget
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 1, 'radio', 'gender', 'Gender', 5);

-- =====================================================================
-- 2. WIDGET_PROPS Table - INSERT Query Examples
-- =====================================================================
-- Replace WIDGET_ID with the actual widget ID from your WIDGET table
-- =====================================================================

-- Example 1: Properties for a textbox widget (WIDGET_ID = 1)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 1, 'placeholder', 'Enter age');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 1, 'required', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 1, 'min', '1');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 1, 'max', '100');

-- Example 2: Properties for a dropdown widget (WIDGET_ID = 2)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 2, 'placeholder', 'Select car brand');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 2, 'required', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 2, 'multiple', 'false');

-- Example 3: Properties for a button widget (WIDGET_ID = 3)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 3, 'variant', 'primary');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 3, 'size', 'large');

-- =====================================================================
-- 3. WIDGET_RULE Table - INSERT Query Examples
-- =====================================================================
-- Replace WIDGET_ID with the actual widget ID from your WIDGET table
-- =====================================================================

-- Example 1: Validation rule for age textbox (WIDGET_ID = 1)
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (SEQ_RULE_ID.NEXTVAL, 1, 'validation', 'value >= 18');

-- Example 2: Visibility rule
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (SEQ_RULE_ID.NEXTVAL, 2, 'visibility', 'age >= 18');

-- Example 3: Enable/Disable rule
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (SEQ_RULE_ID.NEXTVAL, 3, 'enabled', 'termsAccepted == true');

-- Example 4: Format rule
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (SEQ_RULE_ID.NEXTVAL, 1, 'format', 'value.match(/^[0-9]+$/)');

-- =====================================================================
-- 4. WIDGET_ACTION Table - INSERT Query Examples
-- =====================================================================
-- Replace WIDGET_ID with the actual widget ID from your WIDGET table
-- =====================================================================

-- Example 1: Submit Button Action with Dynamic Payload (POST Request)
INSERT INTO WIDGET_ACTION (
    ACTION_ID,
    WIDGET_ID,
    ACTION_NAME,
    ACTION_TYPE,
    TRIGGER_EVENT,
    HTTP_METHOD,
    ENDPOINT_URL,
    PAYLOAD_TEMPLATE,
    PAYLOAD_TYPE,
    HEADERS,
    SUCCESS_HANDLER,
    ERROR_HANDLER,
    TIMEOUT_MS,
    ORDER_NO,
    IS_ENABLED
) VALUES (
    SEQ_ACTION_ID.NEXTVAL,
    3,  -- Replace with your WIDGET_ID
    'submit',
    'api_call',
    'click',
    'POST',
    '/api/insurance/submit',
    '{"age": "{{age}}", "carBrand": "{{carBrand}}", "timestamp": "{{$timestamp}}"}',
    'dynamic',
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
    'navigate:/success',
    'showMessage:Error occurred while submitting',
    30000,
    1,
    'Y'
);

-- Example 2: GET Request Action
INSERT INTO WIDGET_ACTION (
    ACTION_ID,
    WIDGET_ID,
    ACTION_NAME,
    ACTION_TYPE,
    TRIGGER_EVENT,
    HTTP_METHOD,
    ENDPOINT_URL,
    QUERY_PARAMS,
    HEADERS,
    SUCCESS_HANDLER,
    ERROR_HANDLER,
    TIMEOUT_MS,
    ORDER_NO,
    IS_ENABLED
) VALUES (
    SEQ_ACTION_ID.NEXTVAL,
    2,  -- Replace with your WIDGET_ID
    'loadOptions',
    'api_call',
    'focus',
    'GET',
    '/api/cars/brands',
    '{"category": "{{carCategory}}"}',
    '{"Content-Type": "application/json"}',
    'updateDropdown:carBrand',
    'showMessage:Failed to load options',
    20000,
    1,
    'Y'
);

-- Example 3: PUT Request Action
INSERT INTO WIDGET_ACTION (
    ACTION_ID,
    WIDGET_ID,
    ACTION_NAME,
    ACTION_TYPE,
    TRIGGER_EVENT,
    HTTP_METHOD,
    ENDPOINT_URL,
    PAYLOAD_TEMPLATE,
    PAYLOAD_TYPE,
    HEADERS,
    SUCCESS_HANDLER,
    ERROR_HANDLER,
    TIMEOUT_MS,
    ORDER_NO,
    IS_ENABLED,
    CONDITION_EXPRESSION
) VALUES (
    SEQ_ACTION_ID.NEXTVAL,
    1,  -- Replace with your WIDGET_ID
    'updateProfile',
    'api_call',
    'blur',
    'PUT',
    '/api/user/profile',
    '{"age": "{{age}}"}',
    'dynamic',
    '{"Content-Type": "application/json"}',
    'showMessage:Profile updated successfully',
    'showMessage:Failed to update profile',
    25000,
    1,
    'Y',
    'age != null && age.length > 0'
);

-- Example 4: DELETE Request Action
INSERT INTO WIDGET_ACTION (
    ACTION_ID,
    WIDGET_ID,
    ACTION_NAME,
    ACTION_TYPE,
    TRIGGER_EVENT,
    HTTP_METHOD,
    ENDPOINT_URL,
    HEADERS,
    SUCCESS_HANDLER,
    ERROR_HANDLER,
    TIMEOUT_MS,
    ORDER_NO,
    IS_ENABLED
) VALUES (
    SEQ_ACTION_ID.NEXTVAL,
    4,  -- Replace with your WIDGET_ID
    'deleteItem',
    'api_call',
    'click',
    'DELETE',
    '/api/items/{{itemId}}',
    '{"Authorization": "Bearer {{$token}}"}',
    'refreshList',
    'showMessage:Failed to delete item',
    15000,
    1,
    'Y'
);

-- =====================================================================
-- 5. ON_LOAD_SERVICE Table - INSERT Query Examples
-- =====================================================================
-- Replace PAGE_ID with the actual page ID from your PAGE table
-- This table stores services that need to be called when a page loads
-- =====================================================================

-- Example 1: Load User Data on Page Load (GET Request)
INSERT INTO ON_LOAD_SERVICE (
    ON_LOAD_SERVICE_ID,
    PAGE_ID,
    SERVICE_ID,
    API,
    HTTP_METHOD,
    PAYLOAD,
    HEADERS,
    SERVICE_IDENTIFIER,
    ON_SUCCESS,
    ON_FAILURE
) VALUES (
    SEQ_ON_LOAD_SERVICE_ID.NEXTVAL,
    1,  -- Replace with your PAGE_ID
    'USER_DATA_SERVICE',
    '/api/user/profile',
    'GET',
    NULL,
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
    'userProfile',
    'setFormData:userProfile',
    'showMessage:Failed to load user data'
);

-- Example 2: Load Dropdown Options on Page Load (GET Request)
INSERT INTO ON_LOAD_SERVICE (
    ON_LOAD_SERVICE_ID,
    PAGE_ID,
    SERVICE_ID,
    API,
    HTTP_METHOD,
    PAYLOAD,
    HEADERS,
    SERVICE_IDENTIFIER,
    ON_SUCCESS,
    ON_FAILURE
) VALUES (
    SEQ_ON_LOAD_SERVICE_ID.NEXTVAL,
    1,  -- Replace with your PAGE_ID
    'CAR_BRANDS_SERVICE',
    '/api/cars/brands',
    'GET',
    NULL,
    '{"Content-Type": "application/json"}',
    'carBrands',
    'updateDropdown:carBrand',
    'showMessage:Failed to load car brands'
);

-- Example 3: Initialize Form with Default Values (POST Request)
INSERT INTO ON_LOAD_SERVICE (
    ON_LOAD_SERVICE_ID,
    PAGE_ID,
    SERVICE_ID,
    API,
    HTTP_METHOD,
    PAYLOAD,
    HEADERS,
    SERVICE_IDENTIFIER,
    ON_SUCCESS,
    ON_FAILURE
) VALUES (
    SEQ_ON_LOAD_SERVICE_ID.NEXTVAL,
    1,  -- Replace with your PAGE_ID
    'INIT_FORM_SERVICE',
    '/api/forms/initialize',
    'POST',
    '{"formType": "insurance", "userId": "{{$userId}}"}',
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
    'formInit',
    'setFormData:formData',
    'showMessage:Failed to initialize form'
);

-- Example 4: Load Configuration Data (GET Request with Query Params)
INSERT INTO ON_LOAD_SERVICE (
    ON_LOAD_SERVICE_ID,
    PAGE_ID,
    SERVICE_ID,
    API,
    HTTP_METHOD,
    PAYLOAD,
    HEADERS,
    SERVICE_IDENTIFIER,
    ON_SUCCESS,
    ON_FAILURE
) VALUES (
    SEQ_ON_LOAD_SERVICE_ID.NEXTVAL,
    1,  -- Replace with your PAGE_ID
    'CONFIG_SERVICE',
    '/api/config/settings?category=motor',
    'GET',
    NULL,
    '{"Content-Type": "application/json"}',
    'appConfig',
    'setGlobalConfig:config',
    'showMessage:Failed to load configuration'
);

-- Example 5: Multiple Services for Same Page
-- You can have multiple ON_LOAD_SERVICE entries for the same PAGE_ID
-- They will be executed in the order they are retrieved (or based on your application logic)

INSERT INTO ON_LOAD_SERVICE (
    ON_LOAD_SERVICE_ID,
    PAGE_ID,
    SERVICE_ID,
    API,
    HTTP_METHOD,
    PAYLOAD,
    HEADERS,
    SERVICE_IDENTIFIER,
    ON_SUCCESS,
    ON_FAILURE
) VALUES (
    SEQ_ON_LOAD_SERVICE_ID.NEXTVAL,
    1,  -- Same PAGE_ID as above
    'VALIDATION_RULES_SERVICE',
    '/api/validation/rules',
    'GET',
    NULL,
    '{"Content-Type": "application/json"}',
    'validationRules',
    'setValidationRules:rules',
    'showMessage:Failed to load validation rules'
);

-- =====================================================================
-- Notes:
-- =====================================================================
-- 1. Replace WIDGET_ID values with actual widget IDs from your WIDGET table
-- 2. Replace PAGE_ID values with actual page IDs from your PAGE table
-- 3. SERVICE_ID in ON_LOAD_SERVICE should be unique identifiers for each service
-- 4. The PAYLOAD and HEADERS fields can contain JSON strings with template variables
-- 5. Template variables like {{fieldName}} will be replaced at runtime
-- 6. System variables like {{$token}}, {{$userId}}, {{$timestamp}} are available
-- 7. ON_SUCCESS and ON_FAILURE handlers define what to do after service execution
-- 8. Multiple ON_LOAD_SERVICE entries can exist for the same PAGE_ID
-- =====================================================================

COMMIT;

