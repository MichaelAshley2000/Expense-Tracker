import from react {useState, useEffect}

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
        
        # Design System - Colors
        colors = {
            "primary": "#1e3a8a",
            "secondary": "#3b82f6",
            "accent": "#fbbf24",
            "success": "#10b981",
            "background": "#f8fafc",
            "white": "#ffffff",
            "gray": "#e2e8f0",
            "darkGray": "#64748b",
            "text": "#1e293b"
        };

        # Styles - Button
        buttonStyle = {
            "padding": "12px 24px",
            "borderRadius": "8px",
            "border": "none",
            "fontSize": "16px",
            "fontWeight": "600",
            "cursor": "pointer",
            "transition": "all 0.2s",
            "backgroundColor": colors.secondary,
            "color": colors.white,
            "boxShadow": "0 2px 4px rgba(0,0,0,0.1)"
        };

        buttonPrimaryStyle = {
            "padding": "12px 24px",
            "borderRadius": "8px",
            "border": "none",
            "fontSize": "16px",
            "fontWeight": "600",
            "cursor": "pointer",
            "transition": "all 0.2s",
            "color": colors.white,
            "boxShadow": "0 2px 4px rgba(0,0,0,0.1)",
            "backgroundColor": colors.primary
        };

        buttonSecondaryStyle = {
            "padding": "12px 24px",
            "borderRadius": "8px",
            "border": "none",
            "fontSize": "16px",
            "fontWeight": "600",
            "cursor": "pointer",
            "transition": "all 0.2s",
            "color": colors.white,
            "boxShadow": "0 2px 4px rgba(0,0,0,0.1)",
            "backgroundColor": colors.secondary
        };

        buttonAccentStyle = {
            "padding": "12px 24px",
            "borderRadius": "8px",
            "border": "none",
            "fontSize": "16px",
            "fontWeight": "600",
            "cursor": "pointer",
            "transition": "all 0.2s",
            "boxShadow": "0 2px 4px rgba(0,0,0,0.1)",
            "backgroundColor": colors.accent,
            "color": colors.text
        };

        buttonCancelStyle = {
            "padding": "12px 24px",
            "borderRadius": "8px",
            "border": "none",
            "fontSize": "16px",
            "fontWeight": "600",
            "cursor": "pointer",
            "transition": "all 0.2s",
            "boxShadow": "0 2px 4px rgba(0,0,0,0.1)",
            "backgroundColor": colors.gray,
            "color": colors.text
        };

        inputFileStyle = {
            "padding": "8px",
            "borderRadius": "8px",
            "border": "2px solid " + colors.gray,
            "fontSize": "16px",
            "width": "100%",
            "boxSizing": "border-box",
            "marginBottom": "12px",
            "outline": "none"
        };

        # Styles - Input
        inputStyle = {
            "padding": "12px 16px",
            "borderRadius": "8px",
            "border": "2px solid " + colors.gray,
            "fontSize": "16px",
            "width": "100%",
            "boxSizing": "border-box",
            "marginBottom": "12px",
            "outline": "none"
        };

        textareaStyle = {
            **inputStyle,
            "minHeight": "100px",
            "fontFamily": "inherit",
            "resize": "vertical"
        };

        # Styles - Card
        cardStyle = {
            "backgroundColor": colors.white,
            "borderRadius": "12px",
            "padding": "24px",
            "boxShadow": "0 4px 6px rgba(0,0,0,0.1)",
            "marginBottom": "20px"
        };

        categoryCardStyle = {
            "backgroundColor": colors.white,
            "borderRadius": "8px",
            "padding": "16px",
            "boxShadow": "0 2px 4px rgba(0,0,0,0.08)",
            "textAlign": "center",
            "minWidth": "150px"
        };

        # Container styles
        containerStyle = {
            "maxWidth": "1200px",
            "margin": "0 auto",
            "padding": "20px",
            "backgroundColor": colors.background,
            "minHeight": "100vh",
            "fontFamily": "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif"
        };

        headerStyle = {
            "textAlign": "center",
            "marginBottom": "40px",
            "paddingTop": "20px"
        };

        sectionStyle = {
            **cardStyle,
            "marginBottom": "30px"
        };

        gridStyle = {
            "display": "grid",
            "gridTemplateColumns": "repeat(auto-fit, minmax(150px, 1fr))",
            "gap": "16px",
            "marginTop": "20px"
        };

        footerStyle = {
            "textAlign": "center",
            "padding": "20px",
            "color": colors.darkGray,
            "marginTop": "40px"
        };

        statBoxStyle = {
            "backgroundColor": colors.primary,
            "color": colors.white,
            "padding": "20px",
            "borderRadius": "8px",
            "marginBottom": "16px"
        };

        formGroupStyle = {
            "marginBottom": "16px"
        };

        buttonGroupStyle = {
            "display": "flex",
            "gap": "12px",
            "flexWrap": "wrap",
            "marginTop": "16px"
        };

        useEffect(lambda -> None {
            async def loadData() -> None {
                # Fetch dashboard data on component mount
                init_result = await root spawn init_graph();
                dashboard_result = await root spawn get_dashboard_data();
                if dashboard_result and dashboard_result.reports and dashboard_result.reports.length > 0 {
                    setDashboardData(dashboard_result.reports[0]);
                } else {
                    setDashboardData({});
                }
            }
            loadData();
        }, []);

        async def refreshDashboard() -> None {
            dashboard_result = await root spawn get_dashboard_data();
            if dashboard_result and dashboard_result.reports and dashboard_result.reports.length > 0 {
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
            if query_result and query_result.reports and query_result.reports.length > 0 {
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
            # Check if dashboardData exists and has actual content
            if not dashboardData or Object.keys(dashboardData).length == 0 {
                return (
                    <div style={cardStyle}>
                        <div style={{"textAlign": "center", "padding": "40px", "color": colors.darkGray}}>
                            <h3>No data available</h3>
                            <p>Start by adding your first expense!</p>
                        </div>
                    </div>
                );
            }
            
            totalAllTime = String(dashboardData.total_expenses_usd || 0);
            month = dashboardData.month || "Unknown";
            biggestCategory = dashboardData.biggest_category || "N/A";
            biggestAmount = String(dashboardData.biggest_amount || 0);
            categoryBreakdown = {};
            if dashboardData.category_breakdown {
                categoryBreakdown = dashboardData.category_breakdown;
            }

            # Build category cards
            categoryCards = [];
            if categoryBreakdown {
                categoryKeys = Object.keys(categoryBreakdown);
                for catName in categoryKeys {
                    catData = categoryBreakdown[catName];
                    if catData and catData["count"] >= 0 {
                        catTotal = String(catData["total"]);
                        catCount = catData["count"];
                        expenseSuffix = "s";
                        if catCount == 1 {
                            expenseSuffix = "";
                        }
                        expenseText = String(catCount) + " expense" + expenseSuffix;
                        categoryCards.push(
                            <div key={catName} style={categoryCardStyle}>
                                <div style={{"fontSize": "18px", "fontWeight": "600", "color": colors.primary, "marginBottom": "8px"}}>
                                    {catName}
                                </div>
                                <div style={{"fontSize": "24px", "fontWeight": "bold", "color": colors.success}}>
                                    ${catTotal}
                                </div>
                                <div style={{"fontSize": "14px", "color": colors.darkGray, "marginTop": "4px"}}>
                                    {expenseText}
                                </div>
                            </div>
                        );
                    }
                }
            }

            # Build category breakdown section
            categorySection = None;
            if categoryCards and categoryCards.length > 0 {
                categorySection = <div style={gridStyle}>{categoryCards}</div>;
            } else {
                categorySection = (
                    <div style={{"textAlign": "center", "padding": "20px", "color": colors.darkGray}}>
                        No expenses recorded for this month yet.
                    </div>
                );
            }

            return (
                <div style={sectionStyle}>
                    <h2 style={{"marginTop": "0", "color": colors.primary}}>Dashboard</h2>
                    
                    <div style={statBoxStyle}>
                        <h3 style={{"margin": "0 0 8px 0"}}>Total Expenses</h3>
                        <div style={{"fontSize": "32px", "fontWeight": "bold"}}>${totalAllTime}</div>
                        <div style={{"fontSize": "14px", "opacity": "0.9"}}>Current Month: {month}</div>
                    </div>

                    <div style={{"backgroundColor": colors.accent, "color": colors.text, "padding": "16px", "borderRadius": "8px", "marginBottom": "20px"}}>
                        <strong>Biggest Category:</strong> {biggestCategory} (${biggestAmount})
                    </div>

                    <h3 style={{"color": colors.primary}}>Category Breakdown</h3>
                    {categorySection}
                </div>
            );
        }

        def renderAddExpense() -> any {
            if currentForm == "" {
                return (
                    <div style={sectionStyle}>
                        <h2 style={{"marginTop": "0", "color": colors.primary}}>Add Expense</h2>
                        <p style={{"marginBottom": "16px", "color": colors.darkGray}}>Choose how to add your expense:</p>
                        <div style={buttonGroupStyle}>
                            <button
                                style={buttonPrimaryStyle}
                                onClick={lambda -> None { setCurrentForm("manual"); }}
                            >Manual Entry</button>
                            <button
                                style={buttonSecondaryStyle}
                                onClick={lambda -> None { setCurrentForm("text"); }}
                            >From Text</button>
                            <button
                                style={buttonAccentStyle}
                                onClick={lambda -> None { setCurrentForm("image"); }}
                            >From Receipt Image</button>
                        </div>
                    </div>
                );
            } elif currentForm == "manual" {
                return (
                    <div style={sectionStyle}>
                        <h2 style={{"marginTop": "0", "color": colors.primary}}>Add Expense</h2>
                        <h3 style={{"color": colors.primary}}>Manual Entry</h3>
                        <div style={formGroupStyle}>
                            <label style={{"display": "block", "marginBottom": "4px", "fontWeight": "500"}}>Amount</label>
                            <input
                                type="number"
                                style={inputStyle}
                                value={amount}
                                onChange={lambda e: any -> None { setAmount(e.target.value); }}
                                placeholder="Enter amount"
                                step="0.01"
                            />
                        </div>
                        <div style={formGroupStyle}>
                            <label style={{"display": "block", "marginBottom": "4px", "fontWeight": "500"}}>Category</label>
                            <input
                                type="text"
                                style={inputStyle}
                                value={category}
                                onChange={lambda e: any -> None { setCategory(e.target.value); }}
                                placeholder="e.g., Food, Transport, Entertainment"
                            />
                        </div>
                        <div style={formGroupStyle}>
                            <label style={{"display": "block", "marginBottom": "4px", "fontWeight": "500"}}>Merchant</label>
                            <input
                                type="text"
                                style={inputStyle}
                                value={merchant}
                                onChange={lambda e: any -> None { setMerchant(e.target.value); }}
                                placeholder="Store or merchant name"
                            />
                        </div>
                        <div style={formGroupStyle}>
                            <label style={{"display": "block", "marginBottom": "4px", "fontWeight": "500"}}>Date</label>
                            <input
                                type="date"
                                style={inputStyle}
                                value={date}
                                onChange={lambda e: any -> None { setDate(e.target.value); }}
                            />
                        </div>
                        <div style={buttonGroupStyle}>
                            <button
                                style={buttonPrimaryStyle}
                                onClick={lambda -> None { addManualExpense(); }}
                            >Add Expense</button>
                            <button
                                style={buttonCancelStyle}
                                onClick={lambda -> None { setCurrentForm(""); }}
                            >Cancel</button>
                        </div>
                    </div>
                );
            } elif currentForm == "text" {
                return (
                    <div style={sectionStyle}>
                        <h2 style={{"marginTop": "0", "color": colors.primary}}>Add Expense</h2>
                        <h3 style={{"color": colors.primary}}>Add from Text Description</h3>
                        <div style={formGroupStyle}>
                            <label style={{"display": "block", "marginBottom": "4px", "fontWeight": "500"}}>
                                Description
                            </label>
                            <textarea
                                style={textareaStyle}
                                value={textDescription}
                                onChange={lambda e: any -> None { setTextDescription(e.target.value); }}
                                placeholder="e.g., 'Spent $45.50 at Starbucks today for coffee'"
                            ></textarea>
                        </div>
                        <div style={buttonGroupStyle}>
                            <button
                                style={buttonSecondaryStyle}
                                onClick={lambda -> None { addExpenseFromText(); }}
                            >Add Expense</button>
                            <button
                                style={buttonCancelStyle}
                                onClick={lambda -> None { setCurrentForm(""); }}
                            >Cancel</button>
                        </div>
                    </div>
                );
            } elif currentForm == "image" {
                fileSelectedText = "";
                fileSelectedElement = None;
                if imageFile {
                    fileSelectedText = "File selected: " + imageFile.name;
                    fileSelectedElement = (
                        <div style={{"marginTop": "8px", "color": colors.success}}>
                            {fileSelectedText}
                        </div>
                    );
                }
                
                return (
                    <div style={sectionStyle}>
                        <h2 style={{"marginTop": "0", "color": colors.primary}}>Add Expense</h2>
                        <h3 style={{"color": colors.primary}}>Add from Receipt Image</h3>
                        <div style={formGroupStyle}>
                            <label style={{"display": "block", "marginBottom": "4px", "fontWeight": "500"}}>
                                Upload Receipt
                            </label>
                            <input
                                type="file"
                                style={inputFileStyle}
                                accept="image/*"
                                onChange={lambda e: any -> None { setImageFile(e.target.files[0]); }}
                            />
                            {fileSelectedElement}
                        </div>
                        <div style={buttonGroupStyle}>
                            <button
                                style={buttonAccentStyle}
                                onClick={lambda -> None { addExpenseFromImage(); }}
                            >Add Expense</button>
                            <button
                                style={buttonCancelStyle}
                                onClick={lambda -> None { setCurrentForm(""); }}
                            >Cancel</button>
                        </div>
                    </div>
                );
            } else {
                return <div></div>;
            }
        }

        def renderQuery() -> any {
            handleKeyPress = lambda e: any -> None {
                if e.key == "Enter" {
                    handleQuery();
                }
            };

            # Build query response section
            responseSection = None;
            if queryResponse {
                # Build insights list
                insightsList = None;
                if queryResponse.insights and queryResponse.insights.length > 0 {
                    insightItems = [];
                    for insight in queryResponse.insights {
                        insightItems.push(
                            <li key={insight} style={{"marginBottom": "8px", "color": colors.text}}>
                                {insight}
                            </li>
                        );
                    }
                    insightsList = (
                        <div style={{"marginTop": "16px"}}>
                            <h5 style={{"color": colors.primary, "marginBottom": "8px"}}>Key Insights:</h5>
                            <ul style={{"marginLeft": "20px"}}>{insightItems}</ul>
                        </div>
                    );
                }

                # Build category breakdown
                categoryBreakdownSection = None;
                if queryResponse.categorical_breakdown and Object.keys(queryResponse.categorical_breakdown).length > 0 {
                    breakdownItems = [];
                    categoryKeys = Object.keys(queryResponse.categorical_breakdown);
                    for catName in categoryKeys {
                        catAmount = queryResponse.categorical_breakdown[catName];
                        breakdownItems.push(
                            <div key={catName} style={{"display": "flex", "justifyContent": "space-between", "padding": "8px", "backgroundColor": colors.white, "borderRadius": "4px", "marginBottom": "8px"}}>
                                <span style={{"fontWeight": "600", "color": colors.primary}}>{catName}</span>
                                <span style={{"color": colors.success}}>${String(catAmount)}</span>
                            </div>
                        );
                    }
                    categoryBreakdownSection = (
                        <div style={{"marginTop": "16px"}}>
                            <h5 style={{"color": colors.primary, "marginBottom": "8px"}}>Category Breakdown:</h5>
                            {breakdownItems}
                        </div>
                    );
                }

                # Build statistics
                statsSection = None;
                if queryResponse.count >= 0 {
                    statsSection = (
                        <div style={{"marginTop": "16px", "padding": "16px", "backgroundColor": colors.white, "borderRadius": "8px"}}>
                            <h5 style={{"color": colors.primary, "marginTop": "0"}}>Statistics:</h5>
                            <div style={gridStyle}>
                                <div style={{"textAlign": "center"}}>
                                    <div style={{"fontSize": "14px", "color": colors.darkGray}}>Total</div>
                                    <div style={{"fontSize": "20px", "fontWeight": "bold", "color": colors.success}}>${String(queryResponse.total_amount || 0)}</div>
                                </div>
                                <div style={{"textAlign": "center"}}>
                                    <div style={{"fontSize": "14px", "color": colors.darkGray}}>Average</div>
                                    <div style={{"fontSize": "20px", "fontWeight": "bold", "color": colors.secondary}}>${String(queryResponse.average_amount || 0)}</div>
                                </div>
                                <div style={{"textAlign": "center"}}>
                                    <div style={{"fontSize": "14px", "color": colors.darkGray}}>Count</div>
                                    <div style={{"fontSize": "20px", "fontWeight": "bold", "color": colors.primary}}>{String(queryResponse.count)}</div>
                                </div>
                                <div style={{"textAlign": "center"}}>
                                    <div style={{"fontSize": "14px", "color": colors.darkGray}}>Max</div>
                                    <div style={{"fontSize": "20px", "fontWeight": "bold", "color": colors.accent}}>${String(queryResponse.max_amount || 0)}</div>
                                </div>
                            </div>
                        </div>
                    );
                }

                # Build trend analysis
                trendSection = None;
                if queryResponse.trend_analysis {
                    trendSection = (
                        <div style={{"marginTop": "16px", "padding": "16px", "backgroundColor": colors.white, "borderRadius": "8px"}}>
                            <h5 style={{"color": colors.primary, "marginTop": "0"}}>Trend Analysis:</h5>
                            <p style={{"color": colors.text, "lineHeight": "1.6", "margin": "0"}}>{queryResponse.trend_analysis}</p>
                        </div>
                    );
                }

                responseSection = (
                    <div style={{"marginTop": "24px", "padding": "20px", "backgroundColor": colors.background, "borderRadius": "8px", "borderLeft": "4px solid " + colors.success}}>
                        <h4 style={{"marginTop": "0", "color": colors.primary}}>Analysis Results:</h4>
                        <div style={{"color": colors.text, "lineHeight": "1.6", "marginBottom": "16px"}}>
                            {queryResponse.natural_response}
                        </div>
                        {statsSection}
                        {categoryBreakdownSection}
                        {trendSection}
                        {insightsList}
                    </div>
                );
            }

            return (
                <div style={sectionStyle}>
                    <h2 style={{"marginTop": "0", "color": colors.primary}}>Query Expenses</h2>
                    <p style={{"marginBottom": "16px", "color": colors.darkGray}}>
                        Ask questions about your expenses in natural language
                    </p>
                    
                    <div style={formGroupStyle}>
                        <input
                            type="text"
                            style={inputStyle}
                            value={query}
                            onChange={lambda e: any -> None { setQuery(e.target.value); }}
                            onKeyPress={handleKeyPress}
                            placeholder="e.g., 'How much did I spend on food last week?'"
                        />
                    </div>
                    
                <button
                    style={buttonSecondaryStyle}
                    onClick={lambda -> None { handleQuery(); }}
                >Search</button>                    {responseSection}
                </div>
            );
        }

        return (
            <div style={containerStyle}>
                <header style={headerStyle}>
                    <h1 style={{"fontSize": "48px", "margin": "0 0 8px 0", "color": colors.primary}}>
                        Smart Expense Tracker
                    </h1>
                    <p style={{"fontSize": "18px", "margin": "0", "color": colors.darkGray}}>
                        Track expenses with AI-powered insights
                    </p>
                </header>

                {renderDashboard()}
                {renderAddExpense()}
                {renderQuery()}

                <footer style={footerStyle}>
                    <p style={{"margin": "0"}}>
                        Built with ❤️ using Jac Lang | © 2025 Smart Expense Tracker
                    </p>
                </footer>
            </div>
        );
    }