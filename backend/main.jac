"""Smart Expense Tracker - Main Jac file

This file contains the core data structures and API endpoints for the Smart Expense Tracker application.
"""

import: os py;
import: py from dotenv, load_dotenv;

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
    has name: str = "";
    has email: str = "";
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



  