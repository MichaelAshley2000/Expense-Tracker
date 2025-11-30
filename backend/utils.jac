"""Utility functions for the Smart Expense Tracker.

This module contains helper functions for currency conversion, date formatting, and budget calculations.
"""

import os;
import requests;
import from datetime {datetime, timedelta}
import from dotenv {load_dotenv}

# Load environment variables from .env file
glob env_loaded = load_dotenv();
# Currency conversion configuration
glob CURRENCY_API_KEY = os.getenv("CURRENCY_API_KEY");
glob CURRENCY_API_URL = "https://v6.exchangerate-api.com/v6/" + CURRENCY_API_KEY + "/latest/";

# Currency conversion utility functions

def convert_currency(amount: float, from_currency: str, to_currency: str) -> float {
    if from_currency == to_currency {
        return amount;
    }

    try {
        # Get exchange rates from the API
        url = CURRENCY_API_URL + from_currency;
        response = requests.get(url);

        if response.status_code == 200 {
            data = response.json();
            rates = data["conversion_rates"];
            if to_currency in rates {
                rate = rates[to_currency];
                return round(amount * rate, 2);
            }
        }
    } except Exception as e {
            print("Error fetching exchange rates: " + str(e));
    }
    return amount;  # Fallback to original amount if conversion fails
}

# Date Time utility functions

def parse_date(date_str: str) -> datetime {
    # Common date formats
    formats = [
        "%Y-%m-%d", #2025-12-31
        "%d-%m-%Y", #31-12-2025
        "%m/%d/%Y", #12/31/2025
        "%Y/%m/%d", #2025/12/31
        "%d %b %Y", #31 Dec 2025
        "%d %B %Y"  #31 December 2025
    ];

    for fmt in formats {
        try {
            return datetime.strptime(date_str, fmt);
        } except ValueError {
            continue;
        }
    }

    # If no format matches, return current date as fallback
    return get_current_date();
}

def get_current_datetime() -> str {
    # Get current date and time in ISO 8601 format
    return datetime.now().isoformat();
}

def get_current_date() -> str {
    # Get current date in YYYY-MM-DD format
    return datetime.now().strftime("%Y-%m-%d");
}

def get_current_month() -> str {
    # Get current month in YYYY-MM format
    return datetime.now().strftime("%Y-%m");
}

def get_current_time() -> str {
    # Get current time in HH:MM:SS format
    return datetime.now().strftime("%H:%M:%S");
}

def month_range(year: int, month: int) -> (str, str) {
    # Get the start and end date of a given month
    start_date = datetime(year, month, 1);
    if month == 12 {
        end_date = datetime(year + 1, 1, 1) - timedelta(days=1);
    } else {
        end_date = datetime(year, month + 1, 1) - timedelta(days=1);
    }
    return {
        "start_date": start_date.strftime("%Y-%m-%d"),
        "end_date": end_date.strftime("%Y-%m-%d")
    };
}

def get_last_n_months(n: int) -> list {
    # Get a list of the last n months in 'YYYY-MM' format
    months = [];
    today = datetime.now();
    for i in range(n) {
        month = today.strftime("%Y-%m");
        today = datetime.now();
        months.append(month);

        # Go back one month
        if today.month == 1 {
            today = datetime(today.year - 1, 12, 1);
        } else {
            today = datetime(today.year, today.month - 1, 1);
        }
    }

    # Return months in chronological order
    months = months.reverse();
    return months;
}

def is_date_in_range(date_str: str, start_str: str, end_str: str) -> bool {
    # Check if a date is within a given range
    try {
        date = parse_date(date_str);
        start_date = parse_date(start_str);
        end_date = parse_date(end_str);
        return start_date <= date <= end_date;
    } except ValueError {
        return False;
    }
}

# Data Validation Functions

def is_valid_currency(currency_code: str) -> bool {
    # Validate if the currency code is a valid ISO 4217 code
    valid_currencies = [
        "USD", "EUR", "GBP", "JPY", "AUD", "CAD", "CHF", "CNY", "SEK", "NZD",
        # Add more currency codes as needed
    ];
    return currency_code.upper() in valid_currencies;
}

def is_positive_amount(amount: float) -> bool {
    # Check if the amount is a positive number
    return isinstance(amount, (int, float)) and amount > 0;
}

def format_amount(amount: float, currency_code: str) -> str {
    # Format amount with currency symbol
    symbols = {
        "USD": "$",
        "EUR": "€",
        "GBP": "£",
        "JPY": "¥",
        # Add more symbols as needed
    };
    symbol = symbols.get(currency_code.upper(), "");
    return symbol + str(round(amount, 2));
}
  

