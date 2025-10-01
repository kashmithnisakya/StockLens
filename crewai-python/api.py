from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Optional, Dict
from datetime import datetime
import logging
from crew import StockAnalysisCrew
from config import SystemConfig

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Stock Analysis API",
    description="AI-powered stock analysis using CrewAI agents",
    version="1.0.0"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure this for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Request/Response Models
class AnalysisRequest(BaseModel):
    ticker: str = Field(..., description="Stock ticker symbol (e.g., AAPL, GOOGL)")
    depth: str = Field(default="comprehensive", description="Analysis depth: basic, standard, comprehensive")

    class Config:
        schema_extra = {
            "example": {
                "ticker": "AAPL",
                "depth": "comprehensive"
            }
        }

class AnalysisResponse(BaseModel):
    ticker: str
    analysis: str
    timestamp: str
    depth: str
    status: str = "completed"

class BatchAnalysisRequest(BaseModel):
    tickers: list[str] = Field(..., description="List of stock ticker symbols")
    depth: str = Field(default="comprehensive", description="Analysis depth")

    class Config:
        schema_extra = {
            "example": {
                "tickers": ["AAPL", "GOOGL", "MSFT"],
                "depth": "comprehensive"
            }
        }

class BatchAnalysisResponse(BaseModel):
    results: Dict[str, str]
    timestamp: str
    status: str = "completed"

class HealthResponse(BaseModel):
    status: str
    timestamp: str
    version: str

# Initialize crew
crew = None

@app.on_event("startup")
async def startup_event():
    """Initialize the crew on startup"""
    global crew
    try:
        SystemConfig.validate()
        crew = StockAnalysisCrew()
        logger.info("Stock Analysis Crew initialized successfully")
    except Exception as e:
        logger.error(f"Failed to initialize crew: {str(e)}")
        raise

@app.get("/", response_model=HealthResponse)
async def root():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "version": "1.0.0"
    }

@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Detailed health check"""
    return {
        "status": "healthy" if crew is not None else "unhealthy",
        "timestamp": datetime.now().isoformat(),
        "version": "1.0.0"
    }

@app.post("/analyze", response_model=AnalysisResponse)
async def analyze_stock(request: AnalysisRequest):
    """
    Analyze a single stock

    - **ticker**: Stock ticker symbol (e.g., AAPL, GOOGL)
    - **depth**: Analysis depth (basic, standard, comprehensive)
    """
    try:
        logger.info(f"Starting analysis for {request.ticker}")

        if not crew:
            raise HTTPException(status_code=503, detail="Analysis service not available")

        # Run analysis
        result = crew.analyze(request.ticker, request.depth)

        return {
            "ticker": request.ticker,
            "analysis": result,
            "timestamp": datetime.now().isoformat(),
            "depth": request.depth,
            "status": "completed"
        }

    except Exception as e:
        logger.error(f"Analysis failed for {request.ticker}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Analysis failed: {str(e)}")

@app.post("/analyze/batch", response_model=BatchAnalysisResponse)
async def analyze_batch(request: BatchAnalysisRequest):
    """
    Analyze multiple stocks

    - **tickers**: List of stock ticker symbols
    - **depth**: Analysis depth (basic, standard, comprehensive)
    """
    try:
        logger.info(f"Starting batch analysis for {len(request.tickers)} stocks")

        if not crew:
            raise HTTPException(status_code=503, detail="Analysis service not available")

        # Run batch analysis
        results = crew.batch_analyze(request.tickers, request.depth)

        return {
            "results": results,
            "timestamp": datetime.now().isoformat(),
            "status": "completed"
        }

    except Exception as e:
        logger.error(f"Batch analysis failed: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Batch analysis failed: {str(e)}")

@app.get("/analyze/{ticker}", response_model=AnalysisResponse)
async def analyze_stock_get(ticker: str, depth: str = "comprehensive"):
    """
    Analyze a stock using GET method

    - **ticker**: Stock ticker symbol
    - **depth**: Analysis depth (query parameter)
    """
    request = AnalysisRequest(ticker=ticker, depth=depth)
    return await analyze_stock(request)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)
