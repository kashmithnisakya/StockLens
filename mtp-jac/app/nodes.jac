import from byllm { Model }

# Global LLM instance
glob llm = Model(model_name="gpt-4.1");

# Enum for agent types
enum AgentType {
    ANALYST = "analyst",
    STRATEGIST = "strategist",
    RESEARCHER = "researcher"
}

# Enum for analysis depth
enum AnalysisDepth {
    QUICK = "quick",
    STANDARD = "standard",
    COMPREHENSIVE = "comprehensive"
}

# Enum for recommendation types
enum Recommendation {
    BUY = "BUY",
    HOLD = "HOLD",
    SELL = "SELL"
}

# Master node that coordinates all agents
node master_agent {
    has ticker: str = "";
    has depth: AnalysisDepth = AnalysisDepth.COMPREHENSIVE;
    has status: str = "initialized";
    has knowledge_base: dict = {};
    has final_analysis: dict = {};
    has timestamp: str = "";
}

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

# Market Researcher Agent Node
node market_researcher {
    has agent_type: AgentType = AgentType.RESEARCHER;
    has role: str = "Market Researcher";
    has goal: str = "Gather current market data and news";
    has research_data: dict = {};
    has status: str = "pending";

    def execute() {
        f"""
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
    } MarketResearcherOutput -> by llm();
}

class StockAnalysis {
    has fundamentals: dict = {};
    has technicals: dict = {};
    has sentiment: dict = {};
    has summary: str = "";
}

# Stock Analyst Agent Node
node stock_analyst {
    has agent_type: AgentType = AgentType.ANALYST;
    has role: str = "Stock Analyst";
    has goal: str = "Analyze stock fundamentals, technicals, and sentiment";
    has analysis_result: dict = {};
    has status: str = "pending";

    def execute() {
        f"""
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
    } StockAnalysis -> by llm();
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

# Investment Strategist Agent Node
node investment_strategist {
    has agent_type: AgentType = AgentType.STRATEGIST;
    has role: str = "Investment Strategist";
    has goal: str = "Provide investment recommendation based on analysis";
    has recommendation: str = "";
    has reasoning: str = "";
    has status: str = "pending";

    def execute() {
        f"""
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
        """;
    } InvestmentRecommendation -> by llm();
}

# Result node to store final output
node analysis_result {
    has ticker: str;
    has timestamp: str;
    has recommendation: Recommendation;
    has confidence_score: float = 0.0;
    has analysis_summary: str = "";
    has key_metrics: dict = {};
    has risks: list = [];
    has opportunities: list = [];
}

# Task node for individual tasks
node task {
    has task_name: str;
    has description: str;
    has assigned_to: str;
    has result: str = "";
    has status: str = "pending";
    has priority: int = 1;
}