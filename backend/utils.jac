"""Utility functions for the Expense Tracker application

This module includes functions for currency conversion and date handling, and other common operations.
"""

import os;
import requests;
import from datetime {datetime, timedelta}

# Currency conversion 

glob CURRENCY_API_URL = "https://api.exchangerate-api.com/v4/latest/";

def convert_currency(amount: float, from_currency: str, to_currency: str) -> float {
    # Convert amount from one currency to another.

    # If same currency, return the same amount
    if from_currency == to_currency {
        return amount;
    }

    try {
        # Get exchange rates from the API
        url = CURRENCY_API_URL + from_currency;
        response = requests.get(url, timeout=5);

        if response.status_code == 200 {
            data = response.json();
            rates = data.get("rates", {});
            if to_currency in rates {
                rate = rates[to_currency];
                converted_amount = amount * rate;
                return round(converted_amount,2);
            } 
        }
    } except Exception as e {
        print("Error converting currency:", e);
    }

    # Fallback: return original amount if conversion fails
    return amount;
}

def get_exchange_rate(from_currency: str, to_currency: str = "USD") -> float {
    # Fetch the exchange rate from one currency to another.

    if from_currency == to_currency {
        return 1.0;
    }

    try {
        url = CURRENCY_API_URL + from_currency;
        response = requests.get(url, timeout=5);

        if response.status_code == 200 {
            data = response.json();
            rates = data.get("rates", {});
            if to_currency in rates {
                return rates[to_currency];
            } 
        }
    } except Exception as e {
        print("Error fetching exchange rate:", e);
    }

    return 1.0;
}

# Date Time utilities

def parse_date(date_str: str) -> datetime {
    # Parse a date string in YYYY-MM-DD format to a datetime object.
    
    # Common date formats
    formats = [
        "%Y-%m-%d", # 2025-12-31
        "%d-%m-%Y", # 31-12-2025
        "%m-%d-%Y", # 12-31-2025
        "%Y/%m/%d", # 2025/12/31
        "%d/%m/%Y", # 31/12/2025
        "%Y.%m.%d" # 2025.12.31
    ];

    for fmt in formats {
        try {
            return datetime.strptime(date_str, fmt);
        } except ValueError {
            continue;
        }
    }

    # If no format matches, return current date
    return get_current_date();
}

def get_current_datetime() -> str {
    # Get current date and time in ISO 8601 format.
    return datetime.now().isoformat();
}

def get_current_date() -> str {
    # Get current date in YYYY-MM-DD format.
    return datetime.now().strftime("%Y-%m-%d");
}

def get_current_month() -> str {
    # Get current month in YYYY-MM format.
    return datetime.now().strftime("%Y-%m");
}

def get_current_time() -> str {
    # Get current time in HH:MM:SS format.
    return datetime.now().strftime("%H:%M:%S");
}

def get_month_range(year: int, month: int) -> (str, str) {
    # Get the start and end date of a given month.
    
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

def get_last_n_months(n: int = 6) -> [str] {
    # Get a list of the last n months in YYYY-MM format.
    
    months = [];
    today = datetime.now();
    for i in range(n) {
        month = today.strftime("%Y-%m");
        months.append(month);

        # Go back one month
        if today.month == 1 {
            today = datetime(today.year - 1, 12, 1);
        } else {
            today = datetime(today.year, today.month - 1, 1);
        }
    }

    # Return in chronological order
    return months.reverse();   
}

def is_date_in_range(date_str: str, start_date_str: str, end_date_str: str) -> bool {
    # Check if a date is within a specified range.

    try {
        date = parse_date(date_str);
        start_date = parse_date(start_date_str);
        end_date = parse_date(end_date_str);

        return start_date <= date <= end_date;
    } except Exception as e {
        return false;
    }
}

# Data Validation utilities