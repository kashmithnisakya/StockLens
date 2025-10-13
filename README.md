# StockLens

AI-powered stock analysis platform using multi-agent AI systems to provide comprehensive investment insights.

## Overview

StockLens is a full-stack application that leverages CrewAI's multi-agent framework to perform intelligent stock analysis. The system uses specialized AI agents (Stock Analyst and Investment Strategist) to analyze stocks from multiple dimensions and provide actionable investment recommendations.

## Features

- Real-time stock analysis using AI agents
- Comprehensive analysis covering:
  - Fundamental metrics
  - Technical indicators
  - Market sentiment
  - Investment recommendations (BUY/HOLD/SELL)
- Modern React frontend with responsive design
- FastAPI backend with RESTful API
- CLI interface for batch analysis
- Configurable analysis depth (quick/comprehensive)

## Architecture

```
StockLens/
├── crewai-python/      # Backend API (FastAPI + CrewAI)
├── frontend/           # React frontend (Vite)
└── mtp-jac/           # Additional modules
```

### Technology Stack

**Backend:**
- FastAPI - Modern, fast web framework
- CrewAI - Multi-agent AI orchestration
- OpenAI GPT-4o-mini - Language model
- SerperDev - Web search tool
- Uvicorn - ASGI server

**Frontend:**
- React 19 - UI framework
- Vite - Build tool and dev server
- React Markdown - Markdown rendering
- CSS3 - Styling

## Quick Start

### Prerequisites

- Python 3.8+
- Node.js 16+
- OpenAI API key
- SerperDev API key

### 1. Clone the Repository

```bash
git clone <repository-url>
cd StockLens
```

### 2. Setup Backend

```bash
cd crewai-python

# Install dependencies
pip install -r requirements.txt

# Create .env file
cat > .env << EOF
OPENAI_API_KEY=your_openai_api_key
SERPER_API_KEY=your_serper_api_key
EOF

# Start the API server
python main.py
```

The API will be available at `http://localhost:8000`

### 3. Setup Frontend

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

The frontend will be available at `http://localhost:5173`

## Usage

### Web Interface

1. Open `http://localhost:5173` in your browser
2. Enter a stock ticker (e.g., AAPL, GOOGL, MSFT)
3. Select analysis depth (quick or comprehensive)
4. Click "Analyze Stock"
5. View the AI-generated analysis and recommendation

### CLI Interface

```bash
cd crewai-python

# Analyze single stock
python cli.py --ticker AAPL --depth comprehensive

# Analyze multiple stocks
python cli.py --tickers AAPL GOOGL MSFT --depth standard
```

### API Endpoints

**Health Check:**
- `GET /` - Root health check
- `GET /health` - Detailed health status

**Stock Analysis:**
- `POST /api/v1/analyze` - Analyze a single stock
- `GET /api/v1/analyze/{ticker}` - Analyze stock via GET
- `POST /api/v1/analyze/batch` - Analyze multiple stocks

**Example API Request:**

```bash
curl -X POST "http://localhost:8000/api/v1/analyze" \
  -H "Content-Type: application/json" \
  -d '{
    "ticker": "AAPL",
    "depth": "comprehensive"
  }'
```

**Example Response:**

```json
{
  "ticker": "AAPL",
  "status": "success",
  "depth": "comprehensive",
  "analysis": "## Investment Analysis for AAPL\n\n...",
  "timestamp": "2025-10-13T12:00:00Z"
}
```

## API Documentation

Once the backend server is running, visit:
- **Swagger UI:** `http://localhost:8000/docs`
- **ReDoc:** `http://localhost:8000/redoc`

## AI Agents

### Stock Analyst
Analyzes stocks covering fundamentals, technicals, and market sentiment using web search capabilities.

### Investment Strategist
Synthesizes the analyst's findings to provide clear BUY/HOLD/SELL recommendations with supporting rationale.

## Configuration

### Backend Configuration

Edit `crewai-python/app/core/config.py` to customize:
- LLM model (default: `gpt-4o-mini`)
- Temperature settings
- Max iterations
- Rate limits
- Analysis depth settings

### Frontend Configuration

Edit `frontend/vite.config.js` for build settings and `frontend/src/App.jsx` for API endpoint configuration.

## Performance Optimizations

- Uses `gpt-4o-mini` for 10x faster responses than GPT-4
- Streamlined 2-agent architecture (down from 5)
- Disabled crew memory for faster execution
- Limited iterations to prevent timeouts
- Efficient API design with rate limiting

## Development

### Backend Development

```bash
cd crewai-python

# Run with auto-reload
python main.py

# Format code
black app/
```

### Frontend Development

```bash
cd frontend

# Run dev server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Lint code
npm run lint
```

## Project Structure

### Backend (`crewai-python/`)

```
crewai-python/
├── app/
│   ├── api/
│   │   └── routes.py          # FastAPI endpoints
│   ├── core/
│   │   └── config.py          # Configuration
│   ├── models/
│   │   └── schemas.py         # Pydantic models
│   └── services/
│       ├── agents.py          # CrewAI agents
│       ├── tasks.py           # CrewAI tasks
│       └── crew.py            # Crew orchestration
├── main.py                     # Server entry point
├── cli.py                      # CLI interface
└── requirements.txt            # Dependencies
```

### Frontend (`frontend/`)

```
frontend/
├── src/
│   ├── App.jsx                # Main application component
│   ├── App.css                # Styles
│   └── main.jsx               # Entry point
├── public/                     # Static assets
├── package.json               # Dependencies
└── vite.config.js             # Vite configuration
```

## Troubleshooting

### Backend Issues

**API Key Errors:**
- Ensure `.env` file exists in `crewai-python/` directory
- Verify API keys are valid and active

**Port Conflicts:**
- Change port in `main.py` if 8000 is in use

**Agent Timeouts:**
- Reduce max iterations in `config.py`
- Switch to "quick" analysis depth

### Frontend Issues

**CORS Errors:**
- Ensure backend is running on `http://0.0.0.0:8000`
- Check CORS settings in `routes.py`

**Build Errors:**
- Delete `node_modules` and run `npm install` again
- Clear Vite cache: `rm -rf node_modules/.vite`
