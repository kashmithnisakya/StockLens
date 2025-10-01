from crewai import Agent
from crewai_tools import SerperDevTool, ScrapeWebsiteTool
from langchain_openai import ChatOpenAI
from config import SystemConfig

class StockAnalysisAgents:
    """Factory class for creating specialized agents"""

    def __init__(self):
        self.search_tool = SerperDevTool()
        self.llm = ChatOpenAI(
            model=SystemConfig.LLM_MODEL,
            temperature=SystemConfig.LLM_TEMPERATURE
        )

        # Create agents once and reuse them
        self._analyst = None
        self._strategist = None
    
    def analyst(self) -> Agent:
        """Create comprehensive stock analyst"""
        if self._analyst is None:
            self._analyst = Agent(
                role="Stock Analyst",
                goal="Analyze {ticker} covering fundamentals, technicals, and market sentiment",
                backstory="Expert analyst covering all aspects of stock analysis efficiently.",
                tools=[self.search_tool],
                llm=self.llm,
                verbose=True,
                allow_delegation=False,
                max_iter=SystemConfig.MAX_ITERATIONS
            )
        return self._analyst

    def strategist(self) -> Agent:
        """Create investment strategist"""
        if self._strategist is None:
            self._strategist = Agent(
                role="Investment Strategist",
                goal="Provide BUY/HOLD/SELL recommendation for {ticker}",
                backstory="Senior strategist providing clear, actionable investment advice.",
                llm=self.llm,
                verbose=True,
                allow_delegation=False,
                max_iter=SystemConfig.MAX_ITERATIONS
            )
        return self._strategist
