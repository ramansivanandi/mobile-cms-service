-- =====================================================================
-- WIDGET_ACTION Table - INSERT Query Examples
-- =====================================================================
-- This file contains various examples of inserting actions for components
-- Replace WIDGET_ID with the actual component ID from your WIDGET table
-- =====================================================================

-- =====================================================================
-- Example 1: Submit Button with Dynamic Payload (POST Request)
-- =====================================================================
-- This action sends form data to a backend API endpoint
-- Payload template uses {{fieldName}} placeholders that will be replaced
-- with actual form field values by the frontend
-- =====================================================================
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

-- =====================================================================
-- Example 2: Submit Button with Static Payload (POST Request)
-- =====================================================================
-- This action sends a fixed payload that doesn't change based on form data
-- Useful for actions that always send the same data
-- =====================================================================
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
    'submitStatic',
    'api_call',
    'click',
    'POST',
    '/api/insurance/submit',
    '{"action": "submit", "source": "web", "version": "1.0"}',
    'static',
    '{"Content-Type": "application/json"}',
    'navigate:/success',
    'showMessage:Submission failed',
    30000,
    1,
    'Y'
);

-- =====================================================================
-- Example 3: GET Request with Query Parameters (No Payload)
-- =====================================================================
-- This action makes a GET request with query parameters
-- No payload is sent, data is passed via query string
-- =====================================================================
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
    SEQ_ACTION_ID.NEXTVAL,
    4,  -- Replace with your WIDGET_ID
    'fetchData',
    'api_call',
    'click',
    'GET',
    '/api/insurance/details',
    NULL,
    'none',
    '{"Accept": "application/json"}',
    '{"userId": "{{userId}}", "productId": "{{productId}}"}',
    'reload',
    'showMessage:Failed to fetch data',
    20000,
    1,
    'Y'
);

-- =====================================================================
-- Example 4: PUT Request for Update Operation
-- =====================================================================
-- This action updates existing data using PUT method
-- =====================================================================
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
    5,  -- Replace with your WIDGET_ID
    'update',
    'api_call',
    'click',
    'PUT',
    '/api/insurance/update',
    '{"id": "{{id}}", "age": "{{age}}", "carBrand": "{{carBrand}}", "status": "{{status}}"}',
    'dynamic',
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
    'showMessage:Updated successfully',
    'showMessage:Update failed',
    30000,
    1,
    'Y'
);

-- =====================================================================
-- Example 5: DELETE Request
-- =====================================================================
-- This action deletes a record using DELETE method
-- =====================================================================
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
    SEQ_ACTION_ID.NEXTVAL,
    6,  -- Replace with your WIDGET_ID
    'delete',
    'api_call',
    'click',
    'DELETE',
    '/api/insurance/delete',
    NULL,
    'none',
    '{"Authorization": "Bearer {{$token}}"}',
    '{"id": "{{id}}"}',
    'navigate:/list',
    'showMessage:Delete failed',
    20000,
    1,
    'Y'
);

-- =====================================================================
-- Example 6: Navigation Action (No API Call)
-- =====================================================================
-- This action navigates to another page/route without making an API call
-- =====================================================================
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
    7,  -- Replace with your WIDGET_ID
    'navigateNext',
    'navigation',
    'click',
    NULL,
    NULL,
    NULL,
    'none',
    NULL,
    'navigate:/next-page',
    NULL,
    NULL,
    1,
    'Y'
);

-- =====================================================================
-- Example 7: Multiple Actions for Same Component (Action Sequence)
-- =====================================================================
-- A component can have multiple actions that execute in sequence
-- ORDER_NO determines the execution order
-- =====================================================================

-- First action: Validate form
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
    8,  -- Replace with your WIDGET_ID
    'validate',
    'validation',
    'click',
    NULL,
    NULL,
    NULL,
    'none',
    NULL,
    NULL,
    NULL,
    1,
    'Y'
);

-- Second action: Submit after validation (executes if validation succeeds)
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
    8,  -- Same WIDGET_ID as above
    'submit',
    'api_call',
    'click',
    'POST',
    '/api/insurance/submit',
    '{"age": "{{age}}", "carBrand": "{{carBrand}}"}',
    'dynamic',
    '{"Content-Type": "application/json"}',
    'navigate:/success',
    'showMessage:Submission failed',
    30000,
    2,  -- Higher ORDER_NO means executes after action with ORDER_NO = 1
    'Y',
    'validation.success == true'  -- Only execute if validation succeeds
);

-- =====================================================================
-- Example 8: Action with Conditional Expression
-- =====================================================================
-- This action only executes if a condition is met
-- CONDITION_EXPRESSION is evaluated by the frontend
-- =====================================================================
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
    9,  -- Replace with your WIDGET_ID
    'conditionalSubmit',
    'api_call',
    'click',
    'POST',
    '/api/insurance/submit',
    '{"age": "{{age}}", "carBrand": "{{carBrand}}"}',
    'dynamic',
    '{"Content-Type": "application/json"}',
    'navigate:/success',
    'showMessage:Submission failed',
    30000,
    1,
    'Y',
    'age >= 18 && carBrand != null'  -- Only submit if age is 18+ and carBrand is selected
);

-- =====================================================================
-- Example 9: Complex Payload with Nested Objects
-- =====================================================================
-- This example shows a complex payload structure with nested objects
-- =====================================================================
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
    10,  -- Replace with your WIDGET_ID
    'submitComplex',
    'api_call',
    'click',
    'POST',
    '/api/insurance/submit',
    '{
        "personalInfo": {
            "age": "{{age}}",
            "name": "{{name}}",
            "email": "{{email}}"
        },
        "vehicleInfo": {
            "carBrand": "{{carBrand}}",
            "model": "{{model}}",
            "year": "{{year}}"
        },
        "metadata": {
            "timestamp": "{{$timestamp}}",
            "userId": "{{$user.id}}",
            "source": "web"
        }
    }',
    'dynamic',
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}", "X-Request-ID": "{{$requestId}}"}',
    'navigate:/success',
    'showMessage:Submission failed',
    30000,
    1,
    'Y'
);

-- =====================================================================
-- Example 10: Disabled Action (Not Active)
-- =====================================================================
-- This action is disabled and won't be returned in the API response
-- Useful for temporarily disabling actions without deleting them
-- =====================================================================
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
    11,  -- Replace with your WIDGET_ID
    'disabledAction',
    'api_call',
    'click',
    'POST',
    '/api/insurance/submit',
    '{"data": "{{data}}"}',
    'dynamic',
    '{"Content-Type": "application/json"}',
    'navigate:/success',
    'showMessage:Error',
    30000,
    1,
    'N'  -- Disabled - won't appear in API response
);

-- =====================================================================
-- Example 11: Action with Custom Timeout
-- =====================================================================
-- This action has a custom timeout (longer than default 30 seconds)
-- Useful for operations that take longer to complete
-- =====================================================================
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
    12,  -- Replace with your WIDGET_ID
    'longRunningOperation',
    'api_call',
    'click',
    'POST',
    '/api/insurance/process',
    '{"data": "{{data}}"}',
    'dynamic',
    '{"Content-Type": "application/json"}',
    'showMessage:Processing completed',
    'showMessage:Processing failed',
    60000,  -- 60 seconds timeout
    1,
    'Y'
);

-- =====================================================================
-- Example 12: Action Triggered on Different Event (Not Click)
-- =====================================================================
-- Actions can be triggered by different events like 'change', 'blur', etc.
-- =====================================================================
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
    13,  -- Replace with your WIDGET_ID
    'autoSave',
    'api_call',
    'blur',  -- Triggered when field loses focus
    'POST',
    '/api/insurance/autosave',
    '{"fieldName": "{{name}}", "fieldValue": "{{value}}"}',
    'dynamic',
    '{"Content-Type": "application/json"}',
    NULL,  -- No success handler - silent save
    NULL,  -- No error handler - fail silently
    10000,
    1,
    'Y'
);

COMMIT;

-- =====================================================================
-- NOTES:
-- =====================================================================
-- 1. Replace WIDGET_ID values with actual component IDs from WIDGET table
-- 2. PAYLOAD_TEMPLATE uses {{fieldName}} for dynamic values and {{$variable}} for system variables
-- 3. HEADERS and QUERY_PARAMS are stored as JSON strings
-- 4. IS_ENABLED = 'Y' means action is active, 'N' means disabled
-- 5. ORDER_NO determines execution order when multiple actions exist
-- 6. CONDITION_EXPRESSION is evaluated by frontend (JavaScript expression)
-- 7. TRIGGER_EVENT can be: 'click', 'change', 'blur', 'focus', etc.
-- 8. ACTION_TYPE can be: 'api_call', 'navigation', 'form_submit', 'validation', 'custom'
-- 9. PAYLOAD_TYPE can be: 'dynamic', 'static', or 'none'
-- 10. TIMEOUT_MS is in milliseconds (default: 30000 = 30 seconds)
-- =====================================================================

