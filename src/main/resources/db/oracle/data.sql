-- =====================================================================
-- Sample Data for Dynamic UI Configuration
-- =====================================================================

-- Insert Product
INSERT INTO PRODUCT (PRODUCT_ID, NAME, DESCRIPTION) VALUES (SEQ_PRODUCT_ID.NEXTVAL, 'Insurance', 'Insurance Product Configuration');

-- Get the PRODUCT_ID (assuming it's 1)
-- Insert Category
INSERT INTO CATEGORY (CATEGORY_ID, PRODUCT_ID, NAME, DESCRIPTION) 
VALUES (SEQ_CATEGORY_ID.NEXTVAL, 1, 'Motor Insurance', 'Motor Insurance Category');

-- Get the CATEGORY_ID (assuming it's 1)
-- Insert Page
INSERT INTO PAGE (PAGE_ID, CATEGORY_ID, TITLE, ORDER_NO) 
VALUES (SEQ_PAGE_ID.NEXTVAL, 1, 'Personal Info', 1);

-- Get the PAGE_ID (assuming it's 1)
-- Insert Widgets
-- Widget 1: Textbox for age
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 1, 'textbox', 'age', 'Age', 1);

-- Widget 2: Dropdown for carBrand
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 1, 'dropdown', 'carBrand', 'Car Brand', 2);

-- Get WIDGET_IDs (assuming 1 for age, 2 for carBrand)
-- Insert Properties for age textbox (WIDGET_ID = 1)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 1, 'placeholder', 'Enter age');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 1, 'required', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 1, 'min', '1');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (SEQ_PROP_ID.NEXTVAL, 1, 'max', '100');

-- Insert Rule for age textbox (WIDGET_ID = 1)
INSERT INTO WIDGET_RULE (RULE_ID, WIDGET_ID, RULE_TYPE, RULE_EXPRESSION) 
VALUES (SEQ_RULE_ID.NEXTVAL, 1, 'validation', 'value >= 18');

-- Insert Data Source for carBrand dropdown (WIDGET_ID = 2)
INSERT INTO UI_DATA_SOURCE (DS_ID, WIDGET_ID, SOURCE_TYPE, SOURCE_VALUE) 
VALUES (SEQ_DS_ID.NEXTVAL, 2, 'static', '["Toyota","Nissan","BMW"]');

-- Widget 3: Submit button
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 1, 'button', 'submit', 'Submit', 3);

-- Get WIDGET_ID for submit button (assuming it's 3)
-- Insert Action for submit button (WIDGET_ID = 3)
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
    3,
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

COMMIT;

