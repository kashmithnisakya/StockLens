import from ai_core { analyze_stock, provide_recommendation, generate_plan, AgentRole }
import from jac_cloud.jaseci.utils.logger { logger }
import from serper_client { serper_client }
import from typing { Any }


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


    def execute(walker_obj: Any, redo_research: bool = False) {
        logger.debug(f"nodes | master_agent | execute | Starting analysis planning for {self.ticker} (redo_research={redo_research})");

        # Get executed agents if knowledge_base exists (during orchestration)
        executed_agents = [];
        if hasattr(walker_obj, 'knowledge_base') {
            executed_agents = [kb["agent"] for kb in walker_obj.knowledge_base];
        }

        # Provide context about current execution state
        execution_context = {
            "current_sequence": self.sequence,
            "executed_agents": executed_agents,
            "redo_research": redo_research,
            "depth": self.depth.value
        };

        logger.debug(f"nodes | master_agent | execute | Planning context: {execution_context}");

        # Generate optimized sequence
        generated_sequence = generate_plan(
            current_sequence=self.sequence,
            redo_research=redo_research
        );
        converted_sequence = [agent.value for agent in generated_sequence];

        logger.debug(f"nodes | master_agent | execute | Generated agent sequence: {converted_sequence}");
        return converted_sequence;
    }
}

node market_researcher {
    has agent_role: AgentRole = AgentRole.MARKET_RESEARCHER;
    has goal: str = "Gather current market data and news";
    has research_data: dict = {};
    has status: Status = Status.PENDING;

    def execute(walker_obj: Any, redo_research: bool = False) {
        logger.debug(f"nodes | market_researcher | execute | Starting research for {walker_obj.ticker} (redo_research={redo_research})");

        # Determine num_results based on redo_research flag
        news_count = 20 if redo_research else 15;
        trends_count = 10 if redo_research else 8;
        competitor_count = 8 if redo_research else 5;

        if redo_research {
            logger.debug(f"nodes | market_researcher | execute | Performing deeper research with custom search");

            # Use custom search for more comprehensive results
            news_result = serper_client.custom_search(
                query=f"{walker_obj.ticker} stock news earnings financial analysis",
                num_results=news_count,
                search_type="news"
            );

            trends_result = serper_client.custom_search(
                query=f"{walker_obj.ticker} stock market technical analysis price trends indicators",
                num_results=trends_count,
                search_type="search"
            );

            competitor_result = serper_client.custom_search(
                query=f"{walker_obj.ticker} competitors industry comparison market share",
                num_results=competitor_count,
                search_type="search"
            );

            # Compile research data from custom search
            self.research_data = {
                "ticker": walker_obj.ticker,
                "news": news_result.get("results", []),
                "trends": trends_result.get("results", []),
                "competitors": competitor_result.get("results", []),
                "news_count": news_result.get("count", 0),
                "trends_count": trends_result.get("count", 0),
                "competitors_count": competitor_result.get("count", 0),
                "redo_research": True
            };
        } else {
            # Standard research with increased results
            logger.debug(f"nodes | market_researcher | execute | Fetching news for {walker_obj.ticker}");
            news_result = serper_client.search_stock_news(walker_obj.ticker, num_results=news_count);

            # Fetch market trends
            logger.debug(f"nodes | market_researcher | execute | Fetching market trends for {walker_obj.ticker}");
            trends_result = serper_client.search_market_trends(walker_obj.ticker, num_results=trends_count);

            # Fetch competitor information
            logger.debug(f"nodes | market_researcher | execute | Fetching competitor info for {walker_obj.ticker}");
            competitor_result = serper_client.search_competitor_info(walker_obj.ticker, num_results=competitor_count);

            # Compile research data
            self.research_data = {
                "ticker": walker_obj.ticker,
                "news": news_result.get("news", []),
                "trends": trends_result.get("trends", []),
                "competitors": competitor_result.get("competitors", []),
                "news_count": news_result.get("count", 0),
                "trends_count": trends_result.get("count", 0),
                "competitors_count": competitor_result.get("count", 0),
                "redo_research": False
            };
        }

        self.status = Status.COMPLETED;
        logger.debug(f"nodes | market_researcher | execute | Research completed for {walker_obj.ticker}");

        return self.research_data;
    }
}

# Stock Analyst Agent Node
node stock_analyst {
    has agent_role: AgentRole = AgentRole.STOCK_ANALYST;
    has goal: str = "Analyze stock fundamentals, technicals, and sentiment";
    has analysis_result: dict = {};
    has status: Status = Status.PENDING;

    def execute(walker_obj: Any) {
        logger.debug(f"nodes | stock_analyst | execute | Starting analysis for {walker_obj.ticker}");

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

    def execute(walker_obj: Any) {
        logger.debug(f"nodes | investment_strategist | execute | Starting recommendation for {walker_obj.ticker}");

        return provide_recommendation(context=walker_obj.knowledge_base);
    }
}

glob agents = {
    AgentRole.MARKET_RESEARCHER.value: market_researcher,
    AgentRole.STOCK_ANALYST.value: stock_analyst,
    AgentRole.INVESTMENT_STRATEGIST.value: investment_strategist
};