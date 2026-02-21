-- =====================================================================
-- Migration Script: Add PARENT_WIDGET_ID column to WIDGET table
-- =====================================================================
-- This script adds support for nested widgets (e.g., widgets inside cards)
-- 
-- Run this script on existing databases to add the parent widget relationship
-- =====================================================================

-- Add PARENT_WIDGET_ID column to WIDGET table
ALTER TABLE WIDGET ADD PARENT_WIDGET_ID NUMBER;

-- Add foreign key constraint for parent widget relationship
ALTER TABLE WIDGET 
ADD CONSTRAINT FK_WIDGET_PARENT 
FOREIGN KEY (PARENT_WIDGET_ID) 
REFERENCES WIDGET(WIDGET_ID) 
ON DELETE CASCADE;

-- Create index for better query performance
CREATE INDEX IDX_WIDGET_PARENT ON WIDGET(PARENT_WIDGET_ID);

-- Note: Existing widgets will have PARENT_WIDGET_ID = NULL (top-level widgets)
-- This ensures backward compatibility with existing data

