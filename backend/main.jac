"""Smart Expense Tracker - Main Jac file

This file contains the core data structures and API endpoints for the Smart Expense Tracker application.
"""

import os;
import from dotenv {load_dotenv}

# Load environment variables from .env file
glob env_loaded = load_dotenv();

# Enums
enum ExpenseCategory {
    FOOD = "Food",
    TRANSPORT = "Transport",
    ENTERTAINMENT = "Entertainment",
    UTILITIES = "Utilities",
    HEALTH = "Health",
    OTHER = "Other"
}

enum Currency {
    USD = "USD",
    EUR = "EUR",
    GBP = "GBP",
    INR = "INR",
    JPY = "JPY",
    LKR = "LKR"
}

# Nodes

node User {
    has name: str;
    has email: str;
    has password: str; 
    has created_at: str;
}

node Settings {
    has currency: int;
    has budget_alerts: bool = true;
    has monthly_budget: float = 0.0;
}

node Category {
    has name: str;
    has category_type: ExpenseCategory;
    has description: str = "";
}

node Expense {
    has amount: float;
    has currency: Currency;
    has amount_usd: float;
    has merchant: str = "";
    has date: str;
    has created_at: str;
}

# Walkers

# Walker to initialize the graph with default user and settings

walker init_graph {
    "Initialize the graph with default user and settings"

    has user_name: str = "user";

    can create_graph with `root entry {
        # Create user node
        user_node = here ++> User(
            name = self.user_name,
            created_at = get_current_datetime()
        );

        # Create default settings node
        settings_node = here ++> Settings();

        # Create category nodes for default categories
        for cat in ExpenseCategory {
            cat_node = user_node ++> Category(
                name = cat.value,
                category_type = cat
            );
        };

        report {
            "message": "Graph initialized with default user and settings",
            "user": user_node.name,
            "categories_created": len(ExpenseCategory)
        };
    }
}

# Walker to add a new expense

walker add_expense {
    "Add a new expense to the graph"

    has amount: float;
    has currency: str = "USD";  # Default currency
    has merchant: str = "";
    has date: str;  # Expected format: YYYY-MM-DD
    has category_name: str;

    can add_to_category with `root entry {
        # Navigate to user node
        visit [-->](`?User);
    }

    can create_expense with User entry {
        # Find the matching category node
        target_category = None;
        for cat in [-->](`?Category) {
            if cat.name == self.category_name.upper() {
                target_category = cat;
                break;
            }
        }

  