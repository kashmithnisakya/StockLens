"""
Configuration settings for Jac-based stock analysis system
"""

import os
from dotenv import load_dotenv
from typing import Optional

# Load environment variables
load_dotenv()

class Config:
    """Application configuration"""

    # API Keys
    OPENAI_API_KEY: str = os.getenv("OPENAI_API_KEY", "")
    SERPER_API_KEY: str = os.getenv("SERPER_API_KEY", "")

    # LLM Configuration
    LLM_MODEL: str = os.getenv("LLM_MODEL", "gpt-4o-mini")
    LLM_TEMPERATURE: float = float(os.getenv("LLM_TEMPERATURE", "0.7"))
    LLM_MAX_TOKENS: int = int(os.getenv("LLM_MAX_TOKENS", "2000"))

    # Analysis Configuration
    MAX_ITERATIONS: int = 3
    DEFAULT_DEPTH: str = "comprehensive"
    CACHE_TIMEOUT: int = 300  # 5 minutes

    # API Configuration
    API_HOST: str = os.getenv("API_HOST", "0.0.0.0")
    API_PORT: int = int(os.getenv("API_PORT", "8000"))
    API_RELOAD: bool = os.getenv("API_RELOAD", "True").lower() == "true"

    # Rate Limiting
    RATE_LIMIT_PER_MINUTE: int = 10
    RATE_LIMIT_PER_HOUR: int = 100

    # Jac Configuration
    JAC_VERBOSE: bool = os.getenv("JAC_VERBOSE", "True").lower() == "true"
    JAC_DEBUG: bool = os.getenv("JAC_DEBUG", "False").lower() == "true"

    # Agent Configuration
    AGENTS_CONFIG = {
        "researcher": {
            "role": "Market Researcher",
            "goal": "Gather comprehensive market data and news",
            "max_search_results": 10
        },
        "analyst": {
            "role": "Stock Analyst",
            "goal": "Analyze fundamentals, technicals, and sentiment",
            "analysis_areas": ["fundamentals", "technicals", "sentiment"]
        },
        "strategist": {
            "role": "Investment Strategist",
            "goal": "Provide actionable investment recommendations",
            "recommendation_types": ["BUY", "HOLD", "SELL"]
        }
    }

    # Analysis Depth Settings
    DEPTH_SETTINGS = {
        "quick": {
            "max_news_items": 3,
            "analysis_detail": "brief",
            "max_iterations": 1
        },
        "standard": {
            "max_news_items": 5,
            "analysis_detail": "standard",
            "max_iterations": 2
        },
        "comprehensive": {
            "max_news_items": 10,
            "analysis_detail": "detailed",
            "max_iterations": 3
        }
    }

    # Logging
    LOG_LEVEL: str = os.getenv("LOG_LEVEL", "INFO")
    LOG_FORMAT: str = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"

    @classmethod
    def validate(cls) -> bool:
        """Validate required configuration"""
        if not cls.OPENAI_API_KEY:
            print("WARNING: OPENAI_API_KEY not set")
            return False
        return True

    @classmethod
    def get_depth_config(cls, depth: str) -> dict:
        """Get configuration for specific analysis depth"""
        return cls.DEPTH_SETTINGS.get(depth, cls.DEPTH_SETTINGS["comprehensive"])

    @classmethod
    def get_agent_config(cls, agent_type: str) -> dict:
        """Get configuration for specific agent"""
        return cls.AGENTS_CONFIG.get(agent_type, {})


class SystemPrompts:
    """System prompts for different agents"""

    RESEARCHER_PROMPT = """
    You are an expert Market Researcher specializing in stock market analysis.
    Your goal is to gather comprehensive, accurate, and up-to-date information about stocks.

    Focus on:
    - Current market data (price, volume, market cap)
    - Recent news and developments
    - Industry trends and competitive landscape
    - Regulatory and macroeconomic factors

    Provide factual, unbiased information in a structured format.
    """

    ANALYST_PROMPT = """
    You are a Senior Stock Analyst with expertise in fundamental and technical analysis.
    Your goal is to provide thorough, data-driven analysis of stocks.

    Analyze across three dimensions:
    1. Fundamentals: Financial metrics, ratios, profitability, growth
    2. Technicals: Price trends, support/resistance, momentum indicators
    3. Sentiment: Market sentiment, news sentiment, investor sentiment

    Be objective and highlight both strengths and weaknesses.
    """

    STRATEGIST_PROMPT = """
    You are a Chief Investment Strategist responsible for actionable recommendations.
    Your goal is to synthesize analysis into clear investment guidance.

    Provide:
    - Clear recommendation (BUY/HOLD/SELL)
    - Confidence level (0-100)
    - Detailed reasoning
    - Key risks and opportunities
    - Price targets and stop losses (if applicable)

    Be decisive but transparent about uncertainties and assumptions.
    """

    @classmethod
    def get_prompt(cls, agent_type: str, context: dict = None) -> str:
        """Get prompt for specific agent with optional context"""
        prompts = {
            "researcher": cls.RESEARCHER_PROMPT,
            "analyst": cls.ANALYST_PROMPT,
            "strategist": cls.STRATEGIST_PROMPT
        }

        prompt = prompts.get(agent_type, "")

        if context:
            prompt += f"\n\nContext:\n{context}"

        return prompt


# Initialize and validate configuration on import
if not Config.validate():
    print("Configuration validation warnings detected. Check environment variables.")
