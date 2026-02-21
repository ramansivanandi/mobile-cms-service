-- =====================================================================
-- Profile Page Configuration
-- =====================================================================
-- This script configures:
-- 1. A button widget that navigates to profile page
-- 2. A profile page with onLoadService to fetch profile data
-- 3. Display widgets for username, salary, department, address
-- =====================================================================

-- Step 1: Create Profile Page (assuming you have a Category with CATEGORY_ID = 1)
-- Replace CATEGORY_ID with your actual category ID
INSERT INTO PAGE (
    PAGE_ID,
    CATEGORY_ID,
    TITLE,
    ORDER_NO,
    LAYOUT_TYPE,
    COLUMNS_PER_ROW
) VALUES (
    SEQ_PAGE_ID.NEXTVAL,
    1,  -- Replace with your actual CATEGORY_ID
    'Profile Page',
    3,  -- Order number
    'vertical',
    NULL
);

-- Get the PAGE_ID (assuming it's the next available ID, e.g., 3)
-- You can query: SELECT MAX(PAGE_ID) FROM PAGE; to get the latest page ID

-- Step 2: Create OnLoadService for Profile Page
-- This service will be called when the profile page loads
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
    3,  -- Replace with your Profile Page PAGE_ID
    'PROFILE_SERVICE',
    '/api/profile/get',
    'GET',
    NULL,
    '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
    'profileData',  -- This identifier will be used to store the response
    'setGlobalConfig:profileData',  -- Store the response data in DataStore with key 'profileData'
    'showMessage:Failed to load profile data'
);

-- Step 3: Create Display Widgets on Profile Page
-- Widget 1: Username (read-only textbox)
INSERT INTO WIDGET (
    WIDGET_ID,
    PAGE_ID,
    TYPE,
    NAME,
    LABEL,
    ORDER_NO
) VALUES (
    SEQ_WIDGET_ID.NEXTVAL,
    3,  -- Profile Page ID
    'textbox',
    'username',
    'Username',
    1
);

-- Widget 2: Salary (read-only textbox)
INSERT INTO WIDGET (
    WIDGET_ID,
    PAGE_ID,
    TYPE,
    NAME,
    LABEL,
    ORDER_NO
) VALUES (
    SEQ_WIDGET_ID.NEXTVAL,
    3,  -- Profile Page ID
    'textbox',
    'salary',
    'Salary',
    2
);

-- Widget 3: Department (read-only textbox)
INSERT INTO WIDGET (
    WIDGET_ID,
    PAGE_ID,
    TYPE,
    NAME,
    LABEL,
    ORDER_NO
) VALUES (
    SEQ_WIDGET_ID.NEXTVAL,
    3,  -- Profile Page ID
    'textbox',
    'department',
    'Department',
    3
);

-- Widget 4: Address (read-only textarea)
INSERT INTO WIDGET (
    WIDGET_ID,
    PAGE_ID,
    TYPE,
    NAME,
    LABEL,
    ORDER_NO
) VALUES (
    SEQ_WIDGET_ID.NEXTVAL,
    3,  -- Profile Page ID
    'textarea',
    'address',
    'Address',
    4
);

-- Step 4: Configure Widget Properties
-- Get WIDGET_IDs (assuming sequential: latest WIDGET_ID - 3, latest - 2, latest - 1, latest)
-- Query: SELECT MAX(WIDGET_ID) FROM WIDGET; to get the latest widget ID

-- Properties for Username widget
-- Note: Replace WIDGET_ID values with actual IDs from the widgets created above
-- Query to get widget IDs: SELECT WIDGET_ID, NAME FROM WIDGET WHERE PAGE_ID = 3 ORDER BY ORDER_NO;

-- For Username widget (ORDER_NO = 1)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'readonly', 'true'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'username';
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'dataPath', 'profileData.username'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'username';

-- For Salary widget (ORDER_NO = 2)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'readonly', 'true'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'salary';
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'dataPath', 'profileData.salary'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'salary';

-- For Department widget (ORDER_NO = 3)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'readonly', 'true'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'department';
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'dataPath', 'profileData.department'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'department';

-- For Address widget (ORDER_NO = 4)
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'readonly', 'true'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'address';
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'dataPath', 'profileData.address'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'address';
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
SELECT SEQ_PROP_ID.NEXTVAL, WIDGET_ID, 'rows', '3'
FROM WIDGET WHERE PAGE_ID = 3 AND NAME = 'address';

-- Step 5: Create Profile Button on Main Page (assuming PAGE_ID = 1)
-- This button will navigate to the profile page
-- Replace PAGE_ID = 1 with your actual main page ID
INSERT INTO WIDGET (
    WIDGET_ID,
    PAGE_ID,
    TYPE,
    NAME,
    LABEL,
    ORDER_NO
) VALUES (
    SEQ_WIDGET_ID.NEXTVAL,
    1,  -- Main Page ID (replace with your main page ID)
    'button',
    'profileButton',
    'Profile',
    10  -- Order number (adjust based on your existing widgets)
);

-- Step 6: Create Navigation Action for Profile Button
-- Replace PAGE_ID = 3 with your Profile Page PAGE_ID from Step 1
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
    (SELECT MAX(WIDGET_ID) FROM WIDGET WHERE PAGE_ID = 1 AND NAME = 'profileButton'),  -- Profile button widget ID
    'navigateToProfile',
    'navigation',
    'click',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    'navigateToPage:3',  -- Replace 3 with your Profile Page PAGE_ID from Step 1
    'showMessage:Failed to navigate to profile',
    NULL,
    1,
    'Y'
);

-- =====================================================================
-- Expected API Response Format
-- =====================================================================
-- The profile service (/api/profile/get) returns:
-- {
--   "status": {
--     "code": "000000",
--     "desc": "SUCCESS"
--   },
--   "data": {
--     "username": "john.doe",
--     "salary": "75000",
--     "department": "IT Department",
--     "address": "123 Main Street, Suite 100, City, State 12345"
--   }
-- }
-- 
-- The onLoadService stores this in DataStore with key 'profileData'
-- The widgets use dataPath to read from this stored data:
-- - profileData.username
-- - profileData.salary
-- - profileData.department
-- - profileData.address
-- =====================================================================

-- =====================================================================
-- Configuration Summary
-- =====================================================================
-- 1. Profile Button (on main page):
--    - Type: button
--    - Action: navigation
--    - Success Handler: navigateToPage:3 (navigates to profile page)
--
-- 2. Profile Page:
--    - Has onLoadService that calls /api/profile/get
--    - Stores response in DataStore with key 'profileData'
--
-- 3. Display Widgets:
--    - All widgets are read-only (readonly: true)
--    - All widgets use dataPath to read from 'profileData'
--    - Username: profileData.username
--    - Salary: profileData.salary
--    - Department: profileData.department
--    - Address: profileData.address
-- =====================================================================

COMMIT;

