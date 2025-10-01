from crewai import Crew, Process
from typing import List, Dict
from datetime import datetime
from app.services.agents import StockAnalysisAgents
from app.services.tasks import StockAnalysisTasks
from app.models.schemas import StockAnalysisConfig

class StockAnalysisCrew:
    """Orchestrates the multi-agent stock analysis"""

    def __init__(self):
        self.agents = StockAnalysisAgents()
        self.tasks = StockAnalysisTasks(self.agents)

    def create_crew(self, config: StockAnalysisConfig) -> Crew:
        """Create and configure the crew"""

        # Get all tasks
        tasks = self.tasks.create_all_tasks(config)

        # Create crew with optimized settings
        crew = Crew(
            agents=[
                self.agents.analyst(),
                self.agents.strategist()
            ],
            tasks=tasks,
            process=Process.sequential,
            verbose=True,
            max_rpm=10,  # Rate limit to avoid API issues
            memory=False  # Disable memory for faster execution
        )

        return crew

    def analyze(self, ticker: str, analysis_depth: str = "comprehensive") -> str:
        """Execute stock analysis"""

        print(f"\n{'='*80}")
        print(f"Starting Stock Analysis for: {ticker}")
        print(f"Analysis Depth: {analysis_depth}")
        print(f"Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"{'='*80}\n")

        # Create configuration
        config = StockAnalysisConfig(
            ticker=ticker,
            analysis_depth=analysis_depth
        )

        # Create and execute crew
        crew = self.create_crew(config)

        try:
            result = crew.kickoff(inputs={"ticker": ticker})

            print(f"\n{'='*80}")
            print("Analysis Complete!")
            print(f"{'='*80}\n")

            return result

        except Exception as e:
            print(f"Error during analysis: {str(e)}")
            raise

    def batch_analyze(self, tickers: List[str], analysis_depth: str = "comprehensive") -> Dict[str, str]:
        """Analyze multiple stocks"""
        results = {}

        for ticker in tickers:
            print(f"\nProcessing {ticker}...")
            try:
                results[ticker] = self.analyze(ticker, analysis_depth)
            except Exception as e:
                results[ticker] = f"Error: {str(e)}"

        return results
