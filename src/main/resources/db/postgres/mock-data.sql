-- =====================================================================
-- PostgreSQL Mock Data for Dynamic UI Configuration
-- =====================================================================
-- Run AFTER schema.sql has been executed.
-- Order: product -> category -> page -> widget -> widget_props,
--         widget_rule, ui_data_source, widget_action, on_load_service
-- =====================================================================

-- 1. PRODUCT
INSERT INTO product (product_id, name, description) VALUES
  (1, 'Insurance', 'Insurance Product Configuration'),
  (2, 'Banking', 'Banking Product Configuration')
ON CONFLICT (product_id) DO NOTHING;

-- 2. CATEGORY
INSERT INTO category (category_id, product_id, name, description) VALUES
  (1, 1, 'Motor Insurance', 'Motor Insurance Category'),
  (2, 1, 'Home Insurance', 'Home Insurance Category'),
  (3, 2, 'Savings Account', 'Savings Account Category')
ON CONFLICT (category_id) DO NOTHING;

-- 3. PAGE
INSERT INTO page (page_id, category_id, title, order_no, layout_type, columns_per_row) VALUES
  (1, 1, 'Personal Info', 1, 'horizontal', 2),
  (2, 1, 'Confirmation', 2, 'vertical', NULL),
  (3, 2, 'Property Details', 1, 'horizontal', 2),
  (4, 3, 'Account Setup', 1, 'vertical', NULL)
ON CONFLICT (page_id) DO NOTHING;

-- 4. WIDGET (page 1 - Personal Info)
INSERT INTO widget (widget_id, page_id, parent_widget_id, type, name, label, order_no) VALUES
  (1, 1, NULL, 'textbox',   'age',            'Age',                         1),
  (2, 1, NULL, 'dropdown',  'carBrand',       'Car Brand',                   2),
  (3, 1, NULL, 'button',    'submit',         'Submit',                      3),
  (4, 1, NULL, 'checkbox',  'termsAccepted',  'Accept Terms and Conditions', 4),
  -- page 2 - Confirmation
  (5, 2, NULL, 'label',     'confirmTitle',   'Application Submitted',       1),
  (6, 2, NULL, 'label',     'refNo',          'Reference Number',            2),
  -- page 3 - Property Details (card with nested children)
  (7, 3, NULL, 'card',      'propertyCard',   'Property Information',        1),
  (8, 3, 7,    'textbox',   'address',        'Property Address',            1),
  (9, 3, 7,    'dropdown',  'propertyType',   'Property Type',               2),
  -- page 4 - Account Setup
  (10, 4, NULL, 'textbox',  'accountName',    'Account Holder Name',         1),
  (11, 4, NULL, 'dropdown', 'accountType',    'Account Type',                2)
ON CONFLICT (widget_id) DO NOTHING;

-- 5. WIDGET_PROPS
INSERT INTO widget_props (prop_id, widget_id, prop_key, prop_value) VALUES
  -- age textbox
  (1,  1, 'placeholder', 'Enter age'),
  (2,  1, 'required',    'true'),
  (3,  1, 'min',         '1'),
  (4,  1, 'max',         '100'),
  (5,  1, 'width',       '50'),
  -- carBrand dropdown
  (6,  2, 'placeholder', 'Select car brand'),
  (7,  2, 'required',    'true'),
  (8,  2, 'multiple',    'false'),
  (9,  2, 'width',       '50'),
  -- submit button
  (10, 3, 'variant',     'primary'),
  (11, 3, 'size',        'large'),
  -- terms checkbox
  (12, 4, 'required',    'true'),
  (13, 4, 'showTermsLink', 'true'),
  (14, 4, 'termsLinkText', 'Terms and Conditions'),
  -- address textbox (nested in card)
  (15, 8, 'placeholder', 'Enter property address'),
  (16, 8, 'required',    'true'),
  -- propertyType dropdown (nested in card)
  (17, 9, 'placeholder', 'Select property type'),
  (18, 9, 'required',    'true'),
  -- account name
  (19, 10, 'placeholder', 'Enter full name'),
  (20, 10, 'required',    'true'),
  -- account type dropdown
  (21, 11, 'placeholder', 'Select account type'),
  (22, 11, 'required',    'true')
ON CONFLICT (prop_id) DO NOTHING;

-- 6. WIDGET_RULE
INSERT INTO widget_rule (rule_id, widget_id, rule_type, rule_expression) VALUES
  (1, 1, 'validation', 'value >= 18'),
  (2, 2, 'visibility', 'age >= 18'),
  (3, 3, 'enabled',    'termsAccepted == true'),
  (4, 8, 'required',   'true'),
  (5, 9, 'required',   'true')
ON CONFLICT (rule_id) DO NOTHING;

-- 7. UI_DATA_SOURCE (static dropdown options)
INSERT INTO ui_data_source (ds_id, widget_id, source_type, source_value) VALUES
  (1, 9, 'static', '[{"id":"house","name":"House"},{"id":"apartment","name":"Apartment"},{"id":"condo","name":"Condo"}]'),
  (2, 11, 'static', '[{"id":"savings","name":"Savings"},{"id":"checking","name":"Checking"},{"id":"fixed","name":"Fixed Deposit"}]')
ON CONFLICT (ds_id) DO NOTHING;

-- 8. WIDGET_ACTION
INSERT INTO widget_action (action_id, widget_id, action_name, action_type, trigger_event, http_method, endpoint_url, payload_template, payload_type, headers, query_params, success_handler, error_handler, timeout_ms, order_no, is_enabled) VALUES
  (1, 3, 'submit', 'api_call', 'click', 'POST', '/api/insurance/submit',
   '{"age": "{{age}}", "carBrand": "{{carBrand}}", "timestamp": "{{$timestamp}}}"}',
   'dynamic',
   '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
   NULL,
   'navigateToPage:2:store:submitResponse',
   'showMessage:Error occurred while submitting',
   30000, 1, 'Y'),
  (2, 2, 'loadOptions', 'data_binding', 'focus', NULL, NULL, NULL, NULL, NULL, NULL,
   'updateDropdown:carBrand:carBrands', NULL, NULL, 1, 'Y')
ON CONFLICT (action_id) DO NOTHING;

-- 9. ON_LOAD_SERVICE
INSERT INTO on_load_service (on_load_service_id, page_id, service_id, api, http_method, payload, headers, service_identifier, on_success, on_failure) VALUES
  (1, 1, 'USER_DATA_SERVICE', '/api/user/profile', 'GET', NULL,
   '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
   'userProfile', 'setFormData:userProfile', 'showMessage:Failed to load user data'),
  (2, 1, 'CAR_BRANDS_SERVICE', '/api/cars/brands', 'GET', NULL,
   '{"Content-Type": "application/json"}',
   'carBrands', 'updateDropdown:carBrand', 'showMessage:Failed to load car brands'),
  (3, 1, 'INIT_FORM_SERVICE', '/api/forms/initialize', 'POST',
   '{"formType": "insurance", "userId": "{{$userId}}"}',
   '{"Content-Type": "application/json", "Authorization": "Bearer {{$token}}"}',
   'formInit', 'setFormData:formData', 'showMessage:Failed to initialize form'),
  (4, 1, 'CONFIG_SERVICE', '/api/config/settings?category=motor', 'GET', NULL,
   '{"Content-Type": "application/json"}',
   'appConfig', 'setGlobalConfig:config', 'showMessage:Failed to load configuration'),
  (5, 1, 'VALIDATION_RULES_SERVICE', '/api/validation/rules', 'GET', NULL,
   '{"Content-Type": "application/json"}',
   'validationRules', 'setValidationRules:rules', 'showMessage:Failed to load validation rules')
ON CONFLICT (on_load_service_id) DO NOTHING;

-- Sync sequences after data insert
SELECT setval('seq_product_id', COALESCE((SELECT MAX(product_id) FROM product), 0) + 1, false);
SELECT setval('seq_category_id', COALESCE((SELECT MAX(category_id) FROM category), 0) + 1, false);
SELECT setval('seq_page_id', COALESCE((SELECT MAX(page_id) FROM page), 0) + 1, false);
SELECT setval('seq_widget_id', COALESCE((SELECT MAX(widget_id) FROM widget), 0) + 1, false);
SELECT setval('seq_prop_id', COALESCE((SELECT MAX(prop_id) FROM widget_props), 0) + 1, false);
SELECT setval('seq_rule_id', COALESCE((SELECT MAX(rule_id) FROM widget_rule), 0) + 1, false);
SELECT setval('seq_ds_id', COALESCE((SELECT MAX(ds_id) FROM ui_data_source), 0) + 1, false);
SELECT setval('seq_action_id', COALESCE((SELECT MAX(action_id) FROM widget_action), 0) + 1, false);
SELECT setval('seq_on_load_service_id', COALESCE((SELECT MAX(on_load_service_id) FROM on_load_service), 0) + 1, false);
