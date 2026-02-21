-- =====================================================================
-- Complete INSERT Data Script - Ready to Run
-- =====================================================================
-- This script contains all INSERT statements with actual ID values
-- No sequences - all IDs are hardcoded for direct execution
-- Run this after tables are created by Hibernate
-- =====================================================================

-- =====================================================================
-- 1. PRODUCT Table
-- =====================================================================
INSERT INTO PRODUCT (PRODUCT_ID, NAME, DESCRIPTION) VALUES (1, 'Insurance', 'Insurance Product Configuration');

-- =====================================================================
-- 2. CATEGORY Table
-- =====================================================================
INSERT INTO CATEGORY (CATEGORY_ID, PRODUCT_ID, NAME, DESCRIPTION) 
VALUES (1, 1, 'Motor Insurance', 'Motor Insurance Category');

-- =====================================================================
-- 3. PAGE Table
-- =====================================================================
INSERT INTO PAGE (PAGE_ID, CATEGORY_ID, TITLE, ORDER_NO, LAYOUT_TYPE, COLUMNS_PER_ROW) 
VALUES (1, 1, 'Personal Info', 1, 'horizontal', 2);

-- =====================================================================
-- 4. WIDGET Table
-- =====================================================================
-- Widget 1: Textbox for age
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (1, 1, 'textbox', 'age', 'Age', 1);

-- Widget 2: Dropdown for carBrand
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (2, 1, 'dropdown', 'carBrand', 'Car Brand', 2);

-- Widget 3: Submit button
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (3, 1, 'button', 'submit', 'Submit', 3);

-- Widget 4: Checkbox for terms
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (4, 1, 'checkbox', 'termsAccepted', 'Accept Terms and Conditions', 4);

-- =====================================================================
-- 5. WIDGET_PROPS Table
-- =====================================================================
-- Properties for age textbox (WIDGET_ID = 1)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (1, 1, 'placeholder', 'Enter age');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (2, 1, 'required', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (3, 1, 'min', '1');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (4, 1, 'max', '100');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (32, 1, 'width', '50');

-- Properties for carBrand dropdown (WIDGET_ID = 2)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (5, 2, 'placeholder', 'Select car brand');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (6, 2, 'required', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (7, 2, 'multiple', 'false');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (33, 2, 'width', '50');

-- Properties for submit button (WIDGET_ID = 3)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (8, 3, 'variant', 'primary');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (9, 3, 'size', 'large');

-- Properties for terms checkbox (WIDGET_ID = 4)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (15, 4, 'required', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (34, 4, 'showTermsLink', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (35, 4, 'termsLinkText', 'Terms and Conditions');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (36, 4, 'termsTitle', 'Terms and Conditions');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (37, 4, 'termsContent', '<h3>Terms and Conditions</h3><p>By using this service, you agree to the following terms and conditions:</p><h3>1. Eligibility</h3><p>You must be at least 18 years old to use this service. By using this service, you represent and warrant that you are of legal age.</p><h3>2. Use of Service</h3><p>You agree to use this service only for lawful purposes and in accordance with these Terms and Conditions. You agree not to use the service in any way that could damage, disable, overburden, or impair the service.</p><h3>3. Information Accuracy</h3><p>You are responsible for ensuring that all information you provide is accurate, current, and complete. You agree to update your information as necessary.</p><h3>4. Privacy</h3><p>Your use of this service is also governed by our Privacy Policy. Please review our Privacy Policy to understand our practices.</p><h3>5. Limitation of Liability</h3><p>To the fullest extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of this service.</p><h3>6. Changes to Terms</h3><p>We reserve the right to modify these Terms and Conditions at any time. Your continued use of the service after any changes constitutes your acceptance of the new Terms and Conditions.</p>');

-- =====================================================================
-- 6. WIDGET_RULE Table
-- =====================================================================
-- Validation rule for age textbox (WIDGET_ID = 1)
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (1, 1, 'validation', 'value >= 18');

-- Visibility rule for carBrand (WIDGET_ID = 2)
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (2, 2, 'visibility', 'age >= 18');

-- Enable/Disable rule for submit button (WIDGET_ID = 3)
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (3, 3, 'enabled', 'termsAccepted == true');

-- =====================================================================
-- 7. UI_DATA_SOURCE Table
-- =====================================================================
-- Note: carBrand dropdown (WIDGET_ID = 2) loads data dynamically from REST service
-- No static data source needed - data comes from /api/cars/brands via ON_LOAD_SERVICE
-- This table is left empty for this example, but can be used for other widgets that need static data

-- =====================================================================
-- 8. WIDGET_ACTION Table
-- =====================================================================
-- Action for submit button (WIDGET_ID = 3)
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
    1,
    3,
    'submit',
    'api_call',
    'click',
    'POST',
    '/api/insurance/submit',
    '{"age": "{{age}}", "carBrand": "{{carBrand}}", "timestamp": "{{$timestamp}}"}',
    'dynamic',
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
    'navigateToPage:2:store:submitResponse',
    'showMessage:Error occurred while submitting',
    30000,
    1,
    'Y'
);

-- Action for carBrand dropdown - use data from onLoadService (WIDGET_ID = 2)
-- This action uses data already loaded from CAR_BRANDS_SERVICE onLoadService
-- No API call needed - just reference the serviceIdentifier
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
    QUERY_PARAMS,
    SUCCESS_HANDLER,
    ERROR_HANDLER,
    TIMEOUT_MS,
    ORDER_NO,
    IS_ENABLED
) VALUES (
    2,
    2,
    'loadOptions',
    'data_binding',
    'focus',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    'updateDropdown:carBrand:carBrands',
    NULL,
    NULL,
    1,
    'Y'
);

-- =====================================================================
-- 9. ON_LOAD_SERVICE Table
-- =====================================================================
-- Service 1: Load User Data on Page Load (GET Request)
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
    1,
    1,
    'USER_DATA_SERVICE',
    '/api/user/profile',
    'GET',
    NULL,
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
    'userProfile',
    'setFormData:userProfile',
    'showMessage:Failed to load user data'
);

-- Service 2: Load Car Brands Dropdown Options on Page Load (GET Request)
-- This service loads car brands when the page loads and populates the dropdown
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
    2,
    1,
    'CAR_BRANDS_SERVICE',
    '/api/cars/brands',
    'GET',
    NULL,
    '{"Content-Type": "application/json"}',
    'carBrands',
    'updateDropdown:carBrand',
    'showMessage:Failed to load car brands'
);

-- Service 3: Initialize Form with Default Values (POST Request)
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
    3,
    1,
    'INIT_FORM_SERVICE',
    '/api/forms/initialize',
    'POST',
    '{"formType": "insurance", "userId": "{{$userId}}"}',
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
    'formInit',
    'setFormData:formData',
    'showMessage:Failed to initialize form'
);

-- Service 4: Load Configuration Data (GET Request)
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
    4,
    1,
    'CONFIG_SERVICE',
    '/api/config/settings?category=motor',
    'GET',
    NULL,
    '{"Content-Type": "application/json"}',
    'appConfig',
    'setGlobalConfig:config',
    'showMessage:Failed to load configuration'
);

-- Service 5: Load Validation Rules (GET Request)
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
    5,
    1,
    'VALIDATION_RULES_SERVICE',
    '/api/validation/rules',
    'GET',
    NULL,
    '{"Content-Type": "application/json"}',
    'validationRules',
    'setValidationRules:rules',
    'showMessage:Failed to load validation rules'
);

COMMIT;

-- =====================================================================
-- Verification Queries
-- =====================================================================
-- Run these to verify data was inserted correctly:

-- SELECT COUNT(*) FROM PRODUCT;
-- SELECT COUNT(*) FROM CATEGORY;
-- SELECT COUNT(*) FROM PAGE;
-- SELECT COUNT(*) FROM WIDGET;
-- SELECT COUNT(*) FROM WIDGET_PROPS;
-- SELECT COUNT(*) FROM WIDGET_RULE;
-- SELECT COUNT(*) FROM UI_DATA_SOURCE;
-- SELECT COUNT(*) FROM WIDGET_ACTION;
-- SELECT COUNT(*) FROM ON_LOAD_SERVICE;

-- =====================================================================
-- Notes:
-- =====================================================================
-- 1. carBrand dropdown (WIDGET_ID = 2) loads data from REST service:
--    - On page load: via ON_LOAD_SERVICE (CAR_BRANDS_SERVICE) - calls /api/cars/brands
--    - On focus: via WIDGET_ACTION (loadOptions) - uses data already loaded from onLoadService
--      Action type is 'data_binding' - no API call, just references serviceIdentifier 'carBrands'
-- 2. No static data source is used for carBrand dropdown
-- 3. The REST service response should be in the format:
--    [{"id": "1", "name": "Toyota", "country": "Japan"}, ...]
-- 4. Frontend should:
--    - On page load: Call CAR_BRANDS_SERVICE and store result with serviceIdentifier 'carBrands'
--    - On focus: Use the stored data from 'carBrands' to populate dropdown (no API call needed)
-- =====================================================================

