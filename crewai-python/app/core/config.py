import os
from dotenv import load_dotenv

load_dotenv()

class SystemConfig:
    """System-wide configuration"""

    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
    SERPER_API_KEY = os.getenv("SERPER_API_KEY")

    # LLM Configuration
    LLM_MODEL = "gpt-4o-mini"  # Faster and cheaper than GPT-4
    LLM_TEMPERATURE = 0.1
    MAX_ITERATIONS = 3  # Limit agent iterations
    MAX_EXECUTION_TIME = 300  # 5 minutes max

    # Analysis Configuration
    DEFAULT_ANALYSIS_DEPTH = "comprehensive"
    DEFAULT_TIME_HORIZON = "medium"

    # Logging
    LOG_LEVEL = "INFO"
    LOG_FILE = "stock_analysis.log"

    @classmethod
    def validate(cls):
        """Validate required configuration"""
        if not cls.OPENAI_API_KEY:
            raise ValueError("OPENAI_API_KEY not found in environment variables")
        if not cls.SERPER_API_KEY:
            raise ValueError("SERPER_API_KEY not found in environment variables")
