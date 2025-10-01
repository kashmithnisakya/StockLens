from pydantic import BaseModel, Field
from typing import Dict, List

class StockAnalysisConfig(BaseModel):
    """Configuration for stock analysis"""
    ticker: str = Field(..., description="Stock ticker symbol")
    analysis_depth: str = Field(default="comprehensive", description="Analysis depth: basic, standard, comprehensive")
    time_horizon: str = Field(default="medium", description="Time horizon: short, medium, long")

class AnalysisOutput(BaseModel):
    """Structured output for analysis results"""
    ticker: str
    recommendation: str
    confidence_score: float
    key_findings: List[str]
    risks: List[str]
    price_target: Dict[str, float]
    timestamp: str

class AnalysisRequest(BaseModel):
    """API request model for analysis"""
    ticker: str = Field(..., description="Stock ticker symbol (e.g., AAPL, GOOGL)")
    depth: str = Field(default="comprehensive", description="Analysis depth: basic, standard, comprehensive")

    class Config:
        json_schema_extra = {
            "example": {
                "ticker": "AAPL",
                "depth": "comprehensive"
            }
        }

class AnalysisResponse(BaseModel):
    """API response model for analysis"""
    ticker: str
    analysis: str
    timestamp: str
    depth: str
    status: str = "completed"

class BatchAnalysisRequest(BaseModel):
    """API request model for batch analysis"""
    tickers: list[str] = Field(..., description="List of stock ticker symbols")
    depth: str = Field(default="comprehensive", description="Analysis depth")

    class Config:
        json_schema_extra = {
            "example": {
                "tickers": ["AAPL", "GOOGL", "MSFT"],
                "depth": "comprehensive"
            }
        }

class BatchAnalysisResponse(BaseModel):
    """API response model for batch analysis"""
    results: Dict[str, str]
    timestamp: str
    status: str = "completed"

class HealthResponse(BaseModel):
    """API response model for health check"""
    status: str
    timestamp: str
    version: str
