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
You are an expert AI agent orchestrator. 
Based on the current sequence of agents executed, generate an optimized plan for the next set of agents to execute for a comprehensive stock analysis.
sequence should always end with INVESTMENT_STRATEGIST.
- market_researcher: Gathers market trends, competitor info, and news.
- stock_analyst: Performs in-depth analysis of the stock's performance.
- investment_strategist: Develops investment strategies based on the analysis.
"""
def generate_plan(current_sequence: List[str]) -> List[AgentRole] by llm();