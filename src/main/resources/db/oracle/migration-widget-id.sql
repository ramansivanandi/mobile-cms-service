-- =====================================================================
-- Migration Script: Update UI_DATA_SOURCE table from COMPONENT_ID to WIDGET_ID
-- =====================================================================
-- This script migrates the UI_DATA_SOURCE table to use WIDGET_ID instead of COMPONENT_ID
-- Run this script BEFORE starting the application if you encounter ORA-01758 or ORA-00904 errors
-- =====================================================================

-- Step 1: Drop existing foreign key constraint on COMPONENT_ID (if exists)
BEGIN
    FOR rec IN (SELECT constraint_name 
                FROM user_constraints 
                WHERE table_name = 'UI_DATA_SOURCE' 
                AND constraint_type = 'R'
                AND (constraint_name LIKE '%COMPONENT%' OR constraint_name LIKE '%DATASOURCE%'))
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE UI_DATA_SOURCE DROP CONSTRAINT ' || rec.constraint_name;
            DBMS_OUTPUT.PUT_LINE('Dropped constraint: ' || rec.constraint_name);
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error dropping constraint ' || rec.constraint_name || ': ' || SQLERRM);
        END;
    END LOOP;
END;
/

-- Step 2: Drop existing index on COMPONENT_ID (if exists)
BEGIN
    FOR rec IN (SELECT index_name 
                FROM user_indexes 
                WHERE table_name = 'UI_DATA_SOURCE' 
                AND (index_name LIKE '%COMPONENT%' OR index_name LIKE '%DATASOURCE%'))
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP INDEX ' || rec.index_name;
            DBMS_OUTPUT.PUT_LINE('Dropped index: ' || rec.index_name);
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error dropping index ' || rec.index_name || ': ' || SQLERRM);
        END;
    END LOOP;
END;
/

-- Step 3: Check if WIDGET_ID column already exists, if not add it as nullable
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'UI_DATA_SOURCE' AND column_name = 'WIDGET_ID';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE UI_DATA_SOURCE ADD WIDGET_ID NUMBER';
        DBMS_OUTPUT.PUT_LINE('Added WIDGET_ID column');
    ELSE
        DBMS_OUTPUT.PUT_LINE('WIDGET_ID column already exists');
    END IF;
END;
/

-- Step 4: Copy data from COMPONENT_ID to WIDGET_ID (if COMPONENT_ID exists)
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'UI_DATA_SOURCE' AND column_name = 'COMPONENT_ID';
    
    IF v_count > 0 THEN
        UPDATE UI_DATA_SOURCE SET WIDGET_ID = COMPONENT_ID WHERE COMPONENT_ID IS NOT NULL;
        DBMS_OUTPUT.PUT_LINE('Copied data from COMPONENT_ID to WIDGET_ID: ' || SQL%ROWCOUNT || ' rows');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('COMPONENT_ID column does not exist, skipping data copy');
    END IF;
END;
/

-- Step 5: Make WIDGET_ID NOT NULL (only if all rows have been updated)
-- Check if there are any NULL values first
DECLARE
    v_null_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_null_count FROM UI_DATA_SOURCE WHERE WIDGET_ID IS NULL;
    
    IF v_null_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE UI_DATA_SOURCE MODIFY WIDGET_ID NUMBER NOT NULL';
        DBMS_OUTPUT.PUT_LINE('Made WIDGET_ID NOT NULL');
    ELSE
        DBMS_OUTPUT.PUT_LINE('WARNING: ' || v_null_count || ' rows have NULL WIDGET_ID. Please update them before making the column NOT NULL.');
    END IF;
END;
/

-- Step 6: Drop the old COMPONENT_ID column (if it exists)
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'UI_DATA_SOURCE' AND column_name = 'COMPONENT_ID';
    
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE UI_DATA_SOURCE DROP COLUMN COMPONENT_ID';
        DBMS_OUTPUT.PUT_LINE('Dropped COMPONENT_ID column');
    ELSE
        DBMS_OUTPUT.PUT_LINE('COMPONENT_ID column does not exist');
    END IF;
END;
/

-- Step 7: Add foreign key constraint for WIDGET_ID
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE UI_DATA_SOURCE 
                       ADD CONSTRAINT FK_DATASOURCE_WIDGET 
                       FOREIGN KEY (WIDGET_ID) REFERENCES WIDGET(WIDGET_ID) ON DELETE CASCADE';
    DBMS_OUTPUT.PUT_LINE('Added foreign key constraint FK_DATASOURCE_WIDGET');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2275 THEN
            DBMS_OUTPUT.PUT_LINE('Foreign key constraint already exists');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error adding foreign key: ' || SQLERRM);
        END IF;
END;
/

-- Step 8: Create index on WIDGET_ID
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX IDX_DATASOURCE_WIDGET_ID ON UI_DATA_SOURCE(WIDGET_ID)';
    DBMS_OUTPUT.PUT_LINE('Created index IDX_DATASOURCE_WIDGET_ID');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            DBMS_OUTPUT.PUT_LINE('Index already exists');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error creating index: ' || SQLERRM);
        END IF;
END;
/

COMMIT;

-- =====================================================================
-- Verification Query
-- =====================================================================
-- Run this to verify the migration was successful:
SELECT column_name, data_type, nullable 
FROM user_tab_columns 
WHERE table_name = 'UI_DATA_SOURCE' 
ORDER BY column_id;

SELECT constraint_name, constraint_type 
FROM user_constraints 
WHERE table_name = 'UI_DATA_SOURCE';
