# Dynamic UI Configuration - Developer Guide

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Database Schema](#database-schema)
4. [Widget Types and Properties](#widget-types-and-properties)
5. [Rules Configuration](#rules-configuration)
6. [Actions Configuration](#actions-configuration)
7. [OnLoad Services](#onload-services)
8. [API Response Format](#api-response-format)
9. [Configuration Examples](#configuration-examples)
10. [Best Practices](#best-practices)

---

## Overview

This Dynamic UI Configuration system allows you to build dynamic, data-driven user interfaces by configuring widgets, rules, actions, and services in a database. The system consists of:

- **Spring Boot Backend**: Provides REST APIs to fetch UI configuration and mock services
- **Angular Frontend**: Dynamically renders UI based on configuration from the backend
- **Oracle Database**: Stores all UI configuration (widgets, properties, rules, actions, services)

---

## Architecture

### System Flow
1. Angular frontend requests UI configuration from Spring Boot API
2. Spring Boot queries database and returns JSON configuration
3. Angular dynamically renders widgets based on configuration
4. User interactions trigger actions (API calls, navigation, data binding)
5. OnLoad services execute when pages load
6. Rules dynamically control widget visibility, enabled state, and validation

### Key Components
- **Product**: Top-level entity (e.g., "Insurance")
- **Category**: Groups related pages (e.g., "Motor Insurance")
- **Page**: A single screen/form (e.g., "Personal Info")
- **Widget**: UI components (textbox, dropdown, button, etc.)
- **WidgetProps**: Properties that configure widget behavior
- **WidgetRule**: Rules for visibility, enabled state, and validation
- **WidgetAction**: Actions triggered by user interactions
- **OnLoadService**: Services executed when a page loads

---

## Database Schema

### Core Tables

#### PRODUCT
- `PRODUCT_ID` (NUMBER, PK)
- `NAME` (VARCHAR2)
- `DESCRIPTION` (VARCHAR2)

#### CATEGORY
- `CATEGORY_ID` (NUMBER, PK)
- `PRODUCT_ID` (NUMBER, FK → PRODUCT)
- `NAME` (VARCHAR2)
- `DESCRIPTION` (VARCHAR2)

#### PAGE
- `PAGE_ID` (NUMBER, PK)
- `CATEGORY_ID` (NUMBER, FK → CATEGORY)
- `TITLE` (VARCHAR2)
- `ORDER_NO` (NUMBER)
- `LAYOUT_TYPE` (VARCHAR2) - **See Layout Types below**
- `COLUMNS_PER_ROW` (NUMBER) - Number of columns per row (for horizontal layout)

#### WIDGET
- `WIDGET_ID` (NUMBER, PK)
- `PAGE_ID` (NUMBER, FK → PAGE)
- `TYPE` (VARCHAR2) - **See Widget Types below**
- `NAME` (VARCHAR2) - Unique identifier for the widget
- `LABEL` (VARCHAR2) - Display label
- `ORDER_NO` (NUMBER) - Display order

#### WIDGET_PROPS
- `PROP_ID` (NUMBER, PK)
- `WIDGET_ID` (NUMBER, FK → WIDGET)
- `PROP_KEY` (VARCHAR2) - Property name
- `PROP_VALUE` (VARCHAR2) - Property value

#### WIDGET_RULE
- `RULE_ID` (NUMBER, PK)
- `WIDGET_ID` (NUMBER, FK → WIDGET)
- `RULE_TYPE` (VARCHAR2) - **See Rule Types below**
- `RULE_EXPRESSION` (VARCHAR2) - JavaScript expression

#### WIDGET_ACTION
- `ACTION_ID` (NUMBER, PK)
- `WIDGET_ID` (NUMBER, FK → WIDGET)
- `ACTION_NAME` (VARCHAR2)
- `ACTION_TYPE` (VARCHAR2) - **See Action Types below**
- `TRIGGER_EVENT` (VARCHAR2) - **See Trigger Events below**
- `HTTP_METHOD` (VARCHAR2) - **See HTTP Methods below**
- `ENDPOINT_URL` (VARCHAR2)
- `PAYLOAD_TEMPLATE` (CLOB) - JSON template with variables
- `PAYLOAD_TYPE` (VARCHAR2) - `'static'` or `'dynamic'`
- `HEADERS` (CLOB) - JSON object
- `QUERY_PARAMS` (CLOB) - JSON object
- `SUCCESS_HANDLER` (VARCHAR2) - **See Success Handlers below**
- `ERROR_HANDLER` (VARCHAR2) - **See Error Handlers below**
- `TIMEOUT_MS` (NUMBER) - Timeout in milliseconds
- `ORDER_NO` (NUMBER) - Execution order
- `IS_ENABLED` (CHAR(1)) - `'Y'` or `'N'`
- `CONDITION_EXPRESSION` (VARCHAR2) - Optional condition to execute action

#### ON_LOAD_SERVICE
- `ON_LOAD_SERVICE_ID` (NUMBER, PK)
- `PAGE_ID` (NUMBER, FK → PAGE)
- `SERVICE_ID` (VARCHAR2) - Unique service identifier
- `API` (VARCHAR2) - API endpoint URL
- `HTTP_METHOD` (VARCHAR2) - **See HTTP Methods below**
- `PAYLOAD` (CLOB) - JSON payload (for POST/PUT)
- `HEADERS` (CLOB) - JSON headers
- `SERVICE_IDENTIFIER` (VARCHAR2) - Key to store response in DataStore
- `ON_SUCCESS` (VARCHAR2) - **See Success Handlers below**
- `ON_FAILURE` (VARCHAR2) - **See Error Handlers below**

#### UI_DATA_SOURCE
- `DATA_SOURCE_ID` (NUMBER, PK)
- `WIDGET_ID` (NUMBER, FK → WIDGET)
- `DATA_TYPE` (VARCHAR2) - `'static'` or `'dynamic'`
- `DATA_VALUE` (VARCHAR2/CLOB) - JSON array or object

---

## Page Layout Configuration

### Layout Types

| Layout Type | Description | Use Case |
|------------|-------------|----------|
| `vertical` | Components stack vertically (one per row) | Forms, confirmation pages, simple layouts |
| `horizontal` | Components arranged in columns | Multi-column forms, dashboard layouts |

### Layout Configuration

- **`LAYOUT_TYPE`**: Set to `'vertical'` or `'horizontal'`
  - **Default**: If `NULL` or not specified, defaults to `'vertical'`
- **`COLUMNS_PER_ROW`**: Required for horizontal layout. Specifies how many columns per row (e.g., `2` = 2 columns, `3` = 3 columns, `4` = 4 columns)
  - **Default**: If `NULL`, defaults to `2` (only used for horizontal layout)

**Examples:**
```sql
-- Vertical layout (default)
INSERT INTO PAGE (PAGE_ID, CATEGORY_ID, TITLE, ORDER_NO, LAYOUT_TYPE, COLUMNS_PER_ROW) 
VALUES (2, 1, 'Application Confirmation', 2, 'vertical', NULL);

-- Horizontal layout with 2 columns
INSERT INTO PAGE (PAGE_ID, CATEGORY_ID, TITLE, ORDER_NO, LAYOUT_TYPE, COLUMNS_PER_ROW) 
VALUES (1, 1, 'Personal Info', 1, 'horizontal', 2);

-- Horizontal layout with 3 columns
INSERT INTO PAGE (PAGE_ID, CATEGORY_ID, TITLE, ORDER_NO, LAYOUT_TYPE, COLUMNS_PER_ROW) 
VALUES (3, 1, 'Dashboard', 3, 'horizontal', 3);
```

**Note**: 
- If `LAYOUT_TYPE` is `NULL` or not specified, it defaults to `'vertical'`
- For `vertical` layout, `COLUMNS_PER_ROW` should be `NULL` (not used)
- For `horizontal` layout, `COLUMNS_PER_ROW` should be specified (typically 2, 3, or 4)
- If `COLUMNS_PER_ROW` is `NULL` for horizontal layout, it defaults to `2`
- Widgets with `width` property will still respect their width settings
- Checkbox and button widgets automatically span full width regardless of layout

---

## Widget Types and Properties

### Supported Widget Types

| Widget Type | Description | Use Case |
|------------|-------------|----------|
| `textbox` | Single-line text input | Name, email, age, etc. |
| `textarea` | Multi-line text input | Description, comments, address |
| `dropdown` | Select dropdown | Car brand, country, status |
| `checkbox` | Checkbox input | Terms acceptance, options |
| `radio` | Radio button group | Gender, payment method |
| `button` | Action button | Submit, cancel, navigate |
| `datepicker` | Date selection | Date of birth, appointment date |
| `fileupload` | File upload | Documents, images |
| `datatable` | Data table display | User list, transaction history |
| `popup` | Modal popup | Terms, confirmation dialogs |
| `formarray` | Dynamic form fields | Emergency contacts, items list |

---

### Widget Properties Reference

#### Common Properties (All Widgets)

| Property Key | Type | Possible Values | Description |
|-------------|------|----------------|-------------|
| `required` | String | `'true'`, `'false'` | Makes field required |
| `readonly` | String | `'true'`, `'false'` | Makes field read-only |
| `placeholder` | String | Any text | Placeholder text |
| `width` | String | Number (1-100) | Width percentage (e.g., `'50'` = 50%) |
| `dataPath` | String | Dot notation path | Path to data in DataStore (e.g., `'submitResponse.data.applicationId'`) |

#### Textbox Properties

| Property Key | Type | Possible Values | Description |
|-------------|------|----------------|-------------|
| `min` | String | Number | Minimum value |
| `max` | String | Number | Maximum value |
| `minLength` | String | Number | Minimum character length |
| `maxLength` | String | Number | Maximum character length |
| `pattern` | String | Regex pattern | Validation pattern |
| `type` | String | `'text'`, `'email'`, `'number'`, `'password'`, `'tel'`, `'url'` | Input type |

#### Textarea Properties

| Property Key | Type | Possible Values | Description |
|-------------|------|----------------|-------------|
| `rows` | String | Number | Number of visible rows (default: 4) |
| `cols` | String | Number | Number of visible columns |
| `minLength` | String | Number | Minimum character length |
| `maxLength` | String | Number | Maximum character length |

#### Dropdown Properties

| Property Key | Type | Possible Values | Description |
|-------------|------|----------------|-------------|
| `multiple` | String | `'true'`, `'false'` | Allow multiple selections |
| `placeholder` | String | Any text | Placeholder text |

**Note**: Dropdown options come from:
- `UI_DATA_SOURCE` table (static data)
- `OnLoadService` response (dynamic data via `data_binding` action)

#### Checkbox Properties

| Property Key | Type | Possible Values | Description |
|-------------|------|----------------|-------------|
| `showTermsLink` | String | `'true'`, `'false'` | Show clickable terms link in label |
| `termsLinkText` | String | Any text | Text for terms link (e.g., `'Terms and Conditions'`) |
| `termsTitle` | String | Any text | Modal title when terms link is clicked |
| `termsContent` | String | HTML string | Modal content (supports HTML) |

#### Radio Properties

| Property Key | Type | Possible Values | Description |
|-------------|------|----------------|-------------|
| `options` | String | JSON array | Array of `{value, label}` objects |

**Example:**
```json
[{"value":"male","label":"Male"},{"value":"female","label":"Female"}]
```

#### Button Properties

| Property Key | Type | Possible Values | Description |
|-------------|------|----------------|-------------|
| `variant` | String | `'primary'`, `'secondary'`, `'success'`, `'danger'`, `'warning'`, `'info'`, `'light'`, `'dark'`, `'link'` | Bootstrap button variant |
| `size` | String | `'small'`, `'medium'`, `'large'` | Button size |

#### Datepicker Properties

| Property Key | Type | Possible Values | Description |
|-------------|------|----------------|-------------|
| `min` | String | Date (YYYY-MM-DD) | Minimum selectable date |
| `max` | String | Date (YYYY-MM-DD) | Maximum selectable date |

#### Fileupload Properties

| Property Key | Type | Possible Values | Description |
|-------------|------|----------------|-------------|
| `accept` | String | File extensions | Comma-separated extensions (e.g., `'.pdf,.doc,.docx,.jpg,.png'`) |
| `multiple` | String | `'true'`, `'false'` | Allow multiple file selection |
| `maxSize` | String | Number (bytes) | Maximum file size in bytes |

#### Datatable Properties

| Property Key | Type | Possible Values | Description |
|-------------|------|----------------|-------------|
| `paging` | String | `'true'`, `'false'` | Enable pagination |
| `searching` | String | `'true'`, `'false'` | Enable search |
| `ordering` | String | `'true'`, `'false'` | Enable column sorting |
| `pageLength` | String | Number | Rows per page (default: 10) |
| `columns` | String | JSON array | Column definitions |
| `dataPath` | String | Dot notation path | Path to data in DataStore |

**Columns JSON Format:**
```json
[
  {"name":"id","label":"ID"},
  {"name":"name","label":"Name"},
  {"name":"email","label":"Email"}
]
```

**Note**: Datatable data comes from:
- `UI_DATA_SOURCE` table (static data)
- `OnLoadService` response stored in DataStore (dynamic data)

#### Popup Properties

| Property Key | Type | Possible Values | Description |
|-------------|------|----------------|-------------|
| `buttonText` | String | Any text | Text on button that opens popup |
| `variant` | String | `'primary'`, `'secondary'`, etc. | Button variant |
| `modalSize` | String | `'sm'`, `'md'`, `'lg'`, `'xl'` | Modal size |
| `backdrop` | String | `'true'`, `'false'` | Show backdrop (blur effect) |
| `keyboard` | String | `'true'`, `'false'` | Close on Escape key |
| `showConfirmButton` | String | `'true'`, `'false'` | Show confirm button |
| `closeButtonText` | String | Any text | Close button text |
| `content` | String | HTML string | Modal content (supports HTML) |

#### FormArray Properties

| Property Key | Type | Possible Values | Description |
|-------------|------|----------------|-------------|
| `allowAdd` | String | `'true'`, `'false'` | Allow adding new items |
| `allowRemove` | String | `'true'`, `'false'` | Allow removing items |
| `addButtonText` | String | Any text | Text on "Add" button |
| `removeButtonText` | String | Any text | Text on "Remove" button |
| `fields` | String | JSON array | Field definitions for each item |

**Fields JSON Format:**
```json
[
  {
    "name":"name",
    "label":"Contact Name",
    "type":"text",
    "placeholder":"Enter name",
    "defaultValue":""
  },
  {
    "name":"phone",
    "label":"Phone Number",
    "type":"text",
    "placeholder":"Enter phone",
    "defaultValue":""
  }
]
```

**Field Types**: `'text'`, `'number'`, `'email'`, `'date'`, `'dropdown'`

---

## Rules Configuration

### Rule Types

| Rule Type | Description | Expression Returns |
|-----------|-------------|-------------------|
| `visibility` | Controls widget visibility | Boolean (`true` = visible, `false` = hidden) |
| `enabled` | Controls widget enabled state | Boolean (`true` = enabled, `false` = disabled) |
| `validation` | Validates widget value | Boolean (`true` = valid, `false` = invalid) |

### Rule Expression Syntax

Rules use JavaScript-like expressions that can reference:
- **Form field values**: `age`, `carBrand`, `termsAccepted`
- **Comparison operators**: `==`, `!=`, `>`, `<`, `>=`, `<=`
- **Logical operators**: `&&`, `||`, `!`
- **String operations**: `value.length`, `value.includes('text')`
- **Null checks**: `value != null`, `value !== undefined`

### Expression Examples

#### Visibility Rules
```sql
-- Show dropdown only if age >= 18
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (1, 2, 'visibility', 'age >= 18');

-- Show description only if checkbox is checked
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (2, 5, 'visibility', 'termsAccepted == true');
```

#### Enabled Rules
```sql
-- Enable submit button only if terms are accepted
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (3, 3, 'enabled', 'termsAccepted == true');

-- Enable file upload only if age >= 18
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (4, 7, 'enabled', 'age >= 18');
```

#### Validation Rules
```sql
-- Age must be >= 18
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (5, 1, 'validation', 'value >= 18');

-- Email must contain @
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (6, 8, 'validation', 'value.includes("@")');

-- Date of birth must be at least 18 years ago
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (7, 9, 'validation', 'dateOfBirth != null && (new Date().getFullYear() - new Date(dateOfBirth).getFullYear()) >= 18');
```

---

## Actions Configuration

### Action Types

| Action Type | Description | Use Case |
|------------|-------------|----------|
| `api_call` | Makes HTTP request to backend | Submit form, fetch data, update record |
| `data_binding` | Binds data from DataStore to widget | Populate dropdown from onLoadService response |
| `navigation` | Navigates to another page | Navigate to success page, go back |

### Trigger Events

| Trigger Event | Description | Applicable Widgets |
|--------------|-------------|-------------------|
| `click` | User clicks widget | button, checkbox, radio |
| `change` | Value changes | textbox, textarea, dropdown, datepicker, fileupload |
| `focus` | Widget receives focus | textbox, textarea, dropdown |
| `blur` | Widget loses focus | textbox, textarea, dropdown |
| `load` | Widget loads | All widgets |
| `modalClose` | Modal/popup closes | popup |

### HTTP Methods

| HTTP Method | Description | Use Case |
|------------|-------------|----------|
| `GET` | Retrieve data | Fetch list, get details |
| `POST` | Create resource | Submit form, create record |
| `PUT` | Update resource | Update record |
| `DELETE` | Delete resource | Delete record |
| `PATCH` | Partial update | Partial update |

### Payload Type

| Payload Type | Description |
|--------------|-------------|
| `static` | Payload is static JSON (no variable replacement) |
| `dynamic` | Payload contains template variables (e.g., `{{fieldName}}`) |

### Template Variables

In `PAYLOAD_TEMPLATE`, `HEADERS`, `QUERY_PARAMS`, and `ENDPOINT_URL`, you can use:

| Variable | Description | Example |
|----------|-------------|---------|
| `{{fieldName}}` | Form field value | `{{age}}`, `{{carBrand}}` |
| `{{$timestamp}}` | Current timestamp | `{{$timestamp}}` |
| `{{$token}}` | Authentication token (if available) | `{{$token}}` |
| `{{$userId}}` | User ID (if available) | `{{$userId}}` |

**Example Payload Template:**
```json
{
  "age": "{{age}}",
  "carBrand": "{{carBrand}}",
  "timestamp": "{{$timestamp}}"
}
```

### Success Handlers

| Handler Format | Description | Example |
|----------------|-------------|---------|
| `navigate:route` | Navigate to Angular route | `navigate:/success` |
| `navigateToPage:pageId` | Navigate to page by order number | `navigateToPage:2` |
| `navigateToPage:pageId:store:storageKey` | Navigate and store response | `navigateToPage:2:store:submitResponse` |
| `updateDropdown:widgetName:serviceIdentifier` | Update dropdown options | `updateDropdown:carBrand:carBrands` |
| `setFormData:key` | Set form data from response | `setFormData:userProfile` |
| `store:storageKey` | Store response in DataStore | `store:userListData` |
| `showMessage:message` | Show alert message | `showMessage:Success!` |

**Note**: When using `navigateToPage:pageId:store:storageKey`, the **full API response** (including `status` wrapper) is stored in DataStore under `storageKey`. This allows widgets on the next page to access data using `dataPath` property.

### Error Handlers

| Handler Format | Description | Example |
|---------------|-------------|---------|
| `showMessage:message` | Show error alert | `showMessage:Error occurred` |
| `navigate:route` | Navigate on error | `navigate:/error` |

### Action Configuration Example

```sql
INSERT INTO WIDGET_ACTION (
    ACTION_ID, WIDGET_ID, ACTION_NAME, ACTION_TYPE, TRIGGER_EVENT,
    HTTP_METHOD, ENDPOINT_URL, PAYLOAD_TEMPLATE, PAYLOAD_TYPE, HEADERS,
    SUCCESS_HANDLER, ERROR_HANDLER, TIMEOUT_MS, ORDER_NO, IS_ENABLED
) VALUES (
    1, 3, 'submit', 'api_call', 'click',
    'POST', '/api/insurance/submit',
    '{"age": "{{age}}", "carBrand": "{{carBrand}}", "timestamp": "{{$timestamp}}"}',
    'dynamic',
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
    'navigateToPage:2:store:submitResponse',
    'showMessage:Error occurred while submitting',
    30000, 1, 'Y'
);
```

### Data Binding Action Example

```sql
-- Dropdown loads options from onLoadService response
INSERT INTO WIDGET_ACTION (
    ACTION_ID, WIDGET_ID, ACTION_NAME, ACTION_TYPE, TRIGGER_EVENT,
    SUCCESS_HANDLER, ORDER_NO, IS_ENABLED
) VALUES (
    2, 2, 'loadOptions', 'data_binding', 'focus',
    'updateDropdown:carBrand:carBrands',
    1, 'Y'
);
```

---

## OnLoad Services

OnLoad services execute automatically when a page loads. They are useful for:
- Fetching initial data (user profile, configuration, lists)
- Pre-populating form fields
- Loading dropdown options

### HTTP Methods

Same as Action HTTP Methods: `GET`, `POST`, `PUT`, `DELETE`, `PATCH`

### Success/Error Handlers

Same as Action Success/Error Handlers (see above).

### OnLoad Service Configuration Example

```sql
-- Fetch car brands on page load
INSERT INTO ON_LOAD_SERVICE (
    ON_LOAD_SERVICE_ID, PAGE_ID, SERVICE_ID, API, HTTP_METHOD,
    HEADERS, SERVICE_IDENTIFIER, ON_SUCCESS, ON_FAILURE
) VALUES (
    1, 1, 'CAR_BRANDS_SERVICE', '/api/cars/brands', 'GET',
    '{"Content-Type": "application/json"}',
    'carBrands',
    'store:carBrands',
    'showMessage:Failed to load car brands'
);

-- Fetch user profile on page load
INSERT INTO ON_LOAD_SERVICE (
    ON_LOAD_SERVICE_ID, PAGE_ID, SERVICE_ID, API, HTTP_METHOD,
    HEADERS, SERVICE_IDENTIFIER, ON_SUCCESS, ON_FAILURE
) VALUES (
    2, 1, 'USER_PROFILE_SERVICE', '/api/user/profile', 'GET',
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
    'userProfile',
    'setFormData:userProfile',
    'showMessage:Failed to load user data'
);
```

**Note**: The `SERVICE_IDENTIFIER` is used as the key in DataStore. Other widgets can reference this data using `dataPath` or in actions.

---

## API Response Format

### Standard Response Structure

All REST API responses **must** follow this format:

```json
{
  "status": {
    "code": "000000",
    "desc": "SUCCESS"
  },
  "data": {
    // Actual response data here
  }
}
```

### Status Codes

| Code | Description |
|------|-------------|
| `000000` | Success |
| `100001` - `999999` | Error codes (6 digits) |

### Response Examples

#### Success Response
```json
{
  "status": {
    "code": "000000",
    "desc": "SUCCESS"
  },
  "data": {
    "applicationId": "APP-123456",
    "message": "Application submitted successfully",
    "status": "pending"
  }
}
```

#### Error Response
```json
{
  "status": {
    "code": "100001",
    "desc": "VALIDATION_ERROR"
  },
  "data": {
    "errors": [
      "Age must be at least 18"
    ]
  }
}
```

### Backend Implementation

In Spring Boot, use the `ApiResponse` DTO:

```java
@GetMapping("/api/cars/brands")
public ResponseEntity<ApiResponse<List<CarBrand>>> getCarBrands() {
    List<CarBrand> brands = // ... fetch brands
    return ResponseEntity.ok(ApiResponse.success(brands));
}
```

---

## Configuration Examples

### Example 1: Simple Form with Validation

```sql
-- 1. Create Widget: Age textbox
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (1, 1, 'textbox', 'age', 'Age', 1);

-- 2. Add Properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (1, 1, 'placeholder', 'Enter age');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (2, 1, 'required', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (3, 1, 'min', '1');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (4, 1, 'max', '100');

-- 3. Add Validation Rule
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (1, 1, 'validation', 'value >= 18');
```

### Example 2: Dropdown with Dynamic Data

```sql
-- 1. Create Widget: Car Brand dropdown
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (2, 1, 'dropdown', 'carBrand', 'Car Brand', 2);

-- 2. Add Properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (5, 2, 'placeholder', 'Select car brand');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (6, 2, 'required', 'true');

-- 3. Create OnLoadService to fetch car brands
INSERT INTO ON_LOAD_SERVICE (
    ON_LOAD_SERVICE_ID, PAGE_ID, SERVICE_ID, API, HTTP_METHOD,
    HEADERS, SERVICE_IDENTIFIER, ON_SUCCESS, ON_FAILURE
) VALUES (
    1, 1, 'CAR_BRANDS_SERVICE', '/api/cars/brands', 'GET',
    '{"Content-Type": "application/json"}',
    'carBrands',
    'store:carBrands',
    'showMessage:Failed to load car brands'
);

-- 4. Create Action to bind data to dropdown
INSERT INTO WIDGET_ACTION (
    ACTION_ID, WIDGET_ID, ACTION_NAME, ACTION_TYPE, TRIGGER_EVENT,
    SUCCESS_HANDLER, ORDER_NO, IS_ENABLED
) VALUES (
    1, 2, 'loadOptions', 'data_binding', 'focus',
    'updateDropdown:carBrand:carBrands',
    1, 'Y'
);
```

### Example 3: Submit Button with Navigation

```sql
-- 1. Create Widget: Submit button
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (3, 1, 'button', 'submit', 'Submit', 3);

-- 2. Add Properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (8, 3, 'variant', 'primary');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (9, 3, 'size', 'large');

-- 3. Add Enabled Rule (only enable if terms accepted)
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (2, 3, 'enabled', 'termsAccepted == true');

-- 4. Create Submit Action
INSERT INTO WIDGET_ACTION (
    ACTION_ID, WIDGET_ID, ACTION_NAME, ACTION_TYPE, TRIGGER_EVENT,
    HTTP_METHOD, ENDPOINT_URL, PAYLOAD_TEMPLATE, PAYLOAD_TYPE, HEADERS,
    SUCCESS_HANDLER, ERROR_HANDLER, TIMEOUT_MS, ORDER_NO, IS_ENABLED
) VALUES (
    1, 3, 'submit', 'api_call', 'click',
    'POST', '/api/insurance/submit',
    '{"age": "{{age}}", "carBrand": "{{carBrand}}", "timestamp": "{{$timestamp}}"}',
    'dynamic',
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
    'navigateToPage:2:store:submitResponse',
    'showMessage:Error occurred while submitting',
    30000, 1, 'Y'
);
```

### Example 4: Confirmation Page with DataPath

```sql
-- 1. Create Widget: Application ID (read-only)
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (5, 2, 'textbox', 'applicationId', 'Application ID', 1);

-- 2. Add Properties (including dataPath)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (10, 5, 'readonly', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (11, 5, 'placeholder', 'Application ID will appear here');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (25, 5, 'dataPath', 'submitResponse.data.applicationId');

-- 3. Create Widget: Age (read-only)
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (6, 2, 'textbox', 'age', 'Age', 2);

-- 4. Add Properties (including dataPath)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (12, 6, 'readonly', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (13, 6, 'placeholder', 'Age will appear here');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (26, 6, 'dataPath', 'submitResponse.data.data.age');
```

**Note**: The `dataPath` uses dot notation to access nested data. If the stored response is:
```json
{
  "status": {"code": "000000", "desc": "SUCCESS"},
  "data": {
    "applicationId": "APP-123",
    "data": {
      "age": "30",
      "carBrand": "1"
    }
  }
}
```

Then:
- `submitResponse.data.applicationId` → `"APP-123"`
- `submitResponse.data.data.age` → `"30"`

### Example 5: Terms Checkbox with Modal

```sql
-- 1. Create Widget: Terms checkbox
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (4, 1, 'checkbox', 'termsAccepted', 'Accept Terms and Conditions', 4);

-- 2. Add Properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (15, 4, 'required', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (34, 4, 'showTermsLink', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (35, 4, 'termsLinkText', 'Terms and Conditions');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (36, 4, 'termsTitle', 'Terms and Conditions');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (37, 4, 'termsContent', '<h3>1. Introduction</h3><p>Welcome to our service...</p>');
```

### Example 6: Datatable with OnLoadService

```sql
-- 1. Create Widget: User list datatable
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (53, 1, 'datatable', 'userList', 'User List', 8);

-- 2. Add Properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (110, 53, 'paging', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (111, 53, 'searching', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (112, 53, 'ordering', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (113, 53, 'pageLength', '10');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (114, 53, 'columns', '[{"name":"id","label":"ID"},{"name":"name","label":"Name"},{"name":"email","label":"Email"},{"name":"role","label":"Role"}]');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (115, 53, 'dataPath', 'userListData');

-- 3. Create OnLoadService to fetch user list
INSERT INTO ON_LOAD_SERVICE (
    ON_LOAD_SERVICE_ID, PAGE_ID, SERVICE_ID, API, HTTP_METHOD,
    HEADERS, SERVICE_IDENTIFIER, ON_SUCCESS, ON_FAILURE
) VALUES (
    50, 1, 'USER_LIST_SERVICE', '/api/users/list', 'GET',
    '{"Content-Type": "application/json"}',
    'userListData',
    'store:userListData',
    'showMessage:Failed to load user list'
);
```

---

## Best Practices

### 1. Widget Naming
- Use **camelCase** for widget `NAME` (e.g., `carBrand`, `termsAccepted`)
- Use **descriptive labels** for widget `LABEL` (e.g., `'Car Brand'`, `'Accept Terms and Conditions'`)

### 2. Order Numbers
- Use **sequential order numbers** (1, 2, 3, ...) for widgets on the same page
- Leave gaps (e.g., 10, 20, 30) if you plan to insert widgets between existing ones

### 3. Property Keys
- Use **camelCase** for property keys (e.g., `dataPath`, `showTermsLink`)
- **Case-insensitive**: The system matches properties case-insensitively, but use consistent casing

### 4. API Endpoints
- Use **absolute paths** starting with `/api` (e.g., `/api/cars/brands`)
- The frontend automatically handles URL construction

### 5. Data Storage
- Use **descriptive service identifiers** (e.g., `carBrands`, `userListData`, `submitResponse`)
- Store data with meaningful keys for easy reference via `dataPath`

### 6. Rules
- Keep expressions **simple and readable**
- Test expressions in browser console before adding to database
- Use `==` for loose equality, `===` for strict equality (JavaScript behavior)

### 7. Actions
- Set appropriate **timeouts** (default: 30000ms = 30 seconds)
- Use `IS_ENABLED = 'Y'` to enable actions, `'N'` to disable
- Use `ORDER_NO` to control execution order if multiple actions exist

### 8. Error Handling
- Always provide **error handlers** for API calls
- Use user-friendly error messages

### 9. Response Format
- **Always** return responses in the standard format with `status` and `data`
- Use 6-digit error codes (e.g., `100001`, `200001`)

### 10. Testing
- Test each widget individually before integrating
- Verify rules work correctly with different form values
- Test navigation and data persistence between pages

---

## Quick Reference

### Widget Types
`textbox`, `textarea`, `dropdown`, `checkbox`, `radio`, `button`, `datepicker`, `fileupload`, `datatable`, `popup`, `formarray`

### Action Types
`api_call`, `data_binding`, `navigation`

### Trigger Events
`click`, `change`, `focus`, `blur`, `load`, `modalClose`

### HTTP Methods
`GET`, `POST`, `PUT`, `DELETE`, `PATCH`

### Rule Types
`visibility`, `enabled`, `validation`

### Button Variants
`primary`, `secondary`, `success`, `danger`, `warning`, `info`, `light`, `dark`, `link`

### Success Handlers
`navigate:route`, `navigateToPage:pageId`, `navigateToPage:pageId:store:storageKey`, `updateDropdown:widgetName:serviceIdentifier`, `setFormData:key`, `store:storageKey`, `showMessage:message`

---

## Support

For issues or questions, refer to:
- Database schema: `src/main/resources/db/oracle/schema.sql`
- Example configurations: `src/main/resources/db/oracle/complete-insert-data.sql`
- Spring Boot controller: `src/main/java/com/dynamicui/controller/WebController.java`
- Angular components: `dynamic-ui-frontend/src/components/`

---

**Last Updated**: 2025-01-10

