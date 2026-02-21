# Dynamic UI Builder - Setup and Overview

## ✅ What Has Been Created

### Spring Boot Backend (REST APIs)

All CRUD endpoints have been created in the `DynamicUiCode` project:

#### Product Controller (`/api/builder/products`)
- `GET /api/builder/products` - Get all products
- `GET /api/builder/products/{id}` - Get product by ID
- `POST /api/builder/products` - Create product
- `PUT /api/builder/products/{id}` - Update product
- `DELETE /api/builder/products/{id}` - Delete product

#### Category Controller (`/api/builder/categories`)
- `GET /api/builder/categories` - Get all categories
- `GET /api/builder/categories/{id}` - Get category by ID
- `GET /api/builder/categories/product/{productId}` - Get categories by product
- `POST /api/builder/categories` - Create category
- `PUT /api/builder/categories/{id}` - Update category
- `DELETE /api/builder/categories/{id}` - Delete category

#### Page Controller (`/api/builder/pages`)
- `GET /api/builder/pages` - Get all pages
- `GET /api/builder/pages/{id}` - Get page by ID
- `POST /api/builder/pages` - Create page
- `PUT /api/builder/pages/{id}` - Update page
- `DELETE /api/builder/pages/{id}` - Delete page

#### Widget Controller (`/api/builder/widgets`)
- `GET /api/builder/widgets/page/{pageId}` - Get widgets by page
- `GET /api/builder/widgets/{id}` - Get widget by ID
- `POST /api/builder/widgets` - Create widget
- `PUT /api/builder/widgets/{id}` - Update widget
- `DELETE /api/builder/widgets/{id}` - Delete widget

#### Widget Property Controller (`/api/builder/widget-properties`)
- `GET /api/builder/widget-properties/widget/{widgetId}` - Get properties by widget
- `POST /api/builder/widget-properties` - Create property
- `PUT /api/builder/widget-properties/{id}` - Update property
- `DELETE /api/builder/widget-properties/{id}` - Delete property
- `POST /api/builder/widget-properties/batch` - Create multiple properties

#### Widget Rule Controller (`/api/builder/widget-rules`)
- `GET /api/builder/widget-rules/widget/{widgetId}` - Get rules by widget
- `POST /api/builder/widget-rules` - Create rule
- `PUT /api/builder/widget-rules/{id}` - Update rule
- `DELETE /api/builder/widget-rules/{id}` - Delete rule

#### Widget Action Controller (`/api/builder/widget-actions`)
- `GET /api/builder/widget-actions/widget/{widgetId}` - Get actions by widget
- `POST /api/builder/widget-actions` - Create action
- `PUT /api/builder/widget-actions/{id}` - Update action
- `DELETE /api/builder/widget-actions/{id}` - Delete action

#### OnLoad Service Controller (`/api/builder/onload-services`)
- `GET /api/builder/onload-services/page/{pageId}` - Get services by page
- `POST /api/builder/onload-services` - Create service
- `PUT /api/builder/onload-services/{id}` - Update service
- `DELETE /api/builder/onload-services/{id}` - Delete service

### Angular UI Builder Application

Located in `dynamic-ui-builder/` directory:

#### Features:
1. **Hierarchical Navigation**: Product → Category → Page
2. **Drag & Drop**: Drag widgets from palette to canvas
3. **Visual Editor**: See widgets arranged on the page
4. **Property Editor**: Configure all widget properties
5. **Rule Editor**: Add visibility, enabled, and validation rules
6. **Action Editor**: Configure API calls, data binding, navigation
7. **OnLoad Service Editor**: Configure page-load services
8. **Auto-Save**: Properties save automatically on blur

#### Project Structure:
```
dynamic-ui-builder/
├── src/
│   ├── app/
│   │   ├── builder/
│   │   │   ├── builder.component.ts
│   │   │   ├── builder.component.html
│   │   │   └── builder.component.css
│   │   ├── services/
│   │   │   └── builder.service.ts
│   │   ├── models/
│   │   │   └── builder.models.ts
│   │   ├── app.component.ts
│   │   └── app.routes.ts
│   ├── environments/
│   │   └── environment.ts
│   ├── index.html
│   ├── main.ts
│   └── styles.css
├── angular.json
├── package.json
├── tsconfig.json
└── README.md
```

## 🚀 Getting Started

### 1. Install Dependencies

```bash
cd dynamic-ui-builder
npm install
```

### 2. Start the Builder

```bash
npm start
```

The builder will run on `http://localhost:4201`

### 3. Ensure Backend is Running

Make sure the Spring Boot application is running on `http://localhost:8080`

## 📋 Workflow

### Step 1: Create a Product
1. Builder opens with Products view
2. Click "New Product" button
3. Enter product name and description
4. Click "Save"
5. Product appears in the list

### Step 2: Create a Category
1. Click on a product to select it
2. View switches to Categories
3. Click "New Category" button
4. Enter category name and description
5. Click "Save"
6. Category appears in the list

### Step 3: Create a Page
1. Click on a category to select it
2. View switches to Pages
3. Click "New Page" button
4. Enter page details:
   - Title
   - Order number
   - Layout type (vertical/horizontal)
   - Columns per row (if horizontal)
5. Click "Save"
6. Page appears in the list

### Step 4: Add Widgets
1. Click on a page to select it
2. Widget palette appears in sidebar
3. Drag a widget from palette to canvas
4. Widget is automatically created and appears on canvas

### Step 5: Configure Widget
1. Click on a widget on the canvas
2. Properties panel shows on the right
3. Configure:
   - **Basic Info**: Name, label, order
   - **Properties**: Add key-value pairs (e.g., `placeholder`, `required`, `width`)
   - **Rules**: Add visibility, enabled, or validation rules
   - **Actions**: Add API calls, data binding, or navigation actions
4. Changes save automatically when you blur the input field

### Step 6: Configure OnLoad Services
1. Select a page (no widget selected)
2. In properties panel, find "OnLoad Services"
3. Click "+" button
4. Configure service details
5. Save automatically on blur

## 🎯 Key Features

### Hierarchical Structure
- **Products** → **Categories** → **Pages** → **Widgets**
- Breadcrumb navigation at the top of sidebar
- Click breadcrumb items to navigate back

### Drag & Drop
- Drag widgets from palette to canvas
- Widgets are automatically created in database
- Widgets appear immediately on canvas

### Auto-Save
- Properties save when you click outside (blur event)
- Rules save when you blur the expression field
- Actions save when you blur any action field
- Use "Save All" button to ensure everything is persisted

### Visual Feedback
- Selected widgets are highlighted
- Hover effects on widgets
- Delete buttons appear on hover
- Move up/down buttons for reordering

## 🔧 Configuration

### Environment
Edit `src/environments/environment.ts` to change API URL:
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api'
};
```

### Port
The builder runs on port 4201 by default. To change:
```bash
ng serve --port 4201
```

Or edit `package.json`:
```json
"start": "ng serve --port 4201"
```

## 📝 Notes

1. **First Time Setup**: You need at least one Product and Category in the database before creating pages. The builder helps you create them.

2. **CORS**: Make sure CORS is configured in Spring Boot to allow requests from `http://localhost:4201`

3. **Database**: All changes are saved directly to the database. No need to write SQL!

4. **Validation**: The builder doesn't validate all inputs - refer to DEVELOPER_GUIDE.md for valid values

5. **Widget Icons**: Font Awesome icons are used. If icons don't appear, check the CDN link in `index.html`

## 🐛 Troubleshooting

### Builder won't start
- Run `npm install` first
- Check Node.js version (v18+)
- Check for port conflicts (4201)

### Can't connect to backend
- Verify Spring Boot is running on port 8080
- Check CORS configuration
- Check browser console for errors

### Widgets not saving
- Check browser console for errors
- Verify backend API is responding
- Check network tab for failed requests

### Drag and drop not working
- Ensure a page is selected
- Check browser supports HTML5 drag and drop
- Try refreshing the page

## 📚 Related Documentation

- **DEVELOPER_GUIDE.md**: Complete reference for all widget types, properties, rules, and actions
- **UI_BUILDER_GUIDE.md**: Detailed user guide for the builder application
- **README.md** (in builder folder): Quick start guide

## 🎉 Benefits

1. **No SQL Required**: Create entire UI configurations through visual interface
2. **Real-time Preview**: See widgets as you add them
3. **Error Prevention**: Visual validation and helpful error messages
4. **Faster Development**: Drag, drop, configure - done!
5. **Easy Maintenance**: Update configurations without touching SQL

---

**Happy Building! 🚀**

