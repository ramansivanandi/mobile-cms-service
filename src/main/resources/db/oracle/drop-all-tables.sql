-- =====================================================================
-- Drop All Tables Script
-- =====================================================================
-- This script drops all tables in the correct order to respect foreign key constraints
-- Run this script, then restart the application - Hibernate will recreate all tables
-- =====================================================================

-- Drop tables in reverse order of dependencies
DROP TABLE ON_LOAD_SERVICE CASCADE CONSTRAINTS;
DROP TABLE WIDGET_ACTION CASCADE CONSTRAINTS;
DROP TABLE UI_DATA_SOURCE CASCADE CONSTRAINTS;
DROP TABLE WIDGET_RULE CASCADE CONSTRAINTS;
DROP TABLE WIDGET_PROPS CASCADE CONSTRAINTS;
DROP TABLE WIDGET CASCADE CONSTRAINTS;
DROP TABLE PAGE CASCADE CONSTRAINTS;
DROP TABLE CATEGORY CASCADE CONSTRAINTS;
DROP TABLE PRODUCT CASCADE CONSTRAINTS;

-- Drop sequences (optional - Hibernate will recreate them)
DROP SEQUENCE SEQ_PRODUCT_ID;
DROP SEQUENCE SEQ_CATEGORY_ID;
DROP SEQUENCE SEQ_PAGE_ID;
DROP SEQUENCE SEQ_WIDGET_ID;
DROP SEQUENCE SEQ_PROP_ID;
DROP SEQUENCE SEQ_RULE_ID;
DROP SEQUENCE SEQ_DS_ID;
DROP SEQUENCE SEQ_ACTION_ID;
DROP SEQUENCE SEQ_ON_LOAD_SERVICE_ID;

COMMIT;

-- =====================================================================
-- After running this script:
-- 1. Restart your Spring Boot application
-- 2. Hibernate will automatically create all tables with the new schema
-- 3. You can then run your data insertion scripts
-- =====================================================================

