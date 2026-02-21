-- =====================================================================
-- Profile Page Configuration - Simple Version with Actual IDs
-- =====================================================================
-- This script configures a profile page with button navigation
-- Replace the IDs below with your actual IDs or use sequences
-- =====================================================================

-- Step 1: Create Profile Page
-- Replace CATEGORY_ID with your actual category ID (e.g., 1)
INSERT INTO PAGE (
    PAGE_ID,
    CATEGORY_ID,
    TITLE,
    ORDER_NO,
    LAYOUT_TYPE,
    COLUMNS_PER_ROW
) VALUES (
    SEQ_PAGE_ID.NEXTVAL,
    1,  -- Replace with your CATEGORY_ID
    'Profile Page',
    3,
    'vertical',
    NULL
);

-- Note: Get the PAGE_ID after insert (e.g., SELECT MAX(PAGE_ID) FROM PAGE;)
-- Assume it's PAGE_ID = 3 for this example

-- Step 2: Create OnLoadService for Profile Page
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
    3,  -- Profile Page ID (replace with actual PAGE_ID from Step 1)
    'PROFILE_SERVICE',
    '/api/profile/get',
    'GET',
    NULL,
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
    'profileData',
    'setGlobalConfig:profileData',
    'showMessage:Failed to load profile data'
);

-- Step 3: Create Display Widgets on Profile Page
-- Widget 1: Username
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 3, 'textbox', 'username', 'Username', 1);

-- Widget 2: Salary
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 3, 'textbox', 'salary', 'Salary', 2);

-- Widget 3: Department
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 3, 'textbox', 'department', 'Department', 3);

-- Widget 4: Address
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 3, 'textarea', 'address', 'Address', 4);

-- Step 4: Configure Widget Properties
-- Properties for Username widget
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'readonly', 'true'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'username';
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'dataPath', 'profileData.username'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'username';

-- Properties for Salary widget
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'readonly', 'true'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'salary';
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'dataPath', 'profileData.salary'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'salary';

-- Properties for Department widget
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'readonly', 'true'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'department';
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'dataPath', 'profileData.department'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'department';

-- Properties for Address widget
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'readonly', 'true'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'address';
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'dataPath', 'profileData.address'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'address';
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'rows', '3'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'address';

-- Step 5: Create Profile Button on Main Page (PAGE_ID = 1)
-- Replace PAGE_ID = 1 with your actual main page ID
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (SEQ_WIDGET_ID.NEXTVAL, 1, 'button', 'profileButton', 'Profile', 10);

-- Step 6: Create Navigation Action for Profile Button
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
    (SELECT MAX(WIDGET_ID) FROM WIDGET WHERE PAGE_ID = 1 AND NAME = 'profileButton'),
    'navigateToProfile',
    'navigation',
    'click',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    'navigateToPage:3',  -- Replace 3 with your Profile Page PAGE_ID
    'showMessage:Failed to navigate to profile',
    NULL,
    1,
    'Y'
);

COMMIT;

-- =====================================================================
-- How It Works:
-- =====================================================================
-- 1. User clicks "Profile" button on main page
-- 2. Action triggers: navigateToPage:3 (navigates to Profile Page)
-- 3. Profile Page loads and automatically calls onLoadService
-- 4. onLoadService calls GET /api/profile/get
-- 5. Response is stored in DataStore with key 'profileData'
-- 6. Widgets read values using dataPath:
--    - username widget: profileData.username
--    - salary widget: profileData.salary
--    - department widget: profileData.department
--    - address widget: profileData.address
-- =====================================================================

