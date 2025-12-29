import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { useState, useEffect } from "react";
function app() {
  let [dashboardData, setDashboardData] = useState(null);
  let [query, setQuery] = useState("");
  let [queryResponse, setQueryResponse] = useState(null);
  let [currentForm, setCurrentForm] = useState("");
  let [imageFile, setImageFile] = useState(null);
  let [textDescription, setTextDescription] = useState("");
  let [amount, setAmount] = useState(0.0);
  let [date, setDate] = useState("");
  let [category, setCategory] = useState("");
  let [merchant, setMerchant] = useState("");
  let colors = {"primary": "#1e3a8a", "secondary": "#3b82f6", "accent": "#fbbf24", "success": "#10b981", "background": "#f8fafc", "white": "#ffffff", "gray": "#e2e8f0", "darkGray": "#64748b", "text": "#1e293b"};
  let buttonStyle = {"padding": "12px 24px", "borderRadius": "8px", "border": "none", "fontSize": "16px", "fontWeight": "600", "cursor": "pointer", "transition": "all 0.2s", "backgroundColor": colors.secondary, "color": colors.white, "boxShadow": "0 2px 4px rgba(0,0,0,0.1)"};
  let buttonPrimaryStyle = {"padding": "12px 24px", "borderRadius": "8px", "border": "none", "fontSize": "16px", "fontWeight": "600", "cursor": "pointer", "transition": "all 0.2s", "color": colors.white, "boxShadow": "0 2px 4px rgba(0,0,0,0.1)", "backgroundColor": colors.primary};
  let buttonSecondaryStyle = {"padding": "12px 24px", "borderRadius": "8px", "border": "none", "fontSize": "16px", "fontWeight": "600", "cursor": "pointer", "transition": "all 0.2s", "color": colors.white, "boxShadow": "0 2px 4px rgba(0,0,0,0.1)", "backgroundColor": colors.secondary};
  let buttonAccentStyle = {"padding": "12px 24px", "borderRadius": "8px", "border": "none", "fontSize": "16px", "fontWeight": "600", "cursor": "pointer", "transition": "all 0.2s", "boxShadow": "0 2px 4px rgba(0,0,0,0.1)", "backgroundColor": colors.accent, "color": colors.text};
  let buttonCancelStyle = {"padding": "12px 24px", "borderRadius": "8px", "border": "none", "fontSize": "16px", "fontWeight": "600", "cursor": "pointer", "transition": "all 0.2s", "boxShadow": "0 2px 4px rgba(0,0,0,0.1)", "backgroundColor": colors.gray, "color": colors.text};
  let inputFileStyle = {"padding": "8px", "borderRadius": "8px", "border": "2px solid " + colors.gray, "fontSize": "16px", "width": "100%", "boxSizing": "border-box", "marginBottom": "12px", "outline": "none"};
  let inputStyle = {"padding": "12px 16px", "borderRadius": "8px", "border": "2px solid " + colors.gray, "fontSize": "16px", "width": "100%", "boxSizing": "border-box", "marginBottom": "12px", "outline": "none"};
  let textareaStyle = {...inputStyle, "minHeight": "100px", "fontFamily": "inherit", "resize": "vertical"};
  let cardStyle = {"backgroundColor": colors.white, "borderRadius": "12px", "padding": "24px", "boxShadow": "0 4px 6px rgba(0,0,0,0.1)", "marginBottom": "20px"};
  let categoryCardStyle = {"backgroundColor": colors.white, "borderRadius": "8px", "padding": "16px", "boxShadow": "0 2px 4px rgba(0,0,0,0.08)", "textAlign": "center", "minWidth": "150px"};
  let containerStyle = {"maxWidth": "1200px", "margin": "0 auto", "padding": "20px", "backgroundColor": colors.background, "minHeight": "100vh", "fontFamily": "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif"};
  let headerStyle = {"textAlign": "center", "marginBottom": "40px", "paddingTop": "20px"};
  let sectionStyle = {...cardStyle, "marginBottom": "30px"};
  let gridStyle = {"display": "grid", "gridTemplateColumns": "repeat(auto-fit, minmax(150px, 1fr))", "gap": "16px", "marginTop": "20px"};
  let footerStyle = {"textAlign": "center", "padding": "20px", "color": colors.darkGray, "marginTop": "40px"};
  let statBoxStyle = {"backgroundColor": colors.primary, "color": colors.white, "padding": "20px", "borderRadius": "8px", "marginBottom": "16px"};
  let formGroupStyle = {"marginBottom": "16px"};
  let buttonGroupStyle = {"display": "flex", "gap": "12px", "flexWrap": "wrap", "marginTop": "16px"};
  useEffect(() => {
    async function loadData() {
      let init_result = await __jacSpawn("init_graph", "", {});
      let dashboard_result = await __jacSpawn("get_dashboard_data", "", {});
      if (dashboard_result && dashboard_result.reports && dashboard_result.reports.length > 0) {
        setDashboardData(dashboard_result.reports[0]);
      } else {
        setDashboardData({});
      }
    }
    loadData();
  }, []);
  async function refreshDashboard() {
    let dashboard_result = await __jacSpawn("get_dashboard_data", "", {});
    if (dashboard_result && dashboard_result.reports && dashboard_result.reports.length > 0) {
      setDashboardData(dashboard_result.reports[0]);
    }
  }
  async function handleQuery() {
    if (query.trim() === "") {
      return;
    }
    let query_result = await __jacSpawn("query_expenses", "", {"query": query, "conversation_context": {}});
    if (query_result && query_result.reports && query_result.reports.length > 0) {
      setQueryResponse(query_result.reports[0].response);
    } else {
      setQueryResponse(null);
    }
  }
  async function addManualExpense() {
    if (amount <= 0.0 || category.trim() === "") {
      return;
    }
    let add_result = await __jacSpawn("add_expense", "", {"amount": amount, "date": date, "category_name": category, "merchant": merchant, "currency": "USD"});
    setAmount(0.0);
    setDate("");
    setCategory("");
    setMerchant("");
    setCurrentForm("");
    await refreshDashboard();
  }
  async function addExpenseFromText() {
    if (textDescription.trim() === "") {
      return;
    }
    let add_result = await __jacSpawn("add_expense_from_text", "", {"description": textDescription});
    setTextDescription("");
    setCurrentForm("");
    await refreshDashboard();
  }
  async function addExpenseFromImage() {
    if (!imageFile) {
      return;
    }
    function handleFileRead(base64Data) {
      async function processImage() {
        let add_result = await __jacSpawn("add_expense_from_image", "", {"image_path": base64Data});
        setImageFile(null);
        setCurrentForm("");
        await refreshDashboard();
      }
      processImage();
    }
    let reader = Reflect.construct(FileReader, []);
    reader.onload = e => {
      handleFileRead(e.target.result);
    };
    reader.onerror = e => {
      console.error("[ERROR] FileReader error:", e);
    };
    reader.readAsDataURL(imageFile);
  }
  function renderDashboard() {
    if (!dashboardData || Object.keys(dashboardData).length === 0) {
      return __jacJsx("div", {"style": cardStyle}, [__jacJsx("div", {"style": {"textAlign": "center", "padding": "40px", "color": colors.darkGray}}, [__jacJsx("h3", {}, ["No data available"]), __jacJsx("p", {}, ["Start by adding your first expense!"])])]);
    }
    let totalAllTime = String(dashboardData.total_expenses_usd || 0);
    let month = dashboardData.month || "Unknown";
    let biggestCategory = dashboardData.biggest_category || "N/A";
    let biggestAmount = String(dashboardData.biggest_amount || 0);
    let categoryBreakdown = {};
    if (dashboardData.category_breakdown) {
      categoryBreakdown = dashboardData.category_breakdown;
    }
    let categoryCards = [];
    if (categoryBreakdown) {
      let categoryKeys = Object.keys(categoryBreakdown);
      for (const catName of categoryKeys) {
        let catData = categoryBreakdown[catName];
        if (catData && catData["count"] >= 0) {
          let catTotal = String(catData["total"]);
          let catCount = catData["count"];
          let expenseSuffix = "s";
          if (catCount === 1) {
            expenseSuffix = "";
          }
          let expenseText = String(catCount) + " expense" + expenseSuffix;
          categoryCards.push(__jacJsx("div", {"key": catName, "style": categoryCardStyle}, [__jacJsx("div", {"style": {"fontSize": "18px", "fontWeight": "600", "color": colors.primary, "marginBottom": "8px"}}, [catName]), __jacJsx("div", {"style": {"fontSize": "24px", "fontWeight": "bold", "color": colors.success}}, ["$", catTotal]), __jacJsx("div", {"style": {"fontSize": "14px", "color": colors.darkGray, "marginTop": "4px"}}, [expenseText])]));
        }
      }
    }
    let categorySection = null;
    if (categoryCards && categoryCards.length > 0) {
      categorySection = __jacJsx("div", {"style": gridStyle}, [categoryCards]);
    } else {
      categorySection = __jacJsx("div", {"style": {"textAlign": "center", "padding": "20px", "color": colors.darkGray}}, ["No expenses recorded for this month yet."]);
    }
    return __jacJsx("div", {"style": sectionStyle}, [__jacJsx("h2", {"style": {"marginTop": "0", "color": colors.primary}}, ["Dashboard"]), __jacJsx("div", {"style": statBoxStyle}, [__jacJsx("h3", {"style": {"margin": "0 0 8px 0"}}, ["Total Expenses"]), __jacJsx("div", {"style": {"fontSize": "32px", "fontWeight": "bold"}}, ["$", totalAllTime]), __jacJsx("div", {"style": {"fontSize": "14px", "opacity": "0.9"}}, ["Current Month: ", month])]), __jacJsx("div", {"style": {"backgroundColor": colors.accent, "color": colors.text, "padding": "16px", "borderRadius": "8px", "marginBottom": "20px"}}, [__jacJsx("strong", {}, ["Biggest Category:"]), " ", biggestCategory, " ($", biggestAmount, ")"]), __jacJsx("h3", {"style": {"color": colors.primary}}, ["Category Breakdown"]), categorySection]);
  }
  function renderAddExpense() {
    if (currentForm === "") {
      return __jacJsx("div", {"style": sectionStyle}, [__jacJsx("h2", {"style": {"marginTop": "0", "color": colors.primary}}, ["Add Expense"]), __jacJsx("p", {"style": {"marginBottom": "16px", "color": colors.darkGray}}, ["Choose how to add your expense:"]), __jacJsx("div", {"style": buttonGroupStyle}, [__jacJsx("button", {"style": buttonPrimaryStyle, "onClick": () => {
        setCurrentForm("manual");
      }}, ["Manual Entry"]), __jacJsx("button", {"style": buttonSecondaryStyle, "onClick": () => {
        setCurrentForm("text");
      }}, ["From Text"]), __jacJsx("button", {"style": buttonAccentStyle, "onClick": () => {
        setCurrentForm("image");
      }}, ["From Receipt Image"])])]);
    } else if (currentForm === "manual") {
      return __jacJsx("div", {"style": sectionStyle}, [__jacJsx("h2", {"style": {"marginTop": "0", "color": colors.primary}}, ["Add Expense"]), __jacJsx("h3", {"style": {"color": colors.primary}}, ["Manual Entry"]), __jacJsx("div", {"style": formGroupStyle}, [__jacJsx("label", {"style": {"display": "block", "marginBottom": "4px", "fontWeight": "500"}}, ["Amount"]), __jacJsx("input", {"type": "number", "style": inputStyle, "value": amount, "onChange": e => {
        setAmount(e.target.value);
      }, "placeholder": "Enter amount", "step": "0.01"}, [])]), __jacJsx("div", {"style": formGroupStyle}, [__jacJsx("label", {"style": {"display": "block", "marginBottom": "4px", "fontWeight": "500"}}, ["Category"]), __jacJsx("input", {"type": "text", "style": inputStyle, "value": category, "onChange": e => {
        setCategory(e.target.value);
      }, "placeholder": "e.g., Food, Transport, Entertainment"}, [])]), __jacJsx("div", {"style": formGroupStyle}, [__jacJsx("label", {"style": {"display": "block", "marginBottom": "4px", "fontWeight": "500"}}, ["Merchant"]), __jacJsx("input", {"type": "text", "style": inputStyle, "value": merchant, "onChange": e => {
        setMerchant(e.target.value);
      }, "placeholder": "Store or merchant name"}, [])]), __jacJsx("div", {"style": formGroupStyle}, [__jacJsx("label", {"style": {"display": "block", "marginBottom": "4px", "fontWeight": "500"}}, ["Date"]), __jacJsx("input", {"type": "date", "style": inputStyle, "value": date, "onChange": e => {
        setDate(e.target.value);
      }}, [])]), __jacJsx("div", {"style": buttonGroupStyle}, [__jacJsx("button", {"style": buttonPrimaryStyle, "onClick": () => {
        addManualExpense();
      }}, ["Add Expense"]), __jacJsx("button", {"style": buttonCancelStyle, "onClick": () => {
        setCurrentForm("");
      }}, ["Cancel"])])]);
    } else if (currentForm === "text") {
      return __jacJsx("div", {"style": sectionStyle}, [__jacJsx("h2", {"style": {"marginTop": "0", "color": colors.primary}}, ["Add Expense"]), __jacJsx("h3", {"style": {"color": colors.primary}}, ["Add from Text Description"]), __jacJsx("div", {"style": formGroupStyle}, [__jacJsx("label", {"style": {"display": "block", "marginBottom": "4px", "fontWeight": "500"}}, ["Description"]), __jacJsx("textarea", {"style": textareaStyle, "value": textDescription, "onChange": e => {
        setTextDescription(e.target.value);
      }, "placeholder": "e.g., 'Spent $45.50 at Starbucks today for coffee'"}, [])]), __jacJsx("div", {"style": buttonGroupStyle}, [__jacJsx("button", {"style": buttonSecondaryStyle, "onClick": () => {
        addExpenseFromText();
      }}, ["Add Expense"]), __jacJsx("button", {"style": buttonCancelStyle, "onClick": () => {
        setCurrentForm("");
      }}, ["Cancel"])])]);
    } else if (currentForm === "image") {
      let fileSelectedText = "";
      let fileSelectedElement = null;
      if (imageFile) {
        fileSelectedText = "File selected: " + imageFile.name;
        fileSelectedElement = __jacJsx("div", {"style": {"marginTop": "8px", "color": colors.success}}, [fileSelectedText]);
      }
      return __jacJsx("div", {"style": sectionStyle}, [__jacJsx("h2", {"style": {"marginTop": "0", "color": colors.primary}}, ["Add Expense"]), __jacJsx("h3", {"style": {"color": colors.primary}}, ["Add from Receipt Image"]), __jacJsx("div", {"style": formGroupStyle}, [__jacJsx("label", {"style": {"display": "block", "marginBottom": "4px", "fontWeight": "500"}}, ["Upload Receipt"]), __jacJsx("input", {"type": "file", "style": inputFileStyle, "accept": "image/*", "onChange": e => {
        setImageFile(e.target.files[0]);
      }}, []), fileSelectedElement]), __jacJsx("div", {"style": buttonGroupStyle}, [__jacJsx("button", {"style": buttonAccentStyle, "onClick": () => {
        addExpenseFromImage();
      }}, ["Add Expense"]), __jacJsx("button", {"style": buttonCancelStyle, "onClick": () => {
        setCurrentForm("");
      }}, ["Cancel"])])]);
    } else {
      return __jacJsx("div", {}, []);
    }
  }
  function renderQuery() {
    let handleKeyPress = e => {
      if (e.key === "Enter") {
        handleQuery();
      }
    };
    let responseSection = null;
    if (queryResponse) {
      let insightsList = null;
      if (queryResponse.insights && queryResponse.insights.length > 0) {
        let insightItems = [];
        for (const insight of queryResponse.insights) {
          insightItems.push(__jacJsx("li", {"key": insight, "style": {"marginBottom": "8px", "color": colors.text}}, [insight]));
        }
        insightsList = __jacJsx("div", {"style": {"marginTop": "16px"}}, [__jacJsx("h5", {"style": {"color": colors.primary, "marginBottom": "8px"}}, ["Key Insights:"]), __jacJsx("ul", {"style": {"marginLeft": "20px"}}, [insightItems])]);
      }
      let categoryBreakdownSection = null;
      if (queryResponse.categorical_breakdown && Object.keys(queryResponse.categorical_breakdown).length > 0) {
        let breakdownItems = [];
        let categoryKeys = Object.keys(queryResponse.categorical_breakdown);
        for (const catName of categoryKeys) {
          let catAmount = queryResponse.categorical_breakdown[catName];
          breakdownItems.push(__jacJsx("div", {"key": catName, "style": {"display": "flex", "justifyContent": "space-between", "padding": "8px", "backgroundColor": colors.white, "borderRadius": "4px", "marginBottom": "8px"}}, [__jacJsx("span", {"style": {"fontWeight": "600", "color": colors.primary}}, [catName]), __jacJsx("span", {"style": {"color": colors.success}}, ["$", String(catAmount)])]));
        }
        categoryBreakdownSection = __jacJsx("div", {"style": {"marginTop": "16px"}}, [__jacJsx("h5", {"style": {"color": colors.primary, "marginBottom": "8px"}}, ["Category Breakdown:"]), breakdownItems]);
      }
      let statsSection = null;
      if (queryResponse.count >= 0) {
        statsSection = __jacJsx("div", {"style": {"marginTop": "16px", "padding": "16px", "backgroundColor": colors.white, "borderRadius": "8px"}}, [__jacJsx("h5", {"style": {"color": colors.primary, "marginTop": "0"}}, ["Statistics:"]), __jacJsx("div", {"style": gridStyle}, [__jacJsx("div", {"style": {"textAlign": "center"}}, [__jacJsx("div", {"style": {"fontSize": "14px", "color": colors.darkGray}}, ["Total"]), __jacJsx("div", {"style": {"fontSize": "20px", "fontWeight": "bold", "color": colors.success}}, ["$", String(queryResponse.total_amount || 0)])]), __jacJsx("div", {"style": {"textAlign": "center"}}, [__jacJsx("div", {"style": {"fontSize": "14px", "color": colors.darkGray}}, ["Average"]), __jacJsx("div", {"style": {"fontSize": "20px", "fontWeight": "bold", "color": colors.secondary}}, ["$", String(queryResponse.average_amount || 0)])]), __jacJsx("div", {"style": {"textAlign": "center"}}, [__jacJsx("div", {"style": {"fontSize": "14px", "color": colors.darkGray}}, ["Count"]), __jacJsx("div", {"style": {"fontSize": "20px", "fontWeight": "bold", "color": colors.primary}}, [String(queryResponse.count)])]), __jacJsx("div", {"style": {"textAlign": "center"}}, [__jacJsx("div", {"style": {"fontSize": "14px", "color": colors.darkGray}}, ["Max"]), __jacJsx("div", {"style": {"fontSize": "20px", "fontWeight": "bold", "color": colors.accent}}, ["$", String(queryResponse.max_amount || 0)])])])]);
      }
      let trendSection = null;
      if (queryResponse.trend_analysis) {
        trendSection = __jacJsx("div", {"style": {"marginTop": "16px", "padding": "16px", "backgroundColor": colors.white, "borderRadius": "8px"}}, [__jacJsx("h5", {"style": {"color": colors.primary, "marginTop": "0"}}, ["Trend Analysis:"]), __jacJsx("p", {"style": {"color": colors.text, "lineHeight": "1.6", "margin": "0"}}, [queryResponse.trend_analysis])]);
      }
      responseSection = __jacJsx("div", {"style": {"marginTop": "24px", "padding": "20px", "backgroundColor": colors.background, "borderRadius": "8px", "borderLeft": "4px solid " + colors.success}}, [__jacJsx("h4", {"style": {"marginTop": "0", "color": colors.primary}}, ["Analysis Results:"]), __jacJsx("div", {"style": {"color": colors.text, "lineHeight": "1.6", "marginBottom": "16px"}}, [queryResponse.natural_response]), statsSection, categoryBreakdownSection, trendSection, insightsList]);
    }
    return __jacJsx("div", {"style": sectionStyle}, [__jacJsx("h2", {"style": {"marginTop": "0", "color": colors.primary}}, ["Query Expenses"]), __jacJsx("p", {"style": {"marginBottom": "16px", "color": colors.darkGray}}, ["Ask questions about your expenses in natural language"]), __jacJsx("div", {"style": formGroupStyle}, [__jacJsx("input", {"type": "text", "style": inputStyle, "value": query, "onChange": e => {
      setQuery(e.target.value);
    }, "onKeyPress": handleKeyPress, "placeholder": "e.g., 'How much did I spend on food last week?'"}, [])]), __jacJsx("button", {"style": buttonSecondaryStyle, "onClick": () => {
      handleQuery();
    }}, ["Search"]), "                    ", responseSection]);
  }
  return __jacJsx("div", {"style": containerStyle}, [__jacJsx("header", {"style": headerStyle}, [__jacJsx("h1", {"style": {"fontSize": "48px", "margin": "0 0 8px 0", "color": colors.primary}}, ["Smart Expense Tracker"]), __jacJsx("p", {"style": {"fontSize": "18px", "margin": "0", "color": colors.darkGray}}, ["Track expenses with AI-powered insights"])]), renderDashboard(), renderAddExpense(), renderQuery(), __jacJsx("footer", {"style": footerStyle}, [__jacJsx("p", {"style": {"margin": "0"}}, ["Built with ❤️ using Jac Lang | © 2025 Smart Expense Tracker"])])]);
}
export { app };
