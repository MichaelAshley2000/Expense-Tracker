"""AI Utilties Module

This module provides utility functions for AI-related tasks.
 like text processing, data extraction, and natural language queries."""

 import os;
 import from byllm.lib {Image, Model}
 import from utils {get_current_date, get_current_datetime}

 # Global AI model configuraation
 glob llm = Model(model_name="gpt-4o-mini");

# defining expenses object
obj ExpenseObject {
    has amount: float;
    has currency: str;
    has date: str;
    has category: str;
    has merchant: str;
    has created_at: str;
}

 # Semantic objects for expense extraction from text

 obj ExpenseFromText {
     has amount: float;
     has currency: str;
     has date: str;
     has category: str;
     has merchant: str;
     has confidence: float;
     has created_at: str;
 }

 sem ExpenseFromText = "Extract expense details from text description including amount, currency, date, category, and merchant. For dates not explicitly mentioned, infer from context and use the curret date provided in the input to calculate relative dates.";

 def extract_expense_from_text(
    text: str,
    current_date: str = ""
 ) -> ExpenseFromText by llm();

 # Semantic object for expense extraction from image

 obj ExpenseFromImage {
     has amount: float;
     has currency: str;
     has date: str;
     has category: str;
     has merchant: str;
     has confidence: float;
 }

 sem ExpenseFromImage = "Extract expense details from receipt image including amount, currency, date, category, and merchant. For dates, use the current date provided in the input to calculate relative dates if not explicitly mentioned. Provide confidence score.";

def extract_expense_from_image(
    image: Image,
    current_date: str = ""
 ) -> ExpenseFromImage by llm();

# Semantic object for natural language queries

obj QueryParameters {
   has operation: str = "find";    # compare, analyze, summarize
   has category: str = "";
   has date_range: dict[str, str] = {};
   has amount_comparison: str = "";
   has merchant: str = "";
   has temporal_filter: str = "";  # e.g., "last month", "this year"
   has statistical_measure: str = ""; # e.g., "total", "average"
   has group_by: str = "";  # e.g., "category", "month"
   has conversation_context: dict[str, str] = {};
}

sem QueryParameters = """Parse natural language query parameters for expense data into structured format for filtering and operations.
 Include operation type, category, date range, amount comparison, merchant, temporal filters, statistical measures, grouping, and conversation context.""";

def parse_natural_language_query(
    query: str,
    conversation_context: dict[str, str] = {}
 ) -> QueryParameters by llm();

 # Semantic object for AI Query Response

 obj QueryResponse {
   has query: str;
   has expenses: list[ExpenseObject];
   has natural_response: str;
   has operation_performed: str;
   has conversation_continuation: str;

   # Statistical summaries
   has total_amount: float;
   has average_amount: float;
   has max_amount: float;
   has min_amount: float;
   has count: int;
   has categorical_breakdown: dict[str, float];
   has trend_analysis: str;
   has insights: list[str];

   # Temporal analysis
   has start_date: str;
   has end_date: str;
   has temporal_description: str;
 }

sem QueryResponse = """Structured response for AI-driven expense queries including extracted expenses, statistical summaries, temporal analysis, and natural language responses.
Handle all types of queries including comparisons, analyses, and summaries. Provide responses with statistical measures, trends, and insights, and temporal context.""";

def process_query_response(
    parsed_query: QueryParameters,
    expenses: list[ExpenseObject],
 ) -> QueryResponse by llm();

 # Helper function to extract expense from image file path

def extract_expense_from_image_file(
    image_path: str
 ) -> ExpenseFromImage {
     img = Image(url = image_path);
     expense = extract_expense_from_image(img, current_date=get_current_date());
     return expense;
 }
