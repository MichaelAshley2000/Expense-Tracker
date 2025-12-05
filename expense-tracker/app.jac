"""Smart Expense Tracker - Main Jac file

This file contains the core data structures and API endpoints for the Smart Expense Tracker application.
"""

import os;
import from dotenv {load_dotenv}
import from utils {get_current_datetime, get_current_date, get_current_month}
import from ai_utils {
    extract_expense_from_image_file,
    extract_expense_from_text,
    parse_natural_language_query,
    process_query_response
}

cl import from react {useState, useEffect}

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
    has currency: Currency = Currency.USD;
    has budget_alerts: bool = True;
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
    has date: str;
    has created_at: str;
    has merchant: str = "";
}

# Walkers

# Walker to initialize the graph with default user and settings

walker init_graph {
    "Initialize the graph with default user and settings"

    has user_name: str = "user";
    has password: str = "password123";

    can create_graph with `root entry {
        # Create user node
        user_node = here ++> User(
            name = self.user_name,
            email = self.user_name + "@example.com",
            password = self.password,
            created_at = get_current_datetime()
        );

        # Create default settings node
        settings_node = here ++> Settings(
            currency = Currency.USD,
        );

        # Create category nodes for default categories
        for cat in ExpenseCategory {
            cat_node = user_node ++> Category(
                name = cat.value,
                category_type = cat
            );
        };

        report {
            "message": "Graph initialized with default user and settings",
            "user": user_node[0].name,
            "categories_created": len(ExpenseCategory)
        };
    }
}

# Walker to add a new expense

walker add_expense {
    "Add a new expense to the graph"

    has amount: float;
    has date: str;  # Expected format: YYYY-MM-DD
    has category_name: str;
    has currency: str = "USD";  # Default currency
    has merchant: str = "";

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
        };
        if not target_category {
            # Default to 'OTHER' category if not found
            for cat in [-->](`?Category) {
                if cat.category_type == ExpenseCategory.OTHER {
                    target_category = cat;
                    break;
                }
            };
        };

        # Convert amount to USD if necessary (placeholder logic)
        amount_usd = self.amount;

        # Create expense node
        expense_date = self.date if self.date else get_current_date();
        new_expense = target_category ++> Expense(
            amount = self.amount,
            currency = Currency[self.currency] if self.currency in Currency else Currency.USD,
            amount_usd = amount_usd,
            merchant = self.merchant,
            date = expense_date,
            created_at = get_current_datetime()
        );

        report {
            "message": "Expense added successfully",
            "amount": new_expense[0].amount,
            "currency": new_expense[0].currency,
            "category": target_category.name,
            "date": new_expense[0].date
        };
    }
}

walker get_dashboard_data {
    """Retrieve dashboard data including total expenses and category breakdown"""

    can fetch_data with `root entry {
        # Navigate to user node
        visit [-->](`?User);
    }

    can calculate_data with User entry {
        current_month = get_current_month();
        total_expenses = 0.0;
        category_breakdown = {};

        for cat in [-->](`?Category) {
            cat_total = 0.0;
            cat_expenses = [];

            # Sum expenses for the current month in this category
            for exp in [-->](`?Expense) {
                # Filter by current month
                if exp.date.startswith(current_month) {
                    cat_total += exp.amount_usd;
                    total_expenses += exp.amount_usd;
                    cat_expenses.append({
                        "amount": exp.amount,
                        "merchant": exp.merchant,
                        "date": exp.date
                    });
                } 
            }

            if cat_total > 0.0 {
                category_breakdown[cat.name] = {
                    "total": cat_total,
                    "count": len(cat_expenses),
                    "expenses": cat_expenses
                };
            } 
        }

        # Find biggest expense category
        biggest_category = None;
        biggest_amount = 0.0;
        for (cat_name, data) in category_breakdown.items() {
            if data["total"] > biggest_amount {
                biggest_amount = data["total"];
                biggest_category = cat_name;
            };
        };

        report {
            "currency": "USD",
            "total_expenses_usd": total_expenses,
            "month": current_month,
            "category_breakdown": category_breakdown,
            "biggest_category": biggest_category,
            "biggest_amount": biggest_amount
        };
    }
}

walker get_expenses_by_category {
    """Retrieve expenses filtered by category"""

    has category_name: str;

    can fetch_expenses with `root entry {
        # Navigate to user node
        visit [-->](`?User);
    }

    can get_expenses with User entry {
        expenses = [];

        # Find the matching category node
        for cat in [-->](`?Category) {
            if cat.category_type.name == self.category_name.upper() {
                # Get all expenses in this category
                for exp in [-->](`?Expense) {
                    expenses.append({
                        "amount": exp.amount,
                        "currency": exp.currency,
                        "merchant": exp.merchant,
                        "date": exp.date,
                        "created_at": exp.created_at
                    });
                }
                break;
            }
        }
        report {
            "category": self.category_name,
            "count": len(expenses),
            "expenses": expenses
        };
    }
}

walker add_expense_from_image {
    """Add a new expense by extracting details from a receipt image"""

    has image_path: str;

    can process_image with `root entry {
        # Navigate to user node
        visit [-->](`?User);
    }

    can create_expense with User entry {
        # Extract expense details from image
        expense_data = extract_expense_from_image_file(self.image_path);

        # Find the matching category node (default to OTHER)
        target_category = None;
        for cat in [-->](`?Category) {
            if expense_data.category.upper() == cat.name {
                target_category = cat;
                break;
            }
        };

        if not target_category {
            for cat in [-->](`?Category) {
                if cat.category_type == ExpenseCategory.OTHER {
                    target_category = cat;
                    break;
                }
            };
        };

        # Create expense node
        new_expense = target_category ++> Expense(
            amount = expense_data.amount,
            currency = Currency[expense_data.currency] if expense_data.currency in Currency else Currency.USD,
            amount_usd = expense_data.amount,  # Placeholder for conversion logic
            merchant = expense_data.merchant,
            date = expense_data.date,
            created_at = get_current_datetime()
        );

        report {
            "message": "Expense added from image successfully",
            "merchant": new_expense[0].merchant,
            "amount": new_expense[0].amount,
            "currency": new_expense[0].currency,
            "category": target_category.name,
            "date": new_expense[0].date
        };
    }
}

walker add_expense_from_text {
    """Add a new expense by extracting details from text description"""

    has description: str;

    can process_text with `root entry {
        # Navigate to user node
        visit [-->](`?User);
    }

    can create_expense with User entry {
        # Extract expense details from text
        expense_data = extract_expense_from_text(self.description);

        # Find the matching category node (default to OTHER)
        target_category = None;
        for cat in [-->](`?Category) {
            if expense_data.category.upper() == cat.name {
                target_category = cat;
                break;
            }
        };

        if not target_category {
            for cat in [-->](`?Category) {
                if cat.category_type == ExpenseCategory.OTHER {
                    target_category = cat;
                    break;
                }
            };
        };

        # Create expense node
        new_expense = target_category ++> Expense(
            amount = expense_data.amount,
            currency = Currency[expense_data.currency] if expense_data.currency in Currency else Currency.USD,
            amount_usd = expense_data.amount,  # Placeholder for conversion logic
            merchant = expense_data.merchant,
            date = expense_data.date,
            created_at = get_current_datetime()
        );

        report {
            "message": "Expense added from text successfully",
            "merchant": new_expense[0].merchant,
            "amount": new_expense[0].amount,
            "currency": new_expense[0].currency,
            "category": target_category.name,
            "date": new_expense[0].date
        };
    }
}

walker query_expenses {
    """Query expenses based on natural language input"""

    has query: str;
    has conversation_context: dict[str, str] = {};

    can process_query with `root entry {
        # Navigate to user node
        visit [-->](`?User);
    }

    can fetch_expenses with User entry {
        # Collect all expenses
        all_expenses = [];

        for cat in [-->](`?Category) {
            for exp in [-->](`?Expense) {
                all_expenses.append({
                    "amount": exp.amount,
                    "currency": exp.currency,
                    "merchant": exp.merchant,
                    "date": exp.date,
                    "category": cat.name,
                    "created_at": exp.created_at
                });
            }
        };

        # Parse query parameters using AI
        parsed_query = parse_natural_language_query(self.query, self.conversation_context);
        # Process the respone using the query parameters to filter and analyze expenses
        ai_response = process_query_response(parsed_query, all_expenses);

        report {
            "query": self.query,
            "response": ai_response
        }; 
    }
}

cl {
    def app() -> any {
        [dashboardData, setDashboardData] = useState(None);
        [query, setQuery] = useState("");
        [queryResponse, setQueryResponse] = useState(None);
        [currentForm, setCurrentForm] = useState("");
        [imageFile, setImageFile] = useState(None);
        [textDescription, setTextDescription] = useState("");
        [amount, setAmount] = useState(0.0);
        [date, setDate] = useState("");
        [category, setCategory] = useState("");
        [merchant, setMerchant] = useState("");
        
        # Styles - color


        # Styles - buttons


        # Styles - inputs


        # Styles - cards



        useEffect(lambda -> None {
            async def loadData() -> None {
                # Fetch dashboard data on component mount
                init_result = await root spawn init_graph();
                dashboard_result = await root spawn get_dashboard_data();
                if dashboard_result.reports and dashboard_result.reports.length > 0 {
                    setDashboardData(dashboard_result.reports[0]);
                } else {
                    response = None;
                }
            }
            loadData();
        }, []);

        async def refreshDashboard() -> None {
            dashboard_result = await root spawn get_dashboard_data();
            if dashboard_result.reports and dashboard_result.reports.length > 0 {
                setDashboardData(dashboard_result.reports[0]);
            }
        }

        async def handleQuery() -> None {
            if query.trim() == "" {
                return;
            }
            query_result = await root spawn query_expenses(
                query = query,
                conversation_context = {}
            );
            if query_result.reports and query_result.reports.length > 0 {
                setQueryResponse(query_result.reports[0].response);
            } else {
                setQueryResponse(None);
            }
        }

        async def addManualExpense() -> None {
            if amount <= 0.0 or category.trim() == "" {
                return;
            }
            add_result = await root spawn add_expense(
                amount = amount,
                date = date,
                category_name = category,
                merchant = merchant,
                currency = "USD"
            );
            # Clear form and refresh dashboard
            setAmount(0.0);
            setDate("");
            setCategory("");
            setMerchant("");
            setCurrentForm("");

            await refreshDashboard();
        }

        async def addExpenseFromText() -> None {
            if textDescription.trim() == "" {
                return;
            }
            add_result = await root spawn add_expense_from_text(
                description = textDescription
            );
            # Clear form and refresh dashboard
            setTextDescription("");
            setCurrentForm("");

            await refreshDashboard();
        }

        async def addExpenseFromImage() -> None {
            if not imageFile {
                return;
            }
            add_result = await root spawn add_expense_from_image(
                image_path = imageFile.path
            );
            # Clear form and refresh dashboard
            setImageFile(None);
            setCurrentForm("");

            await refreshDashboard();
        }

        def renderDashboard() -> any {
            if not dashboardData {
                # need to add some styling here
                return <div>Loading dashboard...</div>;
            }
            
            totalAllTime = String(dashboardData.total_expenses_usd);

            totalThisMonth = "0.00";
            if "total_current_month" in dashboardData {
                totalThisMonth = String(dashboardData.total_current_month);
            }

            month = "Unknown";
            if "month" in dashboardData {
                month = dashboardData.month;
            }

            biggestCategory = "N/A";
            if "biggest_category" in dashboardData and dashboardData.biggest_category {
                biggestCategory = dashboardData.biggest_category;
            }

            biggestAmount = "0.00";
            if "biggest_amount" in dashboardData {
                biggestAmount = String(dashboardData.biggest_amount);
            }

            return <div>
                # Add some styling here
                <h2>Dashboard</h2>
                <div>Total Expenses (All Time): ${totalAllTime}</div>
                <div>Total Expenses ({month}): ${totalThisMonth}</div>
                <div>Biggest Expense Category: {biggestCategory} (${biggestAmount})</div>
            </div>;
        }

        def renderForms() -> any {
            if currentForm == "manual" {
                return <div>
                    <h3> Manual Expense Entry </h3>
                    <input
                        type="number"
                        value={amount}
                        onChange={lambda e: any -> None { setAmount(e.target.value); }}
                        placeholder="Amount"
                        step="0.01"
                    />
                    <input
                        type="text"
                        value={category}
                        onChange={lambda e: any -> None { setCategory(e.target.value); }}
                        placeholder="Category"
                    />
                    <input
                        type="text"
                        value={merchant}
                        onChange={lambda e: any -> None { setMerchant(e.target.value); }}
                        placeholder="Merchant"
                    />
                    <input
                        type="date"
                        value={date}
                        onChange={lambda e: any -> None { setDate(e.target.value); }}
                        placeholder="Date"
                    />
                    <button
                        type="button"
                        onClick={lambda -> None { await addManualExpense(); }}
                    > Add Expense Manually </button>
                    <button
                        type="button"
                        onClick={lambda -> None { setCurrentForm(""); }}
                    > Cancel </button>
                </div>;
            } elif currentForm == "text" {
                return <div>
                    <h3> Add Expense from Text Description </h3>
                    <textarea
                        value={textDescription}
                        onChange={lambda e: any -> None { setTextDescription(e.target.value); }}
                        placeholder="Enter expense description..."
                    ></textarea>
                    <button
                        type="button"
                        onClick={lambda -> None { await addExpenseFromText(); }}
                    > Add Expense from Text </button>
                    <button
                        type="button"
                        onClick={lambda -> None { setCurrentForm(""); }}
                    > Cancel </button>
                </div>;
            } elif currentForm == "image" {
                return <div>
                    <h3> Add Expense from Receipt Image </h3>
                    <input
                        type="file"
                        accept="image/*"
                        onChange={lambda e: any -> None { setImageFile(e.target.files[0]); }}
                    />
                    <button
                        type="button"
                        onClick={lambda -> None { await addExpenseFromImage(); }}
                    > Add Expense from Image </button>
                    <button
                        type="button"
                        onClick={lambda -> None { setCurrentForm(""); }}
                    > Cancel </button>
                </div>;
            } else {
                return <p> Select an option to add an expense. </p>;
            }
        }
    }
            # Add UI here to render dashboard, forms, and query response
}
