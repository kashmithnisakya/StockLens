import from byllm { Model }
import from typing { Dict, List }


glob llm = Model(model_name="gpt-4.1");

obj StockAnalysis {
    has fundamentals: Dict[str, str] = {};
    has technicals: Dict[str, str] = {};
    has sentiment: Dict[str, str] = {};
    has summary: str = "";
    has redo_research: bool = False;
}

sem StockAnalysis.fundamentals = "Key fundamental metrics such as P/E ratio, revenue, profitability.";
sem StockAnalysis.technicals = "Key technical indicators such as price trends, support and resistance";
sem StockAnalysis.sentiment = "Market sentiment analysis including news sentiment and social media trends.";
sem StockAnalysis.summary = "A concise summary of the overall stock analysis.";
sem StockAnalysis.redo_research = "If given data is insufficient for a comprehensive analysis, set to true.";

"""Analyze stock data"""
def analyze_stock(context: List[Dict[str, any]]) -> StockAnalysis by llm();

# Enum for recommendation types
enum Recommendation {
    BUY,
    HOLD,
    SELL,
}

obj InvestmentRecommendation {
    has recommendation: Recommendation;
    has confidence_score: float = 0.0;
    has reasoning: str = "";
    has key_risks: List[str] = [];
    has key_opportunities: List[str] = [];
    has target_price: float = 0.0;
    has stop_loss: float = 0.0;
}

sem InvestmentRecommendation.recommendation = "Investment recommendation: BUY, HOLD, or SELL.";
sem InvestmentRecommendation.confidence_score = "Confidence score of the recommendation from 0 to 100";
sem InvestmentRecommendation.reasoning = "Detailed reasoning behind the recommendation.";
sem InvestmentRecommendation.key_risks = "List of key risks associated with the investment.";
sem InvestmentRecommendation.key_opportunities = "List of key opportunities associated with the investment.";
sem InvestmentRecommendation.target_price = "Target price for the stock if the recommendation is BUY.";
sem InvestmentRecommendation.stop_loss = "Stop loss price for the stock if the recommendation is BUY.";

"""Provide investment recommendation based on stock analysis"""
def provide_recommendation(context: List[Dict[str, any]]) -> InvestmentRecommendation by llm();

enum AgentRole {
    MARKET_RESEARCHER = "market_researcher",
    STOCK_ANALYST = "stock_analyst",
    INVESTMENT_STRATEGIST = "investment_strategist"
}

"""
PLANNING RULES:
1. Sequence MUST always end with INVESTMENT_STRATEGIST
2. If redo_research is True, prioritize market_researcher with enhanced search capabilities to gather missing information
3. After redo_research, always run stock_analyst again to analyze the new data
4. Consider the current_sequence to avoid unnecessary repetition
5. Optimize for comprehensive analysis while minimizing redundant agent executions
6. Typical flow: market_researcher -> stock_analyst -> [if insufficient: market_researcher -> stock_analyst] -> investment_strategist
7. At least one market_researcher and stock_analyst must be included in the sequence
"""
def generate_plan(current_sequence: List[str], redo_research: bool = False) -> List[AgentRole] by llm();

obj SearchDecision {
    has search_query: str;
    has use_search_tool: bool = False;
}

def should_use_search_tool(current_data: Dict[str, any], user_query: str) -> SearchDecision by llm();

def chat_with_context(user_query: str, search_data: List[Dict[str, any]], knowledge_base: Dict[str, any]) -> str by llm();