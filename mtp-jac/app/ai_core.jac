import from byllm { Model }

# Global LLM instance
glob llm = Model(model_name="gpt-4.1");

class MarketData {
    has price: float = 0.0;
    has volume: int = 0;
    has market_cap: float = 0.0;
    has pe_ratio: float = 0.0;
    has dividend_yield: float = 0.0;
}

class MarketResearcherOutput {
    has market_data: MarketData = MarketData();
    has news: list = [];
    has industry_trends: list = [];
    has competitors: list = [];
}

"""
Research the stock {self.ticker} and gather the following information:
1. Current market data (price, volume, market cap)
2. Recent news and developments
3. Industry trends
4. Competitor analysis

Provide a comprehensive summary in JSON format with keys:
- market_data
- news
- industry_trends
- competitors
"""
def research_stock() -> MarketResearcherOutput by llm();


class StockAnalysis {
    has fundamentals: dict = {};
    has technicals: dict = {};
    has sentiment: dict = {};
    has summary: str = "";
}

"""
You are an expert Stock Analyst. Analyze {self.ticker} based on:

Market Data: {market_data}

Provide a detailed analysis covering:
1. Fundamental Analysis (P/E ratio, revenue, profitability)
2. Technical Analysis (price trends, support/resistance)
3. Sentiment Analysis (market sentiment, news sentiment)

Analysis Depth: {self.depth}

Return your analysis in a structured format with sections:
- fundamentals
- technicals
- sentiment
- summary
"""
def analyze_stock() -> StockAnalysis by llm();

# Enum for recommendation types
enum Recommendation {
    BUY = "BUY",
    HOLD = "HOLD",
    SELL = "SELL"
}

class InvestmentRecommendation {
    has recommendation: Recommendation;
    has confidence_score: float = 0.0;
    has reasoning: str = "";
    has key_risks: list = [];
    has key_opportunities: list = [];
    has target_price: float = 0.0;
    has stop_loss: float = 0.0;
}

"""
You are a Senior Investment Strategist. Based on the following analysis for {self.ticker}:

Fundamental Data: {fundamental_data}
Technical Data: {technical_data}
Sentiment Data: {sentiment_data}
Market Data: {market_data}
News: {news_data}

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
def provide_recommendation() -> InvestmentRecommendation by llm();