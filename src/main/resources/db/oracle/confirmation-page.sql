-- =====================================================================
-- Confirmation Page (Page 2) - Display Submitted Data
-- =====================================================================
-- This page displays the submitted form data after successful submission
-- =====================================================================

-- =====================================================================
-- 1. PAGE Table - Add Confirmation Page
-- =====================================================================
INSERT INTO PAGE (PAGE_ID, CATEGORY_ID, TITLE, ORDER_NO, LAYOUT_TYPE, COLUMNS_PER_ROW) 
VALUES (2, 1, 'Application Confirmation', 2, 'vertical', NULL);

-- =====================================================================
-- 2. WIDGET Table - Display Widgets for Submitted Data
-- =====================================================================
-- Widget 5: Display Application ID (read-only text)
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (5, 2, 'textbox', 'applicationId', 'Application ID', 1);

-- Widget 6: Display Age (read-only text)
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (6, 2, 'textbox', 'age', 'Age', 2);

-- Widget 7: Display Car Brand (read-only text)
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (7, 2, 'textbox', 'carBrand', 'Car Brand', 3);

-- Widget 8: Display Status (read-only text)
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (8, 2, 'textbox', 'status', 'Status', 4);

-- Widget 9: Display Message (read-only textarea)
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (9, 2, 'textbox', 'message', 'Message', 5);

-- Widget 10: Display Estimated Processing Time (read-only text)
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (10, 2, 'textbox', 'estimatedProcessingTime', 'Estimated Processing Time', 6);

-- Widget 11: Display Submitted At (read-only text)
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (11, 2, 'textbox', 'submittedAt', 'Submitted At', 7);

-- Widget 12: Back to Home button
INSERT INTO WIDGET (WIDGET_ID, PAGE_ID, TYPE, NAME, LABEL, ORDER_NO) 
VALUES (12, 2, 'button', 'backToHome', 'Back to Home', 8);

-- =====================================================================
-- 3. WIDGET_PROPS Table - Make all display widgets read-only
-- =====================================================================
-- Application ID properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (10, 5, 'readonly', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (11, 5, 'placeholder', 'Application ID will appear here');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (25, 5, 'dataPath', 'submitResponse.data.applicationId');

-- Age properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (12, 6, 'readonly', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (13, 6, 'placeholder', 'Age will appear here');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (26, 6, 'dataPath', 'submitResponse.data.data.age');

-- Car Brand properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (14, 7, 'readonly', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (15, 7, 'placeholder', 'Car Brand will appear here');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (27, 7, 'dataPath', 'submitResponse.data.data.carBrand');

-- Status properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (16, 8, 'readonly', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (17, 8, 'placeholder', 'Status will appear here');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (28, 8, 'dataPath', 'submitResponse.data.status');

-- Message properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (18, 9, 'readonly', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (19, 9, 'placeholder', 'Message will appear here');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (29, 9, 'dataPath', 'submitResponse.data.message');

-- Estimated Processing Time properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (20, 10, 'readonly', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (21, 10, 'placeholder', 'Processing time will appear here');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (30, 10, 'dataPath', 'submitResponse.data.estimatedProcessingTime');

-- Submitted At properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (22, 11, 'readonly', 'true');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (23, 11, 'placeholder', 'Submission time will appear here');

INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (31, 11, 'dataPath', 'submitResponse.data.submittedAt');

-- Back to Home button properties
INSERT INTO WIDGET_PROPS (PROP_ID, WIDGET_ID, PROP_KEY, PROP_VALUE) 
VALUES (24, 12, 'variant', 'secondary');

-- =====================================================================
-- 4. WIDGET_ACTION Table - Back to Home button action
-- =====================================================================
INSERT INTO WIDGET_ACTION (
    ACTION_ID, 
    WIDGET_ID, 
    ACTION_NAME, 
    ACTION_TYPE, 
    TRIGGER_EVENT, 
    SUCCESS_HANDLER, 
    ORDER_NO, 
    IS_ENABLED
) VALUES (
    3,
    12,
    'backToHome',
    'navigation',
    'click',
    'navigateToPage:1',
    1,
    'Y'
);

-- =====================================================================
-- 5. ON_LOAD_SERVICE Table - Load submitted data from storage
-- =====================================================================
-- This service will be handled by frontend to load data from DataStore
-- No actual API call needed - data comes from previous page submission
-- We'll use a special service identifier to load from storage

COMMIT;

-- =====================================================================
-- Notes:
-- =====================================================================
-- 1. Page 2 (Confirmation) displays submitted form data
-- 2. All display widgets are read-only (readonly=true)
-- 3. Data will be populated from the submission response stored in DataStore
-- 4. Frontend should:
--    - Store submission response in DataStore with key 'submissionResponse'
--    - On page load, retrieve data from DataStore
--    - Populate widgets with data from response
-- 5. Back to Home button navigates back to Page 1
-- =====================================================================

