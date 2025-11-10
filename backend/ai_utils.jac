"""AI Utilties Module

This module provides utility functions for AI-related tasks.
 like text processing, data extraction, and natural language queries."""

 import os;
 import from byllm {Image, Model}

 # Global AI model configuraation
 glob llm = Model(model_name="gpt-4o-mini");

 # Semantic objects for expense extraction from text

 obj ExpenseFromText {
     has amount: float;
     has currency: str;
     has date: str;
     has category: str;
     has merchant: str;
     has confidence: float;
 }

 sem ExpenseFromText = "Extract expense details from text description including amount, currency, date, category, and merchant. Provide confidence score.";

 def extract_expense_from_text(
    text: str
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

 sem ExpenseFromImage = "Extract expense details from receipt image including amount, currency, date, category, and merchant. Provide confidence score.";

def extract_expense_from_image(
    image: MTImage
 ) -> ExpenseFromImage by llm();

# Semantic object for natural language queries

 obj QueryParameters {
    has operation: str = "find";
    has category: str = "";
    has date_range: dict[str, str] = {};
    has amount_comparison: str = "";
    has merchant: str = "";
 }

 sem QueryParameters = "Parse natural language query parameters for expense data into structured format for filtering and operations.";

def parse_natural_language_query(
    query: str
 ) -> QueryParameters by llm();

 
