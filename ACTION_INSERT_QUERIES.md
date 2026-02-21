# UI_COMPONENT_ACTION - Quick Insert Query Reference

## Basic Template

```sql
INSERT INTO UI_COMPONENT_ACTION (
    ACTION_ID,
    COMPONENT_ID,
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
    <COMPONENT_ID>,           -- Replace with actual component ID
    '<action_name>',           -- e.g., 'submit', 'cancel', 'save'
    'api_call',                -- or 'navigation', 'form_submit', 'validation'
    'click',                   -- or 'change', 'blur', 'focus'
    'POST',                    -- GET, POST, PUT, DELETE, PATCH
    '/api/endpoint',           -- Backend endpoint URL
    '{"field": "{{fieldName}}"}',  -- JSON payload template
    'dynamic',                 -- 'dynamic', 'static', or 'none'
    '{"Content-Type": "application/json"}',  -- Headers as JSON
    'navigate:/success',       -- Success handler
    'showMessage:Error',       -- Error handler
    30000,                     -- Timeout in milliseconds
    1,                         -- Execution order
    'Y'                        -- 'Y' for enabled, 'N' for disabled
);
```

## Common Use Cases

### 1. Simple POST with Dynamic Payload
```sql
INSERT INTO UI_COMPONENT_ACTION (
    ACTION_ID, COMPONENT_ID, ACTION_NAME, ACTION_TYPE, TRIGGER_EVENT,
    HTTP_METHOD, ENDPOINT_URL, PAYLOAD_TEMPLATE, PAYLOAD_TYPE,
    HEADERS, SUCCESS_HANDLER, ERROR_HANDLER, TIMEOUT_MS, ORDER_NO, IS_ENABLED
) VALUES (
    SEQ_ACTION_ID.NEXTVAL, 3, 'submit', 'api_call', 'click',
    'POST', '/api/submit',
    '{"age": "{{age}}", "carBrand": "{{carBrand}}"}',
    'dynamic',
    '{"Content-Type": "application/json"}',
    'navigate:/success', 'showMessage:Error', 30000, 1, 'Y'
);
```

### 2. GET Request with Query Parameters
```sql
INSERT INTO UI_COMPONENT_ACTION (
    ACTION_ID, COMPONENT_ID, ACTION_NAME, ACTION_TYPE, TRIGGER_EVENT,
    HTTP_METHOD, ENDPOINT_URL, PAYLOAD_TYPE, QUERY_PARAMS,
    SUCCESS_HANDLER, ERROR_HANDLER, TIMEOUT_MS, ORDER_NO, IS_ENABLED
) VALUES (
    SEQ_ACTION_ID.NEXTVAL, 4, 'fetch', 'api_call', 'click',
    'GET', '/api/data', 'none',
    '{"id": "{{id}}", "type": "{{type}}"}',
    'reload', 'showMessage:Failed', 20000, 1, 'Y'
);
```

### 3. Navigation Action (No API Call)
```sql
INSERT INTO UI_COMPONENT_ACTION (
    ACTION_ID, COMPONENT_ID, ACTION_NAME, ACTION_TYPE, TRIGGER_EVENT,
    PAYLOAD_TYPE, SUCCESS_HANDLER, ORDER_NO, IS_ENABLED
) VALUES (
    SEQ_ACTION_ID.NEXTVAL, 5, 'navigate', 'navigation', 'click',
    'none', 'navigate:/next-page', 1, 'Y'
);
```

### 4. Static Payload (No Placeholders)
```sql
INSERT INTO UI_COMPONENT_ACTION (
    ACTION_ID, COMPONENT_ID, ACTION_NAME, ACTION_TYPE, TRIGGER_EVENT,
    HTTP_METHOD, ENDPOINT_URL, PAYLOAD_TEMPLATE, PAYLOAD_TYPE,
    HEADERS, SUCCESS_HANDLER, ERROR_HANDLER, TIMEOUT_MS, ORDER_NO, IS_ENABLED
) VALUES (
    SEQ_ACTION_ID.NEXTVAL, 6, 'submit', 'api_call', 'click',
    'POST', '/api/submit',
    '{"action": "submit", "source": "web"}',
    'static',
    '{"Content-Type": "application/json"}',
    'navigate:/success', 'showMessage:Error', 30000, 1, 'Y'
);
```

### 5. Action with Conditional Expression
```sql
INSERT INTO UI_COMPONENT_ACTION (
    ACTION_ID, COMPONENT_ID, ACTION_NAME, ACTION_TYPE, TRIGGER_EVENT,
    HTTP_METHOD, ENDPOINT_URL, PAYLOAD_TEMPLATE, PAYLOAD_TYPE,
    HEADERS, SUCCESS_HANDLER, ERROR_HANDLER, TIMEOUT_MS, ORDER_NO,
    IS_ENABLED, CONDITION_EXPRESSION
) VALUES (
    SEQ_ACTION_ID.NEXTVAL, 7, 'submit', 'api_call', 'click',
    'POST', '/api/submit',
    '{"age": "{{age}}", "carBrand": "{{carBrand}}"}',
    'dynamic',
    '{"Content-Type": "application/json"}',
    'navigate:/success', 'showMessage:Error', 30000, 1,
    'Y', 'age >= 18 && carBrand != null'
);
```

## Field Descriptions

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `ACTION_ID` | NUMBER | Yes | Primary key (use sequence) | `SEQ_ACTION_ID.NEXTVAL` |
| `COMPONENT_ID` | NUMBER | Yes | Foreign key to UI_COMPONENT | `3` |
| `ACTION_NAME` | VARCHAR2(100) | Yes | Unique name for the action | `'submit'` |
| `ACTION_TYPE` | VARCHAR2(50) | Yes | Type: api_call, navigation, etc. | `'api_call'` |
| `TRIGGER_EVENT` | VARCHAR2(50) | No | Event: click, change, blur | `'click'` |
| `HTTP_METHOD` | VARCHAR2(10) | No | GET, POST, PUT, DELETE, PATCH | `'POST'` |
| `ENDPOINT_URL` | VARCHAR2(1000) | No | Backend API endpoint | `'/api/submit'` |
| `PAYLOAD_TEMPLATE` | CLOB | No | JSON template with placeholders | `'{"age": "{{age}}"}'` |
| `PAYLOAD_TYPE` | VARCHAR2(20) | No | dynamic, static, or none | `'dynamic'` |
| `HEADERS` | CLOB | No | HTTP headers as JSON | `'{"Content-Type": "application/json"}'` |
| `QUERY_PARAMS` | CLOB | No | Query params as JSON | `'{"id": "{{id}}"}'` |
| `SUCCESS_HANDLER` | VARCHAR2(500) | No | Action on success | `'navigate:/success'` |
| `ERROR_HANDLER` | VARCHAR2(500) | No | Action on error | `'showMessage:Error'` |
| `TIMEOUT_MS` | NUMBER | No | Request timeout (ms) | `30000` |
| `ORDER_NO` | NUMBER | No | Execution order | `1` |
| `IS_ENABLED` | CHAR(1) | No | Y or N | `'Y'` |
| `CONDITION_EXPRESSION` | VARCHAR2(500) | No | Conditional execution | `'age >= 18'` |

## Payload Template Placeholders

- **Field Values**: `{{fieldName}}` - Replaced with form field value
- **System Variables**: 
  - `{{$timestamp}}` - Current timestamp
  - `{{$user.id}}` - Current user ID
  - `{{$token}}` - Authentication token
  - `{{$requestId}}` - Request ID

## Handler Formats

- **Navigation**: `navigate:/path` - Navigate to route
- **Message**: `showMessage:Your message` - Display message
- **Reload**: `reload` - Reload current page

## Complete Example File

For comprehensive examples with all scenarios, see:
`src/main/resources/db/oracle/action-examples.sql`

