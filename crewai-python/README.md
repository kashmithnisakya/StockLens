# StockLens - CrewAI Implementation

AI-powered stock analysis backend using CrewAI multi-agent framework and FastAPI.

## Overview

This is the CrewAI-based implementation of StockLens, using Python and the CrewAI framework to orchestrate AI agents for comprehensive stock analysis.

## Features

- Multi-agent AI system (Stock Analyst + Investment Strategist)
- FastAPI RESTful API
- CLI interface for batch analysis
- Comprehensive analysis covering fundamentals, technicals, and sentiment
- Investment recommendations (BUY/HOLD/SELL)

## Structure

```
crewai-python/
├── backend/          # Backend API implementation
│   ├── app/          # Application code
│   ├── main.py       # FastAPI server
│   ├── cli.py        # Command-line interface
│   └── README.md     # Detailed documentation
└── frontend/         # React frontend
```

## Quick Start

### Prerequisites

- Python 3.8+
- OpenAI API key
- SerperDev API key

### Setup

```bash
cd backend

# Install dependencies
pip install -r requirements.txt

# Configure environment
cat > .env << EOF
OPENAI_API_KEY=your_openai_api_key
SERPER_API_KEY=your_serper_api_key
EOF

# Start the API server
python main.py
```

The API will be available at `http://localhost:8000`

### CLI Usage

```bash
# Analyze single stock
python cli.py --ticker AAPL --depth comprehensive

# Analyze multiple stocks
python cli.py --tickers AAPL GOOGL MSFT --depth standard
```

## API Endpoints

- `GET /` - Health check
- `POST /api/v1/analyze` - Analyze a single stock
- `POST /api/v1/analyze/batch` - Analyze multiple stocks

## Documentation

For detailed documentation, see [backend/README.md](./backend/README.md)

API documentation is available at:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## Technology Stack

- FastAPI - Web framework
- CrewAI - Multi-agent orchestration
- OpenAI GPT-4o-mini - Language model
- SerperDev - Web search
- Uvicorn - ASGI server
