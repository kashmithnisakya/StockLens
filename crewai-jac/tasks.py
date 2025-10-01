from crewai import Task
from typing import List
from agents import StockAnalysisAgents
from config import StockAnalysisConfig

class StockAnalysisTasks:
    """Factory class for creating analysis tasks"""

    def __init__(self, agents: StockAnalysisAgents):
        self.agents = agents

    def create_analysis_task(self, ticker: str) -> Task:
        """Create comprehensive analysis task"""
        return Task(
            description=f"""Analyze {ticker} stock:
            1. Current price, P/E ratio, market cap
            2. Recent news and sentiment (last 7 days)
            3. Key financial metrics (revenue growth, profit margin)
            4. Major risks

            Be concise and focus on key facts.""",
            agent=self.agents.analyst(),
            expected_output="Concise analysis with key metrics and recent developments"
        )

    def create_recommendation_task(self, ticker: str, analysis_task: Task) -> Task:
        """Create investment recommendation task"""
        return Task(
            description=f"""Based on the analysis, provide investment recommendation for {ticker}:
            1. Clear BUY/HOLD/SELL recommendation
            2. Target price (12-month)
            3. Top 3 reasons for recommendation
            4. Key risks

            Keep it brief and actionable.""",
            agent=self.agents.strategist(),
            expected_output="Investment recommendation with target price and rationale",
            context=[analysis_task]
        )

    def create_all_tasks(self, config: StockAnalysisConfig) -> List[Task]:
        """Create all tasks in proper sequence"""
        ticker = config.ticker

        analysis_task = self.create_analysis_task(ticker)
        recommendation_task = self.create_recommendation_task(ticker, analysis_task)

        return [analysis_task, recommendation_task]
