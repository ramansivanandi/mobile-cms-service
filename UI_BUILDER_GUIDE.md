# Dynamic UI Builder - User Guide

## Overview

The Dynamic UI Builder is a visual drag-and-drop interface that allows you to create and configure dynamic UI pages without writing SQL. It provides an intuitive way to:

- Create pages with different layouts
- Add widgets by dragging from a palette
- Configure widget properties, rules, and actions
- Set up onLoad services
- Save everything directly to the database

## Getting Started

### Prerequisites

1. **Spring Boot Backend** must be running on `http://localhost:8080`
2. **Node.js** (v18 or higher) installed
3. **npm** or **yarn** package manager

### Installation

1. Navigate to the builder directory:
```bash
cd dynamic-ui-builder
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm start
```

4. Open browser to `http://localhost:4201`

## Interface Overview

The builder has three main sections:

### 1. Sidebar (Left)
- **Widget Palette**: Drag widgets from here onto the canvas
- **Pages List**: View and select existing pages
- **New Page Button**: Create a new page

### 2. Canvas (Center)
- **Page Display Area**: Shows widgets arranged on the page
- **Toolbar**: Page title and Save All button
- **Widget Management**: Click widgets to select, use arrows to reorder, trash to delete

### 3. Properties Panel (Right)
- **Page Properties**: When no widget is selected
- **Widget Properties**: When a widget is selected
  - Basic Info (name, label, order)
  - Properties (key-value pairs)
  - Rules (visibility, enabled, validation)
  - Actions (API calls, data binding, navigation)

## Step-by-Step Guide

### Creating Your First Page

1. **Click "New Page"** in the sidebar
2. **Fill in the form**:
   - **Title**: Enter a descriptive name (e.g., "User Registration")
   - **Category**: Select from dropdown (must have categories in database)
   - **Order**: Set the display order (1, 2, 3, etc.)
   - **Layout**: Choose "Vertical" or "Horizontal"
   - **Columns Per Row**: If horizontal, specify 2, 3, or 4
3. **Click "Save"**
4. The page appears in the pages list and is automatically selected

### Adding Widgets

1. **Select a page** from the sidebar (or create a new one)
2. **Drag a widget** from the palette onto the canvas
3. The widget is automatically created and appears on the canvas
4. **Click the widget** to select it and configure properties

### Configuring Widget Properties

1. **Select a widget** by clicking it on the canvas
2. In the properties panel, you'll see:
   - **Basic Info**: Name, label, order
   - **Properties**: Key-value pairs
3. **Add a property**:
   - Click the "+" button next to "Properties"
   - Enter a key (e.g., `placeholder`, `required`, `width`)
   - Enter a value (e.g., `Enter your name`, `true`, `50`)
   - The property saves automatically when you click outside the input
4. **Edit existing properties**: Click on the value and modify it
5. **Delete a property**: Click the trash icon

### Common Properties

| Property Key | Example Value | Description |
|-------------|---------------|-------------|
| `placeholder` | `Enter your name` | Placeholder text |
| `required` | `true` | Make field required |
| `readonly` | `true` | Make field read-only |
| `width` | `50` | Width percentage (1-100) |
| `dataPath` | `submitResponse.data.id` | Path to data in DataStore |
| `min` | `1` | Minimum value (for numbers) |
| `max` | `100` | Maximum value (for numbers) |
| `rows` | `5` | Number of rows (for textarea) |
| `accept` | `.pdf,.doc` | File types (for fileupload) |
| `variant` | `primary` | Button style (for button) |
| `size` | `large` | Button size (for button) |

### Adding Rules

1. **Select a widget**
2. In the properties panel, find the "Rules" section
3. **Click the "+" button**
4. **Configure the rule**:
   - **Type**: Choose from:
     - `visibility`: Show/hide widget
     - `enabled`: Enable/disable widget
     - `validation`: Validate widget value
   - **Expression**: Enter JavaScript expression (e.g., `age >= 18`, `termsAccepted == true`)
5. The rule saves automatically when you blur the input

### Adding Actions

1. **Select a widget**
2. In the properties panel, find the "Actions" section
3. **Click the "+" button**
4. **Configure the action**:
   - **Action Name**: Descriptive name (e.g., `submit`, `loadOptions`)
   - **Action Type**: 
     - `api_call`: Make HTTP request
     - `data_binding`: Bind data to widget
     - `navigation`: Navigate to another page
   - **Trigger Event**: When action fires (click, change, focus, blur, load)
   - **For API Calls**:
     - HTTP Method: GET, POST, PUT, DELETE
     - Endpoint URL: API endpoint (e.g., `/api/submit`)
     - Payload Template: JSON with variables (e.g., `{"age": "{{age}}"}`)
     - Headers: JSON headers (e.g., `{"Content-Type": "application/json"}`)
   - **Success Handler**: What to do on success (e.g., `navigateToPage:2:store:submitResponse`)
   - **Error Handler**: What to do on error (e.g., `showMessage:Error occurred`)
   - **Enabled**: Yes/No
5. The action saves automatically when you blur the input

### Configuring OnLoad Services

1. **Select a page** (no widget selected)
2. In the properties panel, find "OnLoad Services"
3. **Click the "+" button**
4. **Configure the service**:
   - **Service ID**: Unique identifier (e.g., `CAR_BRANDS_SERVICE`)
   - **API**: Endpoint URL (e.g., `/api/cars/brands`)
   - **HTTP Method**: GET, POST, PUT, DELETE
   - **Service Identifier**: Key for storing response (e.g., `carBrands`)
   - **On Success**: Handler (e.g., `store:carBrands`)
   - **On Failure**: Handler (e.g., `showMessage:Failed to load`)
5. The service saves automatically when you blur the input

### Reordering Widgets

1. **Select a widget** on the canvas
2. Use the **up/down arrow buttons** to move it
3. The order updates automatically in the database

### Deleting Widgets

1. **Select a widget** on the canvas
2. Click the **trash icon**
3. Confirm deletion
4. The widget is removed from the page and database

### Saving Changes

- **Auto-Save**: Properties, rules, and actions save automatically when you blur the input field
- **Save All**: Click the "Save All" button in the toolbar to ensure all changes are persisted
- **Page Settings**: Page properties (title, layout, etc.) are saved when you click "Save All"

## Tips and Best Practices

### Widget Naming
- Use **camelCase** for widget names (e.g., `firstName`, `carBrand`)
- Use **descriptive labels** (e.g., `First Name`, `Car Brand`)

### Property Keys
- Use **camelCase** for property keys (e.g., `dataPath`, `showTermsLink`)
- Refer to the Developer Guide for all available properties

### Rules
- Keep expressions **simple and readable**
- Test expressions in browser console before adding
- Use `==` for loose equality, `===` for strict equality

### Actions
- Use **descriptive action names**
- Set appropriate **timeouts** (default: 30000ms)
- Always provide **error handlers**

### OnLoad Services
- Use **descriptive service identifiers**
- Store data with meaningful keys for easy reference

## Troubleshooting

### Widgets not appearing after drag
- Check browser console for errors
- Verify backend is running
- Check network tab for API call failures
- Refresh the page

### Properties not saving
- Ensure you click outside the input field (blur event)
- Check browser console for errors
- Verify backend API is responding

### Drag and drop not working
- Ensure you're dragging from the widget palette
- Check that a page is selected
- Try refreshing the page
- Check browser compatibility (modern browsers required)

### Can't create page
- Ensure categories exist in the database
- Check that backend is running
- Verify CORS is configured correctly
- Check browser console for errors

## API Endpoints Used

The builder uses these REST endpoints:

- `GET /api/builder/pages` - Get all pages
- `GET /api/builder/pages/{id}` - Get page by ID
- `POST /api/builder/pages` - Create page
- `PUT /api/builder/pages/{id}` - Update page
- `DELETE /api/builder/pages/{id}` - Delete page

- `GET /api/builder/widgets/page/{pageId}` - Get widgets by page
- `POST /api/builder/widgets` - Create widget
- `PUT /api/builder/widgets/{id}` - Update widget
- `DELETE /api/builder/widgets/{id}` - Delete widget

- `GET /api/builder/widget-properties/widget/{widgetId}` - Get properties
- `POST /api/builder/widget-properties` - Create property
- `PUT /api/builder/widget-properties/{id}` - Update property
- `DELETE /api/builder/widget-properties/{id}` - Delete property
- `POST /api/builder/widget-properties/batch` - Create multiple properties

- `GET /api/builder/widget-rules/widget/{widgetId}` - Get rules
- `POST /api/builder/widget-rules` - Create rule
- `PUT /api/builder/widget-rules/{id}` - Update rule
- `DELETE /api/builder/widget-rules/{id}` - Delete rule

- `GET /api/builder/widget-actions/widget/{widgetId}` - Get actions
- `POST /api/builder/widget-actions` - Create action
- `PUT /api/builder/widget-actions/{id}` - Update action
- `DELETE /api/builder/widget-actions/{id}` - Delete action

- `GET /api/builder/onload-services/page/{pageId}` - Get onLoad services
- `POST /api/builder/onload-services` - Create onLoad service
- `PUT /api/builder/onload-services/{id}` - Update onLoad service
- `DELETE /api/builder/onload-services/{id}` - Delete onLoad service

- `GET /api/builder/categories` - Get all categories

## Next Steps

After creating your pages in the builder:

1. **Test in the main UI**: Use the dynamic-ui-frontend application to see your pages in action
2. **Refine**: Go back to the builder to make adjustments
3. **Add more pages**: Create additional pages for your application flow
4. **Configure actions**: Set up navigation between pages using actions

## Support

For detailed information about:
- Widget types and properties: See `DEVELOPER_GUIDE.md`
- API response formats: See `DEVELOPER_GUIDE.md`
- Database schema: See `src/main/resources/db/oracle/schema.sql`

