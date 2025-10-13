"""
FastAPI routes for Jac-based multi-agent stock analysis
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
import os
import sys

# Add parent directory to path for imports
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

# Initialize FastAPI app
app = FastAPI(
    title="StockLens Jac API",
    description="Multi-agent stock analysis using Jac language",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Request/Response Models
class AnalysisRequest(BaseModel):
    ticker: str = Field(..., description="Stock ticker symbol", example="AAPL")
    depth: str = Field(
        default="comprehensive",
        description="Analysis depth: quick, standard, or comprehensive",
        example="comprehensive"
    )

class BatchAnalysisRequest(BaseModel):
    tickers: List[str] = Field(..., description="List of stock ticker symbols")
    depth: str = Field(
        default="comprehensive",
        description="Analysis depth: quick, standard, or comprehensive"
    )

class AnalysisResponse(BaseModel):
    ticker: str
    status: str
    recommendation: Optional[str] = None
    confidence: Optional[float] = None
    summary: Optional[str] = None
    metrics: Optional[dict] = None
    risks: Optional[List[str]] = None
    opportunities: Optional[List[str]] = None
    timestamp: str
    depth: str

class HealthResponse(BaseModel):
    status: str
    timestamp: str
    version: str
    jac_enabled: bool

# In-memory cache for analysis results
analysis_cache = {}

# Root endpoint
@app.get("/")
async def root():
    """Root endpoint - health check"""
    return {
        "message": "StockLens Jac API is running",
        "status": "active",
        "framework": "Jac Language",
        "docs": "/docs"
    }

# Health check endpoint
@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Detailed health check"""
    return HealthResponse(
        status="healthy",
        timestamp=datetime.now().isoformat(),
        version="1.0.0",
        jac_enabled=True
    )

# Single stock analysis endpoint (POST)
@app.post("/api/v1/analyze", response_model=AnalysisResponse)
async def analyze_stock(request: AnalysisRequest):
    """
    Analyze a single stock using Jac multi-agent system

    This endpoint orchestrates multiple AI agents to:
    1. Research market data and news
    2. Analyze fundamentals and technicals
    3. Generate investment recommendation
    """
    try:
        ticker = request.ticker.upper()
        depth = request.depth.lower()

        # Validate depth
        if depth not in ["quick", "standard", "comprehensive"]:
            raise HTTPException(status_code=400, detail="Invalid depth. Use: quick, standard, or comprehensive")

        # Check cache
        cache_key = f"{ticker}_{depth}"
        if cache_key in analysis_cache:
            cached_result = analysis_cache[cache_key]
            # Return cached result if less than 5 minutes old
            cache_time = datetime.fromisoformat(cached_result["timestamp"])
            if (datetime.now() - cache_time).seconds < 300:
                return AnalysisResponse(**cached_result, depth=depth)

        # Import Jac components (lazy import)
        try:
            from jaclang import jac_import

            # Import Jac modules
            nodes_module = jac_import("app.nodes")
            walkers_module = jac_import("app.walkers")

            # Create master agent node
            MasterAgent = nodes_module.MasterAgent
            OrchestrateAnalysis = walkers_module.OrchestrateAnalysis

            master = MasterAgent()

            # Create and spawn orchestrator walker
            orchestrator = OrchestrateAnalysis(ticker=ticker, depth=depth)
            orchestrator.spawn(master)

            # Get result from walker
            result = orchestrator.result

            if not result or result.get("status") != "success":
                raise HTTPException(
                    status_code=500,
                    detail="Analysis failed. Please try again."
                )

            # Format response
            response_data = {
                "ticker": ticker,
                "status": result.get("status", "completed"),
                "recommendation": result.get("recommendation"),
                "confidence": result.get("confidence", 0.0),
                "summary": result.get("summary", ""),
                "metrics": result.get("metrics", {}),
                "risks": result.get("risks", []),
                "opportunities": result.get("opportunities", []),
                "timestamp": result.get("timestamp", datetime.now().isoformat())
            }

            # Cache result
            analysis_cache[cache_key] = response_data

            return AnalysisResponse(**response_data, depth=depth)

        except ImportError as e:
            # Fallback to mock response for development
            print(f"Jac import error: {e}")
            return _generate_mock_response(ticker, depth)

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Analysis error: {str(e)}")

# Single stock analysis endpoint (GET)
@app.get("/api/v1/analyze/{ticker}", response_model=AnalysisResponse)
async def analyze_stock_get(ticker: str, depth: str = "comprehensive"):
    """Analyze a single stock via GET request"""
    request = AnalysisRequest(ticker=ticker, depth=depth)
    return await analyze_stock(request)

# Batch analysis endpoint
@app.post("/api/v1/analyze/batch")
async def batch_analyze(request: BatchAnalysisRequest):
    """
    Analyze multiple stocks in batch
    """
    try:
        results = []

        for ticker in request.tickers:
            analysis_request = AnalysisRequest(ticker=ticker, depth=request.depth)
            result = await analyze_stock(analysis_request)
            results.append(result)

        return {
            "status": "success",
            "count": len(results),
            "results": results,
            "timestamp": datetime.now().isoformat()
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Batch analysis error: {str(e)}")

# Clear cache endpoint
@app.post("/api/v1/cache/clear")
async def clear_cache():
    """Clear the analysis cache"""
    global analysis_cache
    cache_size = len(analysis_cache)
    analysis_cache = {}
    return {
        "status": "success",
        "message": f"Cleared {cache_size} cached results",
        "timestamp": datetime.now().isoformat()
    }

# Get cache stats
@app.get("/api/v1/cache/stats")
async def cache_stats():
    """Get cache statistics"""
    return {
        "cached_analyses": len(analysis_cache),
        "tickers": list(set(k.split("_")[0] for k in analysis_cache.keys())),
        "timestamp": datetime.now().isoformat()
    }

# Helper function for mock response (development/testing)
def _generate_mock_response(ticker: str, depth: str) -> AnalysisResponse:
    """Generate a mock response for testing"""
    return AnalysisResponse(
        ticker=ticker,
        status="success",
        recommendation="HOLD",
        confidence=75.0,
        summary=f"Mock analysis for {ticker}. This is a development placeholder. "
                f"The Jac multi-agent system will provide real analysis once fully initialized.",
        metrics={
            "pe_ratio": "25.4",
            "market_cap": "$2.8T",
            "price": "$175.50"
        },
        risks=["Market volatility", "Regulatory changes"],
        opportunities=["Product innovation", "Market expansion"],
        timestamp=datetime.now().isoformat(),
        depth=depth
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "api:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
