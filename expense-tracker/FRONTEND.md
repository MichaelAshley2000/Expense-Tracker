# Smart Expense Tracker - Frontend Build Prompt

Build a React-based frontend using Jac Lang for an AI-powered expense tracking application. Users can add expenses manually, from text descriptions, or from receipt images, view dashboard statistics, and query expenses using natural language.

## Requirements

### Design System
- **Colors**: Primary blue (#1e3a8a), secondary blue (#3b82f6), accent yellow (#fbbf24), success green (#10b981), light background (#f8fafc)
- **Styles**: Create reusable button, input, and card styles with consistent padding, border-radius, and shadows

### State Management (10 variables)
- `dashboardData`, `query`, `queryResponse`, `currentForm`, `imageFile`, `textDescription`, `amount`, `date`, `category`, `merchant`

### Core Features
1. **Dashboard**: Display total expenses (all-time + monthly), biggest category, and category breakdown grid with loading/empty states
2. **Add Expense**: Three input methods - manual form (amount, date, category, merchant), text description, receipt image upload
3. **Query Interface**: Natural language search with Enter key support and response display

### Backend Integration
Use these walkers: `init_graph`, `get_dashboard_data`, `add_expense`, `add_expense_from_text`, `add_expense_from_image`, `query_expenses`

### Layout Structure
- Header with title and subtitle
- Three main sections: Dashboard, Add Expense (with form toggle), Query
- Footer with attribution

### Event Handling Pattern
For async operations, define named `async def` functions and reference them directly in event handlers (e.g., `onClick={addManualExpense}`). Use lambdas only for non-async operations like state updates.
