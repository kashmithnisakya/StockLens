import from ai_core { research_stock, analyze_stock, provide_recommendation }
import from jac_cloud.jaseci.utils.logger { logger }


# Enum for agent types
enum AgentType {
    ANALYST = "analyst",
    STRATEGIST = "strategist",
    RESEARCHER = "researcher"
}

enum AnalysisDepth {
    QUICK = "quick",
    STANDARD = "standard",
    COMPREHENSIVE = "comprehensive"
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

# Market Researcher Agent Node
node market_researcher {
    has agent_type: AgentType = AgentType.RESEARCHER;
    has role: str = "Market Researcher";
    has goal: str = "Gather current market data and news";
    has research_data: dict = {};
    has status: str = "pending";

    def execute() {
        logger.debug("Not implemented yet");
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