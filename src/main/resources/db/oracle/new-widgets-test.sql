-- =====================================================================
-- SQL Test Queries for New Widget Types
-- =====================================================================
-- This script contains INSERT statements to test the following widgets:
-- 1. textarea
-- 2. datepicker
-- 3. fileupload
-- 4. datatable
-- 5. popup
-- 6. formarray
-- =====================================================================

-- =====================================================================
-- 1. TEXTAREA Widget Test
-- =====================================================================
-- Widget: Description textarea
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (50, 1, 'textarea', 'description', 'Description', 5);

-- Properties for textarea
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (100, 50, 'placeholder', 'Enter description here');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (101, 50, 'rows', '5');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (102, 50, 'required', 'false');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (103, 50, 'readonly', 'false');

-- =====================================================================
-- 2. DATEPICKER Widget Test
-- =====================================================================
-- Widget: Date of Birth datepicker
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (51, 1, 'datepicker', 'dateOfBirth', 'Date of Birth', 6);

-- Properties for datepicker
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (104, 51, 'placeholder', 'Select date');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (105, 51, 'required', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (106, 51, 'readonly', 'false');

-- =====================================================================
-- 3. FILEUPLOAD Widget Test
-- =====================================================================
-- Widget: Document upload
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (52, 1, 'fileupload', 'documentUpload', 'Upload Document', 7);

-- Properties for fileupload
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (107, 52, 'accept', '.pdf,.doc,.docx,.jpg,.png');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (108, 52, 'multiple', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (109, 52, 'required', 'false');

-- Action for file upload (optional - to upload file to server)
INSERT INTO WIDGET_ACTION (ACTION_ID, WIDGET_ID, ACTION_NAME, ACTION_TYPE, TRIGGER_EVENT, HTTP_METHOD, ENDPOINT_URL, PAYLOAD_TEMPLATE, HEADERS, SUCCESS_HANDLER, ERROR_HANDLER, TIMEOUT_MS, ORDER_NO, ENABLED) 
VALUES (50, 52, 'uploadFile', 'api_call', 'change', 'POST', '/api/files/upload', '{"file": "{{documentUpload}}"}', '{"Content-Type": "multipart/form-data"}', 'showMessage:File uploaded successfully', 'showMessage:File upload failed', 60000, 1, 1);

-- =====================================================================
-- 4. DATATABLE Widget Test
-- =====================================================================
-- Widget: User list datatable
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (53, 1, 'datatable', 'userList', 'User List', 8);

-- Properties for datatable
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (110, 53, 'paging', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (111, 53, 'searching', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (112, 53, 'ordering', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (113, 53, 'pageLength', '10');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (114, 53, 'columns', '[{"name":"id","label":"ID"},{"name":"name","label":"Name"},{"name":"email","label":"Email"},{"name":"role","label":"Role"}]');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (115, 53, 'dataPath', 'userListData');

-- DataSource for datatable (static data example)
-- Note: In real scenario, data would come from onLoadService
INSERT INTO UI_DATA_SOURCE (DATA_SOURCE_ID, WIDGET_ID, DATA_TYPE, DATA_VALUE) 
VALUES (50, 53, 'static', '[{"id":1,"name":"John Doe","email":"john@example.com","role":"Admin"},{"id":2,"name":"Jane Smith","email":"jane@example.com","role":"User"},{"id":3,"name":"Bob Johnson","email":"bob@example.com","role":"User"}]');

-- OnLoadService to fetch user list data
INSERT INTO ON_LOAD_SERVICE (ON_LOAD_SERVICE_ID, PAGE_ID, SERVICE_ID, API, HTTP_METHOD, PAYLOAD, HEADERS, SERVICE_IDENTIFIER, ON_SUCCESS, ON_FAILURE) 
VALUES (50, 1, 'USER_LIST_SERVICE', '/api/users/list', 'GET', NULL, '{"Content-Type": "application/json"}', 'userListData', 'store:userListData', 'showMessage:Failed to load user list');

-- =====================================================================
-- 5. POPUP Widget Test
-- =====================================================================
-- Widget: Terms and conditions popup
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (54, 1, 'popup', 'termsPopup', 'View Terms', 9);

-- Properties for popup
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (116, 54, 'buttonText', 'View Terms & Conditions');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (117, 54, 'variant', 'secondary');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (118, 54, 'modalSize', 'lg');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (119, 54, 'backdrop', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (120, 54, 'keyboard', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (121, 54, 'showConfirmButton', 'false');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (122, 54, 'closeButtonText', 'Close');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (123, 54, 'content', '<h3>Terms and Conditions</h3><p>By using this service, you agree to the following terms...</p><ul><li>Term 1: You must be 18 years or older</li><li>Term 2: All information provided must be accurate</li><li>Term 3: You are responsible for maintaining the confidentiality of your account</li></ul>');

-- Action for popup (optional - triggered on modal close)
INSERT INTO WIDGET_ACTION (ACTION_ID, WIDGET_ID, ACTION_NAME, ACTION_TYPE, TRIGGER_EVENT, HTTP_METHOD, ENDPOINT_URL, PAYLOAD_TEMPLATE, HEADERS, SUCCESS_HANDLER, ERROR_HANDLER, TIMEOUT_MS, ORDER_NO, ENABLED) 
VALUES (51, 54, 'onModalClose', 'data_binding', 'modalClose', NULL, NULL, NULL, NULL, 'showMessage:Terms viewed', NULL, NULL, 1, 1);

-- =====================================================================
-- 6. FORMARRAY Widget Test
-- =====================================================================
-- Widget: Emergency contacts formarray
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (55, 1, 'formarray', 'emergencyContacts', 'Emergency Contacts', 10);

-- Properties for formarray
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (124, 55, 'required', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (125, 55, 'allowAdd', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (126, 55, 'allowRemove', 'true');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (127, 55, 'addButtonText', 'Add Contact');
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) VALUES (128, 55, 'fields', '[{"name":"name","label":"Contact Name","type":"text","placeholder":"Enter name","defaultValue":""},{"name":"phone","label":"Phone Number","type":"text","placeholder":"Enter phone","defaultValue":""},{"name":"relationship","label":"Relationship","type":"text","placeholder":"e.g., Spouse, Parent","defaultValue":""}]');

-- =====================================================================
-- Additional Test: DatePicker with validation rule
-- =====================================================================
-- Rule: Date of birth must be at least 18 years ago
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, EXPRESSION, ORDER_NO) 
VALUES (50, 51, 'validation', 'dateOfBirth != null && (new Date().getFullYear() - new Date(dateOfBirth).getFullYear()) >= 18', 1);

-- =====================================================================
-- Additional Test: Textarea with visibility rule
-- =====================================================================
-- Rule: Description is visible only if age >= 18
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, EXPRESSION, ORDER_NO) 
VALUES (51, 50, 'visibility', 'age >= 18', 1);

-- =====================================================================
-- Additional Test: FileUpload with enabled rule
-- =====================================================================
-- Rule: File upload is enabled only if terms are accepted
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, EXPRESSION, ORDER_NO) 
VALUES (52, 52, 'enabled', 'termsAccepted == true', 1);

-- =====================================================================
-- COMMIT
-- =====================================================================
COMMIT;

