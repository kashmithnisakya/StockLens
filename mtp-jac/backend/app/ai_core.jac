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

"""
You are an expert Stock Analyst.:

Provide a detailed analysis covering:
1. Fundamental Analysis (P/E ratio, revenue, profitability)
2. Technical Analysis (price trends, support/resistance)
3. Sentiment Analysis (market sentiment, news sentiment)

if you think details is not sufficient, set redo_research to true.

Return your analysis in a structured format with sections:
- fundamentals
- technicals
- sentiment
- summary
- redo_research (true/false)
"""
def analyze_stock(context: List[Dict[str, any]]) -> StockAnalysis by llm();

# Enum for recommendation types
enum Recommendation {
    BUY = "BUY",
    HOLD = "HOLD",
    SELL = "SELL"
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

"""
You are a Senior Investment Strategist. Based on the following analysis for {self.ticker}:


Provide a clear investment recommendation:
1. Recommendation: BUY, HOLD, or SELL
2. Confidence Score: 0-100
3. Reasoning: Detailed explanation
4. Key Risks: List of potential risks
5. Key Opportunities: List of potential opportunities
6. Target Price (if BUY)
7. Stop Loss (if BUY)

Format as JSON with these exact keys.
"""
def provide_recommendation(context: List[Dict[str, any]]) -> InvestmentRecommendation by llm();

enum AgentRole {
    MARKET_RESEARCHER = "market_researcher",
    STOCK_ANALYST = "stock_analyst",
    INVESTMENT_STRATEGIST = "investment_strategist"
}

"""
You are an expert AI agent orchestrator for comprehensive stock analysis.

AGENT DESCRIPTIONS:
- market_researcher: Gathers market trends, competitor info, news, and market data. Can perform deeper research with custom search queries when needed.
- stock_analyst: Performs in-depth analysis of stock performance, fundamentals, technicals, and sentiment. Can request additional research if data is insufficient.
- investment_strategist: Develops investment strategies and provides final recommendations based on all available analysis.

PLANNING RULES:
1. Sequence MUST always end with INVESTMENT_STRATEGIST
2. If redo_research is True, prioritize market_researcher with enhanced search capabilities to gather missing information
3. After redo_research, always run stock_analyst again to analyze the new data
4. Consider the current_sequence to avoid unnecessary repetition
5. Optimize for comprehensive analysis while minimizing redundant agent executions
6. Typical flow: market_researcher -> stock_analyst -> [if insufficient: market_researcher -> stock_analyst] -> investment_strategist
7. At least one market_researcher and stock_analyst must be included in the sequence

PARAMETERS:
- current_sequence: List of agents already executed or planned
- redo_research: Boolean indicating if Stock Analyst requested additional research

Generate an optimized sequence that ensures thorough analysis while being efficient.
"""
def generate_plan(current_sequence: List[str], redo_research: bool = False) -> List[AgentRole] by llm();