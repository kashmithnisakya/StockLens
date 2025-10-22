import from ai_core { research_stock, analyze_stock, provide_recommendation }
import from jac_cloud.jaseci.utils.logger { logger }
import from serper_client { serper_client }


# Enum for agent types
enum AgentType {
    ANALYST = "analyst",
    STRATEGIST = "strategist",
    RESEARCHER = "researcher"
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

# Master node that coordinates all agents
node master_agent {
    has ticker: str = "";
    has status: Status = Status.IN_PROGRESS;
    has depth: AnalysisDepth = AnalysisDepth.QUICK;
    has sequence: list = [];
    has max_executions: int = 10;
    has knowledge_base: dict = [];
    has final_analysis: dict = {};
}

# Market Researcher Agent Node
node market_researcher {
    has agent_type: AgentType = AgentType.RESEARCHER;
    has role: str = "Market Researcher";
    has goal: str = "Gather current market data and news";
    has research_data: dict = {};
    has status: str = "pending";
    has ticker: str = "";

    def execute() {
        logger.debug(f"nodes | market_researcher | execute | Starting research for {self.ticker}");

        # Get ticker from master agent
        master = <--[0](`?master_agent);
        if master {
            self.ticker = master.ticker;
        }

        if not self.ticker {
            logger.error("nodes | market_researcher | execute | No ticker found");
            return {
                "status": "error",
                "message": "No ticker provided"
            };
        }

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

        self.status = "completed";
        logger.debug(f"nodes | market_researcher | execute | Research completed for {self.ticker}");

        return self.research_data;
    }
}

# Stock Analyst Agent Node
node stock_analyst {
    has agent_type: AgentType = AgentType.ANALYST;
    has role: str = "Stock Analyst";
    has goal: str = "Analyze stock fundamentals, technicals, and sentiment";
    has analysis_result: dict = {};
    has status: str = "pending";

    def execute() {
        logger.debug("Not implemented yet");
        return "plan";
    }
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
        logger.debug("Not implemented yet");
        return "strategy_plan";
    }
}

# Result node to store final output
node analysis_result {
    has ticker: str;
    has timestamp: str;
    has recommendation: str;
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

glob agents = {
    AgentType.RESEARCHER.value: market_researcher,
    AgentType.ANALYST.value: stock_analyst,
    AgentType.STRATEGIST.value: investment_strategist
};