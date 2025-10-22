import from ai_core { analyze_stock, provide_recommendation }
import from jac_cloud.jaseci.utils.logger { logger }
import from serper_client { serper_client }


enum AgentRole {
    STOCK_ANALYST = "stock_analyst",
    INVESTMENT_STRATEGIST = "investment_strategist",
    MARKET_RESEARCHER = "market_researcher"
}

enum Status {
    PENDING = "pending",
    IN_PROGRESS = "in_progress",
    COMPLETED = "completed",
    FAILED = "failed"
}

enum AnalysisDepth {
    QUICK = "quick",
    STANDARD = "standard",
    COMPREHENSIVE = "comprehensive"
}

node master_agent {
    has ticker: str = "";
    has status: Status = Status.IN_PROGRESS;
    has depth: AnalysisDepth = AnalysisDepth.QUICK;
    has sequence: list = [];
    has max_executions: int = 10;
    has final_analysis: dict = {};
}

node market_researcher {
    has agent_role: AgentRole = AgentRole.MARKET_RESEARCHER;
    has goal: str = "Gather current market data and news";
    has research_data: dict = {};
    has status: Status = Status.PENDING;
    has ticker: str = "";

    def execute(walker_obj: any) {
        logger.debug(f"nodes | market_researcher | execute | Starting research for {self.ticker}");

        # Fetch news using SERPER
        logger.debug(f"nodes | market_researcher | execute | Fetching news for {self.ticker}");
        news_result = serper_client.search_stock_news(self.ticker, num_results=10);

        # Fetch market trends
        logger.debug(f"nodes | market_researcher | execute | Fetching market trends for {self.ticker}");
        trends_result = serper_client.search_market_trends(self.ticker, num_results=5);

        # Fetch competitor information
        logger.debug(f"nodes | market_researcher | execute | Fetching competitor info for {self.ticker}");
        competitor_result = serper_client.search_competitor_info(self.ticker, num_results=5);

        # Compile research data
        self.research_data = {
            "ticker": self.ticker,
            "news": news_result.get("news", []),
            "trends": trends_result.get("trends", []),
            "competitors": competitor_result.get("competitors", []),
            "news_count": news_result.get("count", 0),
            "trends_count": trends_result.get("count", 0),
            "competitors_count": competitor_result.get("count", 0)
        };

        self.status = Status.COMPLETED;
        logger.debug(f"nodes | market_researcher | execute | Research completed for {self.ticker}");

        return self.research_data;
    }
}

# Stock Analyst Agent Node
node stock_analyst {
    has agent_role: AgentRole = AgentRole.STOCK_ANALYST;
    has goal: str = "Analyze stock fundamentals, technicals, and sentiment";
    has analysis_result: dict = {};
    has status: Status = Status.PENDING;

    def execute(walker_obj: any) {
        return analyze_stock(context=walker_obj.knowledge_base);
    }
}

# Investment Strategist Agent Node
node investment_strategist {
    has agent_role: AgentRole = AgentRole.INVESTMENT_STRATEGIST;
    has goal: str = "Provide investment recommendation based on analysis";
    has recommendation: str = "";
    has reasoning: str = "";
    has status: Status = Status.PENDING;

    def execute(walker_obj: any) {
        return provide_recommendation(context=walker_obj.knowledge_base);
    }
}

glob agents = {
    AgentRole.MARKET_RESEARCHER.value: market_researcher,
    AgentRole.STOCK_ANALYST.value: stock_analyst,
    AgentRole.INVESTMENT_STRATEGIST.value: investment_strategist
};